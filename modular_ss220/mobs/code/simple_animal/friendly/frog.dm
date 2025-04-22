/mob/living/simple_animal/frog
	name = "лягушка"
	real_name = "лягушка"
	desc = "Выглядит грустным не по средам и когда её не целуют."
	icon = 'modular_ss220/mobs/icons/mob/animal.dmi'
	icon_state = "frog"
	icon_living = "frog"
	icon_dead = "frog_dead"
	icon_resting = "frog"
	speak = list("Квак!","КУААК!","Квуак!")
	speak_emote = list("квак","куак","квуак")
	emote_hear = list("квак","куак","квуак")
	emote_see = list("лежит расслабленная", "издает гортанные звуки", "лупает глазками")
	var/scream_sound = list ('modular_ss220/mobs/sound/creatures/frog_scream_1.ogg','modular_ss220/mobs/sound/creatures/frog_scream_2.ogg','modular_ss220/mobs/sound/creatures/frog_scream_3.ogg')
	talk_sound = list('modular_ss220/mobs/sound/creatures/frog_talk1.ogg', 'modular_ss220/mobs/sound/creatures/frog_talk2.ogg')
	damaged_sound = list('modular_ss220/mobs/sound/creatures/frog_damaged.ogg')
	death_sound = 'modular_ss220/mobs/sound/creatures/frog_death.ogg'
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 10
	maxHealth = 10
	health = 10
	blood_volume = BLOOD_VOLUME_SURVIVE
	butcher_results = list(/obj/item/food/monstermeat/lizardmeat = 1)
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "stamps on"
	density = 0
	ventcrawler = 2
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	mob_size = MOB_SIZE_TINY
	layer = MOB_LAYER
	atmos_requirements = list("min_oxy" = 16, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 1, "min_co2" = 0, "max_co2" = 5, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 223 // Below -50 Degrees Celcius
	maxbodytemp = 323 // Above 50 Degrees Celcius
	universal_speak = 0
	can_hide = 1
	holder_type = /obj/item/holder/frog
	can_collar = 1
	gold_core_spawnable = FRIENDLY_SPAWN

/mob/living/simple_animal/frog/toxic
	name = "яркая лягушка"
	real_name = "яркая лягушка"
	desc = "Уникальная токсичная раскраска. Лучше не трогать голыми руками."
	icon_state = "rare_frog"
	icon_living = "rare_frog"
	icon_dead = "rare_frog_dead"
	icon_resting = "rare_frog"
	var/toxin_per_touch = 2.5
	var/toxin_type = "toxin"
	gold_core_spawnable = HOSTILE_SPAWN
	holder_type = /obj/item/holder/frog/toxic

/mob/living/simple_animal/frog/scream
	name = "орущая лягушка"
	real_name = "орущая лягушка"
	desc = "Не любит когда на неё наступают. Используется в качестве наказания за проступки"
	var/squeak_sound = list ('modular_ss220/mobs/sound/creatures/frog_scream1.ogg','modular_ss220/mobs/sound/creatures/frog_scream2.ogg')
	gold_core_spawnable = NO_SPAWN


/mob/living/simple_animal/frog/Initialize(mapload)
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_atom_entered),
	)
	AddElement(/datum/element/connect_loc, loc_connections)

// Frog procs
/mob/living/simple_animal/frog/attack_hand(mob/living/carbon/human/M as mob)
	if(M.a_intent == INTENT_HELP)
		get_scooped(M)
	..()

/mob/living/simple_animal/frog/proc/on_atom_entered(datum/source, atom/movable/entered)
	SIGNAL_HANDLER
	if(!ishuman(source))
		return
	if(stat)
		return
	to_chat(source, span_notice("[bicon(src)] квакнул!"))

// Toxic frog procs
/mob/living/simple_animal/frog/toxic/attack_hand(mob/living/carbon/human/H as mob)
	if(ishuman(H))
		if(!istype(H.gloves, /obj/item/clothing/gloves))
			for(var/obj/item/organ/external/A in H.bodyparts)
				if(!A.is_robotic())
					if((A.body_part == HAND_LEFT) || (A.body_part == HAND_RIGHT))
						to_chat(H, span_warning("Дотронувшись до [src.name], ваша кожа начинает чесаться!"))
						toxin_affect(H)
						if(H.a_intent == INTENT_DISARM || H.a_intent == INTENT_HARM)
							..()
	..()

/mob/living/simple_animal/frog/toxic/on_atom_entered(datum/source, atom/movable/entered)
	..()
	if(!ishuman(source))
		return
	var/mob/living/carbon/human/H = source
	if(istype(H.shoes, /obj/item/clothing/shoes))
		return
	for(var/obj/item/organ/external/F in H.bodyparts)
		if(F.is_robotic() || (F.body_part != FOOT_LEFT && !F.body_part == FOOT_RIGHT))
			continue
		toxin_affect(H)
		to_chat(H, span_warning("Ваши ступни начинают чесаться!"))

/mob/living/simple_animal/frog/toxic/proc/toxin_affect(mob/living/carbon/human/M as mob)
	if(M.reagents && !toxin_per_touch == 0)
		M.reagents.add_reagent(toxin_type, toxin_per_touch)

// Scream frog procs
/mob/living/simple_animal/frog/scream/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/squeak, squeak_sound, 50, extrarange = SHORT_RANGE_SOUND_EXTRARANGE) //as quiet as a frog or whatever

/mob/living/simple_animal/frog/toxic/scream
	var/squeak_sound = list ('modular_ss220/mobs/sound/creatures/frog_scream1.ogg','modular_ss220/mobs/sound/creatures/frog_scream2.ogg')
	gold_core_spawnable = NO_SPAWN

/mob/living/simple_animal/frog/toxic/scream/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/squeak, squeak_sound, 50, extrarange = SHORT_RANGE_SOUND_EXTRARANGE) //as quiet as a frog or whatever

// Additional procs
/mob/living/simple_animal/frog/handle_automated_movement()
	. = ..()
	if(!resting && !buckled)
		if(prob(1))
			custom_emote(1,"издаёт боевой клич!")
			playsound(src, pick(src.scream_sound), 50, TRUE)

/mob/living/simple_animal/frog/emote(emote_key, type_override = 1, message, intentional, force_silence)
	if(incapacitated())
		return

	var/on_CD = 0
	emote_key = lowertext(emote_key)
	switch(emote_key)
		if("warcry")
			on_CD = start_audio_emote_cooldown()
		else
			on_CD = 0

	if(!force_silence && on_CD == 1)
		return

	switch(emote_key)
		if("warcry")
			message = "издаёт боевой клич!"
			type_override = 2 //audible
			playsound(src, pick(src.scream_sound), 50, TRUE)
		if("help")
			to_chat(src, "warcry")
	..()

