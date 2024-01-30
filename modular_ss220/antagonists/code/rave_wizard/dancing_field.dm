/obj/effect/proc_holder/spell/aoe/conjure/timestop/dance
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
	icon = 'icons/effects/160x160.dmi' //TODO change to other effect
	icon_state = "time"

/obj/effect/timestop/dancing/New()
	..()
	for(var/mob/living/M in GLOB.player_list)
		for(var/obj/effect/proc_holder/spell/aoe/conjure/timestop/dance/D in M.mind.spell_list) //conjurer is immune
			immune |= M

/obj/effect/timestop/dancing/timestop()
	playsound(get_turf(src), 'modular_ss220/antagonists/sound/dancing_field.mp3', 100, 1, -1)

	for(var/i in 1 to duration-1)
		for(var/A in orange (freezerange, loc))
			if(isliving(A))
				var/mob/living/M = A
				if(M in immune)
					continue
				M.notransform = TRUE
				M.anchored = TRUE
				M.apply_status_effect(STATUS_EFFECT_PACIFIED)
				M.emote(pick(list("dance","spin","flip")))
				if(ishostile(M))
					var/mob/living/simple_animal/hostile/H = M
					H.AIStatus = AI_OFF
					H.LoseTarget()
				stopped_atoms |= M


		for(var/mob/living/M in stopped_atoms)
			if(get_dist(get_turf(M),get_turf(src)) > freezerange) //If they lagged/ran past the timestop somehow, just ignore them
				unfreeze_mob(M)
				stopped_atoms -= M
		sleep(1)

/datum/spellbook_entry/dancestop
	name = "Dance Stop"
	spell_type = /obj/effect/proc_holder/spell/aoe/conjure/timestop/dance
	category = "Defensive"

/obj/effect/timestop/dancing/wizard
	duration = 100

/obj/effect/timestop/dancing/wizard/New()
	..()
	timestop()
