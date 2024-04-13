/datum/spell/aoe/conjure/timestop/dance
	name = "Dance Time"
	desc = "This spell makes everyone dance in it's range. Enchanted targets cannot attack, but projectiles harm as usual"
	invocation = "DAN SIN FIVA"
	action_icon_state = "no_state"
	action_background_icon_state = "dance_field"
	action_icon = 'modular_ss220/antagonists/icons/rave.dmi'
	summon_lifespan = 100
	summon_type = list(/obj/effect/timestop/dancing/wizard)

/obj/effect/timestop/dancing
	name = "Dancing field"
	desc = "Feel the heat"
	icon = 'modular_ss220/antagonists/icons/160x160.dmi'
	icon_state = "dancing_ball"
	var/sound_type = list('modular_ss220/antagonists/sound/music1.mp3',
						'modular_ss220/antagonists/sound/music2.mp3',
						'modular_ss220/antagonists/sound/music3.mp3',
						'modular_ss220/antagonists/sound/music4.mp3',
						'modular_ss220/antagonists/sound/music5.mp3',
						'modular_ss220/antagonists/sound/music6.mp3')
	var/emote_probability = 60

/obj/effect/timestop/dancing/timestop()
	playsound(get_turf(src), pick(sound_type), 100, 1, -1)
	for(var/i in 0 to duration-2)
		addtimer(CALLBACK(src, PROC_REF(stop_and_dance_mobs_in_area)), i)
	addtimer(CALLBACK(src, PROC_REF(release_frozen_mobs)), duration-1)
	QDEL_IN(src, duration)
	return

/obj/effect/timestop/dancing/proc/release_frozen_mobs()
	for(var/mob/living/M in stopped_atoms)
		unfreeze_mob(M)

/obj/effect/timestop/dancing/proc/stop_and_dance_mobs_in_area()
	for(var/A in orange (freezerange, loc))
		if(isliving(A))
			var/mob/living/dancestoped_mob = A
			if(dancestoped_mob in immune)
				continue
			dancestoped_mob.notransform = TRUE
			dancestoped_mob.anchored = TRUE
			if(ishostile(dancestoped_mob))
				var/mob/living/simple_animal/hostile/H = dancestoped_mob
				H.AIStatus = AI_OFF
				H.LoseTarget()
			stopped_atoms |= dancestoped_mob
	for(var/mob/living/M in stopped_atoms)
		if(get_dist(get_turf(M),get_turf(src)) > freezerange) //If they lagged/ran past the timestop somehow, just ignore them
			unfreeze_mob(M)
			stopped_atoms -= M
		if(prob(emote_probability))
			M.emote(pick(list("spin","dance","flip")), intentional = TRUE)

/datum/spellbook_entry/dancestop
	name = "Dance Stop"
	spell_type = /datum/spell/aoe/conjure/timestop/dance
	category = "Rave"

/obj/effect/timestop/dancing/wizard
	duration = 100

/obj/effect/timestop/dancing/wizard/New()
	..()
	timestop()
