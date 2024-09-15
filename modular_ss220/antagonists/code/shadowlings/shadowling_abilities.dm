/obj/effect/proc_holder/spell/proc/shadowling_check(mob/living/carbon/human/user)
	if(!istype(user))
		return FALSE

	if(isshadowling(user) && is_shadow(user))
		return TRUE

	if(isshadowlinglesser(user) && is_thrall(user))
		return TRUE

	if(!is_shadow_or_thrall(user))
		to_chat(user, "<span class='warning'>You can't wrap your head around how to do this.</span>")

	else if(is_thrall(user))
		to_chat(user, "<span class='warning'>You aren't powerful enough to do this.</span>")

	else if(is_shadow(user))
		to_chat(user, "<span class='warning'>Your telepathic ability is suppressed. Hatch or use Rapid Re-Hatch first.</span>")

	return FALSE
