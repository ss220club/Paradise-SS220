/datum/reagent/medicine/syndicate_nanites
	overdose_threshold = 50
	harmless = FALSE

/datum/reagent/medicine/syndicate_nanites/overdose_process(mob/living/M, severity)
	var/update_flags = STATUS_UPDATE_NONE
	update_flags |= M.adjustCloneLoss(1.5 * REAGENTS_EFFECT_MULTIPLIER, FALSE)
	return list(0, update_flags)

/mob/living/proc/can_apply(mob/user, error_msg, target_zone, penetrate_thick)
	return TRUE

/mob/living/carbon/human/can_apply(mob/user, error_msg, target_zone, apply_through_thick = FALSE, apply_through_everything = FALSE)
	. = TRUE

	if(!target_zone)
		if(!user)
			. = FALSE
			CRASH("can_apply() called on a human mob with neither a user nor a targeting zone selected.")
		else
			target_zone = user.zone_selected

	var/obj/item/organ/external/affecting = get_organ(target_zone)
	var/fail_msg
	if(!affecting)
		. = FALSE
		fail_msg = "Эта конечность отсутствует!"

	if(apply_through_everything)
		return TRUE

	if(target_zone == "head")
		if((head?.flags & THICKMATERIAL) && !apply_through_thick)
			. = FALSE
	else
		if((wear_suit?.flags & THICKMATERIAL) && !apply_through_thick)
			. = FALSE
	if(!. && error_msg && user)
		if(!fail_msg)
			fail_msg = "Нельзя дотянуться до кожи сквозь плотную одежду!"
		to_chat(user, span_warning("[fail_msg]"))
