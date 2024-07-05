#define DRIVER_SEAT "Пилота"
#define GUNNER_SEAT "Стрелка"

#define NOMAD_DOWN 1
#define NOMAD_UP 2
#define NOMAD_PREPARE_TO_RISE 3
#define NOMAD_RISES 4
#define NOMAD_GOES_DOWN 5

#define COMSIG_MECHA_EQUIPMENT_CLICK "mecha_action_equipment_click"

/obj/effect/drop_pod
	icon = 'modular_ss220/event_invasion/icons/drop_pod.dmi'
	icon_state = "flare"
	appearance_flags = PIXEL_SCALE
	name = "МОЩЬ 11 СТВОЛОВ"
	desc = "Ужасают."

/obj/effect/drop_pod/Initialize(mapload)
	. = ..()
	flick("flare_act", src)

/obj/effect/nomad_guns
	icon = 'modular_ss220/event_invasion/icons/mecha.dmi'
	icon_state = "weapon_act_up"
	appearance_flags = PIXEL_SCALE
	name = "МОЩЬ 11 СТВОЛОВ"
	desc = "Ужасают."
	layer = 5
	pixel_x = -16
	pixel_y = 32

/obj/structure/mecha_wreckage/nomad
	name = "\improper Останки Кочевника"
	icon = 'modular_ss220/event_invasion/icons/mecha.dmi'
	icon_state = "nomad-broken"
	anchored = TRUE
	bound_height = 96
	bound_width = 64
	layer = 5.4
	pixel_x = -16
	pixel_y = 32

/obj/structure/mecha_wreckage/nomad/Initialize(mapload, mob/living/silicon/ai/AI_pilot)
	. = ..()

	appearance_flags |= PIXEL_SCALE
	transform = transform.Scale(2, 2)

/obj/mecha/combat/nomad
	desc = "A lightweight, security exosuit. Popular among private and corporate security."
	name = "Кочевник"
	icon = 'modular_ss220/event_invasion/icons/mecha.dmi'
	icon_state = "mech-down-0-0"
	initial_icon = "nomad"
	wreckage = /obj/structure/mecha_wreckage/nomad
	layer = 5.1
	step_in = 3
	opacity = FALSE
	dir_in = 1
	pixel_x = -16
	pixel_y = 32
	max_integrity = 5000
	deflect_chance = 5
	armor = list(melee = 50, bullet = 50, laser = 50, energy = 55, bomb = 50, rad = 50, fire = 100, acid = 75)
	max_temperature = 50000
	infra_luminosity = 6
	lights_power = 15
	leg_overload_coeff = 2
	wreckage = /obj/structure/mecha_wreckage/nomad
	internal_damage_threshold = 35
	max_equip = 3
	maxsize = 2
	step_energy_drain = 3
	normal_step_energy_drain = 3
	starting_voice = /obj/item/mecha_modkit/voice/syndicate/nomad
	var/mob/living/carbon/gunner = null
	var/datum/action/innate/mecha/gunner_mech_eject/gunner_eject_action = new
	var/datum/action/innate/mecha/strafe/strafing_action = new
	var/datum/action/innate/mecha/change_stance/change_stance_action = new
	var/datum/action/innate/mecha/mech_evacuation/mech_evacuate_action = new
	eject_action = new /datum/action/innate/mecha/mech_eject/nomad

	var/datum/action/innate/mecha/drop_pod/drop_pod_action = new
	var/datum/action/innate/mecha/drop_pod_launch/drop_launch_action = new
	var/mob/camera/aiEye/remote/nomad/eyeobj
	var/strafe = FALSE
	var/guns_decal_path = /obj/effect/nomad_guns
	var/obj/effect/guns_decal
	var/nomad_state = NOMAD_DOWN

/obj/mecha/combat/nomad/Initialize()
	. = ..()
	appearance_flags |= PIXEL_SCALE
	transform = transform.Scale(2, 2)
	update_icon(UPDATE_ICON_STATE)
	set_nomad_overlays(NOMAD_DOWN)
	var/obj/item/mecha_parts/mecha_equipment/nomad_gun = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/nomad/carbine
	nomad_gun.attach(src)
	nomad_gun = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/nomad/missile
	nomad_gun.attach(src)

