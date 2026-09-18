/// Управляет только шлюзами (airlock)
#define DOORCONTROL_AIRLOCK 1
/// Управляет только гермозатворами (poddoor)
#define DOORCONTROL_PODDOOR 2
/// Управляет и шлюзами, и гермозатворами
#define DOORCONTROL_BOTH    3

#define DOORCONTROL_MASS_DRIVER    4


#define DOORCONTROL_BUTTON    1

#define DOORCONTROL_GLASS_BUTTON    2




/obj/machinery/Do_It_Admin
	name = "Button"
	desc = "Mystery button"
	var/ai_can_act = TRUE
	var/humman_can_act = TRUE
	var/base_ghost_can_act = TRUE
	var/a_ghost_can_act = TRUE
	var/only_in_adv_can_act = TRUE
	var/base_only_in_ghost_interaction = TRUE
	var/del_acess_on_emagging = TRUE
	resistance_flags = LAVA_PROOF | FIRE_PROOF
	var/only_one_use = FALSE
	var/used_after = FALSE
	power_state = NO_POWER_USE
	interact_offline = TRUE
	var/id = "TEST_DIA_ID"
	var/id_tag = "TEST_DIA_TAG"
	var/specialfunctions = 1
	var/desiredstate_open = FALSE
	var/safety_z_check = TRUE

	/*
	Bitflag, 	1= open
				2= idscan,
				4= bolts
				8= shock
				16= door safties

	*/

	power_channel = PW_CHANNEL_ENVIRONMENT

	//icon_state = "[initial(icon_state)]_launched"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "doorctrl0"

	var/can_emag_act = FALSE
	var/msg_if_emagg_act_fail = "No no no, mr. Fish."
	var/msg_after_one_use_act_failure = "No result"
	var/msg_after_one_use_act_success = "Pressing too hard damaged the button. It looks like she can no longer be active."
	var/msg_if_no_access = "Access Denied."
	req_access = list()
	req_one_access = list()
	var/icon_if_denied = TRUE
	var/icon_if_activate = TRUE
	var/icon_if_complite = TRUE
	var/doorcontrol_mode = DOORCONTROL_BOTH
	var/act_if_no_poddor_bitflag = TRUE
	max_integrity = 500
	armor = list(melee = 50, bullet = 50, laser = 50, energy = 50, bomb = 10, rad = 100, fire = 90, acid = 70)
	var/active = FALSE

	var/idle_icon_ifter_one_use = FALSE

	var/glass = TRUE
	var/range = 7

	var/type_by_button = DOORCONTROL_BUTTON

	var/msg_gbutton_glass_breaking_usr = "Вы разбиваете стекло кнопки!"
	var/msg_gbutton_glass_breaking_vis = "Он разбивает стекло кнопки!"
	var/sound_breaking_glass = 'sound/effects/hit_on_shattered_glass.ogg'
	var/sound_cnock_glass = 'sound/effects/glassknock.ogg'
	var/msg_gbutton_glass_cnocking_usr = "Вы дружески похлопываете по стеклу."
	var/msg_gbutton_glass_cnocking_vis = "Он дружески похлопывает по стеклу."
	var/training_msg = "Если вы пытаетесь разбить стекло, вам придется ударить по нему сильнее..."

/obj/machinery/Do_It_Admin/proc/swap_indestructible(answer=TRUE)
	if(answer)
		resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
		return 1
	else
		resistance_flags = LAVA_PROOF | FIRE_PROOF
		return 1

/obj/machinery/Do_It_Admin/proc/swap_button_type()
	if(active)
		return
	obj_integrity = max_integrity
	switch(type_by_button)
		if(DOORCONTROL_BUTTON)
			type_by_button = DOORCONTROL_GLASS_BUTTON
			icon = 'modular_ss220/sm_space_drop/icons/sm_buttons.dmi'
			icon_state = "button"
			return TRUE
		if(DOORCONTROL_GLASS_BUTTON)
			type_by_button = DOORCONTROL_BUTTON
			icon = 'icons/obj/stationobjs.dmi'
			icon_state = "doorctrl0"
			launched = FALSE
			glass = TRUE
			return TRUE
	return FALSE

/obj/machinery/Do_It_Admin/power_change()
	if(!..())
		return
	if(stat & NOPOWER)
		switch(type_by_button)
			if(DOORCONTROL_BUTTON)
				icon_state = "doorctrl-p"

	else
		switch(type_by_button)
			if(DOORCONTROL_BUTTON)
				icon_state = "doorctrl0"


