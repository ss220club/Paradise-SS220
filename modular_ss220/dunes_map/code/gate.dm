
//boss gate
/obj/structure/boss_gate //не смог победить cut overlay
	name = "\improper врата храма"
	desc = "Проклятые чёрные врата забытой пирамиды. Хирка таит в себе множество тайн и загадок, но что бы подобное..."
	icon = 'modular_ss220/dunes_map/icons/gate_boss.dmi'
	icon_state = "bossgate_full"
	light_power = 0
	light_range = 0
	flags = ON_BORDER
	appearance_flags = 0
	layer = TABLE_LAYER
	anchored = TRUE
	density = TRUE
	pixel_x = -32
	pixel_y = -32
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/open = FALSE
	var/changing_openness = FALSE
	var/static/mutable_appearance/top_overlay
	var/static/mutable_appearance/door_overlay
	var/static/mutable_appearance/dais_overlay
	var/obj/structure/opacity_blocker_boss/sight_blocker
	var/sight_blocker_distance = 1

/obj/structure/boss_gate/Initialize()
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

	top_overlay = mutable_appearance('modular_ss220/dunes_map/icons/gate_boss.dmi', "bossgate_top")
	top_overlay.layer = EDGED_TURF_LAYER
	add_overlay(top_overlay)

	door_overlay = mutable_appearance('modular_ss220/dunes_map/icons/gate_boss.dmi', "bossdoor")
	door_overlay.layer = EDGED_TURF_LAYER
	add_overlay(door_overlay)

	dais_overlay = mutable_appearance('modular_ss220/dunes_map/icons/gate_boss.dmi', "bossgate_dais")
	dais_overlay.layer = CLOSED_TURF_LAYER
	add_overlay(dais_overlay)

/obj/structure/boss_gate/Destroy()
	qdel(sight_blocker, TRUE)
	return ..()

/obj/structure/boss_gate/singularity_pull()
	return

/obj/structure/boss_gate/CanPass(atom/movable/mover, turf/target)
	if(get_dir(loc, target) == dir)
		return !density
	return TRUE

/obj/structure/boss_gate/CheckExit(atom/movable/O, target)
	if(get_dir(O.loc, target) == dir)
		return !density
	return TRUE

/obj/structure/opacity_blocker_boss
	icon = 'modular_ss220/dunes_map/icons/gate_boss.dmi'
	icon_state = "bossgate_blocker"
	layer = EDGED_TURF_LAYER
	pixel_x = -32
	pixel_y = -32
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	opacity = TRUE
	anchored = TRUE

/obj/structure/opacity_blocker_boss/singularity_pull()
	return

/obj/structure/boss_gate/attack_hand(mob/user)
	. = ..()
	toggle_the_bossgate(user)

/obj/structure/boss_gate/proc/toggle_the_bossgate(mob/user)
	if(changing_openness)
		return

	changing_openness = TRUE
	var/turf/T = get_turf(src)

	if(open)
		new /obj/effect/temp_visual/boss_gate(T)
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
		addtimer(CALLBACK(src, PROC_REF(toggle_boss_open_delayed_step), T), 0.5 SECONDS, TIMER_UNIQUE)
		return TRUE

	cut_overlay(door_overlay)
	new /obj/effect/temp_visual/boss_gate/open(T)
	visible_message("<span class='warning'>Врата пирамиды расступаются перед вами, издавая пронзительный скрежет...</span>")
	playsound(T, 'sound/effects/stonedoor_openclose.ogg', 300, TRUE, frequency = 20000)
	addtimer(CALLBACK(src, PROC_REF(toggle_boss_closed_delayed_step)), 2.2 SECONDS, TIMER_UNIQUE)
	return TRUE

/obj/structure/boss_gate/proc/toggle_boss_open_delayed_step(turf/T)
	playsound(T, 'sound/magic/clockwork/invoke_general.ogg', 30, TRUE, frequency = 15000)
	add_overlay(door_overlay)
	open = FALSE
	changing_openness = FALSE

/obj/structure/boss_gate/proc/toggle_boss_closed_delayed_step()
	sight_blocker.forceMove(src)
	density = FALSE
	open = TRUE
	changing_openness = FALSE

/obj/effect/temp_visual/boss_gate
	icon = 'modular_ss220/dunes_map/icons/gate_boss.dmi'
	icon_state = "bossdoor_closing"
	appearance_flags = 0
	duration = 10
	layer = EDGED_TURF_LAYER
	pixel_x = -32
	pixel_y = -32

/obj/effect/temp_visual/boss_gate/open
	icon_state = "bossdoor_opening"
	duration = 10

//Арка

/obj/structure/necropolis_arch/boss_arch
	name = "арка пирамиды"
	desc = "Циклопическая арка над вратами пирамиды, высеченная из черного камня."
	icon = 'modular_ss220/dunes_map/icons/arch.dmi'
	icon_state = "bossarch_full"
	pixel_x = -64
	pixel_y = -42

/obj/structure/necropolis_arch/boss_arch/Initialize()
	. = ..()
	icon_state = "bossarch_bottom"
	top_overlay = mutable_appearance('modular_ss220/dunes_map/icons/arch.dmi', "bossarch_top")
	top_overlay.layer = EDGED_TURF_LAYER
	add_overlay(top_overlay)
