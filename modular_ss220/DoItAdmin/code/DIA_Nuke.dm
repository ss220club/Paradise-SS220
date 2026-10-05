// Свои дефайны стадий, потому что NUKE_* андефаются в конце nuclearbomb_220.dm
#define DIA_NUKE_INTACT 0
#define DIA_NUKE_PANEL_UNSCREWED 1
#define DIA_NUKE_PANEL_REMOVED 2
#define DIA_NUKE_PLATE_WELDED 3
#define DIA_NUKE_PLATE_REMOVED_STATIC 4
#define DIA_NUKE_PLATE_REMOVED 5
#define DIA_NUKE_CORE_REMOVED 6

/obj/machinery/nuclearbomb/Do_It_Admin
	name = "\improper Ядерный терминал комплекса"
	desc = "Last chance at redemption"
	icon = 'icons/obj/machines/nuke_terminal.dmi'
	icon_state = "nuclearbomb_base"
	var/f_name_to_anonce = "Ядерный терминал комплекса D-6"

	var/obj/effect/countdown/nuclearbomb/countdown
	var/numeric_input = ""
	is_syndicate = TRUE
	requires_NAD_to_unbolt = TRUE

/obj/machinery/nuclearbomb/Do_It_Admin/Initialize(mapload)
	. = ..()
	countdown = new(src)

/obj/machinery/nuclearbomb/Do_It_Admin/Destroy()
	QDEL_NULL(countdown)
	return ..()

// Запрет на отвинчивание болтов
/obj/machinery/nuclearbomb/Do_It_Admin/wrench_act(mob/user, obj/item/I)
	return FALSE

/obj/machinery/nuclearbomb/Do_It_Admin/update_icon_state()
	if(exploded)
		icon_state = "nuclearbomb_exploding"
		return
	icon_state = "nuclearbomb_base"

/obj/machinery/nuclearbomb/Do_It_Admin/update_overlays()
	. = ..()
	underlays.Cut()
	set_light(0)

	// Свет
	if(!wires.is_cut(WIRE_NUKE_LIGHT))
		set_light(1, LIGHTING_MINIMUM_POWER)
		if(exploded)
			// nuclearbomb_exploding уже содержит свет
		else if(timing)
			. += "lights-timing"
		else
			. += "lights-safety"

	// Стадии разборки
	switch(removal_stage)
		if(DIA_NUKE_INTACT)
			// ничего
		if(DIA_NUKE_PANEL_UNSCREWED)
			. += "panel-unscrewed"
		if(DIA_NUKE_PANEL_REMOVED)
			. += "panel-removed"
		if(DIA_NUKE_PLATE_WELDED)
			. += "plate-welded"
		if(DIA_NUKE_PLATE_REMOVED_STATIC)
			. += "plate-removed-static"
		if(DIA_NUKE_PLATE_REMOVED)
			. += "plate-removed"
		if(DIA_NUKE_CORE_REMOVED)
			. += "core-removed"

/obj/machinery/nuclearbomb/Do_It_Admin/screwdriver_act(mob/user, obj/item/I)
	. = TRUE
	if(!I.use_tool(src, user, 0, volume = I.tool_volume))
		return
	if(removal_stage != DIA_NUKE_INTACT)
		flick("nuclearbomb_exploding", src)
		return
	// Спец-отвёртка ИЛИ любая отвёртка при наличии диска
	if(!istype(I, /obj/item/screwdriver/nuke) && !auth)
		to_chat(user, SPAN_WARNING("[src] emits a buzzing noise, the panel staying locked in."))
		flick("nuclearbomb_exploding", src)
		return
	user.visible_message(
		SPAN_NOTICE("[user] unscrews the panel of [src]."),
		SPAN_NOTICE("You unscrew the panel of [src].")
	)
	removal_stage = DIA_NUKE_PANEL_UNSCREWED
	update_icon()

/obj/machinery/nuclearbomb/Do_It_Admin/crowbar_act(mob/user, obj/item/I)
	. = TRUE
	if(!I.use_tool(src, user, 0, volume = I.tool_volume))
		return
	if(removal_stage == DIA_NUKE_PANEL_UNSCREWED)
		user.visible_message(
			SPAN_NOTICE("[user] pries off the panel of [src]."),
			SPAN_NOTICE("You pry off the panel of [src].")
		)
		new /obj/item/stack/sheet/metal(loc, 5)
		removal_stage = DIA_NUKE_PANEL_REMOVED
		update_icon()
		return
	if(removal_stage == DIA_NUKE_PLATE_WELDED)
		user.visible_message(
			SPAN_NOTICE("[user] pries off the inner plate of [src]."),
			SPAN_NOTICE("You pry off the inner plate of [src].")
		)
		new /obj/item/stack/sheet/mineral/titanium(loc, 5)
		removal_stage = DIA_NUKE_PLATE_REMOVED_STATIC
		update_icon()
		return

