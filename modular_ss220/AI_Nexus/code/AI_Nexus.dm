/*
 * ОБЪЕДИНЁННАЯ КОНСОЛЬ АПЛОУДА (ИИ + БОРГИ)
 * Полностью новый тип консоли — заменяет aiupload и borgupload.
 *
 * Поток:
 *   1. Тык рукой → открывается TGUI
 *   2. Выбираем режим (ИИ / Борг) и цель из списка
 *   3. Тык платой законов → проверяем цель → устанавливаем законы
 *
 * Установка:
 *   - Этот файл: code/modules/silicon/laws/combined_upload_console.dm
 *   - TGUI: tgui/packages/tgui/interfaces/CombinedUploadConsole.tsx
 *   - Добавить в paradise.dme
 *   - В AI_modules.dm patch'нут /obj/item/ai_module/proc/install(),
 *     чтобы он распознавал combined_upload (см. комментарий там же).
 *
 * ПРИМЕЧАНИЯ ПО НАХОДКАМ:
 *
 * 1. REF()/text_ref() в этой версии кодовой базы не существует.
 *    Родной встроенный аналог BYOND — .UID() / locateUID(),
 *    используем именно его (см. паттерн в ai_mob.dm: RNC.UID(),
 *    locateUID(network_manager_uid) и т.д.)
 *
 * 2. GLOB.silicon_mobs не существует. Список ИИ — GLOB.ai_list.
 *    Список боргов — GLOB.silicon_mob_list (НЕ GLOB.player_list,
 *    который содержит только мобов с подключённым клиентом —
 *    из-за этого борги без живого игрока не попадали в список).
 *
 * 3. /obj/item/ai_module/proc/install() в AI_modules.dm проверяет
 *    тип консоли через istype(C, .../aiupload) / istype(C, .../borgupload).
 *    Наш тип не совпадает ни с одним из них, поэтому install()
 *    молча ничего не делал. Исправлено патчем в AI_modules.dm,
 *    который добавляет распознавание combined_upload и маршрутизацию
 *    по upload_mode (а не по типу консоли, иначе ИИ-ветка перехватила
 *    бы и борг-режим тоже, так как оба матчат istype(C, combined_upload)).
 */

#define COMBINED_UPLOAD_EMAG_COOLDOWN 60 SECONDS

/// Режим выбора цели
#define UPLOAD_MODE_NONE  0
#define UPLOAD_MODE_AI    1
#define UPLOAD_MODE_BORG  2

/obj/machinery/computer/combined_upload
	name = "Консоль аплоуда силиконов"
	desc = "Универсальная консоль для загрузки законов в ИИ и киборгов."
	icon_screen = "command"
	icon_keyboard = "med_key"
	circuit = /obj/item/circuitboard/combined_upload
	light_color = LIGHT_COLOR_WHITE

	/// Текущий режим: UPLOAD_MODE_NONE / UPLOAD_MODE_AI / UPLOAD_MODE_BORG
	var/upload_mode = UPLOAD_MODE_NONE
	/// Текущая выбранная цель (ИИ или Борг — единая переменная,
	/// так как install() в AI_modules.dm читает именно .current)
	var/mob/living/silicon/current = null
	/// Кулдаун для emag-режима
	var/cooldown = 0
	/// Служебная переменная для emag: кол-во inherent законов
	var/found_laws = 0

// ─────────────────────────────────────────
// EMAG
// ─────────────────────────────────────────

/obj/machinery/computer/combined_upload/emag_act(mob/user)
	if(emagged)
		return
	emagged = TRUE
	if(user)
		user.visible_message(
			SPAN_WARNING("Из [src] летят искры!"),
			SPAN_NOTICE("Вы взломали [src], нарушив систему кодирования законов.")
		)
	playsound(loc, 'sound/effects/sparks4.ogg', 50, TRUE)
	do_sparks(5, TRUE, src)
	circuit = /obj/item/circuitboard/combined_upload_broken
	return TRUE

// ─────────────────────────────────────────
// ПОЛУЧЕНИЕ СПИСКОВ ЦЕЛЕЙ
// ─────────────────────────────────────────

/**
 * Возвращает список активных ИИ на том же Z-уровне, что и консоль.
 * Логика фильтрации скопирована из /proc/active_ais() (unsorted.dm):
 * исключаем мёртвых и тех, у кого отключено управление (control_disabled).
 */
/obj/machinery/computer/combined_upload/proc/get_available_ais()
	var/list/result = list()
	for(var/mob/living/silicon/ai/A in GLOB.ai_list)
		if(A.stat == DEAD)
			continue
		if(A.control_disabled)
			continue
		if(!atoms_share_level(get_turf(A), get_turf(src)))
			continue
		result += A
	return result

