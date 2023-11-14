
//////////////////////////////////////
//			СБССМ Кнопки			//
//////////////////////////////////////

/obj/machinery/driver_button/sm_drop_button
	name = "\improper экстренный сброс СМ"
	desc = "<font color='red'>ВНИМАНИЕ:</font>Сброс кристала суперматерии. Неправомерное использование может привести к тюремному заключению."
	icon = 'modular_ss220/sm_space_drop/icons/sm_buttons.dmi'
	icon_state = "button"
	anchored = TRUE
	armor = list(melee = 50, bullet = 50, laser = 50, energy = 50, bomb = 10, rad = 100, fire = 90, acid = 70)
	idle_power_consumption = 2
	active_power_consumption = 4
	resistance_flags = LAVA_PROOF | FIRE_PROOF
	id_tag = "SpaceDropSM"
	req_access = list(ACCESS_CE)

	var/glass = TRUE
	var/launched = FALSE

// In case we're annihilated by a meteor
/obj/machinery/driver_button/sm_drop_button/Destroy()
	if(!launched)
		launch_sequence()
	return ..()


/obj/machinery/driver_button/sm_drop_button/update_icon()
	if(launched)
		icon_state = "[initial(icon_state)]_launched"
	else if(!glass)
		icon_state = "[initial(icon_state)]_open"
	else
		icon_state = "[initial(icon_state)]"
	..()

/obj/machinery/driver_button/sm_drop_button/attack_hand(mob/user)
	if(stat & (NOPOWER|BROKEN))
		return

	if(active)
		return

	add_fingerprint(user)

	if(!allowed(usr))
		return

	use_power(5)

	// Already launched
	if(launched)
		to_chat(user, "<span class='warning'>Кнопку уже нажали, процесс выброса СМ запущен.</span>")

	// Glass present
	else if(glass)
		if(user.a_intent == INTENT_HARM)
			user.custom_emote(EMOTE_VISIBLE, "Разбивает стекло кнопки [src]!")
			glass = FALSE
			playsound(src, 'sound/effects/hit_on_shattered_glass.ogg', 100, 1)
			update_icon()
		else
			user.custom_emote(EMOTE_VISIBLE, "Хлопает по стеклу кнопки [src].")
			to_chat(user, "<span class='warning'>Если вы пытаетесь разбить стекло, вам придется ударить по нему сильнее...</span>")
	// Must be !glass and !launched
	else
		user.custom_emote(EMOTE_VISIBLE, "Нажиамает кнопку сброса [src]!")
		visible_message("<span class='notice'>Кнопка громко щелкает.</span>")
		launch_sequence()
		playsound(src, pick('modular_ss220/sm_space_drop/sound/button.ogg','modular_ss220/sm_space_drop/sound/button1.ogg','modular_ss220/sm_space_drop/sound/button2.ogg','modular_ss220/sm_space_drop/sound/button3.ogg','modular_ss220/sm_space_drop/sound/button4.ogg'), 100, 1)
		update_icon()


/obj/machinery/driver_button/sm_drop_button/launch_sequence()
	if(launched)
		return
	launched = TRUE
	update_icon()

	for(var/obj/machinery/atmospherics/supermatter_crystal/engine/crystal in SSair.atmos_machinery)
		if(crystal.id_tag == id_tag)
			crystal.anchored = FALSE
			break

	..()

/obj/machinery/driver_button/sm_drop_button/rearm()
	active = FALSE

/obj/machinery/driver_button/drop_sm/multitool_act(mob/user, obj/item/I)
	return FALSE
