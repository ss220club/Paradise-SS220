/datum/buildmode_mode/save
	key = "save"

	// Клик обрабатывается полностью по-своему (см. handle_click() ниже) -
	// общий, "выбери 2 угла -> третий клик подтверждает" механизм из
	// bm_mode.dm тут не используется вообще, поэтому use_corner_selection
	// выключен явно.
	use_corner_selection = FALSE
	var/use_json = TRUE

	/// SAVE_SELMODE_AREA - тянуть прямоугольник; SAVE_SELMODE_POINT - тыкать по одному тайлу
	var/selection_mode = SAVE_SELMODE_AREA

	/// Множество выделенных тайлов "здесь и сейчас" (используется как
	/// ассоциативный список - turf = TRUE - для быстрой проверки "выделен
	/// ли тайл" без линейного перебора). При сохранении из него берётся
	/// как рамка (min/max по x/y/z, для локации самого шаттла), так и
	/// само множество (для "дырок" - см. write_map()/save_map() в writer.dm
	/// и разговор про пончик).
	var/list/turf/selected_tiles = list()

	/// Первый угол, пока идёт "перетаскивание" в режиме Area. Пока это не
	/// null - за курсором следует второй (синий) маркер и две границы.
	var/turf/pending_corner

	var/image/corner_marker_img
	var/image/hover_marker_img
	var/list/obj/effect/buildmode_line/border_line_objs = list()
	var/list/image/selection_overlay_imgs = list()

	/// Стек действий для Undo/Redo. Каждый элемент - list(тайлы), которые
	/// были переключены (toggle) этим действием. Повторное переключение
	/// того же списка полностью отменяет действие - toggle сам себе обратен.
	var/list/action_stack = list()
	var/list/redo_stack = list()

/datum/buildmode_mode/save/enter_mode(datum/click_intercept/buildmode/BM)
	. = ..()
	// Эти 4 кнопки нужны только Save - вешаем их именно тут, а не в общем
	// create_buttons(), чтобы в любом другом режиме их не было видно вообще.
	BM.holder.screen += new /atom/movable/screen/buildmode/save_undo(BM)
	BM.holder.screen += new /atom/movable/screen/buildmode/save_redo(BM)
	BM.holder.screen += new /atom/movable/screen/buildmode/save_savezone(BM)
	BM.holder.screen += new /atom/movable/screen/buildmode/save_modetoggle(BM)

/datum/buildmode_mode/save/exit_mode(datum/click_intercept/buildmode/BM)
	for(var/atom/movable/screen/buildmode/B in BM.holder.screen)
		if(istype(B, /atom/movable/screen/buildmode/save_undo) || \
			istype(B, /atom/movable/screen/buildmode/save_redo) || \
			istype(B, /atom/movable/screen/buildmode/save_savezone) || \
			istype(B, /atom/movable/screen/buildmode/save_modetoggle))
			BM.holder.screen -= B
			qdel(B)
	Reset()
	return ..()

/datum/buildmode_mode/save/Reset()
	stop_area_drag()
	BM.holder.images -= selection_overlay_imgs
	QDEL_LIST_CONTENTS(selection_overlay_imgs)
	selection_overlay_imgs = list()
	selected_tiles = list()
	action_stack = list()
	redo_stack = list()

/datum/buildmode_mode/save/show_help(mob/user)
	to_chat(user, SPAN_NOTICE("***********************************************************"))
	to_chat(user, SPAN_NOTICE("Режим Area (по умолчанию):"))
	to_chat(user, SPAN_NOTICE("  ЛКМ по тайлу         = поставить первый угол (зелёный)"))
	to_chat(user, SPAN_NOTICE("  Двигайте курсором    = второй угол (синий) и границы следуют за курсором"))
	to_chat(user, SPAN_NOTICE("  ЛКМ по второму тайлу = подтвердить область (выделение переключается: было -> не было)"))
	to_chat(user, SPAN_NOTICE("Режим Point:"))
	to_chat(user, SPAN_NOTICE("  ЛКМ по тайлу         = переключить выделение именно этого тайла"))
	to_chat(user, SPAN_NOTICE("Общее:"))
	to_chat(user, SPAN_NOTICE("  ПКМ                  = отменить текущий угол, а если его нет - отменить последнее действие (Undo)"))
	to_chat(user, SPAN_NOTICE("  Кнопка Undo/Redo     = то же самое, отменить/повторить последнее действие"))
	to_chat(user, SPAN_NOTICE("  Кнопка Toggle        = переключить Area/Point"))
	to_chat(user, SPAN_NOTICE("  Кнопка Save Zone     = сохранить всё, что сейчас выделено"))
	to_chat(user, SPAN_NOTICE("***********************************************************"))

