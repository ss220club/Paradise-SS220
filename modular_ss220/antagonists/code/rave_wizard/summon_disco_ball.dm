/datum/spell/aoe/conjure/summon_disco
	name = "Summon Disco Ball"
	desc = "Summons a disco ball"
	base_cooldown = 400 SECONDS
	summon_type = list(/obj/machinery/jukebox/disco/indestructible)
	invocation = "YRTAP SELDEN"
	invocation_type = "shout"
	summon_amt = 1
	aoe_range = 0
	level_max = 0 //cannot be improved
	action_icon_state = "no_state"
	action_background_icon_state = "summon_disco"
	action_icon = 'modular_ss220/antagonists/icons/rave.dmi'
	var/obj/machinery/jukebox/disco/indestructible/our_disco

/datum/spell/aoe/conjure/summon_disco/cast(list/targets, mob/living/user = usr)
	if(!our_disco)
		var/list/summoned_items = ..()
		if(summoned_items || summoned_items.len > 0)
			our_disco = summoned_items[1]
	else
		playsound(get_turf(src), cast_sound, 50, 1)
		our_disco.forceMove(user.loc)
		playsound(get_turf(user), cast_sound, 50,1)

/datum/spellbook_entry/summon_disco
	name = "Summon Disco Ball"
	spell_type = /datum/spell/aoe/conjure/summon_disco
	cost = 1
	category = "Rave"
