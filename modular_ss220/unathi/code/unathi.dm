/datum/action/innate/unathi_ignite
	name = "Пламя души"
	desc = "Ваша раса настолько сильна духом, что способна выдыхать маленькое пламя, достаточное для зажигания сигарет."
	cooldown_duration = 3 SECONDS
	welding_fuel_used = 0

/datum/action/innate/unathi_ignite/Activate()
	var/mob/living/carbon/human/user = owner

	if(world.time <= cooldown)
		to_chat(user, SPAN_WARNING("Пламя души мерцает. Дайте ему разгореться."))
		return

	var/obj/item/clothing/mask/cigarette/cig = user.wear_mask

	if(ismask(user.wear_mask) && !istype(user.wear_mask, /obj/item/clothing/mask/cigarette))
		var/obj/item/clothing/mask/worn_mask = user.wear_mask

		if((worn_mask.flags_cover & MASKCOVERSMOUTH) && !worn_mask.up)
			to_chat(user, SPAN_WARNING("Ваша пасть чем-то прикрыта."))
			return

	if((user.head?.flags_cover & HEADCOVERSMOUTH) && !istype(cig))
		to_chat(user, SPAN_WARNING("Ваша пасть чем-то прикрыта."))
		return

	if((user.head?.flags_cover & HEADCOVERSMOUTH) && istype(cig))
		if(!cig.lit)
			user.visible_message(
				SPAN_ROSE("[user] выпускает из пасти пламя души, зажигая [cig.declent_ru(ACCUSATIVE)]"),
				SPAN_ROSE("Вы выдыхаете пламя души — [cig.declent_ru(NOMINATIVE)] оживает ярким огнём."),
				SPAN_WARNING("Тишину разрывает резкий щелчок пламени!")
			)

			cig.light(user, user)
			playsound(user.loc, 'sound/effects/unathiignite.ogg', 40, FALSE)

			cooldown = world.time + cooldown_duration
			return
		to_chat(user, SPAN_WARNING("Ваша сигарета уже зажженна!"))
		return

	var/obj/item/match/unathi/fire = new(user.loc, src)

	if(user.put_in_hands(fire))
		to_chat(user, SPAN_NOTICE("Вы зажигаете маленькое пламя души у себя в пасти."))
		cooldown = world.time + cooldown_duration
		return

	qdel(fire)

	if(istype(cig) && !cig.lit)
		user.visible_message(
			SPAN_ROSE("[user] выпускает из пасти пламя души, зажигая [cig.declent_ru(ACCUSATIVE)]"),
			SPAN_ROSE("Вы выдыхаете пламя своей души — [cig.declent_ru(NOMINATIVE)] оживает ярким огнём."),
			SPAN_WARNING("Тишину разрывает резкий щелчок пламени!")
		)

		cig.light(user, user)
		playsound(user.loc, 'sound/effects/unathiignite.ogg', 40, FALSE)

		cooldown = world.time + cooldown_duration
		return

	to_chat(user, SPAN_WARNING("Ваши лапы чем-то заняты!"))

	/datum/action/innate/unathi_ignite/ash_walker
	desc = "Годы подражания величественным рептилиям лавовой планеты научили вас выдыхать маленькое пламя, достаточное для... прикуривания сигарет?"
	cooldown_duration = 3 SECONDS


