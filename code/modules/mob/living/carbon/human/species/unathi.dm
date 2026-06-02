/datum/species/unathi
	name = "Unathi"
	name_plural = "Unathi"
	article_override = "a"  // it's pronounced "you-nah-thee"
	icobase = 'icons/mob/human_races/r_lizard.dmi'
	language = "Sinta'unathi"
	tail = "sogtail"
	unarmed_type = /datum/unarmed_attack/claws
	primitive_form = /datum/species/monkey/unathi

	blurb = "Унатхи - чешуйчатый вид рептилий с тропической планеты Могес, расположенной в системе Узул. \
	Организовавшись в высококонкурентные феодальные королевства, не заимели какого-либо широкомасштабного объединения.<br/><br/> \
	Хоть и установлена Имперская гегемония, однако из-за консерватизма управляющих, ограничены родным сектором."

	species_traits = list(LIPS)
	inherent_biotypes = MOB_ORGANIC | MOB_HUMANOID | MOB_REPTILE
	clothing_flags = HAS_UNDERWEAR | HAS_UNDERSHIRT | HAS_SOCKS
	bodyflags = HAS_TAIL | HAS_HEAD_ACCESSORY | HAS_BODY_MARKINGS | HAS_HEAD_MARKINGS | HAS_SKIN_COLOR | HAS_ALT_HEADS | TAIL_WAGGING | TAIL_OVERLAPPED
	dietflags = DIET_CARN
	taste_sensitivity = TASTE_SENSITIVITY_SHARP

	cold_level_1 = 280 //Default 260 - Lower is better
	cold_level_2 = 220 //Default 200
	cold_level_3 = 140 //Default 120

	heat_level_1 = 505 //Default 360 - Higher is better
	heat_level_2 = 540 //Default 400
	heat_level_3 = 600 //Default 460

	flesh_color = "#34AF10"
	reagent_tag = PROCESS_ORG
	base_color = "#066000"
	//Default styles for created mobs.
	default_headacc = "Simple"
	default_headacc_colour = "#404040"
	male_scream_sound = 'sound/effects/unathiscream.ogg' // credits to skyrat [https://github.com/Skyrat-SS13/Skyrat-tg/pull/892]
	female_scream_sound = 'sound/effects/unathiscream.ogg'
	butt_sprite = "unathi"

	meat_type = /obj/item/food/meat/human
	skinned_type = /obj/item/stack/sheet/animalhide/lizard
	has_organ = list(
		"heart" =    /obj/item/organ/internal/heart/unathi,
		"lungs" =    /obj/item/organ/internal/lungs/unathi,
		"liver" =    /obj/item/organ/internal/liver/unathi,
		"kidneys" =  /obj/item/organ/internal/kidneys/unathi,
		"brain" =    /obj/item/organ/internal/brain/unathi,
		"appendix" = /obj/item/organ/internal/appendix,
		"eyes" =     /obj/item/organ/internal/eyes/unathi //3 darksight.
		)
	allowed_consumed_mobs = list(
		/mob/living/basic/mouse,
		/mob/living/basic/lizard,
		/mob/living/basic/chick,
		/mob/living/basic/chicken,
		/mob/living/basic/crab,
		/mob/living/basic/butterfly,
		/mob/living/simple_animal/parrot,
		/mob/living/basic/bee,
	)

	suicide_messages = list(
		"is attempting to bite their tongue off!",
		"is jamming their claws into their eye sockets!",
		"is twisting their own neck!",
		"is holding their breath!")
	autohiss_basic_map = list(
			"s" = list("ss", "sss", "ssss")
		)
	autohiss_extra_map = list(
			"x" = list("ks", "kss", "ksss")
		)
	autohiss_exempt = list("Sinta'unathi")

	plushie_type = /obj/item/toy/plushie/lizardplushie

/datum/species/unathi/on_species_gain(mob/living/carbon/human/H)
	..()
	var/datum/action/innate/unathi_ignite/fire = new()
	fire.Grant(H)

