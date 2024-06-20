/datum/feed_channel/add_message(datum/feed_message/M)
	. = ..()
	if(!M.author_ckey)
		return
	var/list/data = M.serialize() + list("publish_realtime" = world.realtime, "channel_name" = channel_name)
	SSredis.publish("byond.news", json_encode(data))

/datum/feed_message/serialize()
	. = ..()
	. += list(
		"author" = author,
		"author_ckey" = author_ckey,
		"title" = title,
		"body" = body,
		"img" = icon2base64(img),
		"censor_flags" = censor_flags,
		"admin_locked" = admin_locked,
		"view_count" = view_count,
		"publish_time" = publish_time
	)
	return .

