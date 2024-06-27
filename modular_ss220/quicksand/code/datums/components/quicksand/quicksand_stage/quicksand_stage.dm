/datum/quicksand_stage
	/// Duration of this stage.
	var/duration = 1 SECONDS
	/// Chance in percent of mob resisting this stage.
	var/resist_chance = 50

/**
 * Suction stage must be applied to mob this way. Calls `on_apply`.
 */
/datum/quicksand_stage/proc/apply(mob/living/apply_to)
	SHOULD_NOT_OVERRIDE(TRUE)

	on_apply(apply_to)

/**
 * Suction stage must be removed from mob this way. Calls `on_remove`.
 */
/datum/quicksand_stage/proc/remove(mob/living/remove_from)
	SHOULD_NOT_OVERRIDE(TRUE)

	on_remove(remove_from)

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
