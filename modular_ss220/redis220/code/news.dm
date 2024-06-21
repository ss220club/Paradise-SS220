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

/datum/modpack/redis220/initialize()
	var/datum/feed_channel/some_channel = new
	some_channel.channel_name = "Проклятье 220 Ньюс"

	var/datum/feed_message/some_message = new
	some_message.author = "Фурриверс Нормандия"
	some_message.author_ckey = "mooniverse"
	some_message.title = "ГСБ любит вульп!"
	some_message.body = {"
	В столе ГСБ найдена стопка фотографий седалищных мест вульпканинов из его отдела!
	Служебный роман или главой отдела стал извращнец? Узнайте в сегодняшнем выпуске!
	"}

	some_message.img = new /icon('icons/obj/butts.dmi', "vulp")

	some_channel.add_message(some_message)
	world.log << "Passed UT"
	world.log << "Is redis alive - [SSredis.connected]"
