/// Stage 1
/datum/status_effect/quicksand_stage_1
	id = "quicksand_stage_1"
	duration = -1
	tick_interval = -1
	alert_type = /atom/movable/screen/alert/status_effect/quicksand_stage_1

/datum/status_effect/quicksand_stage_1/on_apply()
	ADD_TRAIT(owner, TRAIT_IMMOBILIZED, id)
	return TRUE

/datum/status_effect/quicksand_stage_1/on_remove()
	REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, id)

/atom/movable/screen/alert/status_effect/quicksand_stage_1
	name = "Зыбучие пески"
	desc = "Твои ноги попали в зыбучие пески"
	icon = 'modular_ss220/quicksand/icon/quicksand_status_effects.dmi'
	icon_state = "feet"

/// Stage 2
/datum/status_effect/quicksand_stage_2
	id = "quicksand_stage_2"
	duration = -1
	tick_interval = -1
	alert_type = /atom/movable/screen/alert/status_effect/quicksand_stage_2

/datum/status_effect/quicksand_stage_2/on_apply()
	ADD_TRAIT(owner, TRAIT_IMMOBILIZED, id)
	return TRUE

/datum/status_effect/quicksand_stage_2/on_remove()
	REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, id)

/atom/movable/screen/alert/status_effect/quicksand_stage_2
	name = "Зыбучие пески"
	desc = "Ты по пояс провалился в зыбучие пески"
	icon = 'modular_ss220/quicksand/icon/quicksand_status_effects.dmi'
	icon_state = "torso"

/// Stage 3
/datum/status_effect/quicksand_stage_3
	id = "quicksand_stage_3"
	duration = -1
	tick_interval = 3 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/quicksand_stage_3

/datum/status_effect/quicksand_stage_3/on_apply()
	ADD_TRAIT(owner, TRAIT_IMMOBILIZED, id)
	ADD_TRAIT(owner, TRAIT_HANDS_BLOCKED, id)
	ADD_TRAIT(owner, TRAIT_MUTE, id)
	ADD_TRAIT(owner, TRAIT_CANT_BREATH_FROM_ENVIRONMENT, id)
	return TRUE

/datum/status_effect/quicksand_stage_3/on_remove()
	REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, id)
	REMOVE_TRAIT(owner, TRAIT_HANDS_BLOCKED, id)
	REMOVE_TRAIT(owner, TRAIT_MUTE, id)
	REMOVE_TRAIT(owner, TRAIT_CANT_BREATH_FROM_ENVIRONMENT, id)

/datum/status_effect/quicksand_stage_3/tick()
	owner.adjustBruteLoss(5, FALSE)
	to_chat(owner, span_danger("На тебя все сильнее давят зыбучие пески..."))

/atom/movable/screen/alert/status_effect/quicksand_stage_3
	name = "Зыбучие пески"
	desc = "Тебя по голову поглотили зыбучие пески. Это будет медленная и мучительная смерть."
	icon = 'modular_ss220/quicksand/icon/quicksand_status_effects.dmi'
	icon_state = "head"
