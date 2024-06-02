/obj/structure/musician/drumskit
	name = "\improper барабанная установка"
	desc = "Складные барабаны, используйте гаечный ключ чтобы их поставить или сложить."
	icon = 'modular_ss220/jukebox/icons/jukebox.dmi'
	icon_state = "drum_red_unanchored"
	base_icon_state = "drum_red"
	atom_say_verb = "states"
	anchored = FALSE
	can_play_unanchored = FALSE
	var/active = FALSE
	allowed_instrument_ids = "drums"
	layer = 2.5
	can_buckle = FALSE
	buckle_lying = FALSE
	resistance_flags = NONE
	max_integrity = 250
	integrity_failure = 25
	buckle_offset = 0
	var/buildstacktype = /obj/item/stack/sheet/metal
	var/buildstackamount = 1
	var/item_chair = /obj/item/chair // if null it can't be picked up
	var/comfort = 0
	var/possible_dirs = 1
	var/stat = 0

/obj/structure/musician/drumskit/Initialize(mapload)
	. = ..()
	song = new(src, "drums") // Piano is the default instrument but all instruments are allowed
	song.instrument_range = 15
	song.allowed_instrument_ids = "drums"
	// To update the icon
	RegisterSignal(src, COMSIG_SONG_START, PROC_REF(start_playing))
	RegisterSignal(src, COMSIG_SONG_END, PROC_REF(stop_playing))

/obj/structure/musician/drumskit/proc/start_playing()
	active = TRUE
	update_icon(UPDATE_ICON_STATE)

/obj/structure/musician/drumskit/proc/stop_playing()
	active = FALSE
	update_icon(UPDATE_ICON_STATE)

/obj/structure/musician/drumskit/wrench_act(mob/living/user, obj/item/I)
	if(active || (resistance_flags & INDESTRUCTIBLE))
		return

	if(!anchored && !isinspace())
		to_chat(user, span_notice("You secure [src] to the floor."))
		anchored = TRUE
		can_buckle = TRUE
		layer = 5
	else if(anchored)
		to_chat(user, span_notice("You unsecure and disconnect [src]."))
		anchored = FALSE
		can_buckle = FALSE
		layer = 2.5

	update_icon()
	icon_state = "[base_icon_state][anchored ? null : "_unanchored"]"

	playsound(src, 'sound/items/deconstruct.ogg', 50, 1)

	return TRUE

/obj/structure/musician/drumskit/attack_hand(mob/user)
	add_fingerprint(user)

	if(!anchored)
		return

	ui_interact(user)

/obj/structure/musician/drumskit/update_icon_state()
	if(stat & (BROKEN))
		icon_state = "[base_icon_state]_broken"
	else if(anchored)
		icon_state = "[base_icon_state][active ? "-active" : null]"

	setDir(SOUTH)
