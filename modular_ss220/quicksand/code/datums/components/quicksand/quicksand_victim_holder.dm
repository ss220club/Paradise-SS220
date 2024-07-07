#define SAND_APLHA_MASK_FILTER_NAME "sand_alpha_mask"

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
	RegisterSignal(victim, COMSIG_ATOM_ATTACK_HAND, PROC_REF(on_attack_hand))
	RegisterSignal(victim, COMSIG_LIVING_RESIST, PROC_REF(on_victim_resist))
	move_to_next_stage()
	randomize_victim_pixel_x_in_sand()

/datum/quicksand_victim_holder/Destroy(force, ...)
	if(stage_change_timer_id)
		deltimer(stage_change_timer_id)

	release_victim()
	current_stage = null
	planned_stages = null

	return ..()

/datum/quicksand_victim_holder/proc/randomize_victim_pixel_x_in_sand()
	PRIVATE_PROC(TRUE)

	victim.pixel_x = rand(-10, 10)

/datum/quicksand_victim_holder/proc/get_victim()
	return victim

/datum/quicksand_victim_holder/proc/on_attack_hand(atom/target, mob/user)
	SIGNAL_HANDLER

	if(user.a_intent != INTENT_HELP || user == victim)
		return

	INVOKE_ASYNC(src, PROC_REF(handle_attack_hand), user)
	return COMPONENT_CANCEL_ATTACK_CHAIN

/datum/quicksand_victim_holder/proc/handle_attack_hand(mob/user)
	if(!current_stage)
		return

	to_chat(user, span_notice("Ты пытаешься помочь [victim] выбраться из зыбучих песков"))
	to_chat(victim, span_notice("[user] пытается помочь тебе выбраться из зыбучих песков"))
	if(!do_after_once(user, current_stage.resist_duration, TRUE, user, attempt_cancel_message = "Ты передумал помогать [victim] выбраться из зыбучих песков"))
		return

	if(!prob(current_stage.assist_chance))
		to_chat(user, span_notice("[victim] выскальзывает у тебя из рук, и все еще остается в песках"))
		return

	move_to_previous_stage()

/datum/quicksand_victim_holder/proc/on_victim_resist(mob/living/resisting_victim)
	SIGNAL_HANDLER

	INVOKE_ASYNC(src, PROC_REF(handle_resisting), resisting_victim)

/datum/quicksand_victim_holder/proc/handle_resisting(mob/living/resisting_victim)
	to_chat(resisting_victim, span_notice("Ты пытаешься выбраться из зыбучих песков"))
	if(!do_after_once(resisting_victim, current_stage.resist_duration, FALSE, resisting_victim, attempt_cancel_message = "Видимо ты решил передохнуть и дать пескам тебя поглотить..."))
		return

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

	to_chat(victim, span_green(pick(current_stage.on_successful_resist_messages)))
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

	remove_current_stage(FALSE)
	UnregisterSignal(victim, COMSIG_ATOM_ATTACK_HAND)
	UnregisterSignal(victim, COMSIG_LIVING_RESIST)
	SEND_SIGNAL(src, COMSIG_QUICKSAND_VICTIM_RELEASED, victim)
	victim = null

/datum/quicksand_victim_holder/proc/change_stage(datum/quicksand_stage/stage_to_change_to)
	PRIVATE_PROC(TRUE)

	remove_current_stage(TRUE)
	apply_stage(stage_to_change_to)

/datum/quicksand_victim_holder/proc/apply_stage(datum/quicksand_stage/stage_to_apply)
	PRIVATE_PROC(TRUE)

	if(!stage_to_apply)
		return

	stage_to_apply.apply(victim)
	run_sand_sinking_animation(stage_to_apply)
	to_chat(victim, span_danger(pick(stage_to_apply.on_apply_messages)))

	current_stage = stage_to_apply

/datum/quicksand_victim_holder/proc/run_sand_sinking_animation(datum/quicksand_stage/stage_to_apply)
	PRIVATE_PROC(TRUE)

	var/filter = victim.get_filter(SAND_APLHA_MASK_FILTER_NAME)
	if(!filter)
		victim.add_filter(SAND_APLHA_MASK_FILTER_NAME, 1, list("type" = "alpha", "icon" = icon('icons/effects/effects.dmi', "white")))
		filter = victim.get_filter(SAND_APLHA_MASK_FILTER_NAME)

	var/animation_duration = stage_to_apply.duration / 2
	animate(filter, y = stage_to_apply.alpha_mask_y, time = animation_duration, easing = CUBIC_EASING|EASE_OUT , flags = ANIMATION_PARALLEL)
	animate(victim, pixel_y = - ceil(stage_to_apply.alpha_mask_y / 2), time = animation_duration, easing = CUBIC_EASING|EASE_OUT, flags = ANIMATION_PARALLEL)

/datum/quicksand_victim_holder/proc/remove_current_stage(stage_transition = FALSE)
	PRIVATE_PROC(TRUE)

	if(!current_stage)
		return

	if(!stage_transition)
		victim.remove_filter(SAND_APLHA_MASK_FILTER_NAME)
		victim.pixel_x = 0
		victim.pixel_y = 0
		animate(victim)

	current_stage.remove(victim)
	current_stage = null

#undef SAND_APLHA_MASK_FILTER_NAME
