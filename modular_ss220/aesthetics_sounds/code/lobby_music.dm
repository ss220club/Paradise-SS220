/datum/controller/subsystem/ticker/Initialize()
	var/static/list/config_songs = flist("config/lobby_music/sounds/")
	var/static/list/music = list()
	for(var/song in config_songs)
		music += song

	login_music = "config/lobby_music/sounds/[pick(music)]"

/client/playtitlemusic()
	UNTIL(SSticker.login_music)

	if(!(prefs.sound & SOUND_LOBBY) || GLOB.configuration.general.disable_lobby_music)
		return
	SEND_SOUND(src, sound(SSticker.login_music, repeat = 1, wait = 0, volume = 50 * prefs.get_channel_volume(CHANNEL_LOBBYMUSIC), channel = CHANNEL_LOBBYMUSIC))
