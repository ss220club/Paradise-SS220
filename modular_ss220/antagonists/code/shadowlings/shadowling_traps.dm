/obj/structure/shadow_trap
	name = "тёмное пятно"
	desc = "Большое тёмное пятно на полу, стенах и потолке. Вы не уверены что это такое, но лучше держаться подальше."
	var/trap_name = "сломанная"
	var/shadowling_desc = "Эта ловушка, похоже, сломана."
	anchored = TRUE
	opacity = FALSE
	layer = ABOVE_OBJ_LAYER
	max_integrity = 50

	var/created_by

/obj/structure/shadow_trap/Crossed(atom/movable/AM, oldloc)
	. = ..()
	if(is_shadow_or_thrall(AM))
		return
	if(!trap_activate(AM))	// Returns false if trap isn't triggered by this type
		return
	if(created_by)
		to_chat(created_by, span_purple("Ваша [trap_name] сработала на [AM] в [get_turf(AM.loc)]"))
	else
		created_by = "Admin spawn"
	add_attack_logs(AM, AM, "activated shadowling trap placed by [created_by]", ATKLOG_ALL)
	qdel(src)

/obj/structure/shadow_trap/proc/trap_activate(mob/living/target)
	return

/obj/structure/shadow_trap/examine(mob/user)
	. = ..()
	if(is_shadow_or_thrall(user))
		. += shadowling_desc

// Stun Trap
// Disable headset, stun for 6 seconds and disable light

/obj/structure/shadow_trap/stun
	trap_name = "оглущающая"
	shadowling_desc = "Это оглушающая ловушка."

/obj/structure/shadow_trap/stun/trap_activate(mob/living/target)
	if(ishuman(target))
		var/mob/living/carbon/human/human_target = target
		to_chat(human_target, span_boldwarning("Вас что-то схватило за ногу!"))
		human_target.emote("scream")
		human_target.KnockDown(6 SECONDS)
		human_target.Confused(7 SECONDS)
		human_target.extinguish_light()
		for(var/obj/item/headset in human_target.contents)
			if(istype(headset, /obj/item/radio))
				headset.emp_act()
		return TRUE
	if(isrobot(target))
		var/mob/living/silicon/robot/robot_target = target
		to_chat(robot_target, span_boldwarning("ОШИБКА: Неизвестное проникновение в п$о%#@*&..."))
		robot_target << 'sound/misc/interference.ogg'
		playsound(robot_target, 'sound/machines/warning-buzzer.ogg', 50, TRUE)
		do_sparks(5, 1, robot_target)
		robot_target.extinguish_light()
		robot_target.Weaken(6 SECONDS)
		return TRUE
	return FALSE
