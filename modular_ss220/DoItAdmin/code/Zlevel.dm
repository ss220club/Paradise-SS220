/*
#define ANNOUNCE_VIS_LIVING    (1 << 0)  // 1  — живые
#define ANNOUNCE_VIS_GHOSTS    (1 << 1)  // 2  — госты (мёртвые с клиентом)
#define ANNOUNCE_VIS_LOBBY     (1 << 2)  // 4  — игроки в лобби
#define ANNOUNCE_VIS_SILICONS  (1 << 3)  // 8  — синтетики (ИИ, борги)
#define ANNOUNCE_VIS_OBSERVERS (1 << 4)  // 16 — обсерверы (observer-мобы, если есть отдельно)

#define ANNOUNCE_VIS_ALL       (ANNOUNCE_VIS_LIVING | ANNOUNCE_VIS_GHOSTS | ANNOUNCE_VIS_LOBBY | ANNOUNCE_VIS_SILICONS | ANNOUNCE_VIS_OBSERVERS)
#define ANNOUNCE_VIS_DEFAULT   (ANNOUNCE_VIS_LIVING | ANNOUNCE_VIS_GHOSTS)
*/

/datum/announcement_configuration/zlevel
	default_title = "ВНИМАНИЕ."
	global_announcement = FALSE
	sound = sound('sound/misc/notice2.ogg')
	style = "major"
	add_log = FALSE

/datum/announcer/zlevel
	var/anchor_z = 0
	var/vis_mask = ANNOUNCE_VIS_DEFAULT

/datum/announcer/zlevel/New(config_type = null, z = 0, vis = ANNOUNCE_VIS_DEFAULT)
	. = ..(config_type)
	anchor_z = z
	vis_mask = vis

/datum/announcer/zlevel/Get_Receivers(datum/language/message_language, force_translation = FALSE)
	var/list/receivers = list()
	var/list/garbled_receivers = list()

	if(!anchor_z)
		return list(receivers, garbled_receivers)

	for(var/mob/M in GLOB.player_list)
		if(!M.client)
			continue

		// Категория моба
		if(isnewplayer(M))
			if(!(vis_mask & ANNOUNCE_VIS_LOBBY))
				continue
		else if(M.stat == DEAD)
			if(!(vis_mask & ANNOUNCE_VIS_GHOSTS))
				continue
		else if(issilicon(M))
			if(!(vis_mask & ANNOUNCE_VIS_SILICONS))
				continue
		else if(isobserver(M))
			if(!(vis_mask & ANNOUNCE_VIS_OBSERVERS))
				continue
		else
			if(!(vis_mask & ANNOUNCE_VIS_LIVING))
				continue

		// Фильтр по Z-уровню
		var/turf/T = get_turf(M)
		if(!T || T.z != anchor_z)
			continue

		if(!M.say_understands(null, message_language))
			if(force_translation && HAS_TRAIT(M, TRAIT_FOREIGNER))
				continue
			garbled_receivers |= M
		else
			receivers |= M

	return list(receivers, garbled_receivers)

// Переопределяем, чтобы убрать новости
/datum/announcer/zlevel/Announce(message, new_title = null, new_sound = null, msg_sanitized = FALSE, msg_language, new_sound2 = null, new_subtitle = null, force_translation = FALSE)
	if(!message)
		return

	var/title = html_encode(new_title || config.default_title)
	var/subtitle = new_subtitle ? html_encode(new_subtitle) : null
	var/message_sound = new_sound ? sound(new_sound) : config.sound

	if(!msg_sanitized)
		message = html_encode(message)

	var/datum/language/message_language = GLOB.all_languages[msg_language ? msg_language : language]

	var/list/combined_receivers = Get_Receivers(message_language, force_translation)
	var/list/receivers = combined_receivers[1]
	var/list/garbled_receivers = combined_receivers[2]

	var/formatted_message = Format(message, title, subtitle)
	var/garbled_formatted_message = Format(
		message_language.scramble(message),
		message_language.scramble(title),
		message_language.scramble(subtitle)
	)

	Message(formatted_message, garbled_formatted_message, receivers, garbled_receivers)
	Sound(message_sound, receivers + garbled_receivers)

/proc/announce_zlevel(z, message, title = null, subtitle = null, sound = null, vis = ANNOUNCE_VIS_DEFAULT, language = "Galactic Common")
	if(!z || !message)
		return
	var/datum/announcer/zlevel/A = new /datum/announcer/zlevel(/datum/announcement_configuration/zlevel, z, vis)
	A.Announce(message, new_title = title, new_subtitle = subtitle, new_sound = sound, msg_language = language)
	qdel(A)