/datum/buildmode_mode/save/change_settings(mob/user)
	use_json = (tgui_alert(user, "Would you like to use json (Default is \"Yes\")?", "Save Format", list("Yes", "No")) == "Yes")

// ============================================================================
// Клики
// ============================================================================

/datum/buildmode_mode/save/handle_click(user, params, object)
	var/list/pa = params2list(params)
	var/left_click = pa.Find("left")
	var/right_click = pa.Find("right")

	if(right_click)
		if(pending_corner)
			stop_area_drag()
			to_chat(user, SPAN_NOTICE("Selection corner cancelled."))
		else
			undo_action(user)
		return

	if(!left_click)
		return

	var/turf/T = get_turf(object)
	if(!T)
		return

	if(selection_mode == SAVE_SELMODE_POINT)
		do_action(list(T))
		return

	// SAVE_SELMODE_AREA
	if(!pending_corner)
		pending_corner = T
		if(corner_marker_img)
			BM.holder.images -= corner_marker_img
		corner_marker_img = image('icons/turf/overlays.dmi', T, "greenOverlay")
		corner_marker_img.alpha = 255 // "погуще", чем раньше
		corner_marker_img.layer = ABOVE_ALL_MOB_LAYER // иначе рендерится под столами/стенами/шлюзами
		corner_marker_img.plane = GAME_PLANE
		BM.holder.images += corner_marker_img
	else
		var/list/turf/rect = block(pending_corner, T)
		stop_area_drag()
		do_action(rect)

// Вызывается из хуков наведения мыши ниже, пока идёт перетаскивание в Area
/datum/buildmode_mode/save/proc/update_hover(turf/T)
	if(!pending_corner || T == pending_corner)
		return

	if(hover_marker_img)
		BM.holder.images -= hover_marker_img
	hover_marker_img = image('icons/turf/overlays.dmi', T, "blueOverlay")
	hover_marker_img.alpha = 255 // "погуще", чем раньше
	hover_marker_img.layer = ABOVE_ALL_MOB_LAYER
	hover_marker_img.plane = GAME_PLANE
	BM.holder.images += hover_marker_img

	QDEL_LIST_CONTENTS(border_line_objs)
	border_line_objs = list()
	// Две линии-границы, сходящиеся изломом на тайле под курсором - по ним
	// видно, какой прямоугольник в итоге выделится. Поблёклее и попрозрачнее
	// зелёной/синей точки, как и просили - подберите числа alpha/color на
	// глаз в игре, я их не вижу отрендеренными.
	var/turf/bend_h = locate(pending_corner.x, T.y, T.z)
	var/turf/bend_v = locate(T.x, pending_corner.y, T.z)
	var/obj/effect/buildmode_line/L1 = new(BM.holder, bend_h, T, "save_border_h")
	var/obj/effect/buildmode_line/L2 = new(BM.holder, bend_v, T, "save_border_v")
	L1.I.alpha = 90
	L2.I.alpha = 90
	L1.I.color = "#88AA88"
	L2.I.color = "#88AA88"
	border_line_objs += L1
	border_line_objs += L2

/datum/buildmode_mode/save/proc/stop_area_drag()
	pending_corner = null
	if(corner_marker_img)
		BM.holder.images -= corner_marker_img
		corner_marker_img = null
	if(hover_marker_img)
		BM.holder.images -= hover_marker_img
		hover_marker_img = null
	QDEL_LIST_CONTENTS(border_line_objs)
	border_line_objs = list()

// ============================================================================
// Выделение / Undo / Redo
// ============================================================================

/datum/buildmode_mode/save/proc/toggle_tiles(list/turf/tiles)
	for(var/turf/T in tiles)
		if(selected_tiles[T])
			selected_tiles -= T
		else
			selected_tiles[T] = TRUE
	rebuild_selection_overlay()

/datum/buildmode_mode/save/proc/rebuild_selection_overlay()
	BM.holder.images -= selection_overlay_imgs
	QDEL_LIST_CONTENTS(selection_overlay_imgs)
	selection_overlay_imgs = list()
	for(var/turf/T in selected_tiles)
		var/image/I = image('icons/turf/overlays.dmi', T, "redOverlay")
		I.layer = ABOVE_ALL_MOB_LAYER
		I.plane = GAME_PLANE
		selection_overlay_imgs += I
	BM.holder.images += selection_overlay_imgs

/datum/buildmode_mode/save/proc/do_action(list/turf/tiles)
	if(!length(tiles))
		return
	toggle_tiles(tiles)
	action_stack += list(tiles.Copy())
	redo_stack = list()