/obj/mecha/combat/nomad/proc/CreateEye()
	eyeobj = new()
	eyeobj.origin = src
	eyeobj.visible_icon = 1
	eyeobj.icon = 'modular_ss220/event_invasion/icons/drop_pod.dmi'
	eyeobj.icon_state = "drop_pod"
	eyeobj.user_image = image(eyeobj.icon, eyeobj.loc, eyeobj.icon_state,FLY_LAYER)
	eyeobj.user_image.appearance_flags |= PIXEL_SCALE
	eyeobj.user_image.transform = eyeobj.user_image.transform.Scale(2, 2)

/obj/mecha/combat/nomad/proc/give_eye_control(mob/user)
	eyeobj.eye_user = user
	eyeobj.name = "Camera Eye ([user.name])"
	user.remote_control = eyeobj
	if(drop_launch_action)
		drop_launch_action.Grant(user, src)
	if(user.client)
		user.client.images += eyeobj.user_image
	user.reset_perspective(eyeobj)

/obj/mecha/combat/nomad/proc/remove_eye_control(mob/living/user)
	if(!user)
		return
	if(drop_launch_action)
		drop_launch_action.Remove(user)
	GrantActions(user)
	if(user.client)
		user.reset_perspective(null)
		eyeobj.RemoveImages()
	eyeobj.eye_user = null
	user.remote_control = null

/obj/mecha/combat/nomad/proc/set_nomad_overlays(state)
	if(!guns_decal)
		guns_decal = new guns_decal_path(loc)
		guns_decal.transform = guns_decal.transform.Scale(2, 2)
	switch(state)
		if(NOMAD_DOWN)
			guns_decal.icon_state = "weapon_down"
		if(NOMAD_RISES)
			flick("weapon_act_rise", guns_decal)
			guns_decal.icon_state = "weapon_up"
		if(NOMAD_GOES_DOWN)
			flick("weapon_act_down", guns_decal)
			guns_decal.icon_state = "weapon_down"
		if(NOMAD_UP)
			if(guns_decal)
				qdel(guns_decal)
				guns_decal = null

/obj/mecha/combat/nomad/update_icon_state()
	. = ..()
	switch(nomad_state)
		if(NOMAD_UP)
			icon_state = "mech"
		if(NOMAD_DOWN)
			icon_state = "mech-down-[occupant ? 1 : 0]-[gunner ? 1 : 0]"
		if(NOMAD_PREPARE_TO_RISE)
			icon_state = "mech-down-1-1"
		if(NOMAD_RISES)
			icon_state = "mech"
		if(NOMAD_GOES_DOWN)
			icon_state = "mech-down-1-1"


/obj/mecha/combat/nomad/MouseDrop_T(mob/M, mob/user)
	if(frozen)
		to_chat(user, "<span class='warning'>Do not enter Admin-Frozen mechs.</span>")
		return TRUE
	if(user.incapacitated())
		return
	if(user != M)
		return
	if(nomad_state == NOMAD_UP)
		to_chat(user, "<span class='warning'>\"Кочевник\" в боевой стойке. Вы не можете войти в него</span>")
		return TRUE
	log_message("[user] tries to move in.")
	if(occupant && gunner)
		to_chat(user, "<span class='warning'>[src] уже занят!</span>")
		log_append_to_last("Permission denied.")
		return TRUE

	var/input = tgui_alert(user, "Вы хотите сесть на место?:", "Выбор места", list(DRIVER_SEAT, GUNNER_SEAT))
	if(user == occupant || user == gunner)
		return TRUE
	switch (input)
		if(DRIVER_SEAT)
			if(occupant)
				to_chat(user, "<span class='warning'>[src] уже имеет пилота!</span>")
				log_append_to_last("Permission denied.")
				return TRUE
		if(GUNNER_SEAT)
			if(gunner)
				to_chat(user, "<span class='warning'>[src] уже имеет стрелка!</span>")
				log_append_to_last("Permission denied.")
				return TRUE
		else
			return TRUE
	var/passed
	if(dna)
		if(ishuman(user))
			if(user.dna.unique_enzymes == dna)
				passed = 1
	else if(operation_allowed(user))
		passed = 1
	if(!passed)
		to_chat(user, "<span class='warning'>Access denied.</span>")
		log_append_to_last("Permission denied.")
		return TRUE
	if(user.buckled)
		to_chat(user, "<span class='warning'>You are currently buckled and cannot move.</span>")
		log_append_to_last("Permission denied.")
		return TRUE
	if(user.has_buckled_mobs()) //mob attached to us
		to_chat(user, "<span class='warning'>You can't enter the exosuit with other creatures attached to you!</span>")
		return TRUE

	visible_message("<span class='notice'>[user] starts to climb into [src]")
	INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/mecha/combat/nomad, put_in_seat), user, input)
	return TRUE

