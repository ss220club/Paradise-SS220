#define INIT_ORDER_JUKEBOX 11

SUBSYSTEM_DEF(jukeboxes)
	name = "Jukeboxes"
	wait = 5
	init_order = INIT_ORDER_JUKEBOX
	var/list/songs = list()
	var/list/active_jukeboxes = list()
	var/list/free_jukebox_channels = list()

/datum/track/New(name, path, length, beat)
	song_name = name
	song_path = path
	song_length = length
	song_beat = beat

/datum/controller/subsystem/jukeboxes/proc/add_jukebox(obj/machinery/jukebox/jukebox, datum/track/T, jukefalloff = 1)
	if(!istype(T))
		CRASH("[src] tried to play a song with a nonexistant track.")
	var/channel_to_reserve = pick(free_jukebox_channels)
	if(!channel_to_reserve)
		return FALSE
	free_jukebox_channels -= channel_to_reserve
	var/list/you_got_free_jukebox = list(T, channel_to_reserve, jukebox, jukefalloff)
	active_jukeboxes.len++
	active_jukeboxes[active_jukeboxes.len] = you_got_free_jukebox
	var/sound/song_to_init = sound(T.song_path)
	song_to_init.status = SOUND_MUTE
	for(var/mob/living/M in GLOB.player_list)
		if(!M.client)
			continue
		if(!M.client || !(M.client.prefs.sound & SOUND_DISCO))
			continue

		M.playsound_local(M, null, jukebox.volume, channel = you_got_free_jukebox[2], S = song_to_init)
	return active_jukeboxes.len

/datum/controller/subsystem/jukeboxes/proc/remove_jukebox(IDtoremove)
	if(islist(active_jukeboxes[IDtoremove]))
		var/jukebox_channel = active_jukeboxes[IDtoremove][2]
		for(var/mob/living/M in GLOB.player_list)
			if(!M.client)
				continue
			M.stop_sound_channel(jukebox_channel)
		free_jukebox_channels |= jukebox_channel
		active_jukeboxes.Cut(IDtoremove, IDtoremove+1)
		return TRUE
	else
		CRASH("Tried to remove jukebox with invalid ID")

/datum/controller/subsystem/jukeboxes/proc/find_jukebox_index(obj/machinery/jukebox)
	if(active_jukeboxes.len)
		for(var/list/jukebox_info in active_jukeboxes)
			if(jukebox in jukebox_info)
				return active_jukeboxes.Find(jukebox_info)
	return FALSE

/datum/controller/subsystem/jukeboxes/Initialize()
	var/list/tracks = flist("config/jukebox_music/sounds/")

	for(var/S in tracks)
		var/datum/track/T = new()
		T.song_path = file("config/jukebox_music/sounds/[S]")
		var/list/L = splittext(S,"+")
		T.song_name = L[1]
		T.song_length = text2num(L[2])
		T.song_beat = text2num(L[3])
		songs |= T

	for(var/i in CHANNEL_JUKEBOX_START to CHANNEL_JUKEBOX)
		free_jukebox_channels |= i
	return

/datum/controller/subsystem/jukeboxes/fire()
	if(!active_jukeboxes.len)
		return
	for(var/list/jukebox_info in active_jukeboxes)
		if(!jukebox_info.len)
			stack_trace("Active jukebox without any associated metadata.")
			continue
		var/datum/track/jukebox_track = jukebox_info[1]
		if(!istype(jukebox_track))
			stack_trace("Invalid jukebox track datum.")
			continue
		var/obj/machinery/jukebox/jukebox = jukebox_info[3]
		if(!istype(jukebox))
			stack_trace("Nonexistant or invalid object associated with jukebox.")
			continue
		var/sound/song_played = sound(jukebox_track.song_path)
		var/turf/current_turf = get_turf(jukebox)

		song_played.falloff = jukebox_info[4]

		for(var/mob/living/M in GLOB.player_list)
			if(!M.client)
				continue
			if(!(M.client.prefs.sound & SOUND_DISCO) || !M.can_hear())
				M.stop_sound_channel(jukebox_info[2])
				continue

			if(jukebox.z == M.z)	//todo - expand this to work with mining planet z-levels when robust jukebox audio gets merged to master
				song_played.status = SOUND_UPDATE
			else
				song_played.status = SOUND_MUTE | SOUND_UPDATE	//Setting volume = 0 doesn't let the sound properties update at all, which is lame.

			M.playsound_local(current_turf, null, jukebox.volume, channel = jukebox_info[2], S = song_played)
			CHECK_TICK
	return
