#define EMOTE_HUMAN_GBSROAR 			"Рычать"
#define EMOTE_HUMAN_GBSHISS 			"Шипеть"
#define EMOTE_HUMAN_GBSWIGGLE 			"Шевелить усиками"

/mob/living/carbon/human/proc/emote_gasroar()
	set name = "< " + EMOTE_HUMAN_ROAR + " >"
	set category = "Эмоции"
	emote("gasroar", intentional = TRUE)

/mob/living/carbon/human/proc/emote_gashiss()
	set name = "< " + EMOTE_HUMAN_HISS + " >"
	set category = "Эмоции"
	emote("gashiss", intentional = TRUE)

/mob/living/carbon/human/proc/emote_gaswiggles()
	set name = "< " + EMOTE_HUMAN_WIGGLES + " >"
	set category = "Эмоции"
	emote("gaswiggles", intentional = TRUE)

/datum/emote/living/carbon/human/gasroar
	name = EMOTE_HUMAN_GBSROAR

/datum/emote/living/carbon/human/gashiss
	name = EMOTE_HUMAN_GBSHISS

/datum/emote/living/carbon/human/gaswiggles
	name = EMOTE_HUMAN_GBSWIGGLE

/datum/emote/living/carbon/human/gasroar
	key = "gasroar"
	key_third_person = "gasroar"
	message = "утробно рычит."
	message_mime = "бесшумно рычит."
	message_param = "утробно рычит на %t."
	species_type_whitelist_typecache = list(/datum/species/serpentid)
	volume = 50
	muzzled_noises = list("раздражённый")
	emote_type = EMOTE_VISIBLE | EMOTE_MOUTH | EMOTE_AUDIBLE
	age_based = TRUE

/datum/emote/living/carbon/human/gasroar/get_sound(mob/living/user)
	return pick(
		'modular_ss220/species/serpentids/sounds/serpentid_roar.ogg')

/datum/emote/living/carbon/human/gashiss
	key = "gashiss"
	key_third_person = "gashisses"
	message = "шипит."
	message_param = "шипит на %t."
	species_type_whitelist_typecache = list(/datum/species/serpentid)
	emote_type = EMOTE_AUDIBLE | EMOTE_MOUTH
	age_based = TRUE
	sound = "modular_ss220/species/serpentids/sounds/serpentid_hiss.ogg"
	muzzled_noises = list("weak hissing")

/datum/emote/living/carbon/human/gaswiggles
	key = "gaswiggles"
	key_third_person = "gaswiggles"
	message = "шевелит усиками."
	message_param = "шевелит усиками в сторону %t."
	cooldown = 5 SECONDS
	species_type_whitelist_typecache = list(/datum/species/serpentid)
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE | EMOTE_MOUTH
	age_based = TRUE
	volume = 80
	muzzled_noises = list("слабо")
	sound = 'modular_ss220/species/serpentids/sounds/serpentid_wiggle.ogg'

/datum/keybinding/emote/carbon/human/gasroar
	linked_emote = /datum/emote/living/carbon/human/gasroar
	name = EMOTE_HUMAN_GBSROAR

/datum/keybinding/emote/carbon/human/gashiss
	linked_emote = /datum/emote/living/carbon/human/gashiss
	name = EMOTE_HUMAN_GBSHISS

/datum/keybinding/emote/carbon/human/gaswiggles
	linked_emote = /datum/emote/living/carbon/human/gaswiggles
	name = EMOTE_HUMAN_GBSWIGGLE