/datum/buildmode_mode/save/proc/undo_action(mob/user)
	if(!length(action_stack))
		to_chat(user, SPAN_WARNING("Nothing to undo."))
		return
	var/list/tiles = action_stack[length(action_stack)]
	action_stack.Cut(length(action_stack), length(action_stack) + 1)
	toggle_tiles(tiles)
	redo_stack += list(tiles)

/datum/buildmode_mode/save/proc/redo_action(mob/user)
	if(!length(redo_stack))
		to_chat(user, SPAN_WARNING("Nothing to redo."))
		return
	var/list/tiles = redo_stack[length(redo_stack)]
	redo_stack.Cut(length(redo_stack), length(redo_stack) + 1)
	toggle_tiles(tiles)
	action_stack += list(tiles)

/datum/buildmode_mode/save/proc/toggle_selection_mode(mob/user)
	stop_area_drag()
	selection_mode = (selection_mode == SAVE_SELMODE_AREA) ? SAVE_SELMODE_POINT : SAVE_SELMODE_AREA
	to_chat(user, SPAN_NOTICE("Selection mode: [selection_mode == SAVE_SELMODE_POINT ? "Point" : "Area"]"))

// ============================================================================
// Сохранение
// ============================================================================

/datum/buildmode_mode/save/proc/save_selection(mob/user)
	if(!length(selected_tiles))
		to_chat(user, SPAN_WARNING("Nothing selected."))
		return

	// Рамка (bounding box) нужна как t1/t2 для save_map() - сам файл всё
	// равно физически представляет собой прямоугольную сетку (см. разговор
	// про формат .dmm). А вот что именно окажется НАПОЛНЕНО внутри этой
	// рамки, а что станет "дыркой" (/turf/template_noop) - решает
	// selected_tiles, переданный отдельно.
	var/minx = INFINITY
	var/miny = INFINITY
	var/minz = INFINITY
	var/maxx = -INFINITY
	var/maxy = -INFINITY
	var/maxz = -INFINITY
	for(var/turf/T in selected_tiles)
		minx = min(minx, T.x)
		maxx = max(maxx, T.x)
		miny = min(miny, T.y)
		maxy = max(maxy, T.y)
		minz = min(minz, T.z)
		maxz = max(maxz, T.z)

	var/turf/cornerA = locate(minx, miny, minz)
	var/turf/cornerB = locate(maxx, maxy, maxz)

	var/map_name = tgui_input_text(user, "Please select a name for your map", "Map Name", "")
	if(map_name == "")
		return
	var/map_flags = 0
	if(use_json)
		map_flags = 32 // Magic number defined in `writer.dm` that I can't use directly
		// because #defines are for some reason our coding standard
	var/our_map = GLOB.maploader.save_map(cornerA, cornerB, map_name, map_flags, selected_tiles)
	user << ftp(our_map)
	to_chat(user, "Map saving complete! [our_map]")

// ============================================================================
// Отслеживание курсора мышью для второго (синего) угла
// ============================================================================
// ВАЖНО: это глобальные оверрайды /turf/MouseEntered() и
// /atom/movable/MouseEntered() - они будут вызываться при наведении мыши
// ЛЮБЫМ игроком на ЛЮБОЙ тайл/объект, не только админом в Save-режиме. Все
// проверки внутри организованы так, чтобы для подавляющего большинства
// вызовов (обычные игроки, не в buildmode) выйти как можно раньше и
// дешевле - но сам факт, что это глобальные хуки, стоит держать в уме,
// если когда-нибудь будете профилировать производительность.
//
// Нужны ОБА (не только /turf) - стена, стол, шлюз, стул и вообще что угодно,
// физически стоящее на тайле, перехватывает наведение мыши на СЕБЯ раньше,
// чем оно доходит до тайла под ним. Без хука на /atom/movable синий маркер
// просто замирал, стоило навести курсор на любой непустой тайл, и ждал,
// пока курсор снова окажется на голом полу.
/proc/buildmode_save_mouse_entered(atom/hovered)
	if(!usr?.client)
		return
	var/datum/click_intercept/buildmode/BM = usr.client.click_intercept
	if(!istype(BM))
		return
	var/datum/buildmode_mode/save/S = BM.mode
	if(!istype(S) || !S.pending_corner)
		return
	S.update_hover(get_turf(hovered))

/turf/MouseEntered(location, control, params)
	. = ..()
	buildmode_save_mouse_entered(src)

/atom/movable/MouseEntered(location, control, params)
	. = ..()
	buildmode_save_mouse_entered(src)
