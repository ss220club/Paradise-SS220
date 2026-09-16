
#define OPERATING_MOD_DROP_SM 1

#define OPERATING_MOD_ACT_NUCLEAR 2

/obj/machinery/driver_button/sm_drop_button/Do_It_Admin
	name = "Big Red Button"
	desc = "Mystery Big Red buttom"
	resistance_flags = LAVA_PROOF | FIRE_PROOF
	launched = FALSE
	glass = TRUE
	range = 7
	req_access = list()
	req_one_access = list()

	id_tag = "TEST_DIA"

	power_state = NO_POWER_USE
	interact_offline = TRUE

	active = FALSE
	/// If the safety glass is still in place
	glass = TRUE
	/// If it's already used and launched
	launched = FALSE
	max_integrity = 500
	armor = list(melee = 50, bullet = 50, laser = 50, energy = 50, bomb = 10, rad = 100, fire = 90, acid = 70)

	var/ai_can_act = TRUE
	var/humman_can_act = TRUE
	var/base_ghost_can_act = TRUE
	var/a_ghost_can_act = TRUE
	var/only_in_adv_can_act = TRUE
	var/base_only_in_ghost_interaction = TRUE
	var/del_acess_on_emagging = TRUE
	var/only_one_use = FALSE
	var/used_after = FALSE
	var/can_emag_act = FALSE
	var/msg_if_emagg_act_fail = "No no no, mr. Fish."
	var/msg_after_one_use_act_failure = "No result"
	var/msg_after_one_use_act_success = "Pressing too hard damaged the button. It looks like she can no longer be active."
	var/msg_if_no_access = "Access Denied."
	var/icon_if_denied = TRUE
	var/icon_if_complite = TRUE
	var/doorcontrol_mode = DOORCONTROL_BOTH
	var/act_if_no_poddor_bitflag = TRUE

/obj/machinery/driver_button/sm_drop_button/Do_It_Admin/proc/swap_indestructible(answer=TRUE)
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

/obj/machinery/driver_button/sm_drop_button/attack_hand(mob/user)
	user.changeNext_move(CLICK_CD_MELEE)

	if(stat & (NOPOWER|BROKEN))
		return

	if(active)
		return

	if(is_ai(user))
		return

	add_fingerprint(user)
	use_power(5)

	if(!allowed(user) && !glass && !launched)
		to_chat(user, SPAN_WARNING("В доступе отказано."))
		return

	// Already launched
	if(launched)
		to_chat(user, SPAN_WARNING("Кнопка уже нажата."))
		return

	// Glass present
	else if(glass)
		if(user.a_intent == INTENT_HARM)
			user.visible_message(SPAN_WARNING("[user] разбивает стекло [name]!"), SPAN_WARNING("Вы разбиваете стекло [name]!"))
			user.do_attack_animation(src, ATTACK_EFFECT_PUNCH)
			glass = FALSE
			playsound(loc, 'sound/effects/hit_on_shattered_glass.ogg', 100, TRUE)
			update_icon(UPDATE_ICON_STATE)
		else
			user.visible_message(SPAN_NOTICE("[user] дружески похлопывает по [name]."), SPAN_NOTICE("Вы дружески похлопываете по [name]."))
			playsound(loc, 'sound/effects/glassknock.ogg', 50, TRUE)
			to_chat(user, SPAN_WARNING("Если вы пытаетесь разбить стекло, вам придется ударить по нему сильнее..."))
	else
		// Must be !glass and !launched and crystal is in emergency state (around 10%)
		for(crystal in SSair.atmos_machinery)
			if(crystal?.id_tag == id_tag && crystal?.get_integrity() < SUPERMATTER_EMERGENCY)
				user.visible_message(SPAN_WARNING("[user] нажимает кнопку сброса [name]!"), SPAN_WARNING("Вы нажимаете кнопку сброса!"))
				playsound(loc, "modular_ss220/sm_space_drop/sound/button[rand(1, 5)].ogg", 100, TRUE)
				visible_message(SPAN_NOTICE("Кнопка громко щелкает."))
				launch_sequence()
				update_icon(UPDATE_ICON_STATE)
				if(SSticker && SSticker.current_state == GAME_STATE_PLAYING)
					var/area/area = get_area(src)
					if(area)
						message_admins("Supermatter Crystal has been launched to space by [key_name_admin(user)] [ADMIN_JMP(src)].")
						investigate_log("has been launched to space at ([area.name]) by [key_name(user)].", "supermatter")
				break
			else
				playsound(loc, "modular_ss220/sm_space_drop/sound/button[rand(1, 5)].ogg", 100, TRUE)
				to_chat(user, SPAN_WARNING("Система безопасности заблокировала попытку сброса. Кристалл не находится в состоянии расслоения!"))
				return