/obj/mecha/combat/nomad/proc/put_in_seat(mob/user, seat)
	if(do_after(user, mech_enter_time, target = src))
		if(obj_integrity <= 0)
			to_chat(user, "<span class='warning'>You cannot get in the [name], it has been destroyed!</span>")
		else if(occupant && seat == DRIVER_SEAT)
			to_chat(user, "<span class='danger'>[occupant] was faster! Try better next time, loser.</span>")
		else if(gunner && seat == GUNNER_SEAT)
			to_chat(user, "<span class='danger'>[gunner] was faster! Try better next time, loser.</span>")
		else if(user.buckled)
			to_chat(user, "<span class='warning'>You can't enter the exosuit while buckled.</span>")
		else if(user.has_buckled_mobs())
			to_chat(user, "<span class='warning'>You can't enter the exosuit with other creatures attached to you!</span>")
		else
			moved_inside_seat(user, seat)
	else
		to_chat(user, "<span class='warning'>You stop entering the exosuit!</span>")

/obj/mecha/combat/nomad/GrantActions(mob/living/user, human_occupant = 0)
	internals_action.Grant(user, src)
	lights_action.Grant(user, src)
	change_stance_action.Grant(user, src)

	if (user == occupant)
		GrantDriverActions(user)
	else if (user == gunner)
		GrantGunnerActions(user)

/obj/mecha/combat/nomad/proc/GrantDriverActions(mob/living/user)
	eject_action.Grant(user, src)
	stats_action.Grant(user, src)
	strafing_action.Grant(user, src)
	if(locate(/obj/item/mecha_parts/mecha_equipment/thrusters) in equipment)
		add_thrusters()
	if(drop_pod_action)
		drop_pod_action.Grant(user, src)

/obj/mecha/combat/nomad/proc/GrantGunnerActions(mob/living/user)
	gunner_eject_action.Grant(user, src)
	mech_evacuate_action.Grant(user, src)

/obj/mecha/combat/nomad/proc/RemoveGunnerActions(mob/living/user)
	gunner_eject_action.Remove(user)
	mech_evacuate_action.Remove(user)

/obj/mecha/combat/nomad/proc/RemoveDriverActions(mob/living/user)
	eject_action.Remove(user)
	strafing_action.Remove(user)
	thrusters_action.Remove(user)
	stats_action.Remove(user)
	if(drop_pod_action)
		drop_pod_action.Remove(user)

/obj/mecha/combat/nomad/RemoveActions(mob/living/user, human_occupant = 0)
	internals_action.Remove(user)
	lights_action.Remove(user)
	change_stance_action.Remove(user)
	user.client.RemoveViewMod("mecha-auto-zoom")
	user.client.fit_viewport()

	if (user == occupant)
		RemoveDriverActions(user)
	if (user == gunner)
		RemoveGunnerActions(user)

/obj/mecha/combat/nomad/domove(direction)
	if(can_move >= world.time)
		return FALSE
	if(!Process_Spacemove(direction))
		return FALSE
	if(!has_charge(step_energy_drain))
		return FALSE
	if(nomad_state == NOMAD_DOWN)
		if(world.time - last_message > 20)
			occupant_message("<span class='danger'>Вы не можете двигаться, \"Кочевник\" сидит.</span>")
			last_message = world.time
		return FALSE
	if(nomad_state == NOMAD_GOES_DOWN || nomad_state == NOMAD_RISES || nomad_state == NOMAD_PREPARE_TO_RISE)
		if(world.time - last_message > 20)
			occupant_message("<span class='danger'>Вы не можете двигаться, \"Кочевник\" меняет стойку.</span>")
			last_message = world.time
		return FALSE
	if(defence_mode)
		if(world.time - last_message > 20)
			occupant_message("<span class='danger'>Unable to move while in defence mode.</span>")
			last_message = world.time
		return FALSE
	if(zoom_mode)
		if(world.time - last_message > 20)
			occupant_message("<span class='danger'>Unable to move while in zoom mode.</span>")
			last_message = world.time
		return FALSE

	if(thrusters_active && has_gravity(src))
		thrusters_active = FALSE
		to_chat(occupant, "<span class='notice'>Thrusters automatically disabled.</span>")
		step_in = initial(step_in)
	var/move_result = 0
	var/move_type = 0
	if(internal_damage & MECHA_INT_CONTROL_LOST)
		move_result = mechsteprand()
		move_type = MECHAMOVE_RAND
	else if(src.dir!=direction && !strafe)
		move_result = mechturn(direction)
		move_type = MECHAMOVE_TURN
	else
		move_result = mechstep(direction)
		move_type = MECHAMOVE_STEP

	if(move_result && move_type)
		aftermove(move_type)
		can_move = world.time + step_in
		return TRUE
	return FALSE