#define IS_HUMAN    1
#define IS_AI    2
#define IS_GHOST    3
#define IS_AGHOST    4

/obj/machinery/Do_It_Admin/proc/pred_prov(mob/user, hu = IS_HUMAN)
	if(active)
		return
	switch(type_by_button)
		if(DOORCONTROL_BUTTON)
			if(only_one_use)
				if(used_after)
					to_chat(user, SPAN_WARNING(msg_after_one_use_act_failure))
					return
				to_chat(user, SPAN_WARNING(msg_after_one_use_act_success))
				used_after = TRUE
				return activate_button(user, hu)
			else
				return activate_button(user, hu)

		if(DOORCONTROL_GLASS_BUTTON)
			if(glass)
				if(user.a_intent == INTENT_HARM)
					if(hu==IS_HUMAN)
						user.visible_message(SPAN_WARNING(msg_gbutton_glass_breaking_vis), SPAN_WARNING(msg_gbutton_glass_breaking_usr))
						user.do_attack_animation(src, ATTACK_EFFECT_PUNCH)
					glass = FALSE
					playsound(loc, sound_breaking_glass, 100, TRUE)
					icon_state = "button_open"
				else
					if(hu==IS_HUMAN)
						user.visible_message(SPAN_NOTICE(msg_gbutton_glass_cnocking_vis), SPAN_NOTICE(msg_gbutton_glass_cnocking_usr))
					playsound(loc, sound_cnock_glass, 50, TRUE)
					to_chat(user, SPAN_WARNING(training_msg))
			else
				if(only_one_use)
					if(used_after)
						to_chat(user, SPAN_WARNING(msg_after_one_use_act_failure))
						return
					to_chat(user, SPAN_WARNING(msg_after_one_use_act_success))
					used_after = TRUE
					return activate_button(user, hu)
				else
					return activate_button(user, hu)

/obj/machinery/Do_It_Admin/attack_ai(mob/user)
	return pred_prov(user, IS_AI)

/obj/machinery/Do_It_Admin/attack_ghost(mob/user)
	if(base_ghost_can_act)
		if(base_only_in_ghost_interaction)
			if(GLOB.configuration.general.ghost_interaction)
				if(is_admin(user))
					return pred_prov(user, IS_AGHOST)
				else
					return pred_prov(user, IS_GHOST)
			if(a_ghost_can_act && is_admin(user))
				if(only_in_adv_can_act)
					if(user.can_advanced_admin_interact())
						return pred_prov(user, IS_AGHOST)
				else
					return pred_prov(user, IS_AGHOST)
			return
		else
			if(is_admin(user))
				return pred_prov(user, IS_AGHOST)
			else
				return pred_prov(user, IS_GHOST)

	if(a_ghost_can_act && is_admin(user))
		if(only_in_adv_can_act)
			if(user.can_advanced_admin_interact())
				return pred_prov(user, IS_AGHOST)
		else
			return pred_prov(user, IS_AGHOST)


