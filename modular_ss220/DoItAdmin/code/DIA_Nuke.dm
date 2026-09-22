// Свои дефайны стадий, потому что NUKE_* андефаются в конце nuclearbomb_220.dm
#define DIA_NUKE_INTACT 0
#define DIA_NUKE_COVER_OFF 1
#define DIA_NUKE_COVER_OPEN 2
#define DIA_NUKE_SEALANT_OPEN 3
#define DIA_NUKE_UNWRENCHED 4
#define DIA_NUKE_MOBILE 5
#define DIA_NUKE_CORE_EVERYTHING_FINE 6
#define DIA_NUKE_CORE_PANEL_EXPOSED 7
#define DIA_NUKE_CORE_PANEL_UNWELDED 8
#define DIA_NUKE_CORE_FULLY_EXPOSED 9

/obj/machinery/nuclearbomb/Do_It_Admin
	name = "\improper Nuclear Fission Explosive"
	desc = "Last chance at redemption"
	icon = 'modular_ss220/DoItAdmin/code/nuke_terminal.dmi'
	icon_state = "nuclearbomb_base"

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

	if(!wires.is_cut(WIRE_NUKE_LIGHT))
		set_light(1, LIGHTING_MINIMUM_POWER)
		if(!exploded)
			if(timing)
				. += "lights-timing"
			// убран lights-safety

	var/selected_stage = removal_stage
	if(removal_stage < DIA_NUKE_CORE_EVERYTHING_FINE)
		selected_stage = core_stage
	switch(selected_stage)
		if(DIA_NUKE_INTACT)
			// ничего
		if(DIA_NUKE_COVER_OFF, DIA_NUKE_COVER_OPEN, DIA_NUKE_SEALANT_OPEN, DIA_NUKE_UNWRENCHED, DIA_NUKE_MOBILE)
			. += "panel-removed"
		if(DIA_NUKE_CORE_EVERYTHING_FINE)
			. += "plate-welded"
		if(DIA_NUKE_CORE_PANEL_EXPOSED, DIA_NUKE_CORE_PANEL_UNWELDED)
			. += "plate-removed-static"
		if(DIA_NUKE_CORE_FULLY_EXPOSED)
			. += core ? "plate-removed" : "core-removed"

/obj/machinery/nuclearbomb/Do_It_Admin/explode()
	timing = FALSE
	exploded = TRUE
	GLOB.bomb_set = FALSE
	update_icon_state()
	update_icon(UPDATE_OVERLAYS)
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
					update_icon_state()
					update_icon(UPDATE_OVERLAYS)
					message_admins("[key_name_admin(usr)] engaged a nuclear bomb [ADMIN_JMP(src)]")
					announce_local(
						"Механизм самоуничтожения станции задействован. Все члены экипажа обязаны подчиняться всем \
						указаниям, данными Главами отделов. Любые нарушения этих приказов наказуемы уничтожением на \
						месте. Это не учебная тревога.",
						"ВНИМАНИЕ! КОД ДЕЛЬТА!",
						" ",
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
					update_icon_state()
					update_icon(UPDATE_OVERLAYS)
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
				update_icon(UPDATE_OVERLAYS)
				. = TRUE
			else
				playsound(src, 'sound/machines/nuke/angry_beep.ogg', 50, FALSE)

/obj/machinery/nuclearbomb/Do_It_Admin/screwdriver_act(mob/user, obj/item/I)
	. = ..()
	if(.)
		return
	flick("nuclearbomb_exploding", src)

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
#undef DIA_NUKE_COVER_OFF
#undef DIA_NUKE_COVER_OPEN
#undef DIA_NUKE_SEALANT_OPEN
#undef DIA_NUKE_UNWRENCHED
#undef DIA_NUKE_MOBILE
#undef DIA_NUKE_CORE_EVERYTHING_FINE
#undef DIA_NUKE_CORE_PANEL_EXPOSED
#undef DIA_NUKE_CORE_PANEL_UNWELDED
#undef DIA_NUKE_CORE_FULLY_EXPOSED
