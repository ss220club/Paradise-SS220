/obj/item/melee/stylet
	name = "stylet"
	desc = "Маленький складной нож скрытого ношения. \
	Нож в итальянском стиле, который исторически стал предметом споров и даже запретов \
	Его лезвие практически мгновенно выбрасывается при нажатии кнопки-качельки."
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_TINY

	var/on = FALSE
	force = 2
	var/force_on = 8

	lefthand_file = 'modular_ss220/objects/icons/inhands/melee_lefthand.dmi'
	righthand_file = 'modular_ss220/objects/icons/inhands/melee_righthand.dmi'
	icon = 'modular_ss220/objects/icons/melee.dmi'
	hitsound = 'sound/weapons/bladeslice.ogg'
	icon_state = "stylet_0"
	var/icon_state_on = "stylet_1"
	var/extend_sound = 'modular_ss220/objects/sound/weapons/styletext.ogg'
	attack_verb = list("hit", "poked")
	sharp = TRUE
	var/list/attack_verb_on = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/obj/item/melee/stylet/update_icon_state()
	. = ..()
	icon_state = on ? icon_state_on : initial(icon_state)

/obj/item/melee/stylet/attack_self__legacy__attackchain(mob/user)
	on = !on

	if(on)
		to_chat(user, span_userdanger("Вы разложили [name]."))
		update_icon(UPDATE_ICON_STATE)
		w_class = WEIGHT_CLASS_SMALL
		force = force_on
		attack_verb = attack_verb_on
	else
		to_chat(user, span_notice("Вы сложили [name]."))
		update_icon(UPDATE_ICON_STATE)
		w_class = initial(w_class)
		force = initial(force)
		attack_verb = initial(attack_verb)

	// Update mob hand visuals
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()
	playsound(loc, extend_sound, 50, TRUE)
	add_fingerprint(user)
