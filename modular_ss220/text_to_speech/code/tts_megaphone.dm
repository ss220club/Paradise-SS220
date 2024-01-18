/obj/item/megaphone/say_msg(mob/living/user, message)
	if(HAS_TRAIT(src, TRAIT_CMAGGED))
		playsound(src, "sound/items/bikehorn.ogg", 50, TRUE)
	else
		playsound(src, "sound/items/megaphone.ogg", 100, FALSE, 5)

	audible_message("<span class='game say'><span class='name'>[user.GetVoice()]</span> [user.GetAltName()] broadcasts, <span class='[span]'>\"[message]\"</span></span>", hearing_distance = 14)
	log_say("(MEGAPHONE) [message]", user)
	user.create_log(SAY_LOG, "(megaphone) '[message]'")
	for(var/obj/O in view(14, get_turf(src)))
		O.hear_talk(user, message_to_multilingual("<span class='[span]'>[message]</span>"))

	for(var/mob/M in get_mobs_in_view(7, src))
		if((M.client?.prefs.toggles2 & PREFTOGGLE_2_RUNECHAT) && M.can_hear())
			M.create_chat_message(user, message, FALSE, "big")
		var/effect = SOUND_EFFECT_MEGAPHONE
		if(isrobot(user))
			effect = SOUND_EFFECT_MEGAPHONE_ROBOT
		INVOKE_ASYNC(GLOBAL_PROC, /proc/tts_cast, user, M, message, user.tts_seed, FALSE, effect)