/obj/machinery/nuclearbomb/Do_It_Admin/welder_act(mob/user, obj/item/I)
	. = TRUE
	if(!I.tool_use_check(user, 0))
		return
	if(removal_stage == DIA_NUKE_PANEL_REMOVED)
		user.visible_message(
			SPAN_NOTICE("[user] starts welding the inner plate of [src]."),
			SPAN_NOTICE("You start welding the inner plate of [src].")
		)
		if(!I.use_tool(src, user, 4 SECONDS, volume = I.tool_volume))
			return
		user.visible_message(
			SPAN_NOTICE("[user] finishes welding the inner plate of [src]."),
			SPAN_NOTICE("You finish welding the inner plate of [src].")
		)
		removal_stage = DIA_NUKE_PLATE_WELDED
		update_icon()
		return
	if(removal_stage == DIA_NUKE_PLATE_REMOVED_STATIC)
		user.visible_message(
			SPAN_NOTICE("[user] starts cutting the welds on [src]'s core armor."),
			SPAN_NOTICE("You start cutting the welds on [src]'s core armor.")
		)
		if(!I.use_tool(src, user, 4 SECONDS, volume = I.tool_volume))
			return
		user.visible_message(
			SPAN_NOTICE("[user] finishes cutting the welds on [src]'s core armor. The core's green glow starts pulsing."),
			SPAN_NOTICE("You finish cutting the welds. The core's green glow starts pulsing.")
		)
		removal_stage = DIA_NUKE_PLATE_REMOVED
		update_icon()
		return

/obj/machinery/nuclearbomb/Do_It_Admin/attack_hand(mob/user as mob)
	if(removal_stage == DIA_NUKE_PLATE_REMOVED && core)
		user.visible_message(
			SPAN_NOTICE("[user] starts to pull [core] out of [src]!"),
			SPAN_NOTICE("You start to pull [core] out of [src]!")
		)
		if(do_after(user, 5 SECONDS, target = src))
			user.visible_message(
				SPAN_NOTICE("[user] pulls [core] out of [src]!"),
				SPAN_NOTICE("You pull [core] out of [src]! Might want to put it somewhere safe.")
			)
			core.forceMove(loc)
			core = null
			removal_stage = DIA_NUKE_CORE_REMOVED
			update_icon()
		return
	..()

/obj/machinery/nuclearbomb/Do_It_Admin/explode()
	timing = FALSE
	exploded = TRUE
	GLOB.bomb_set = FALSE
	update_icon()
	if(countdown)
		countdown.stop()
	for(var/mob/M in GLOB.mob_list)
		if(M.stat != DEAD)
			var/turf/T = get_turf(M)
			if(T && T.z == src.z)
				to_chat(M, SPAN_DANGER("The blast wave tears you atom from atom!"))
				M.ghostize()
				M.dust()
		CHECK_TICK

/obj/machinery/nuclearbomb/Do_It_Admin/proc/announce_local(message, title = null, subtitle = null, sound = null, vis = ANNOUNCE_VIS_DEFAULT)
	var/turf/T = get_turf(src)
	if(!T)
		return
	announce_zlevel(T.z, message, title, subtitle, sound, vis)

/obj/machinery/nuclearbomb/Do_It_Admin/ui_interact(mob/user, datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "NuclearBombDIA", name)
		ui.open()

/obj/machinery/nuclearbomb/Do_It_Admin/ui_data(mob/user)
	var/list/data = list()
	data["disk_present"] = auth ? TRUE : FALSE
	data["anchored"] = anchored

	if(exploded)
		data["status1"] = "DEVICE DEPLOYED"
		data["status2"] = "THANK YOU"
	else if(timing)
		data["status1"] = "DEVICE ARMED"
		data["status2"] = "TIME: [timeleft]"
	else if(!auth)
		data["status1"] = "DEVICE LOCKED"
		data["status2"] = "AWAIT DISK"
	else if(!yes_code)
		data["status1"] = "INPUT CODE"
		if(numeric_input == "ERROR")
			data["status2"] = "ERROR"
		else if(length(numeric_input))
			data["status2"] = "CODE: [numeric_input]"
		else
			data["status2"] = "CODE: -----"
	else
		data["status1"] = "DEVICE READY"
		data["status2"] = "TIME: [timeleft]"

	return data

