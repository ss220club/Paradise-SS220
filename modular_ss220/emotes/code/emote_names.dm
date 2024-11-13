/datum/emote
	var/name

/datum/emote/New()
	. = ..()
	if(!name)
		name = key
