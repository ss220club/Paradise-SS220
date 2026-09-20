/obj/machinery/nuclearbomb/syndicate/Do_It_Admin
	name = "\improper Nuclear Fission Explosive"
	desc = "Last chance at redemption"

/obj/machinery/nuclearbomb/syndicate/Do_It_Admin/explode()
	timing = FALSE
	exploded = TRUE
	GLOB.bomb_set = FALSE
	icon_state = "nuclearbomb3"
	update_icon(UPDATE_OVERLAYS)
	for(var/mob/M in GLOB.mob_list)
		if(M.stat != DEAD)
			var/turf/T = get_turf(M)
			if(T && T.z == src.z)
				to_chat(M, SPAN_DANGER("The blast wave tears you atom from atom!"))
				M.ghostize()
				M.dust()
		CHECK_TICK

/obj/machinery/nuclearbomb/syndicate/Do_It_Admin/proc/announce_local(message, title = null, subtitle = null, sound = null, vis = ANNOUNCE_VIS_DEFAULT)
	var/turf/T = get_turf(src)
	if(!T)
		return
	announce_zlevel(T.z, message, title, subtitle, sound, vis)

/obj/machinery/nuclearbomb/syndicate/Do_It_Admin/ui_act(action, params)
	var/was_timing = timing
	. = ..()
	if(. == FALSE)
		return
	if(action == "toggle_armed" && !was_timing && timing && !safety)
		announce_local(
			"Боеголовка взведена. Всем покинуть сектор.",
			"ВНИМАНИЕ.",
			"Угроза взрыва",
			vis = ANNOUNCE_VIS_LIVING | ANNOUNCE_VIS_GHOSTS | ANNOUNCE_VIS_SILICONS
		)