/obj/mecha/combat/nomad/mechstep(direction)
	var/current_dir = src.dir
	. = step(src, direction)
	if(strafe)
		src.dir = current_dir
	if(!.)
		if(phasing && get_charge() >= phasing_energy_drain)
			if(can_move < world.time)
				. = FALSE // We lie to mech code and say we didn't get to move, because we want to handle power usage + cooldown ourself
				flick("[initial_icon]-phase", src)
				forceMove(get_step(src, direction))
				use_power(phasing_energy_drain)
				playsound(src, stepsound, 40, 1)
				can_move = world.time + (step_in * 3)
	else if(stepsound)
		playsound(src, stepsound, 40, 1)

/obj/mecha/combat/nomad/proc/moved_inside_seat(mob/living/carbon/human/H as mob, seat)
	if(!(H && H.client && (H in range(2))))
		return FALSE
	switch (seat)
		if(DRIVER_SEAT)
			occupant = H
		if(GUNNER_SEAT)
			gunner = H
	GrantActions(H)
	H.stop_pulling()
	H.forceMove(src)
	add_fingerprint(H)
	forceMove(loc)
	log_append_to_last("[H] moved in as pilot.")
	dir = dir_in
	H.client.AddViewMod("mecha-auto-zoom", 12)
	H.client.fit_viewport()
	playsound(src, 'sound/machines/windowdoor.ogg', 50, 1)
	if(!activated)
		SEND_SOUND(occupant, sound(longactivationsound, volume = 50))
		activated = TRUE
	else if(!hasInternalDamage())
		SEND_SOUND(occupant, sound(nominalsound, volume = 50))
	if(state)
		H.throw_alert("locked", /atom/movable/screen/alert/mech_maintenance)
	if(connected_port)
		H.throw_alert("mechaport_d", /atom/movable/screen/alert/mech_port_disconnect)
	switch (seat)
		if(DRIVER_SEAT)
			flick("mech-close-act-2-[gunner ? 1 : 0]", src)
		if(GUNNER_SEAT)
			flick("mech-close-act-[occupant ? 1 : 0]-2", src)
	sleep(2 SECONDS)
	update_icon(UPDATE_ICON_STATE)
	return TRUE

/obj/mecha/combat/nomad/click_action(atom/target, mob/user, params)
	if((!occupant && !gunner) || (occupant != user && gunner != user))
		return
	if(user.incapacitated())
		return
	if(phasing)
		occupant_message("<span class='warning'>Unable to interact with objects while phasing.</span>")
		return
	if(state)
		occupant_message("<span class='warning'>Maintenance protocols in effect.</span>")
		return
	if(!get_charge())
		return
	if(src == target)
		return

	var/dir_to_target = get_dir(src, target)
	if(dir_to_target && !(dir_to_target & dir))//wrong direction
		return

	if(hasInternalDamage(MECHA_INT_CONTROL_LOST))
		target = safepick(view(3,target))
		if(!target)
			return

	var/mob/living/L = user
	if(!target.Adjacent(src))
		if(selected && selected.is_ranged() && gunner == user)
			if(HAS_TRAIT(L, TRAIT_PACIFISM) && selected.harmful)
				to_chat(L, "<span class='warning'>You don't want to harm other living beings!</span>")
				return
			if(user.mind?.martial_art?.no_guns)
				to_chat(L, "<span class='warning'>[L.mind.martial_art.no_guns_message]</span>")
				return
			if(SEND_SIGNAL(src, COMSIG_MECHA_EQUIPMENT_CLICK, L, target))
				return
			selected.action(target, params)
	else if(selected && selected.is_melee() && occupant == user)
		if(isliving(target) && selected.harmful && HAS_TRAIT(L, TRAIT_PACIFISM))
			to_chat(user, "<span class='warning'>You don't want to harm other living beings!</span>")
			return
		if(SEND_SIGNAL(src, COMSIG_MECHA_EQUIPMENT_CLICK, L, target))
			return
		selected.action(target, params)
	else
		if(internal_damage & MECHA_INT_CONTROL_LOST)
			target = safepick(oview(1, src))
		if(!melee_can_hit || !isatom(target))
			return
		target.mech_melee_attack(src)
		melee_can_hit = 0
		spawn(melee_cooldown)
			melee_can_hit = 1

