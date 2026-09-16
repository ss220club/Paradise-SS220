/**
 * Emotes usable by brains, but only while they're in MMIs.
 */
/datum/emote/living/brain
	mob_type_allowed_typecache = list(/mob/living/brain)
	mob_type_blacklist_typecache = null
	/// The message that will be displayed to themselves, since brains can't really see their own emotes
	var/self_message

/datum/emote/living/brain/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return FALSE

	if(self_message)
		to_chat(user, self_message)
// So, brains can't really see their own emotes so we'll probably just want to send an extra message

/datum/emote/living/brain/can_run_emote(mob/user, status_check, intentional)
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/brain/B = user

	if(!(B.container && istype(B.container, /obj/item/mmi)))  // No MMI, no emotes
		return FALSE

/datum/emote/living/brain/alarm
	key = "alarm"
	key_third_person = "alarms"
	message = "подаёт сигнал тревоги."
	self_message = "Вы подаёте сигнал тревоги."

/datum/emote/living/brain/alert
	key = "alert"
	key_third_person = "alerts"
	message = "издаёт страдальческий звук."
	self_message = "Вы издаёте страдальческий звук."

/datum/emote/living/brain/notice
	key = "notice"
	message = "воспроизводит громкий звук."
	self_message = "Вы воспроизводите громкий звук."

/datum/emote/living/brain/flash
	key = "flash"
	message = "начинает быстро мигать лампочками!"

/datum/emote/living/brain/whistle
	key = "whistle"
	key_third_person = "whistles"
	message = "свистит."
	self_message = "Вы свистите."

/datum/emote/living/brain/beep
	key = "beep"
	key_third_person = "beeps"
	message = "бипает."
	self_message = "Вы бипаете."
	emote_type = EMOTE_AUDIBLE
	sound = "sound/machines/twobeep.ogg"

/datum/emote/living/brain/boop
	key = "boop"
	key_third_person = "boops"
	message = "бупает."
	self_message = "Вы бупаете."
	emote_type = EMOTE_AUDIBLE
	sound = "sound/machines/boop.ogg"

/datum/emote/living/brain/scream
	key = "scream"
	key_third_person = "screams"
	message = "screams!"
	self_message = "You scream!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/brain/scream/select_message_type(mob/user, msg, intentional)
	. = ..()
	var/mob/living/carbon/human/H = user
	if(H.dna.species?.scream_verb)
		if(H.mind?.miming)
			return "[H.dna.species?.scream_verb] silently!"
		else
			return "[H.dna.species?.scream_verb]!"

/datum/emote/living/brain/scream/get_sound(mob/living/brain/user)
	if(user.mind?.miming || !istype(user))
		return
	if(user.gender == FEMALE)
		return user.dna.species.female_scream_sound
	else
		return user.dna.species.male_scream_sound
