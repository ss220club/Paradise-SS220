#define SHUTTLE_ROADKILL_TELEPORTATION_RANGE 24

/obj/docking_port/mobile/proc/roadkill_living(mob/living/L)	// Used in /obj/docking_port/mobile/proc/roadkill for modular behavior
	if(L.incorporeal_move || L.status_flags & GODMODE)
		return TRUE	// Calls 'continue'
	L.stop_pulling()
	if(isspaceturf(get_turf(L)))
		L.visible_message(
			"<span class='warning'>[L] иcчезает в спышке блю-спейс излучения в тот момент, когда шаттл материализуется в нашем пространстве!</span>",
			"<span class='userdanger'>Вы чувствует, будто вас сейчас стошнит. Блю-спейс прыжок шаттла телепортировал вас в другое место!</span>"
		)
		do_teleport(L, get_turf(L), SHUTTLE_ROADKILL_TELEPORTATION_RANGE, sound_in = 'sound/effects/phasein.ogg')
		return TRUE // Calls 'continue' to avoid qdeling of mob
	else
		L.visible_message(
			"<span class='warning'>Тело [L] разрывается на куски, от приземлившегося шаттла</span>",
			"<span class='userdanger'>Вы чуствуете как ваше тело раздавило огромным весом прилетевшего шаттла!</span>"
		)
		L.gib()

/obj/mecha/get_out_and_die()
	var/mob/living/pilot = occupant
	if(isspaceturf(get_turf(src)))
		pilot.visible_message(
			"<span class='warning'>[src] иcчезает в спышке блю-спейс излучения в тот момент, когда шаттл материализуется в нашем пространстве!</span>",
			"<span class='userdanger'>Вы чувствует, будто вас сейчас стошнит. Блю-спейс прыжок шаттла телепортировал вас в другое место!</span>"
		)
		do_teleport(src, get_turf(src), SHUTTLE_ROADKILL_TELEPORTATION_RANGE, sound_in = 'sound/effects/phasein.ogg')
	else
		pilot.visible_message(
			"<span class='warning'>Тело [pilot] разрывается на куски, от приземлившегося шаттла</span>",
			"<span class='userdanger'>Вы чуствуете как ваше тело раздавило огромным весом прилетевшего шаттла!</span>"
		)
		go_out(TRUE)
		if(iscarbon(pilot))
			pilot.gib()
		qdel(src)

#undef SHUTTLE_ROADKILL_TELEPORTATION_RANGE
