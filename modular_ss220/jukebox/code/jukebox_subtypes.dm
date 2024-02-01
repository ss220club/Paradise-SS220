/obj/machinery/jukebox/bar
	req_access = list(ACCESS_BAR)

/obj/machinery/jukebox/disco
	name = "\improper танцевальный диско-шар - тип IV"
	desc = "Первые три прототипа были сняты с производства после инцидентов с массовыми жертвами."
	icon_state = "disco"
	base_icon_state = "disco"
	max_integrity = 300
	integrity_failure = 150
	var/list/spotlights = list()
	var/list/sparkles = list()

/obj/machinery/jukebox/disco/indestructible
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

// Drums
/obj/machinery/jukebox/drum_red
	name = "\improper красный барабан"
	desc = "Крутые барабаны от какой-то группы."
	icon_state = "drum_red_unanchored"
	base_icon_state = "drum_red"
	anchored = FALSE
	music_folder = "config/jukebox_music/drum_music/"

/obj/machinery/jukebox/drum_red/wrench_act()
	. = ..()
	icon_state = "[base_icon_state][anchored ? null : "_unanchored"]"

/obj/machinery/jukebox/drum_red/update_icon_state()
	if(stat & (BROKEN))
		icon_state = "[base_icon_state]_broken"
	else
		icon_state = "[base_icon_state][music_player.active_song_sound ? "-active" : null]"

/obj/machinery/jukebox/drum_red/drum_yellow
	name = "\improper желтый барабан"
	icon_state = "drum_yellow_unanchored"
	base_icon_state = "drum_yellow"

/obj/machinery/jukebox/drum_red/drum_blue
	name = "\improper синий барабан"
	icon_state = "drum_blue_unanchored"
	base_icon_state = "drum_blue"

/datum/supply_packs/misc/bigband/New()
	. = ..()
	contains |= /obj/machinery/jukebox/drum_red