/**
 * Возвращает список боргов на том же Z-уровне.
 * Используем GLOB.silicon_mob_list (включает клиентless мобов),
 * а не GLOB.player_list (только мобы с активным клиентом).
 *
 * Фильтрация по смыслу как в /proc/freeborg() (unsorted.dm).
 */
/obj/machinery/computer/combined_upload/proc/get_available_borgs()
	var/list/result = list()
	for(var/mob/living/silicon/robot/B in GLOB.silicon_mob_list)
		if(B.stat == DEAD)
			continue
		if(B.scrambledcodes)
			continue
		if(isdrone(B))
			continue
		// if(B.connected_ai) continue // раскомментируй, если нужны только свободные борги
		if(!atoms_share_level(get_turf(B), get_turf(src)))
			continue
		result += B
	return result

/**
 * Проверяет принадлежность объекта к ожидаемому типу и валидность
 * после получения его через locateUID() из TGUI-параметров.
 */
/obj/machinery/computer/combined_upload/proc/resolve_uid_target(uid, mode)
	var/atom/target = locateUID(uid)
	if(!target || QDELETED(target))
		return null
	if(mode == UPLOAD_MODE_AI && !istype(target, /mob/living/silicon/ai))
		return null
	if(mode == UPLOAD_MODE_BORG && !istype(target, /mob/living/silicon/robot))
		return null
	if(!atoms_share_level(get_turf(target), get_turf(src)))
		return null
	return target

// ─────────────────────────────────────────
// TGUI
// ─────────────────────────────────────────

/obj/machinery/computer/combined_upload/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CombinedUploadConsole", name)
		ui.open()

/obj/machinery/computer/combined_upload/ui_data(mob/user)
	var/list/data = list()

	data["upload_mode"] = upload_mode
	data["emagged"]     = emagged

	// Автосброс если цель исчезла, умерла или вышла из зоны действия
	if(current)
		if(QDELETED(current) || current.stat == DEAD || !atoms_share_level(get_turf(current), get_turf(src)))
			current = null

	if(current)
		data["current_uid"]   = current.UID()
		data["current_name"]  = current.real_name
		data["current_alive"] = TRUE
	else
		data["current_uid"]   = null
		data["current_name"]  = null
		data["current_alive"] = FALSE

	// Список ИИ
	var/list/ai_list = list()
	for(var/mob/living/silicon/ai/A in get_available_ais())
		ai_list += list(list(
			"uid"   = A.UID(),
			"name"  = A.real_name,
			"alive" = TRUE
		))
	data["ai_list"] = ai_list

	// Список боргов
	var/list/borg_list = list()
	for(var/mob/living/silicon/robot/B in get_available_borgs())
		borg_list += list(list(
			"uid"   = B.UID(),
			"name"  = "[B.real_name] ([B.modtype] [B.braintype])",
			"alive" = TRUE
		))
	data["borg_list"] = borg_list

	return data

/obj/machinery/computer/combined_upload/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("set_mode")
			var/new_mode = text2num(params["mode"])
			if(new_mode == UPLOAD_MODE_AI || new_mode == UPLOAD_MODE_BORG)
				upload_mode = new_mode
				current = null // сброс выбора при смене режима
				return TRUE

		if("select_target")
			var/mob/living/silicon/target = resolve_uid_target(params["uid"], upload_mode)
			if(!target)
				to_chat(ui.user, SPAN_DANGER("Цель не найдена или уже не существует."))
				return TRUE
			current = target
			to_chat(ui.user, SPAN_NOTICE("[current.real_name] выбран в качестве цели."))
			return TRUE

		if("clear_target")
			current = null
			return TRUE

	return FALSE

// ─────────────────────────────────────────
// ВЗАИМОДЕЙСТВИЕ С ПЛАТОЙ ЗАКОНОВ
// ─────────────────────────────────────────

/obj/machinery/computer/combined_upload/attack_hand(mob/user)
	if(stat & NOPOWER)
		to_chat(user, SPAN_WARNING("Консоль обесточена!"))
		return
	if(stat & BROKEN)
		to_chat(user, SPAN_WARNING("Консоль сломана!"))
		return
	return ui_interact(user)

/obj/machinery/computer/combined_upload/attack_ghost(user)
	return ui_interact(user)

