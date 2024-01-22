/obj/effect/proc_holder/spell/aoe/conjure/summon_disco
	name = "Summon Disco Ball"
	desc = "Summons a disco ball"
	base_cooldown = 400 SECONDS
	summon_type = list(/obj/machinery/jukebox/disco/anchored/indestructible)
	invocation = "YRTAP SELDEN"
	invocation_type = "shout"
	summon_amt = 1
	aoe_range = 0
	level_max = 0 //cannot be improved
	summon_lifespan = 400 SECONDS
	action_icon_state = "no_state"
	action_background_icon_state = "summon_disco"
	action_icon = 'modular_ss220/antagonists/icons/rave.dmi'

/obj/effect/proc_holder/spell/aoe/conjure/summon_disco/cast(list/targets, mob/living/user = usr)
	..()
	//for(var/obj/machinery/disco/our_disco in summoned_objects)


/datum/spellbook_entry/summon_disco
	name = "Summon Disco Ball"
	spell_type = /obj/effect/proc_holder/spell/aoe/conjure/summon_disco
	cost = 3
	category = "Offensive"

