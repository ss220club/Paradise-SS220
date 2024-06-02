/obj/structure/concertspeaker_fake
	name = "\improper концертная колонка"
	icon_state = "concertspeaker"
	icon = 'modular_ss220/instruments/icons/Samurai_Gitara.dmi'
	atom_say_verb = "states"
	anchored = FALSE
	var/active = FALSE
	density = FALSE
	layer = 2.5
	resistance_flags = NONE
	max_integrity = 250
	integrity_failure = 25
	var/stat = 0
	var/code = 0
	var/frequency = 1400
	var/receiving = TRUE

/obj/structure/concertspeaker_fake/update_icon_state()
	if(stat & BROKEN)
		icon_state = "[initial(icon_state)]_broken"
		return
	icon_state = "[initial(icon_state)]"

	if(active)
		icon_state = "[initial(icon_state)]-active"
	else if(anchored)
		icon_state = "[initial(icon_state)]_anchored"

/obj/structure/concertspeaker_fake/wrench_act(mob/living/user, obj/item/I)
	if(resistance_flags & INDESTRUCTIBLE)
		return

	if(!anchored && !isinspace())
		to_chat(user, span_notice("You secure [src] to the floor."))
		anchored = TRUE
		density = TRUE
		layer = 5
		update_icon()
	else if(anchored)
		to_chat(user, span_notice("You unsecure and disconnect [src]."))
		anchored = FALSE
		density = FALSE
		layer = 2.5
		update_icon()

	playsound(src, 'sound/items/deconstruct.ogg', 50, 1)

	return TRUE

/obj/structure/concertspeaker_fake/attack_hand(mob/user)
	return TRUE

/obj/structure/concertspeaker_fake/Initialize()
	. = ..()
	GLOB.remote_signalers |= src

/obj/structure/concertspeaker_fake/proc/signal_callback()
	active = !active
	update_icon()