/obj/mecha/combat/nomad/relaymove(mob/user, direction)
	if(!direction || frozen)
		return
	if(user != occupant) //While not "realistic", this piece is player friendly.
		if(world.time - last_message > 20)
			to_chat(user, "<span class='notice'>Вы не сидите на месте пилота меха \"[src]\".</span>")
			last_message = world.time
		return FALSE
	if(connected_port)
		if(world.time - last_message > 20)
			occupant_message("<span class='warning'>Unable to move while connected to the air system port!</span>")
			last_message = world.time
		return FALSE
	if(state)
		occupant_message("<span class='danger'>Maintenance protocols in effect.</span>")
		return
	return domove(direction)

/obj/mecha/combat/nomad/Destroy()
	gunner = null
	QDEL_NULL(guns_decal)
	. = ..()

/obj/mecha/combat/nomad/proc/drop_pod_launch(var/landing_loc)
	var/obj/structure/container/syndie/container = new(landing_loc)
	container.pixel_z = 1000
	forceMove(container)
	QDEL_NULL(guns_decal)

	var/obj/effect/flares = new /obj/effect/drop_pod(landing_loc)
	sleep(5 SECONDS)

	drop_launch_action.Remove(occupant)
	QDEL_NULL(drop_launch_action)
	drop_pod_action.Remove(occupant)
	QDEL_NULL(drop_pod_action)

	remove_eye_control(occupant)
	QDEL_NULL(eyeobj)

	animate(container, pixel_z = 0, time = 1 SECONDS)
	sleep(1 SECONDS)
	QDEL_NULL(flares)
	container.open_container()

/datum/action/innate/mecha/change_stance
	name = "Сменить стойку меха"
	icon_icon = 'modular_ss220/event_invasion/icons/mech_icon.dmi'
	button_icon_state = "mech_up"

/datum/action/innate/mecha/change_stance/Activate()
	if(!owner)
		return

	var/obj/mecha/combat/nomad/parsed_chassis = chassis

	if(!parsed_chassis || (parsed_chassis.occupant != owner && parsed_chassis.gunner != owner))
		return
	if(parsed_chassis.strafe)
		to_chat(owner, "<span class='warning'>Вы не можете поменять стойку пока \"Кочевник\" стрейфит.</span>")
		return

	parsed_chassis.dir = SOUTH
	if(parsed_chassis.nomad_state == NOMAD_UP)
		parsed_chassis.nomad_state = NOMAD_GOES_DOWN
		parsed_chassis.set_nomad_overlays(NOMAD_GOES_DOWN)
		parsed_chassis.update_icon(UPDATE_ICON_STATE)
		flick("mech-act-down", parsed_chassis)
		sleep(5 SECONDS)
		flick("mech-open-act-[parsed_chassis.occupant ? 1 : 2]-[parsed_chassis.gunner ? 1 : 2]", parsed_chassis)
		parsed_chassis.nomad_state = NOMAD_DOWN
		parsed_chassis.set_nomad_overlays(NOMAD_DOWN)
		parsed_chassis.update_icon(UPDATE_ICON_STATE)

	else if(parsed_chassis.nomad_state == NOMAD_DOWN)
		flick("mech-close-act-[parsed_chassis.occupant ? 1 : 2]-[parsed_chassis.gunner ? 1 : 2]", parsed_chassis)
		parsed_chassis.nomad_state = NOMAD_PREPARE_TO_RISE
		parsed_chassis.update_icon(UPDATE_ICON_STATE)
		sleep(2 SECONDS)

		flick("mech-act-up", parsed_chassis)
		parsed_chassis.set_nomad_overlays(NOMAD_RISES)
		parsed_chassis.nomad_state = NOMAD_RISES
		parsed_chassis.update_icon(UPDATE_ICON_STATE)
		sleep(5 SECONDS)
		parsed_chassis.nomad_state = NOMAD_UP
		parsed_chassis.update_icon(UPDATE_ICON_STATE)
		parsed_chassis.set_nomad_overlays(NOMAD_UP)

	button_icon_state = "mech_[parsed_chassis.nomad_state == NOMAD_DOWN ? "up" : "down"]"
	UpdateButtons()