/obj/machinery/nuclearbomb/Do_It_Admin/ui_act(action, params)
	playsound(src, "terminal_type", 20, FALSE)
	if(exploded)
		return
	if(wires.is_cut(WIRE_NUKE_CONTROL))
		to_chat(usr, SPAN_WARNING("The control panel isn't responding! Something must be wrong with its wiring!"))
		return FALSE

	switch(action)
		// Выброс / вставка диска
		if("eject_disk")
			if(auth && auth.loc == src)
				playsound(src, 'sound/machines/terminal_insert_disc.ogg', 50, FALSE)
				auth.forceMove(get_turf(src))
				auth = null
				yes_code = FALSE
				numeric_input = ""
				. = TRUE
			else
				var/obj/item/I = usr.get_active_hand()
				if(istype(I, /obj/item/disk/nuclear))
					if(!usr.drop_item())
						to_chat(usr, SPAN_NOTICE("[I] is stuck to your hand!"))
						return FALSE
					I.forceMove(src)
					auth = I
					playsound(src, 'sound/machines/terminal_insert_disc.ogg', 50, FALSE)
					. = TRUE

		// Кейпад
		if("keypad")
			if(!auth)
				playsound(src, 'sound/machines/nuke/angry_beep.ogg', 50, FALSE)
				return FALSE

			var/digit = params["digit"]
			switch(digit)
				if("C")
					numeric_input = ""
					. = TRUE
				if("E")
					if(!yes_code)
						if(numeric_input == "[r_code]")
							numeric_input = ""
							yes_code = TRUE
							playsound(src, 'sound/machines/nuke/general_beep.ogg', 50, FALSE)
							. = TRUE
						else
							playsound(src, 'sound/machines/nuke/angry_beep.ogg', 50, FALSE)
							numeric_input = "ERROR"
					else
						var/number_value = text2num(numeric_input)
						if(number_value)
							timeleft = clamp(number_value, 120, 600)
							numeric_input = ""
							playsound(src, 'sound/machines/nuke/general_beep.ogg', 50, FALSE)
							. = TRUE
						else
							playsound(src, 'sound/machines/nuke/angry_beep.ogg', 50, FALSE)
				if("0","1","2","3","4","5","6","7","8","9")
					if(numeric_input != "ERROR")
						numeric_input += digit
						if(length(numeric_input) > 5)
							numeric_input = "ERROR"
						else
							playsound(src, 'sound/machines/nuke/general_beep.ogg', 50, FALSE)
						. = TRUE

		// Взведение / разоружение
		if("arm")
			if(auth && yes_code && !exploded)
				if(!timing)
					if(wires.is_cut(WIRE_NUKE_DETONATOR))
						to_chat(usr, SPAN_WARNING("[src] isn't arming! Something must be wrong with its wiring!"))
						return FALSE
					timing = TRUE
					GLOB.bomb_set = TRUE
					if(countdown)
						countdown.start()
					update_icon()
					message_admins("[key_name_admin(usr)] engaged a nuclear terminal bomb [ADMIN_JMP(src)]")
					announce_local(
						"Механизм самоуничтожения объекта задействован. Всем сотрудникам предписывается подчиняться \
						указаниям, данным старшими по званию. Критическая перегрузка ядра будет достигнута через [timeleft] секунд.",
						"[f_name_to_anonce]",
						"ВНИМАНИЕ! ОБЪЯВЛЕН КОД ДЕЛЬТА!",
						sound = 'sound/effects/delta_klaxon.ogg',
						vis = ANNOUNCE_VIS_LIVING | ANNOUNCE_VIS_GHOSTS | ANNOUNCE_VIS_SILICONS
					)
					. = TRUE
				else
					if(wires.is_cut(WIRE_NUKE_DISARM))
						to_chat(usr, SPAN_WARNING("[src] isn't disarming! Something must be wrong with its wiring!"))
						return FALSE
					timing = FALSE
					GLOB.bomb_set = FALSE
					if(countdown)
						countdown.stop()
					update_icon()
					. = TRUE
			else
				playsound(src, 'sound/machines/nuke/angry_beep.ogg', 50, FALSE)

		// Привязка / отвязка
		if("anchor")
			if(auth && yes_code)
				if(!anchored && isinspace())
					to_chat(usr, SPAN_WARNING("There is nothing to anchor to!"))
					return FALSE
				anchored = !anchored
				update_icon()
				. = TRUE
			else
				playsound(src, 'sound/machines/nuke/angry_beep.ogg', 50, FALSE)

/obj/effect/countdown/nuclearbomb
	name = "nuclear bomb countdown"

/obj/effect/countdown/nuclearbomb/get_value()
	var/obj/machinery/nuclearbomb/N = attached_to
	if(!istype(N))
		return
	if(N.timing)
		return N.timeleft
	return

#undef DIA_NUKE_INTACT
#undef DIA_NUKE_PANEL_UNSCREWED
#undef DIA_NUKE_PANEL_REMOVED
#undef DIA_NUKE_PLATE_WELDED
#undef DIA_NUKE_PLATE_REMOVED_STATIC
#undef DIA_NUKE_PLATE_REMOVED
#undef DIA_NUKE_CORE_REMOVED
