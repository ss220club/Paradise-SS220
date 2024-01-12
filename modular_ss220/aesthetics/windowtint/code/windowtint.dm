/obj/machinery/button/windowtint
	icon = 'modular_ss220/aesthetics/windowtint/icons/polarizer.dmi'
	icon_state = "polarizer-0"
	layer = ABOVE_WINDOW_LAYER

/obj/machinery/button/windowtint/attack_hand(mob/user)
	if(!allowed(user) && !user.can_advanced_admin_interact())
		to_chat(user, span_warning("Access Denied."))
		flick("polarizer-denied",src)
		playsound(src, pick('modular_ss220/aesthetics/windowtint/sound/button.ogg', 'modular_ss220/aesthetics/windowtint/sound/button_alternate.ogg', 'modular_ss220/aesthetics/windowtint/sound/button_meloboom.ogg'), 20)
		return 1

	toggle_tint()

/obj/machinery/button/windowtint/toggle_tint()
	..()
	if(!range)
		for(var/obj/machinery/button/windowtint/B in button_area)
			if (B.range || B.id)
				continue
			B.animate_windowtint()
	else
		animate_windowtint()

/obj/machinery/button/windowtint/proc/animate_windowtint()
	icon_state = active ? "polarizer-turning_on" : "polarizer-turning_off"
	addtimer(CALLBACK(src, PROC_REF(update_windowtint_icon)), 0.5 SECONDS)

/obj/machinery/button/windowtint/proc/update_windowtint_icon()
	icon_state = "polarizer-[active]"
