// Tweak for multi-tile airlocks, to make them paintable

/obj/machinery/door/airlock/multi_tile
	paintable = TRUE

/datum/painter/airlock/paint_atom(atom/target, mob/user)
	if(!istype(target, /obj/machinery/door/airlock/multi_tile))	// Special behavior for multi-tile airlocks
		return ..()
	if(!paint_setting)
		to_chat(user, "<span class='warning'>You need to select a paintjob first.</span>")
		return

	var/obj/machinery/door/airlock/A = target
	if(!A.paintable)
		to_chat(user, "<span class='warning'>This type of airlock cannot be painted.</span>")
		return

	var/static/list/multi_paint_jobs = list(
		"Atmospherics" = /obj/machinery/door/airlock/multi_tile/atmospheric,
		"Command" = /obj/machinery/door/airlock/multi_tile/command,
		"Engineering" = /obj/machinery/door/airlock/multi_tile/engineering,
		"Mining" = /obj/machinery/door/airlock/multi_tile/supply,
		"Public" = /obj/machinery/door/airlock/multi_tile,
		"Security" = /obj/machinery/door/airlock/multi_tile/security,
	)

	var/obj/machinery/door/airlock/airlock = multi_paint_jobs["[paint_setting]"]
	if(isnull(airlock))
		to_chat(user, "<span class='warning'>У выбранного стиля шлюзов нету двойной версии.</span>")
		return

	var/obj/structure/door_assembly/assembly = initial(airlock.assemblytype)
	if(A.assemblytype == assembly)
		to_chat(user, "<span class='notice'>This airlock is already painted with the \"[paint_setting]\" color scheme!</span>")
		return

	if(do_after(user, 2 SECONDS, FALSE, A))
		A.icon = initial(airlock.icon)
		A.overlays_file = initial(airlock.overlays_file)
		A.assemblytype = initial(airlock.assemblytype)
		A.update_icon()
		return TRUE
	return

