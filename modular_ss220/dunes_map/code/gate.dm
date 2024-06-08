//template gate
/obj/structure/necropolis_gate/temple_gate
	name = "\improper врата храма"
	desc = "Массивные врата древнего храма, вырезанные из песчанника и исписанные древними проклятиями."
	icon = 'modular_ss220/dunes_map/icons/gate.dmi'
	icon_state = "desertgate_full"
	light_power = 0
	light_range = 0

/obj/structure/necropolis_gate/Initialize()
	. = ..()
	var/turf/sight_blocker_turf = get_turf(src)
	if(sight_blocker_distance)
		for(var/i in 1 to sight_blocker_distance)
			if(!sight_blocker_turf)
				break
			sight_blocker_turf = get_step(sight_blocker_turf, NORTH)
	if(sight_blocker_turf)
		sight_blocker = new (sight_blocker_turf) //we need to block sight in a different spot than most things do
		sight_blocker.pixel_y = initial(sight_blocker.pixel_y) - (32 * sight_blocker_distance)
	icon_state = "desertgate_bottom"

	top_overlay = mutable_appearance('modular_ss220/dunes_map/icons/gate.dmi', "desertgate_top")
	top_overlay.layer = EDGED_TURF_LAYER
	add_overlay(top_overlay)

	door_overlay = mutable_appearance('modular_ss220/dunes_map/icons/gate.dmi', "desertdoor")
	door_overlay.layer = EDGED_TURF_LAYER
	add_overlay(door_overlay)

	dais_overlay = mutable_appearance('modular_ss220/dunes_map/icons/gate.dmi', "desertgate_dais")
	dais_overlay.layer = CLOSED_TURF_LAYER
	add_overlay(dais_overlay)

/obj/structure/necropolis_gate/temple_gate/toggle_the_gate(mob/user)
	if(changing_openness)
		return

	changing_openness = TRUE
	var/turf/T = get_turf(src)

	if(open)
		new /obj/effect/temp_visual/necropolis/desert(T)
		visible_message("<span class='danger'> Двери храма с грохотом закрылись!</span>")
		playsound(T, 'sound/effects/stonedoor_openclose.ogg', 300, TRUE, frequency = 80000)
		density = TRUE
		var/turf/sight_blocker_turf = get_turf(src)
		if(sight_blocker_distance)
			for(var/i in 1 to sight_blocker_distance)
				if(!sight_blocker_turf)
					break
				sight_blocker_turf = get_step(sight_blocker_turf, NORTH)
		if(sight_blocker_turf)
			sight_blocker.pixel_y = initial(sight_blocker.pixel_y) - (32 * sight_blocker_distance)
			sight_blocker.forceMove(sight_blocker_turf)
		addtimer(CALLBACK(src, PROC_REF(toggle_open_delayed_step), T), 0.5 SECONDS, TIMER_UNIQUE)
		return TRUE

	cut_overlay(door_overlay)
	new /obj/effect/temp_visual/necropolis/open/desert(T)
	visible_message("<span class='warning'>Массивная дверь поддается и медленно открвает вам путь во тьму...</span>")
	playsound(T, 'sound/effects/stonedoor_openclose.ogg', 300, TRUE, frequency = 20000)
	addtimer(CALLBACK(src, PROC_REF(toggle_closed_delayed_step)), 2.2 SECONDS, TIMER_UNIQUE)
	return TRUE

/obj/effect/temp_visual/necropolis/desert
	icon = 'modular_ss220/dunes_map/icons/gate.dmi'
	icon_state = "desertdoor_closing"
	appearance_flags = 0
	duration = 6
	layer = EDGED_TURF_LAYER
	pixel_x = -32
	pixel_y = -32

/obj/effect/temp_visual/necropolis/open/desert
	icon_state = "desertdoor_opening"
	duration = 38

/obj/structure/opacity_blocker/desert
	icon = 'modular_ss220/dunes_map/icons/gate.dmi'
	icon_state = "desertgate_blocker"
	layer = EDGED_TURF_LAYER
	pixel_x = -32
	pixel_y = -32
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	opacity = TRUE
	anchored = TRUE


//boss gate

/obj/structure/necropolis_gate/boss_gate
	name = "\improper врата храма"
	desc = "Проклятые чёрные врата забытой пирамиды. Хирка таит в себе множество тайн и загадок, но что бы подобное..."
	icon = 'modular_ss220/dunes_map/icons/gate.dmi'
	icon_state = "bossgate_full"
	light_power = 0
	light_range = 0