/obj/machinery/Do_It_Admin/emag_act(mob/user)
	if(can_emag_act)
		if(!emagged)
			emagged = TRUE
			if(del_acess_on_emagging)
				req_access = list()
				req_one_access = list()
			playsound(src, "sparks", 100, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
			return TRUE
		return FALSE
	to_chat(user, SPAN_WARNING(msg_if_emagg_act_fail))
	return FALSE

/obj/machinery/Do_It_Admin/attack_hand(mob/user)
	return pred_prov(user, IS_HUMAN)

/obj/machinery/Do_It_Admin/proc/activate_button(mob/user, hu = IS_HUMAN)
	if(hu == IS_HUMAN)
		add_fingerprint(user)
	if(stat & (NOPOWER|BROKEN))
		return

	if(!allowed(user)&& !user.can_advanced_admin_interact())
		to_chat(user, SPAN_WARNING(msg_if_no_access))
		switch(type_by_button)
			if(DOORCONTROL_BUTTON)
				flick("doorctrl-denied", src)
		return
	if(active)
		return
	active = TRUE
	if(icon_if_activate)
		switch(type_by_button)
			if(DOORCONTROL_BUTTON)
				icon_state = "doorctrl1"
			if(DOORCONTROL_GLASS_BUTTON)
				flick("button_launched", src)

	switch(doorcontrol_mode)
		if(DOORCONTROL_AIRLOCK)
			control_airlocks()
		if(DOORCONTROL_PODDOOR)
			control_poddoors()
		if(DOORCONTROL_BOTH)
			control_airlocks()
			control_poddoors()
		if(DOORCONTROL_MASS_DRIVER)
			control_mass()
		else
			stack_trace("door_control [src] имеет некорректный doorcontrol_mode: [doorcontrol_mode]")

	desiredstate_open = !desiredstate_open
	spawn(15)
		if(!(stat & NOPOWER))
			if(icon_if_complite)
				switch(type_by_button)
					if(DOORCONTROL_BUTTON)
						icon_state = "doorctrl0"
					if(DOORCONTROL_GLASS_BUTTON)
						icon_state = "button_open"
	active=FALSE

/// Пробегается по всем airlock'ам с нашим id и применяет specialfunctions / desiredstate_open.
/obj/machinery/Do_It_Admin/proc/control_airlocks()
	for(var/obj/machinery/door/airlock/D in GLOB.airlocks)
		if(safety_z_check && D.z != z)
			continue
		if(D.id_tag != id)
			continue

		if(specialfunctions & OPEN)
			if(D.density)
				spawn(0)
					D.open()
			else
				spawn(0)
					D.close()

		if(desiredstate_open)
			if(specialfunctions & IDSCAN)
				D.aiDisabledIdScanner = 1
			if(specialfunctions & BOLTS)
				D.lock()
			if(specialfunctions & SHOCK)
				D.electrify(-1)
			if(specialfunctions & SAFE)
				D.safe = 0
		else
			if(specialfunctions & IDSCAN)
				D.aiDisabledIdScanner = 0
			if(specialfunctions & BOLTS)
				D.unlock()
			if(specialfunctions & SHOCK)
				D.electrify(0)
			if(specialfunctions & SAFE)
				D.safe = 1

/// Пробегается по всем poddoor'ам с нашим id и открывает/закрывает их.
/obj/machinery/Do_It_Admin/proc/control_poddoors()
	// Если кнопка требует явного бита OPEN — проверяем его.
	// Если переменной нет у типа (базовый /obj/machinery/door_control) — считаем, что ограничения нет.
	var/require_open_bit = !act_if_no_poddor_bitflag
	if(require_open_bit && !(specialfunctions & OPEN))
		return

	for(var/obj/machinery/door/poddoor/M in GLOB.airlocks)
		if(safety_z_check && M.z != z)
			continue
		if(M.id_tag != id)
			continue

		if(M.density)
			spawn(0)
				M.open()
		else
			spawn(0)
				M.close()

/obj/machinery/Do_It_Admin/proc/control_mass()

	// Time sequence
	// OPEN DOORS
	// Wait 2 seconds
	// LAUNCH
	// Wait 5 seconds
	// CLOSE
	// Then make not active
	for(var/obj/machinery/door/poddoor/M in range(src, range))
		if(M.id_tag == id_tag && !M.protected)
			INVOKE_ASYNC(M, TYPE_PROC_REF(/obj/machinery/door, open))

	// 2 seconds after previous invocation

	for(var/obj/machinery/mass_driver/M in range(src, range))
		if(M.id_tag == id_tag)
			addtimer(CALLBACK(M, TYPE_PROC_REF(/obj/machinery/mass_driver, drive)), 2 SECONDS)

	// We want this 5 seconds after open, so the delay is 7 seconds from this proc

	for(var/obj/machinery/door/poddoor/M in range(src, range))
		if(M.id_tag == id_tag && !M.protected)
			addtimer(CALLBACK(M, TYPE_PROC_REF(/obj/machinery/door, close)), 7 SECONDS)

/*
/obj/machinery/driver_button/sm_drop_button/update_icon_state()
	if(launched)
		icon_state = "[initial(icon_state)]_launched"
	else if(!glass)
		icon_state = "[initial(icon_state)]_open"
	else
		icon_state = "[initial(icon_state)]"
	..()

/obj/machinery/driver_button/sm_drop_button/examine(mob/user)
	. = ..()
	if(!glass)
		. += SPAN_NOTICE("У [name] разбито защитное стекло.")
	if(launched)
		. += SPAN_NOTICE("Кнопка медленно мигает, сигнализируя о том, что она была нажата.")
*/

/*
/obj/machinery/item_interaction(mob/living/user, obj/item/used, list/modifiers)
	if(istype(used, /obj/item/detective_scanner))
		return ITEM_INTERACT_COMPLETE
	return ..()

/rearm()

if(launched)
		return
	launched = TRUE

addtimer(CALLBACK(src, PROC_REF(rearm)), 7 SECONDS)
*/
