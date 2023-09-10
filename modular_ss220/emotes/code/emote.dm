/mob/proc/user_triggered_emote(act, type, message, force)
	if(stat || !use_me && usr == src)
		if(usr)
			to_chat(usr, "You are unable to emote.")
		return
	emote(act, type, message, force)