/obj/machinery/computer/combined_upload/item_interaction(mob/living/user, obj/item/used, list/modifiers)
	var/obj/item/ai_module/module = used
	if(!istype(module))
		return ..()

	if(!check_valid_target(user))
		return ITEM_INTERACT_COMPLETE

	if(!emagged)
		module.install(src)
		return ITEM_INTERACT_COMPLETE

	// Emag — только для ИИ
	if(upload_mode == UPLOAD_MODE_AI)
		apply_emag_laws(user)
	else
		to_chat(user, SPAN_WARNING("Взломанная консоль не может применить случайные законы к боргу."))

	return ITEM_INTERACT_COMPLETE

/// Проверяет: выбрана ли цель, жива ли, на том ли Z-уровне
/obj/machinery/computer/combined_upload/proc/check_valid_target(mob/user)
	if(upload_mode == UPLOAD_MODE_NONE)
		to_chat(user, SPAN_DANGER("Режим не выбран. Откройте консоль и выберите ИИ или борга."))
		return FALSE
	if(!current || QDELETED(current))
		to_chat(user, SPAN_DANGER("Цель не выбрана или была удалена. Откройте консоль и выберите цель."))
		current = null
		return FALSE
	if(current.stat == DEAD)
		to_chat(user, SPAN_DANGER("Цель недоступна: [current.real_name] не в сети!"))
		return FALSE
	var/turf/T = get_turf(current)
	if(!atoms_share_level(T, get_turf(src)))
		to_chat(user, SPAN_DANGER("Невозможно подключиться: [current.real_name] слишком далеко!"))
		return FALSE
	return TRUE

// ─────────────────────────────────────────
// EMAG-ЛОГИКА (только ИИ, как в оригинале)
// ─────────────────────────────────────────

/obj/machinery/computer/combined_upload/proc/apply_emag_laws(mob/user)
	if(world.time < cooldown)
		to_chat(user, SPAN_DANGER("Программа зависла. Требуется время на обработку."))
		return
	do_sparks(5, TRUE, src)
	var/mob/living/silicon/ai/ai_target = current
	found_laws = length(ai_target.laws.inherent_laws)
	if(!emag_ion_check(ai_target))
		emag_inherent_law(ai_target)

/obj/machinery/computer/combined_upload/proc/emag_ion_check(mob/living/silicon/ai/ai_target)
	var/datum/ai_law/inherent/new_law = new(generate_ion_law())
	var/emag_law = new_law.law
	if(!length(ai_target.laws.ion_laws))
		if(prob(80))
			return FALSE
		ai_target.add_ion_law(generate_ion_law())
		cooldown = world.time + COMBINED_UPLOAD_EMAG_COOLDOWN
		return TRUE
	if(prob(90))
		return FALSE
	ai_target.laws.ion_laws[1].law = emag_law
	cooldown = world.time + COMBINED_UPLOAD_EMAG_COOLDOWN
	log_and_message_admins("has given [ai_target] the ion law: [ai_target.laws.ion_laws[1].law].")
	return TRUE

/obj/machinery/computer/combined_upload/proc/emag_inherent_law(mob/living/silicon/ai/ai_target)
	if(!found_laws)
		return
	var/datum/ai_law/inherent/new_law = new(generate_ion_law())
	var/emag_law = new_law.law
	var/lawposition = rand(1, found_laws)
	ai_target.laws.inherent_laws[lawposition].law = emag_law
	log_and_message_admins("has given [ai_target] the emag'd inherent law: [ai_target.laws.inherent_laws[lawposition].law].")
	ai_target.show_laws()
	alert_silicons(ai_target)
	cooldown = world.time + COMBINED_UPLOAD_EMAG_COOLDOWN

/obj/machinery/computer/combined_upload/proc/alert_silicons(mob/living/silicon/ai/ai_target)
	ai_target.show_laws()
	ai_target.throw_alert("newlaw", /atom/movable/screen/alert/newlaw)
	for(var/mob/living/silicon/robot/borg in ai_target.connected_robots)
		borg.cmd_show_laws()
		borg.throw_alert("newlaw", /atom/movable/screen/alert/newlaw)

// ─────────────────────────────────────────
// CIRCUIT BOARDS
// ─────────────────────────────────────────

/obj/item/circuitboard/combined_upload
	board_name = "Консоль Аплоуда"
	icon_state = "command"
	build_path = /obj/machinery/computer/combined_upload
	origin_tech = "programming=5;engineering=5"

/obj/item/circuitboard/combined_upload_broken
	board_name = "Консоль Аплоуда"
	desc = SPAN_WARNING("The board is charred and smells of burnt plastic. It has been rendered useless.")
	icon_state = "command_broken"

// ─────────────────────────────────────────

#undef COMBINED_UPLOAD_EMAG_COOLDOWN
#undef UPLOAD_MODE_NONE
#undef UPLOAD_MODE_AI
#undef UPLOAD_MODE_BORG
