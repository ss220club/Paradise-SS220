/datum/quicksand_victim
	/// Timer id of changing current stage to next planned
	VAR_PRIVATE/stage_change_timer_id = null
	/// The number of current stage
	VAR_PRIVATE/current_stage_number = 0
	/// Reference to actual victim mob
	VAR_PRIVATE/mob/living/victim = null
	/// The stage of quicksand the victim is currently on
	VAR_PRIVATE/datum/quicksand_stage/current_stage = null
	/// List of stages the victim will go through
	VAR_PRIVATE/list/planned_stages = list()

/datum/quicksand_victim/New(mob/living/victim, list/planned_stages)
	src.victim = victim
	src.planned_stages = planned_stages
	move_to_next_stage()
	RegisterSignal(victim, COMSIG_LIVING_RESIST, PROC_REF(on_victim_resist))

/datum/quicksand_victim/proc/on_victim_resist(mob/living/resisting_victim)
	SIGNAL_HANDLER

	// TODO: Properly implement
	return

/datum/quicksand_victim/proc/change_stage(datum/quicksand_stage/stage_to_change_to)
	PRIVATE_PROC(TRUE)

	remove_current_stage()
	apply_stage(stage_to_change_to)

/datum/quicksand_victim/proc/apply_stage(datum/quicksand_stage/stage_to_apply)
	PRIVATE_PROC(TRUE)

	if(!stage_to_apply)
		return

	stage_to_apply.apply(victim)
	current_stage = stage_to_apply

/datum/quicksand_victim/proc/remove_current_stage()
	PRIVATE_PROC(TRUE)

	if(!current_stage)
		return

	current_stage.remove(victim)
	current_stage = null

/datum/quicksand_victim/proc/move_to_next_stage()
	PRIVATE_PROC(TRUE)

	stage_change_timer_id = null
	current_stage_number++
	if(current_stage_number > length(planned_stages))
		return

	change_stage(planned_stages[current_stage_number])
	plan_move_to_next_stage()

/datum/quicksand_victim/proc/plan_move_to_next_stage()
	PRIVATE_PROC(TRUE)

	if(stage_change_timer_id)
		deltimer(stage_change_timer_id)

	var/next_stage_number = current_stage_number + 1
	if(next_stage_number > length(planned_stages))
		return

	stage_change_timer_id = addtimer(CALLBACK(PROC_REF(move_to_next_stage)), current_stage.duration)
