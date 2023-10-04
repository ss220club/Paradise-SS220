// D:\GitHub\Paradise-Remake-SS220\code\modules\mob\living\living_defense.dm
/mob/living/grabbedby(mob/living/carbon/user, supress_message = FALSE)
	if(user == src || anchored)
		return FALSE
	if(!(status_flags & CANPUSH))
		return FALSE
	if(user.pull_force < move_force)
		return FALSE

	for(var/obj/item/grab/G in grabbed_by)
		if(G.assailant == user)
			to_chat(user, "<span class='notice'>You already grabbed [src].</span>")

			// if(holder_type)
			// 	get_scooped(user)
			// else
			// 	to_chat(user, "<span class='notice'>[pluralize_ru(user.gender,"Ты","Вы")] уже схватил[genderize_ru(user.gender,"","а","о","и")] [src.declent_ru(ACCUSATIVE)].</span>")
			return

	add_attack_logs(user, src, "Grabbed passively", ATKLOG_ALL)

	var/obj/item/grab/G = new /obj/item/grab(user, src)
	if(!G)	//the grab will delete itself in New if src is anchored
		return 0
	user.put_in_active_hand(G)
	G.synch()
	LAssailant = user

	playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
	/*if(user.dir == src.dir)
		G.state = GRAB_AGGRESSIVE
		G.last_upgrade = world.time
		if(!supress_message)
			visible_message("<span class='warning'>[user] has grabbed [src] from behind!</span>")
	else*///This is an example of how you can make special types of grabs simply based on direction.
	if(!supress_message)
		visible_message("<span class='warning'>[user] has grabbed [src] passively!</span>")

	return G



// D:\GitHub\Paradise-Remake-SS220\code\modules\mob\living\simple_animal\animal_defense.dm
/mob/living/simple_animal/attackby(obj/item/O, mob/living/user)
	if(can_collar && istype(O, /obj/item/petcollar) && !pcollar)
		add_collar(O, user)
		return
	else
		return ..()


	// if(user.a_intent == INTENT_HELP || user.a_intent == INTENT_GRAB)
	// 	if(can_collar && istype(O, /obj/item/clothing/accessory/petcollar) && !pcollar)
	// 		add_collar(O, user)
	// 		return
	// 	if(istype(O, /obj/item/pet_carrier))
	// 		var/obj/item/pet_carrier/C = O
	// 		if(C.put_in_carrier(src, user))
	// 			return
	// return ..()




/mob/living/simple_animal/attack_hand(mob/living/carbon/human/M)
	..()
	switch(M.a_intent)

		if(INTENT_HELP)
			if(health > 0)
				visible_message("<span class='notice'>[M] [response_help] [src].</span>", "<span class='notice'>[M] [response_help] you.</span>")
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)

		if(INTENT_GRAB)
			grabbedby(M)
			// if(holder_type)
			// 	get_scooped(M)
			// else
			// 	grabbedby(M)

		if(INTENT_HARM, INTENT_DISARM)
			if(HAS_TRAIT(M, TRAIT_PACIFISM))
				to_chat(M, "<span class='warning'>You don't want to hurt [src]!</span>")
				return
			M.do_attack_animation(src, ATTACK_EFFECT_PUNCH)
			visible_message("<span class='danger'>[M] [response_harm] [src]!</span>", "<span class='userdanger'>[M] [response_harm] you!</span>")
			playsound(loc, attacked_sound, 25, 1, -1)
			attack_threshold_check(harm_intent_damage)
			add_attack_logs(M, src, "Melee attacked with fists")
			updatehealth()
			return TRUE