/datum/species/unathi/on_species_loss(mob/living/carbon/human/H)
	..()
	for(var/datum/action/innate/unathi_ignite/fire in H.actions)
		fire.Remove(H)

/datum/action/innate/unathi_ignite
	name = "Пламя души"
	desc = "Ваша раса настолько сильна духом, что способна выдыхать маленькое пламя, достаточное для зажигания сигарет."
	button_icon = 'icons/obj/cigarettes.dmi'
	button_icon_state = "match_unathi"
	var/cooldown = 0
	var/cooldown_duration = 3 SECONDS
	check_flags = AB_CHECK_HANDS_BLOCKED

/datum/action/innate/unathi_ignite/Activate()
	var/mob/living/carbon/human/user = owner

	if(world.time <= cooldown)
		to_chat(user, SPAN_WARNING("Пламя души мерцает. Дайте ему разгореться."))
		return

	var/obj/item/clothing/mask/cigarette/cig = user.wear_mask

	// 1. Обычная маска блокирует способность.
	if(ismask(user.wear_mask) && !istype(user.wear_mask, /obj/item/clothing/mask/cigarette))
		var/obj/item/clothing/mask/worn_mask = user.wear_mask

		if((worn_mask.flags_cover & MASKCOVERSMOUTH) && !worn_mask.up)
			to_chat(user, SPAN_WARNING("Ваша пасть чем-то прикрыта."))
			return

	// 2. Шлем закрывает рот и сигареты нет.
	if((user.head?.flags_cover & HEADCOVERSMOUTH) && !istype(cig))
		to_chat(user, SPAN_WARNING("Ваша пасть чем-то прикрыта."))
		return

	// 3. Шлем + сигарета = сразу поджигаем сигарету.
	if((user.head?.flags_cover & HEADCOVERSMOUTH) && istype(cig))
		if(!cig.lit)
			user.visible_message(
				"<span class='rose'>[user] выпускает из пасти пламя души, зажигая [cig.declent_ru(ACCUSATIVE)].</span>",
				"<span class='rose'>Вы выдыхаете пламя своей души — [cig.declent_ru(NOMINATIVE)] оживает ярким огнём.</span>",
				"<span class='warning'>Тишину разрывает резкий щелчок пламени!</span>"
			)

			cig.light(user, user)
			playsound(user.loc, 'sound/effects/unathiignite.ogg', 40, FALSE)

			cooldown = world.time + cooldown_duration

		return

	// 4. Есть свободная рука — создаём искру.
	var/obj/item/match/unathi/fire = new(user.loc, src)

	if(user.put_in_hands(fire))
		to_chat(user, SPAN_NOTICE("Вы зажигаете маленькое пламя души у себя в пасти."))
		cooldown = world.time + cooldown_duration
		return

	qdel(fire)

	// 5. Руки заняты, но есть сигарета.
	if(istype(cig) && !cig.lit)
		user.visible_message(
			"<span class='rose'>[user] выпускает из пасти пламя души, зажигая [cig.declent_ru(ACCUSATIVE)].</span>",
			"<span class='rose'>Вы выдыхаете пламя своей души — [cig.declent_ru(NOMINATIVE)] оживает ярким огнём.</span>",
			"<span class='warning'>Тишину разрывает резкий щелчок пламени!</span>"
		)

		cig.light(user, user)
		playsound(user.loc, 'sound/effects/unathiignite.ogg', 40, FALSE)

		cooldown = world.time + cooldown_duration
		return

	// 6. Всё занято и сигареты нет.
	to_chat(user, SPAN_WARNING("Вашы лапы чем-то заняты!"))
