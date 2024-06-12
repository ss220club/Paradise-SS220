/datum/controller/subsystem/ticker/Initialize()
	var/static/list/possible_music = flist("config/lobby_music/sounds/")
	login_music = "config/lobby_music/sounds/[pick(possible_music)]"

	for(var/client in GLOB.clients)
		var/client/C = client
		C.playtitlemusic()