/datum/action/innate/mecha/mech_eject/nomad/Activate()
	if(!owner)
		return

	var/obj/mecha/combat/nomad/parsed_chassis = chassis

	if(!parsed_chassis || parsed_chassis.occupant != owner)
		return

	if(parsed_chassis.nomad_state != NOMAD_DOWN)
		to_chat(owner, "<span class='warning'>Вы не можете выйти из \"Кочевника\" пока он не в сидячем положении.</span>")
		return


	flick("mech-open-act-2-[parsed_chassis.gunner ? 1 : 0]", parsed_chassis)
	sleep(2 SECONDS)
	chassis.go_out()
	parsed_chassis.update_icon(UPDATE_ICON_STATE)

/datum/action/innate/mecha/gunner_mech_eject
	name = "Выйти из меха"
	button_icon_state = "mech_eject"

/datum/action/innate/mecha/gunner_mech_eject/Activate()
	if(!owner)
		return

	var/obj/mecha/combat/nomad/parsed_chassis = chassis

	if(!parsed_chassis || parsed_chassis.gunner != owner)
		return

	if(parsed_chassis.nomad_state != NOMAD_DOWN)
		to_chat(owner, "<span class='warning'>Вы не можете выйти из \"Кочевника\" пока он не в сидячем положении.</span>")
		return

	flick("mech-open-act-[parsed_chassis.occupant ? 1 : 0]-2", parsed_chassis)
	parsed_chassis.update_icon(UPDATE_ICON_STATE)
	sleep(2 SECONDS)
	owner.forceMove(get_turf(parsed_chassis))
	to_chat(owner, "<span class='notice'>Вы вылезли из меха \"[src]\".</span>")
	parsed_chassis.RemoveActions(owner)
	parsed_chassis.gunner = null

/datum/action/innate/mecha/strafe
	name = "Переключить режим стрейфа"
	button_icon_state = "strafe"

/datum/action/innate/mecha/strafe/Activate()
	if(!owner || !chassis || chassis.occupant != owner)
		return

	var/obj/mecha/combat/nomad/parsed_chassis = chassis

	if(!parsed_chassis)
		return

	parsed_chassis.strafe = !parsed_chassis.strafe

	chassis.occupant_message("Стрейф [parsed_chassis.strafe ? "активирован" : "деактивирован"].")
	chassis.log_message("Стрейф [parsed_chassis.strafe ? "активирован" : "деактивирован"].")

/datum/action/innate/mecha/mech_evacuation
	name = "Блюспейс эвакуация"
	icon_icon = 'modular_ss220/event_invasion/icons/mech_icon.dmi'
	button_icon_state = "drop_pilot"

/datum/action/innate/mecha/mech_evacuation/Activate()
	if(!owner)
		return

	var/obj/mecha/combat/nomad/parsed_chassis = chassis
	var/mob/target = owner
	parsed_chassis.RemoveActions(owner)

	if(!parsed_chassis)
		return
	if (parsed_chassis.occupant == target)
		parsed_chassis.occupant = null
	else if(parsed_chassis.gunner == target)
		parsed_chassis.gunner = null
	else
		return
	evacuate_target(target)

