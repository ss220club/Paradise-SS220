/// Управляет только шлюзами (airlock)
#define DOORCONTROL_AIRLOCK 1
/// Управляет только гермозатворами (poddoor)
#define DOORCONTROL_PODDOOR 2
/// Управляет и шлюзами, и гермозатворами
#define DOORCONTROL_BOTH    3

#define DOORCONTROL_MASS_DRIVER    4

/obj/machinery/door_control/Do_It_Admin
	name = "Button"
	desc = "Mystery buttom"
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
	id = "TEST_DIA"
	var/can_emag_act = FALSE
	var/msg_if_emagg_act_fail = "No no no, mr. Fish."
	var/msg_after_one_use_act_failure = "No result"
	var/msg_after_one_use_act_success = "Pressing too hard damaged the button. It looks like she can no longer be active."
	var/msg_if_no_access = "Access Denied."
	req_access = list()
	req_one_access = list()
	var/icon_if_denied = TRUE
	var/icon_if_complite = TRUE
	var/doorcontrol_mode = DOORCONTROL_BOTH
	var/act_if_no_poddor_bitflag = TRUE
	max_integrity = 500
	armor = list(melee = 50, bullet = 50, laser = 50, energy = 50, bomb = 10, rad = 100, fire = 90, acid = 70)

	var/launched = FALSE
	var/glass = TRUE
	var/range = 7
	var/button_double = FALSE

/obj/machinery/door_control/Do_It_Admin/proc/swap_indestructible(answer=TRUE)
	if(answer)
		resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	else
		resistance_flags = LAVA_PROOF | FIRE_PROOF

/obj/machinery/door_control/Do_It_Admin/proc/if_one_use(mob/user)
	if(only_one_use)
		if(used_after)
			to_chat(user, SPAN_WARNING(msg_after_one_use_act_failure))
			return
		to_chat(user, SPAN_WARNING(msg_after_one_use_act_success))
		used_after = TRUE
		return attack_hand(user)
	else
		return attack_hand(user)
/obj/machinery/door_control/Do_It_Admin/attack_ai(mob/user)
	return if_one_use(user)

/obj/machinery/door_control/Do_It_Admin/attack_ghost(mob/user)
	if(base_ghost_can_act)
		if(base_only_in_ghost_interaction)
			if(GLOB.configuration.general.ghost_interaction)
				return if_one_use(user)
			if(a_ghost_can_act && is_admin(user))
				if(only_in_adv_can_act)
					if(user.can_advanced_admin_interact())
						return if_one_use(user)
				else
					return if_one_use(user)
			return
		return if_one_use(user)

	if(a_ghost_can_act && is_admin(user))
		if(only_in_adv_can_act)
			if(user.can_advanced_admin_interact())
				return if_one_use(user)
		else
			return if_one_use(user)


/obj/machinery/door_control/Do_It_Admin/emag_act(mob/user)
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

/obj/machinery/door_control/Do_It_Admin/attack_hand(mob/user as mob)
	add_fingerprint(usr)
	if(stat & (NOPOWER|BROKEN))
		return

	if(!allowed(user) && (wires & 1) && !user.can_advanced_admin_interact())
		to_chat(user, SPAN_WARNING(msg_if_no_access))
		flick("doorctrl-denied", src)
		return

	use_power(5)
	if(icon_if_complite)
		icon_state = "doorctrl1"
	add_fingerprint(user)

	switch(doorcontrol_mode)
		if(DOORCONTROL_AIRLOCK)
			control_airlocks()
		if(DOORCONTROL_PODDOOR)
			control_poddoors()
		if(DOORCONTROL_BOTH)
			control_airlocks()
			control_poddoors()
		else
			stack_trace("door_control [src] имеет некорректный doorcontrol_mode: [doorcontrol_mode]")

	desiredstate_open = !desiredstate_open
	spawn(15)
		if(!(stat & NOPOWER))
			if(icon_if_complite)
				icon_state = "doorctrl0"

/// Пробегается по всем airlock'ам с нашим id и применяет specialfunctions / desiredstate_open.
/obj/machinery/door_control/Do_It_Admin/proc/control_airlocks()
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
			return

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
/obj/machinery/door_control/Do_It_Admin/proc/control_poddoors()
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
		return



/*
/obj/machinery/door_control/item_interaction(mob/living/user, obj/item/used, list/modifiers)
	if(istype(used, /obj/item/detective_scanner))
		return ITEM_INTERACT_COMPLETE
	return ..()

/rearm()

if(launched)
		return
	launched = TRUE

addtimer(CALLBACK(src, PROC_REF(rearm)), 7 SECONDS)
*/
