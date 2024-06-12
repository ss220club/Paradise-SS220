/datum/controller/subsystem/ticker/Initialize()
	var/static/list/possible_music= flist("config/lobby_music/sounds/")
	login_music = "config/lobby_music/sounds/[pick(possible_music)]"

/client/playtitlemusic()
	UNTIL(SSticker.login_music)

	if(!(prefs.sound & SOUND_LOBBY) || GLOB.configuration.general.disable_lobby_music)
		return
	SEND_SOUND(src, sound(SSticker.login_music, repeat = FALSE, wait = 0, volume = 50 * prefs.get_channel_volume(CHANNEL_LOBBYMUSIC), channel = CHANNEL_LOBBYMUSIC))