/obj/structure/necropolis_gate/Initialize()
	. = ..()
	var/turf/sight_blocker_turf = get_turf(src)
	if(sight_blocker_distance)
		for(var/i in 1 to sight_blocker_distance)
			if(!sight_blocker_turf)
				break
			sight_blocker_turf = get_step(sight_blocker_turf, NORTH)
	if(sight_blocker_turf)
		sight_blocker = new (sight_blocker_turf) //we need to block sight in a different spot than most things do
		sight_blocker.pixel_y = initial(sight_blocker.pixel_y) - (32 * sight_blocker_distance)
	icon_state = "bossgate_bottom"

	top_overlay = mutable_appearance('modular_ss220/dunes_map/icons/gate.dmi', "bossgate_top")
	top_overlay.layer = EDGED_TURF_LAYER
	add_overlay(top_overlay)

	door_overlay = mutable_appearance('modular_ss220/dunes_map/icons/gate.dmi', "bossdoor")
	door_overlay.layer = EDGED_TURF_LAYER
	add_overlay(door_overlay)

	dais_overlay = mutable_appearance('modular_ss220/dunes_map/icons/gate.dmi', "bossgate_dais")
	dais_overlay.layer = CLOSED_TURF_LAYER
	add_overlay(dais_overlay)

/obj/structure/necropolis_gate/temple_gate/toggle_the_gate(mob/user)
	if(changing_openness)
		return

	changing_openness = TRUE
	var/turf/T = get_turf(src)

	if(open)
		new /obj/effect/temp_visual/necropolis/boss(T)
		visible_message("<span class='danger'> Врата пирамиды медленно закрываются.</span>")
		playsound(T, 'sound/effects/stonedoor_openclose.ogg', 300, TRUE, frequency = 80000)
		density = TRUE
		var/turf/sight_blocker_turf = get_turf(src)
		if(sight_blocker_distance)
			for(var/i in 1 to sight_blocker_distance)
				if(!sight_blocker_turf)
					break
				sight_blocker_turf = get_step(sight_blocker_turf, NORTH)
		if(sight_blocker_turf)
			sight_blocker.pixel_y = initial(sight_blocker.pixel_y) - (32 * sight_blocker_distance)
			sight_blocker.forceMove(sight_blocker_turf)
		addtimer(CALLBACK(src, PROC_REF(toggle_open_delayed_step), T), 0.5 SECONDS, TIMER_UNIQUE)
		return TRUE

	cut_overlay(door_overlay)
	new /obj/effect/temp_visual/necropolis/open/boss(T)
	visible_message("<span class='warning'>Врата пирамиды расступаются перед вами, издавая пронзительный скрежет...</span>")
	playsound(T, 'sound/effects/stonedoor_openclose.ogg', 300, TRUE, frequency = 20000)
	addtimer(CALLBACK(src, PROC_REF(toggle_closed_delayed_step)), 2.2 SECONDS, TIMER_UNIQUE)
	return TRUE

/obj/effect/temp_visual/necropolis/boss
	icon = 'modular_ss220/dunes_map/icons/gate.dmi'
	icon_state = "bossdoor_closing"
	appearance_flags = 0
	duration = 6
	layer = EDGED_TURF_LAYER
	pixel_x = -32
	pixel_y = -32

/obj/effect/temp_visual/necropolis/open/boss
	icon_state = "bossdoor_opening"
	duration = 38

/obj/structure/opacity_blocker/boss
	icon = 'modular_ss220/dunes_map/icons/gate.dmi'
	icon_state = "bossgate_blocker"
	layer = EDGED_TURF_LAYER
	pixel_x = -32
	pixel_y = -32
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	opacity = TRUE
	anchored = TRUE

/obj/structure/necropolis_arch/boss_arch
	name = "арка пирамиды"
	desc = "Циклопическая арка над вратами пирамиды, высеченная из черного камня."
	icon = 'modular_ss220/dunes_map/icons/arch.dmi'
	icon_state = "bossarch_full"
	pixel_x = -65
	pixel_y = -42

/obj/structure/necropolis_arch/boss_arch/Initialize()
	. = ..()
	icon_state = "bossarch_bottom"
	top_overlay = mutable_appearance('modular_ss220/dunes_map/icons/arch.dmi', "bossarch_top")
	top_overlay.layer = EDGED_TURF_LAYER
	add_overlay(top_overlay)
