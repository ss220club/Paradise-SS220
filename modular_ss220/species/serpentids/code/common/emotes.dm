/mob/living/carbon/human/verb/emote_gbsroar()
	set name = "< " + EMOTE_HUMAN_ROAR + " >"
	set category = "Эмоции"
	emote("gbsroar", intentional = TRUE)

/mob/living/carbon/human/verb/emote_gbshiss()
	set name = "< " + EMOTE_HUMAN_HISS + " >"
	set category = "Эмоции"
	emote("gbshiss", intentional = TRUE)

/mob/living/carbon/human/verb/emote_gbswiggles()
	set name = "< " + EMOTE_HUMAN_WIGGLES + " >"
	set category = "Эмоции"
	emote("gbswiggles", intentional = TRUE)

/mob/living/carbon/human/verb/emote_gbsblink()
	set name = "< " + EMOTE_CARBON_BLINK + " >"
	set category = "Эмоции"
	emote("gbsblink", intentional = TRUE)

/datum/emote/living/carbon/human/roar/gbs
	key = "gbsroar"
	key_third_person = "gbsroar"
	message = "утробно рычит."
	message_mime = "бесшумно рычит."
	message_param = "утробно рычит на %t."
	species_type_whitelist_typecache = list(/datum/species/serpentid)
	volume = 50
	muzzled_noises = list("раздражённый")
	emote_type = EMOTE_VISIBLE | EMOTE_MOUTH | EMOTE_AUDIBLE
	age_based = TRUE

/datum/emote/living/carbon/human/roar/gbs/get_sound(mob/living/user)
	return pick(
		'modular_ss220/species/serpentids/sounds/serpentid_roar.ogg')

/datum/emote/living/carbon/human/hiss/gbs
	key = "gbshiss"
	key_third_person = "gbshisses"
	message = "шипит."
	message_param = "шипит на %t."
	species_type_whitelist_typecache = list(/datum/species/serpentid)
	emote_type = EMOTE_AUDIBLE | EMOTE_MOUTH
	age_based = TRUE
	// Credit to Jamius (freesound.org) for the sound.
	sound = "modular_ss220/species/serpentids/sounds/serpentid_hiss.ogg"
	muzzled_noises = list("weak hissing")

/datum/emote/living/carbon/human/wiggles/gbs
	key = "gbswiggles"
	key_third_person = "gbswiggles"
	message = "шевелит усиками."
	message_param = "шевелит усиками в сторону %t."
	cooldown = 5 SECONDS
	species_type_whitelist_typecache = list(/datum/species/serpentid)
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE | EMOTE_MOUTH
	age_based = TRUE
	volume = 80
	muzzled_noises = list("слабо")
	sound = 'modular_ss220/species/serpentids/sounds/serpentid_wiggle.ogg'

/datum/emote/living/carbon/human/blink/gbs
	key = "gbsblink"
	key_third_person = "gbsblink"
	message = "протирает клинками глаза."
	message_param = "протирает клинками глаза в сторону %t."
	cooldown = 5 SECONDS
	species_type_whitelist_typecache = list(/datum/species/serpentid)
	emote_type = EMOTE_VISIBLE | EMOTE_MOUTH
	age_based = TRUE
