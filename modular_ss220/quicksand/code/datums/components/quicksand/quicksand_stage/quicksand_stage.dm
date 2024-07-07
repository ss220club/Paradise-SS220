/datum/quicksand_stage
	/// Duration of this stage
	var/duration = 1 SECONDS
	/// Chance in percent of mob resisting this stage and move back to previous stage
	var/resist_chance = 50
	/// Amount of time resist `do_after` will take
	var/resist_duration = 1 SECONDS
	/// Chance in percent of another mob to successfully help to remove this stage from the victim when pulling it.
	var/assist_chance = 100
	/// Chance in percent to fail critically and progress to next stage
	var/critical_failure_chance = 50
	/// Y position of alpha mask. Used for sinking animation
	var/alpha_mask_y = 0
	/// Status effect that will be applied in `apply` proc. Null if no status effect should be applied
	var/datum/status_effect/on_apply_status_effect = null
	/// Pool of messages that victim recieves when stage is applied
	var/list/on_apply_messages = list("Generic message")
	/// Pool of messages that victim recieves when stage is removed
	var/list/on_successful_resist_messages = list("Generic message")

/**
 * Suction stage must be applied to mob this way. Calls `on_apply`.
 */
/datum/quicksand_stage/proc/apply(mob/living/apply_to)
	SHOULD_NOT_OVERRIDE(TRUE)

	if(on_apply_status_effect)
		apply_to.apply_status_effect(on_apply_status_effect)

	on_apply(apply_to)
	to_chat(apply_to, span_danger(pick(on_apply_messages)))

/**
 * Suction stage must be removed from mob this way. Calls `on_remove`.
 */
/datum/quicksand_stage/proc/remove(mob/living/remove_from)
	SHOULD_NOT_OVERRIDE(TRUE)

	if(on_apply_status_effect)
		remove_from.remove_status_effect(on_apply_status_effect)

	on_remove(remove_from)
	to_chat(remove_from, span_green(pick(on_successful_resist_messages)))

/**
 * Override if need to do something specific, when this stage is applied to mob.
 */
/datum/quicksand_stage/proc/on_apply(mob/living/applied_to)
	return

/**
 * Override if need to do something specific, when this stage is removed from mob.
 */
/datum/quicksand_stage/proc/on_remove(mob/living/removed_from)
	return