/*
/datum/action/innate/unathi_ignite/Activate()
	var/mob/living/carbon/human/user = owner
	if(world.time <= cooldown)
		to_chat(user, SPAN_WARNING("Пламя души мерцает. Дайте ему разгореться.")) //[round((cooldown - world.time) / 10)]
		return
	if(ismask(user.wear_mask))
		var/obj/item/clothing/mask/worn_mask = user.wear_mask
		if((user.head?.flags_cover & HEADCOVERSMOUTH) || (worn_mask.flags_cover & MASKCOVERSMOUTH) && !worn_mask.up)
			to_chat(user, SPAN_WARNING("Ваша пасть чем-то прикрыта."))
			return
	var/obj/item/match/unathi/fire = new(user.loc, src)
	if(user.put_in_hands(fire))
		to_chat(user, SPAN_NOTICE("Вы зажигаете маленькое пламя души у себя в пасти."))
		cooldown = world.time + cooldown_duration
	else
		qdel(fire)

		var/obj/item/clothing/mask/cigarette/cig = user.wear_mask

		if(istype(cig) && !cig.lit)
			user.visible_message(
				"<span class='rose'>[user] выпускает из пасти пламя души, зажигая [cig.declent_ru(ACCUSATIVE)].</span>",
				"<span class='rose'>Вы выдыхаете пламя своей души — [cig.declent_ru(NOMINATIVE)] оживает ярким огнём.</span>",
				"<span class='warning'>Тишину разрывает резкий щелчок пламени!</span>"
			)

			cig.light(user, user)

			playsound(user.loc, 'sound/effects/unathiignite.ogg', 40, FALSE)

			cooldown = world.time + cooldown_duration
		else
			to_chat(user, SPAN_WARNING("Вашы лапы чем-то заняты!"))

*/
/datum/species/unathi/handle_death(gibbed, mob/living/carbon/human/H)
	H.stop_tail_wagging()

/datum/species/unathi/ashwalker
	name = "Ash Walker"
	name_plural = "Ash Walkers"
	sprite_sheet_name = "Unathi" // We have the same sprite sheets as unathi
	article_override = null

	blurb = "Эти рептилоидные существа, похоже, родственны Унатхам, но выглядят значительно менее развитыми. \
	Они скитаются по пустошам Лаваленда, поклоняются мертвому городу и похищают ничего не подозревающих шахтеров."

	default_language = "Sinta'unathi"

	speed_mod = -0.80
	species_traits = list(LIPS, NOT_SELECTABLE)
	inherent_traits = list(TRAIT_CHUNKYFINGERS)

	// same as unathi's organs, aside for the lungs as they need to be able to breathe on lavaland.
	has_organ = list(
		"heart"		= /obj/item/organ/internal/heart/unathi,
		"lungs"		= /obj/item/organ/internal/lungs/unathi/ash_walker,
		"liver"		= /obj/item/organ/internal/liver/unathi,
		"kidneys"	= /obj/item/organ/internal/kidneys/unathi,
		"brain"		= /obj/item/organ/internal/brain/unathi,
		"appendix"	= /obj/item/organ/internal/appendix,
		"eyes"		= /obj/item/organ/internal/eyes/unathi
	)

/datum/species/unathi/ashwalker/on_species_gain(mob/living/carbon/human/H)
	..()
	for(var/datum/action/innate/unathi_ignite/fire in H.actions)
		fire.Remove(H)
	var/datum/action/innate/unathi_ignite/ash_walker/fire = new()
	fire.Grant(H)
	H.faction |= "ashwalker"

/datum/species/unathi/ashwalker/on_species_loss(mob/living/carbon/human/H)
	..()
	for(var/datum/action/innate/unathi_ignite/ash_walker/fire in H.actions)
		fire.Remove(H)
	H.faction -= "ashwalker"

/datum/species/unathi/ashwalker/movement_delay(mob/living/carbon/human/H)
	. = ..()
	var/turf/our_turf = get_turf(H)
	if(!is_mining_level(our_turf.z))
		. -= speed_mod

/datum/action/innate/unathi_ignite/ash_walker
	desc = "Годы подражания величественным рептилиям лавовой планеты научили вас выдыхать маленькое пламя, достаточное для... прикуривания сигарет?"
	cooldown_duration = 3 SECONDS
