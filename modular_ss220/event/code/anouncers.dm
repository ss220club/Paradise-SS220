
/datum/announcement_configuration/begemot
	default_title = "Бегемот ревёт"
	global_announcement = TRUE
	sound = sound('modular_ss220/event/sound/begemore_rar.ogg')
	tts_seed = /datum/tts_seed/silero/anubarak

/datum/announcement_configuration/herald
	default_title = "Вестник - оглашает"
	global_announcement = TRUE
	sound = sound('modular_ss220/event/sound/begemore_rar.ogg')
	tts_seed = /datum/tts_seed/silero/swain

GLOBAL_DATUM_INIT(begemot, /datum/announcer, new(config_type = /datum/announcement_configuration/begemot))
GLOBAL_DATUM_INIT(herald, /datum/announcer, new(config_type = /datum/announcement_configuration/herald))
