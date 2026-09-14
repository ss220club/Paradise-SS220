USER_VERB(map_template_place, R_DEBUG, "Map template - Place", "Map template - Place", VERB_CATEGORY_DEBUG)
	var/datum/map_template/template

	var/map = tgui_input_list(client, "Choose a Map Template to place at your CURRENT LOCATION", "Place Map Template", GLOB.map_templates)
	if(!map)
		return
	template = GLOB.map_templates[map]

	var/turf/T = get_turf(client.mob)
	if(!T)
		return

	if(!template.fits_in_map_bounds(T, centered = TRUE))
		to_chat(client, "Map is too large to fit in bounds. Map's dimensions: ([template.width], [template.height])")
		return

	var/list/preview = list()
	// Skip tiles that are just /turf/template_noop placeholders (holes left
	// by a non-rectangular Save selection - see writer.dm/reader.dm) -
	// otherwise the preview shows the whole rectangle as "will be affected"
	// even for tiles Place won't actually touch. noop_relative_positions is
	// keyed by the template's own LOCAL coordinates (see preload_size()),
	// so each affected world turf needs converting back to local space the
	// same way get_coordinate_bounds() computes it - reusing that proc
	// directly instead of re-deriving the offset here, to avoid the two
	// ever drifting out of sync.
	var/list/coordinate_bounds = template.get_coordinate_bounds(T, centered = TRUE)
	var/datum/coords/bottom_left = coordinate_bounds["bottom_left"]
	for(var/S in template.get_affected_turfs(T,centered = TRUE))
		if(template.noop_relative_positions)
			var/turf/ST = S
			var/rel_x = ST.x - bottom_left.x_pos + 1
			var/rel_y = ST.y - bottom_left.y_pos + 1
			if(template.noop_relative_positions["[rel_x],[rel_y],1"])
				continue
		var/image/I = image('icons/turf/overlays.dmi',S,"greenOverlay")
		I.layer = ABOVE_ALL_MOB_LAYER
		I.plane = GAME_PLANE
		preview += I
	client.images += preview

	// "Overlay" (старое поведение - всё, что тут уже стоит, остаётся, новое
	// добавляется поверх) или "Replace" (сносит существующее содержимое
	// затрагиваемых тайлов перед загрузкой, кроме мобов - см. комментарий
	// в map_template.dm/load()). Нужно в первую очередь для случая, когда
	// шаблон кладут на то же самое, уже занятое место (например, копия
	// поверх оригинала) - без этого дублирующиеся объекты (особенно трубы
	// атмосферы) могут привести к зависанию сервера.
	var/choice = tgui_alert(client, "Confirm location.", "Template Confirm", list("Place (Overlay)", "Place (Replace Existing)", "Cancel"))
	if(choice && choice != "Cancel")
		var/clear_existing = (choice == "Place (Replace Existing)")
		var/timer = start_watch()
		message_admins(SPAN_ADMINNOTICE("[key_name_admin(client)] has started to place the map template ([template.name]) at <A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[T.x];Y=[T.y];Z=[T.z]'>(JMP)</a>"))
		if(template.load(T, centered = TRUE, clear_existing = clear_existing))
			message_admins(SPAN_ADMINNOTICE("[key_name_admin(client)] has placed a map template ([template.name]) at <A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[T.x];Y=[T.y];Z=[T.z]'>(JMP)</a>. Took [stop_watch(timer)]s."))
		else
			to_chat(client, "Failed to place map")
	client.images -= preview

USER_VERB(map_template_upload, R_DEBUG, "Map Template - Upload", "Map Template - Upload", VERB_CATEGORY_DEBUG)
	var/map = input(client, "Choose a Map Template to upload to template storage","Upload Map Template") as null|file
	if(!map)
		return
	if(copytext("[map]",-4) != ".dmm")
		to_chat(client, "Bad map file: [map]")
		return

	var/timer = start_watch()
	message_admins(SPAN_ADMINNOTICE("[key_name_admin(client)] has begun uploading a map template ([map])"))
	// SS220 EDIT START
	// `map` here is a transient /file handle backed by the browser's upload
	// (rsc cache), not a real on-disk path. Reading it repeatedly (which
	// happens every time this template gets Lazy Loaded afterwards) is
	// unreliable - the first read can be fine, but later reads on the same
	// round return truncated or empty content (empty containers, or a fully
	// empty map_data string -> "Bad Map bounds" in reader.dm). Persist it to
	// a real file on disk immediately and load everything from there instead.
	var/upload_dir = "data/uploaded_maps/"
	if(!fexists(upload_dir))
		fdel(upload_dir) // clears out any stray non-directory file at that path
	var/dest_path = "[upload_dir][time2text(world.realtime, "YYYY-MM-DD_hh-mm-ss")]_[map]"
	fcopy(map, dest_path)
	if(!fexists(dest_path))
		to_chat(client, "Map template '[map]' failed to save to disk")
		return

	// New(path=...) already calls preload_size() internally and fills in
	// width/height - a second explicit call here would just re-read the
	// file for nothing.
	var/datum/map_template/M = new(path=dest_path, rename="[map]")
	if(M.width && M.height) // SS220 EDIT END
		to_chat(client, "Map template '[map]' ready to place ([M.width]x[M.height])")
		GLOB.map_templates[M.name] = M
		message_admins(SPAN_ADMINNOTICE("[key_name_admin(client)] has uploaded a map template ([map]). Took [stop_watch(timer)]s."))
	else
		to_chat(client, "Map template '[map]' failed to load properly")

USER_VERB(map_template_load_lazy, R_DEBUG, "Map template - Lazy Load", "Map template - Lazy Load", VERB_CATEGORY_DEBUG)
	var/map = tgui_input_list(client, "Choose a Map Template to place on the lazy load map level.", "Place Map Template", GLOB.map_templates)
	if(!map)
		return
	var/datum/map_template/template = GLOB.map_templates[map]

	// Кордон съедает лишнюю рамку в 1 тайл вокруг зарезервированной области.
	// Для шаблонов, рассчитанных впритык на весь сектор, этой рамке негде
	// поместиться - резервация тогда никогда не находит места, и без
	// возможности отключить кордон единственный вариант - ручной Place.
	var/skip_cordon = (tgui_alert(client, "Enable cordon barrier around the reserved area? (Disable this only if the template is too large to fit alongside it.)", "Cordon", list("Yes", "No")) == "No")

	message_admins(SPAN_ADMINNOTICE("[key_name_admin(client)] is lazyloading the map template ([template.name])."))
	var/datum/turf_reservation/reserve = SSmapping.lazy_load_template(template, skip_cordon)
	if(!istype(reserve))
		message_admins(SPAN_DANGER("Lazyloading [template.name] failed! You should report this as a bug."))
		return
	message_admins(SPAN_ADMINNOTICE("[key_name_admin(client)] has lazyloaded the map template ([template.name]) at [ADMIN_JMP(reserve.bottom_left_turf)]"))
