#define SAND_APLHA_MASK_FILTER_NAME "sand_alpha_mask"

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
	/// Message that victim recieves when stage is applied
	var/on_apply_message = "Generic message"
	/// Message that victim recieves when stage is removed
	var/on_successful_resist_message = "Generic message"
	var/vertical_slide_size_pixels = 0
	var/displacement_icon = 'modular_ss220/quicksand/icon/sand_displacement_maps.dmi'
	var/displacement_icon_state = ""
	/// Status effect that will be applied in `apply` proc. Null if no status effect should be applied
	var/datum/status_effect/on_apply_status_effect = null

/**
 * Suction stage must be applied to mob this way. Calls `on_apply`.
 */
/datum/quicksand_stage/proc/apply(mob/living/apply_to)
	SHOULD_NOT_OVERRIDE(TRUE)

	if(on_apply_status_effect)
		apply_to.apply_status_effect(on_apply_status_effect)

	apply_to.add_filter(SAND_APLHA_MASK_FILTER_NAME, 1, list("type" = "alpha", "icon" = icon(displacement_icon, displacement_icon_state)))
	animate(apply_to, pixel_y = vertical_slide_size_pixels, time = 1 SECONDS)

	on_apply(apply_to)
	to_chat(apply_to, span_danger(on_apply_message))

/**
 * Suction stage must be removed from mob this way. Calls `on_remove`.
 */
/datum/quicksand_stage/proc/remove(mob/living/remove_from)
	SHOULD_NOT_OVERRIDE(TRUE)

	if(on_apply_status_effect)
		remove_from.remove_status_effect(on_apply_status_effect)

	remove_from.remove_filter(SAND_APLHA_MASK_FILTER_NAME)
	remove_from.pixel_y = 0

	on_remove(remove_from)
	to_chat(remove_from, span_green(on_successful_resist_message))

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
