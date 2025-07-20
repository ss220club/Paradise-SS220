/mob/living/trapped_mind
	name = "Заключённый разум"
	real_name = "Заключённый разум"
	hud_type = /datum/hud/trapped_mind
	see_in_dark = 6
	var/is_resisting_control = FALSE
	var/mob/living/carbon/human/original_body

/mob/living/trapped_mind/add_tts_component()
	AddComponent(/datum/component/tts_component, /datum/tts_seed/silero/anubarak)

/mob/living/trapped_mind/say(message, verb, sanitize, ignore_speech_problems, ignore_atmospherics, ignore_languages)
	if(!message)
		return
	to_chat(src, span_purple("<b>[name]: <i>[message]</i></b>"))
	to_chat(original_body, span_purple("<b>[name]: <i>[message]</i></b>"))
	cast_tts(original_body, message, src, FALSE)
	cast_tts(src, message, src, FALSE)
	for(var/mob/M in GLOB.player_list)
		if((M in GLOB.dead_mob_list) && !isnewplayer(M))
			to_chat(M, "<span class='notice'><b>[name]</b> -> [original_body.name] ([ghost_follow_link(original_body, ghost=M)]): [message]</span>")

/mob/living/trapped_mind/emote(emote_key, type_override, message, intentional, force_silence)
	to_chat(src, span_warning("Вы не способны на выражение эмоций."))

/mob/living/trapped_mind/whisper(message as text)
	to_chat(src, span_warning("Вы не способны шептать."))

/datum/hud/trapped_mind/New(mob/user)
	..()
	user.overlay_fullscreen("see_through_darkness", /atom/movable/screen/fullscreen/stretch/see_through_darkness)

/datum/action/resist_control
	name = "Сопротивляться контролю"
	desc = "Вы сопротивляетесь контролю паразита и вернёте контроль над телом Вы вернёте тело себе через минуту после использования этого навыка."
	button_overlay_icon_state = "enslave_mind"
	button_overlay_icon = 'modular_ss220/lazarus/icons/lazarus_actions.dmi'

/datum/action/resist_control/Trigger(left_click)
	var/mob/living/trapped_mind/user = usr
	if(!istype(user))
		return
	if(user.is_resisting_control)
		to_chat(user, span_warning("Вы уже сопротивляетесь контролю."))
		return
	if(user.original_body.treacherous_flesh.host_enslaved)
		to_chat(user, span_warning("Ваш разум был порабощён. Вы не можете сопротивляться"))
		return
	to_chat(usr, span_warning("Мы начинает по-немногу возвращать контроль над телом"))
	user.is_resisting_control = TRUE

	user.original_body.Jitter(8 SECONDS)
	sleep(20 SECONDS)
	user.original_body.Jitter(8 SECONDS)
	sleep(20 SECONDS)
	user.original_body.Jitter(8 SECONDS)
	sleep(20 SECONDS)

	if(!user)
		return
	if(!user.original_body.treacherous_flesh.trapped_mind)
		return
	user.original_body.treacherous_flesh.ckey = user.original_body.ckey
	user.original_body.ckey = user.original_body.treacherous_flesh.trapped_mind.ckey
	user.original_body.treacherous_flesh.trapped_mind = null
	qdel(user)
