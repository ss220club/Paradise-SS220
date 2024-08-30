/datum/controller/subsystem/ticker/Initialize()
	login_music = "modular_ss220/lazarus/sound/music/Darkwood-OST-Morning.ogg"

	for(var/client/client as anything in GLOB.clients)
		client.playtitlemusic()
