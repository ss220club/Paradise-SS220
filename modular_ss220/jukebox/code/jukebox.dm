/obj/machinery/jukebox
	name = "\improper музыкальный автомат"
	desc = "Классический музыкальный автомат."
	icon = 'modular_ss220/jukebox/icons/jukebox.dmi'
	icon_state = "jukebox"
	base_icon_state = "jukebox"
	atom_say_verb =  "states"
	anchored = TRUE
	density = TRUE
	idle_power_consumption = 10
	active_power_consumption = 100
	max_integrity = 200
	integrity_failure = 100
	/// Cooldown between "Error" sound effects being played
	COOLDOWN_DECLARE(jukebox_error_cd)
	/// Cooldown between being allowed to play another song
	COOLDOWN_DECLARE(jukebox_song_cd)
	/// TimerID to when the current song ends
	var/song_timerid
	/// The actual music player datum that handles the music
	var/datum/jukebox/music_player
	/// From which folder to load music
	var/music_folder = "config/jukebox_music/sounds/"

/obj/machinery/jukebox/Initialize(mapload)
	. = ..()
	music_player = new(src, music_folder)

/obj/machinery/jukebox/Destroy()
	stop_music()
	QDEL_NULL(music_player)
	return ..()

/obj/machinery/jukebox/wrench_act(mob/user, obj/item/tool)
	if(music_player.active_song_sound || (resistance_flags & INDESTRUCTIBLE))
		return
	. = TRUE
	if(!tool.use_tool(src, user, 0, volume = tool.tool_volume))
		return
	if(!anchored && !isinspace())
		anchored = TRUE
		WRENCH_ANCHOR_MESSAGE
	else if(anchored)
		anchored = FALSE
		WRENCH_UNANCHOR_MESSAGE
	playsound(src, 'sound/items/deconstruct.ogg', 50, 1)

/obj/machinery/jukebox/update_icon_state()
	if(stat & (BROKEN))
		icon_state = "[base_icon_state]_broken"
	else
		icon_state = "[base_icon_state][music_player.active_song_sound ? "-active" : null]"

/obj/machinery/jukebox/update_overlays()
	. = ..()
	underlays.Cut()

	if(stat & (NOPOWER|BROKEN))
		return
	if(music_player.active_song_sound)
		underlays += emissive_appearance(icon, "[icon_state]_lightmask")

/obj/machinery/jukebox/attack_hand(mob/user)
	if(..())
		return
	if(isobserver(user))
		return
	if(!anchored)
		to_chat(user, span_warning("Это устройство должно быть закреплено гаечным ключом!"))
		return
	if(!allowed(user))
		to_chat(user,span_warning("Ошибка: Отказано в доступе."))
		user.playsound_local(src, 'sound/misc/compiler-failure.ogg', 25, TRUE)
		return
	if(!length(music_player.songs))
		to_chat(user,span_warning("Ошибка: Для вашей станции не было авторизовано ни одной музыкальной композиции. Обратитесь к Центральному командованию с просьбой решить эту проблему."))
		user.playsound_local(src, 'sound/misc/compiler-failure.ogg', 25, TRUE)
		return
	ui_interact(user)

/obj/machinery/jukebox/ui_state(mob/user)
	return GLOB.default_state

/obj/machinery/jukebox/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Jukebox", name)
		ui.open()

/obj/machinery/jukebox/ui_data(mob/user)
	return music_player.get_ui_data()

/obj/machinery/jukebox/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	switch(action)
		if("toggle")
			if(isnull(music_player.active_song_sound))
				if(!COOLDOWN_FINISHED(src, jukebox_song_cd))
					to_chat(usr, span_warning("Error: The device is still resetting from the last activation, \
						it will be ready again in [DisplayTimeText(COOLDOWN_TIMELEFT(src, jukebox_song_cd))]."))
					if(COOLDOWN_FINISHED(src, jukebox_error_cd))
						playsound(src, 'sound/misc/compiler-failure.ogg', 33, TRUE)
						COOLDOWN_START(src, jukebox_error_cd, 15 SECONDS)
					return TRUE

				activate_music()
			else
				stop_music()

			return TRUE

		if("select_track")
			if(!isnull(music_player.active_song_sound))
				to_chat(usr, span_warning("Error: You cannot change the song until the current one is over."))
				return TRUE

			var/datum/track/new_song = music_player.songs[params["track"]]
			if(QDELETED(src) || !istype(new_song, /datum/track))
				return TRUE

			music_player.selection = new_song
			return TRUE

		if("set_volume")
			var/new_volume = params["volume"]
			if(new_volume == "reset" || new_volume == "max")
				music_player.set_volume_to_max()
			else if(new_volume == "min")
				music_player.set_new_volume(0)
			else if(isnum(text2num(new_volume)))
				music_player.set_new_volume(text2num(new_volume))
			return TRUE

		if("loop")
			music_player.sound_loops = !!params["looping"]
			return TRUE

/obj/machinery/jukebox/proc/activate_music()
	if(!isnull(music_player.active_song_sound))
		return FALSE

	music_player.start_music()
	change_power_mode(ACTIVE_POWER_USE)
	update_icon()
	if(!music_player.sound_loops)
		song_timerid = addtimer(CALLBACK(src, PROC_REF(stop_music)), music_player.selection.song_length, TIMER_UNIQUE|TIMER_STOPPABLE|TIMER_DELETE_ME)
	return TRUE

/obj/machinery/jukebox/proc/stop_music()
	if(!isnull(song_timerid))
		deltimer(song_timerid)

	music_player.unlisten_all()
	music_player.endTime = 0
	music_player.startTime = 0

	if(!QDELING(src))
		COOLDOWN_START(src, jukebox_song_cd, 10 SECONDS)
		playsound(src,'sound/machines/terminal_off.ogg', 50, TRUE)
		change_power_mode(IDLE_POWER_USE)
		update_icon()
	return TRUE

/obj/machinery/jukebox/obj_break()
	if(stat & BROKEN)
		return
	stat |= BROKEN
	idle_power_consumption = 0
	stop_music()
