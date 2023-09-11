/mob/proc/user_triggered_emote(act, type, message, force)
	if(stat || !use_me && usr == src)
		if(usr)
			to_chat(usr, "Вы не можете проявлять эмоции.")
		return
	emote(act, type, message, force)


/datum/emote/living/carbon/human/gasp
	message = "задыхается!"
	message_mime = "кажется, задыхается!"
	emote_type = EMOTE_SOUND
	unintentional_stat_allowed = UNCONSCIOUS
	bypass_unintentional_cooldown = TRUE

/datum/emote/living/carbon/human/gasp/get_sound(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user

	if(H.is_muzzled())
		// If you're muzzled you're not making noise
		return

	if(H.health > 0)
		if(H.gender == FEMALE)
			return pick(H.dna.species.female_gasp_sound)
		else
			return pick(H.dna.species.gasp_sound)

	if(H.gender == FEMALE)
		return pick(H.dna.species.female_dying_gasp_sounds)
	else
		return pick(H.dna.species.male_dying_gasp_sounds)

/datum/emote/living/carbon/human/scream
	message = "кричит!"
	message_mime = "как будто кричит!"
	message_simple = "скулит."
	message_alien = "рычит!"
	message_postfix = "на %t!"
	muzzled_noises = list("очень громко")
	emote_type = EMOTE_VISIBLE | EMOTE_MOUTH

/datum/emote/living/carbon/human/scream/select_message_type(mob/user, msg, intentional)
	. = ..()
	var/mob/living/carbon/human/H = user
	if(H.dna.species?.scream_verb)
		if(H.mind?.miming)
			return "как будто [H.dna.species?.scream_verb]!"
		else
			return "[H.dna.species?.scream_verb]!"

/datum/emote/living/carbon/human/salute
	message = "салютует."
	message_param = "салютует %t."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/carbon/human/salute/get_sound(mob/living/user)
	var/mob/living/carbon/human/H = user
	if(!is_type_in_list(H.shoes, funny_shoes))
		return 'sound/effects/salute.ogg'
	if(is_type_in_list(H.shoes, funny_shoes))
		return 'sound/items/toysqueak1.ogg'

/datum/emote/living/carbon/human/cry
	message = "плачет."
	muzzled_noises = list("слабо", "жалко", "грустно")
	emote_type = EMOTE_AUDIBLE | EMOTE_MOUTH | EMOTE_VISIBLE

/datum/emote/living/carbon/human/cry/get_sound(mob/living/user)
	. = ..()
	if(user.gender == FEMALE)
		return pick(
			"modular_ss220/emotes/audio/female/cry_female_1.ogg",
			"modular_ss220/emotes/audio/female/cry_female_2.ogg",
			"modular_ss220/emotes/audio/female/cry_female_3.ogg",)
	else
		return pick(
			"modular_ss220/emotes/audio/male/cry_male_1.ogg",
			"modular_ss220/emotes/audio/male/cry_male_2.ogg",)

/datum/emote/living/carbon/giggle
	message = "хихикает."
	message_mime = "бесшумно хихикает!"
	muzzled_noises = list("булькающе")

/datum/emote/living/carbon/giggle/get_sound(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user

	if(H.gender == FEMALE)
		return pick(H.dna.species.female_giggle_sound)
	else
		return pick(H.dna.species.male_giggle_sound)

/datum/emote/living/carbon/moan
	message = "стонет!"
	message_mime = "как будто стонет!"
	muzzled_noises = list("болезненно")
	emote_type = EMOTE_VISIBLE

/datum/emote/living/carbon/moan/get_sound(mob/living/user)
	. = ..()
	if(user.gender == FEMALE)
		return pick(
			"modular_ss220/emotes/audio/female/moan_female_1.ogg",
			"modular_ss220/emotes/audio/female/moan_female_2.ogg",
			"modular_ss220/emotes/audio/female/moan_female_3.ogg")
	else
		return pick(
			"modular_ss220/emotes/audio/male/moan_male_1.ogg",
			"modular_ss220/emotes/audio/male/moan_male_2.ogg",
			"modular_ss220/emotes/audio/male/moan_male_3.ogg")

/datum/emote/living/carbon/laugh
	message = "смеется."
	message_mime = "бесшумно смеется!"
	message_param = "смеется над %t."
	muzzled_noises = list("счастливо", "весело")
	emote_type = EMOTE_AUDIBLE | EMOTE_MOUTH | EMOTE_VISIBLE

/datum/emote/living/carbon/laugh/get_sound(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user

	if(H.gender == FEMALE)
		return pick(H.dna.species.female_laugh_sound)
	else
		return pick(H.dna.species.male_laugh_sound)

/datum/emote/living/carbon/yawn
	message = "зевает."
	muzzled_noises = list("устало", "медленно", "сонно")
	emote_type = EMOTE_AUDIBLE | EMOTE_MOUTH | EMOTE_SOUND

/datum/emote/living/carbon/yawn/get_sound(mob/living/user)
	. = ..()
	if(user.gender == FEMALE)
		return pick(
			"modular_ss220/emotes/audio/female/yawn_female_1.ogg",
			"modular_ss220/emotes/audio/female/yawn_female_2.ogg",
			"modular_ss220/emotes/audio/female/yawn_female_3.ogg")
	else
		return pick(
			"modular_ss220/emotes/audio/male/yawn_male_1.ogg",
			"modular_ss220/emotes/audio/male/yawn_male_2.ogg")

/datum/emote/living/sigh
	message = "вздыхает."
	message_mime = "беззвучно вздыхает."
	emote_type = EMOTE_AUDIBLE | EMOTE_MOUTH

/datum/emote/living/sigh/get_sound(mob/living/user)
	. = ..()
	if(user.gender == FEMALE)
		return "modular_ss220/emotes/audio/female/sigh_female.ogg"
	else
		return "modular_ss220/emotes/audio/male/sigh_male.ogg"

/datum/emote/living/choke
	message = "подавился!"
	message_mime = "отчаянно хватается за горло!"
	emote_type = EMOTE_AUDIBLE | EMOTE_MOUTH
	audio_cooldown = 3 SECONDS

/datum/emote/living/choke/get_sound(mob/living/user)
	. = ..()
	if(user.gender == FEMALE)
		return pick(
			"modular_ss220/emotes/audio/female/choke_female_1.ogg",
			"modular_ss220/emotes/audio/female/choke_female_2.ogg",
			"modular_ss220/emotes/audio/female/choke_female_3.ogg")
	else
		return pick(
			"modular_ss220/emotes/audio/male/choke_male_1.ogg",
			"modular_ss220/emotes/audio/male/choke_male_2.ogg",
			"modular_ss220/emotes/audio/male/choke_male_3.ogg")

/datum/emote/living/sniff
	message = "нюхает."
	message_mime = "бесшумно нюхнул."
	cooldown = 5 SECONDS
	audio_cooldown = 3 SECONDS

/datum/emote/living/sniff/get_sound(mob/living/user)
	. = ..()
	if(user.gender == FEMALE)
		return "modular_ss220/emotes/audio/female/sniff_female.ogg"
	else
		return "modular_ss220/emotes/audio/male/sniff_male.ogg"

/datum/emote/living/snore
	message = "храпит."
	message_mime = "крепко спит."
	message_simple = "ворочается во сне."
	message_robot = "мечтает об электроовцах"
	emote_type = EMOTE_AUDIBLE | EMOTE_SOUND
	max_stat_allowed = UNCONSCIOUS
	max_unintentional_stat_allowed = CONSCIOUS
	unintentional_stat_allowed = CONSCIOUS

/datum/emote/living/snore/get_sound(mob/living/user)
	. = ..()
	if(iscarbon(user))
		return pick(
			"modular_ss220/emotes/audio/snore_1.ogg",
			"modular_ss220/emotes/audio/snore_2.ogg",
			"modular_ss220/emotes/audio/snore_3.ogg",
			"modular_ss220/emotes/audio/snore_4.ogg",
			"modular_ss220/emotes/audio/snore_5.ogg",
			"modular_ss220/emotes/audio/snore_6.ogg",
			"modular_ss220/emotes/audio/snore_7.ogg")

/datum/emote/living/dance
	message = "радостно танцует."
	var/dance_time = 3 SECONDS

/datum/emote/living/dance/run_emote(mob/living/user, params, type_override, intentional)
	. = ..()
	user.spin(dance_time, pick(0.1 SECONDS, 0.2 SECONDS))
	user.do_jitter_animation(rand(8 SECONDS, 16 SECONDS), dance_time / 4)
