/datum/spell/summonmob
	name = "Summon Servant"
	desc = "Призывает вашего личного слугу, готового сделать для вас всё что угодно в любое время дня и ночи!"
	clothes_req = FALSE
	invocation = "JE VES"
	invocation_type = "whisper"
	level_max = 0 //cannot be improved
	cooldown_min = 100

	var/mob/living/target_mob

	action_icon_state = "summons"

/datum/spell/summonmob/create_new_targeting()
	return new /datum/spell_targeting/self

/datum/spell/summonmob/cast(list/targets, mob/user = usr)
	if(!target_mob)
		return
	var/turf/Start = get_turf(user)
	for(var/direction in GLOB.alldirs)
		var/turf/T = get_step(Start,direction)
		if(!T.density)
			target_mob.Move(T)
