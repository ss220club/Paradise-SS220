/datum/spell/shadowling
	school = "shadowling"
	action_background_icon_state = "shadow_demon_bg"
	human_req = TRUE
	clothes_req = FALSE

/datum/spell/shadowling/proc/get_light_level(mob/living/target)
	var/light_amount = 0
	if(isturf(target.loc))
		var/turf/T = target.loc
		light_amount = T.get_lumcount() * 10
	return light_amount

/datum/spell/shadowling/proc/shadowling_check(mob/living/carbon/human/user)
	if(!istype(user))
		return FALSE

	if(isshadowling(user) && is_shadow(user))
		return TRUE

	if(isshadowlinglesser(user) && is_thrall(user))
		return TRUE

	return FALSE
