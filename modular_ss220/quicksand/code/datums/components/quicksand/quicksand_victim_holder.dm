/datum/quicksand_victim_holder
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

/datum/quicksand_victim_holder/New(mob/living/victim, list/planned_stages)
	src.victim = victim
	src.planned_stages = planned_stages
	move_to_next_stage()
	RegisterSignal(victim, COMSIG_LIVING_RESIST, PROC_REF(on_victim_resist))

/datum/quicksand_victim_holder/Destroy(force, ...)
	if(stage_change_timer_id)
		deltimer(stage_change_timer_id)

	release_victim()
	current_stage = null
	planned_stages = null

	return ..()

/datum/quicksand_victim_holder/proc/get_victim()
	return victim

/datum/quicksand_victim_holder/proc/on_victim_resist(mob/living/resisting_victim)
	SIGNAL_HANDLER

	if(!prob(current_stage.resist_chance) && prob(current_stage.critical_failure_chance))
		move_to_next_stage()
		return

	move_to_previous_stage()

/datum/quicksand_victim_holder/proc/move_to_next_stage()
	PRIVATE_PROC(TRUE)

	if(current_stage_number + 1 > length(planned_stages))
		return

	current_stage_number++
	change_stage_and_plan_move_to_next_stage(planned_stages[current_stage_number])

/datum/quicksand_victim_holder/proc/plan_move_to_next_stage()
	PRIVATE_PROC(TRUE)

	if(current_stage_number + 1 > length(planned_stages))
		return

	if(current_stage.duration <= 0)
		move_to_next_stage()
		return

	stage_change_timer_id = addtimer(CALLBACK(src, PROC_REF(move_to_next_stage)), current_stage.duration, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_STOPPABLE)

/datum/quicksand_victim_holder/proc/move_to_previous_stage()
	PRIVATE_PROC(TRUE)

	if(current_stage_number <= 1)
		release_victim()
		return

	current_stage_number--
	change_stage_and_plan_move_to_next_stage(planned_stages[current_stage_number])

/datum/quicksand_victim_holder/proc/change_stage_and_plan_move_to_next_stage(datum/quicksand_stage/stage_to_change_to)
	change_stage(stage_to_change_to)
	plan_move_to_next_stage()

/datum/quicksand_victim_holder/proc/release_victim()
	PRIVATE_PROC(TRUE)

	remove_current_stage()
	SEND_SIGNAL(src, COMSIG_QUICKSAND_VICTIM_RELEASED, victim)
	victim = null

/datum/quicksand_victim_holder/proc/change_stage(datum/quicksand_stage/stage_to_change_to)
	PRIVATE_PROC(TRUE)

	remove_current_stage()
	apply_stage(stage_to_change_to)

/datum/quicksand_victim_holder/proc/apply_stage(datum/quicksand_stage/stage_to_apply)
	PRIVATE_PROC(TRUE)

	if(!stage_to_apply)
		return

	stage_to_apply.apply(victim)
	current_stage = stage_to_apply

/datum/quicksand_victim_holder/proc/remove_current_stage()
	PRIVATE_PROC(TRUE)

	if(!current_stage)
		return

	current_stage.remove(victim)
	current_stage = null