/datum/action/innate/mecha/mech_evacuation/proc/evacuate_target(atom/movable/target)
	var/obj/effect/extraction_holder/holder_obj = new(locate(328, 118, 3))
	var/mutable_appearance/balloon
	var/mutable_appearance/balloon2
	var/mutable_appearance/balloon3

	playsound(target.loc, 'sound/items/fultext_launch.ogg', 50, 1, -3)
	target.forceMove(holder_obj)
	holder_obj.appearance = target.appearance
	balloon2 = mutable_appearance('icons/obj/fulton_balloon.dmi', "fulton_expand")
	balloon2.pixel_y = 10
	balloon2.appearance_flags = RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM
	holder_obj.add_overlay(balloon2)
	holder_obj.pixel_z = 1000
	balloon = mutable_appearance('icons/obj/fulton_balloon.dmi', "fulton_balloon")
	balloon.pixel_y = 10
	balloon.appearance_flags = RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM
	holder_obj.cut_overlay(balloon2)
	holder_obj.add_overlay(balloon)
	if(ishuman(target))
		var/mob/living/carbon/human/living_target = target
		living_target.SetParalysis(0)
		living_target.SetDrowsy(0)
		living_target.SetSleeping(0)
	animate(holder_obj, pixel_z = 10, time = 50)
	sleep(50)
	animate(holder_obj, pixel_z = 15, time = 10)
	sleep(10)
	animate(holder_obj, pixel_z = 10, time = 10)
	sleep(10)
	balloon3 = mutable_appearance('icons/obj/fulton_balloon.dmi', "fulton_retract")
	balloon3.pixel_y = 10
	balloon3.appearance_flags = RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM
	holder_obj.cut_overlay(balloon)
	holder_obj.add_overlay(balloon3)
	sleep(4)
	holder_obj.cut_overlay(balloon3)
	target.anchored = FALSE // An item has to be unanchored to be extracted in the first place.
	target.density = initial(target.density)
	animate(holder_obj, pixel_z = 0, time = 5)
	target.forceMove(holder_obj.loc)
	qdel(holder_obj)

/datum/action/innate/mecha/drop_pod_launch
	name = "Начать десантирование меха"
	icon_icon = 'modular_ss220/event_invasion/icons/mech_icon.dmi'
	button_icon_state = "drop_pod"

/datum/action/innate/mecha/drop_pod_launch/Activate()
	var/obj/mecha/combat/nomad/parsed_chassis = chassis
	if(!owner || !parsed_chassis)
		return

	parsed_chassis.drop_pod_launch(parsed_chassis.eyeobj.loc)

/datum/action/innate/mecha/drop_pod
	name = "Десантировать мех на планету"
	icon_icon = 'modular_ss220/event_invasion/icons/mech_icon.dmi'
	button_icon_state = "drop_pod"
	var/in_use = FALSE

/datum/action/innate/mecha/drop_pod/Activate()
	var/obj/mecha/combat/nomad/parsed_chassis = chassis
	if(!owner || parsed_chassis.occupant != owner)
		return

	if(!parsed_chassis.eyeobj)
		parsed_chassis.CreateEye()

	if(in_use)
		parsed_chassis.remove_eye_control(owner)
		name = "Десантировать мех на планету"
		button_icon_state = "drop_pod"
		UpdateButtons()
		in_use = FALSE
		return

	name = "Выйти из режима десантирования"
	button_icon_state = "cancel_drop_pod"
	UpdateButtons()
	in_use = TRUE

	if(!parsed_chassis.eyeobj.eye_initialized)
		var/eye_location = locate(328, 118, 3)
		parsed_chassis.eyeobj.eye_initialized = 1
		parsed_chassis.give_eye_control(owner)
		parsed_chassis.eyeobj.setLoc(eye_location)
	else
		parsed_chassis.give_eye_control(owner)
		parsed_chassis.eyeobj.setLoc(parsed_chassis.eyeobj.loc)

/mob/camera/aiEye/remote/nomad
	use_static = FALSE

/mob/camera/aiEye/remote/nomad/Destroy()
	RemoveImages()
	QDEL_NULL(user_image)
	return ..()


/mob/camera/aiEye/remote/nomad/setLoc(T)
	if(!eye_user)
		return
	T = get_turf(T)
	var/old_loc = loc
	loc = T
	Moved(old_loc, get_dir(old_loc, loc))
	if(use_static)
		GLOB.cameranet.visibility(src, GetViewerClient())
	user_image.loc = T

#undef DRIVER_SEAT
#undef GUNNER_SEAT
#undef COMSIG_MECHA_EQUIPMENT_CLICK

