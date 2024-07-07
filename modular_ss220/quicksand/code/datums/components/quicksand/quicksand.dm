/datum/component/quicksand
	/// Chance in percent of catching lying mob.
	VAR_PRIVATE/lying_mob_catch_chance = 5
	/// Chance in percent of catching walking or running mob.
	VAR_PRIVATE/default_mob_catch_chance = 30
	/// Steps that mob will come through
	/// Assoc list of mob currently being sucked to `/datum/quicksand_victim_holder` object.
	VAR_PRIVATE/list/victims = list()
	/// List of stages stage types
	VAR_PRIVATE/list/stage_types = list(
		/datum/quicksand_stage/feet,
		/datum/quicksand_stage/torso,
		/datum/quicksand_stage/head
	)
	/// List of cached stage prototypes
	VAR_PRIVATE/list/cached_stage_prototypes = list()
	/// List of all quicksand stages. Static, so shared by all components of this type
	VAR_PRIVATE/static/list/all_quicksand_stages = list()

/datum/component/quicksand/Initialize(lying_mob_catch_chance, default_mob_catch_chance, list/stage_types)
	. = ..()

	if(!isnull(lying_mob_catch_chance) && lying_mob_catch_chance >= 0)
		src.lying_mob_catch_chance = lying_mob_catch_chance

	if(default_mob_catch_chance > 0)
		src.default_mob_catch_chance = default_mob_catch_chance

	if(length(stage_types) > 0)
		src.stage_types = stage_types

	init_quicksand_stages()

/datum/component/quicksand/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ATOM_ENTERED, PROC_REF(on_entered))
	RegisterSignal(parent, COMSIG_ATOM_EXITED, PROC_REF(on_exited))

/datum/component/quicksand/proc/init_quicksand_stages()
	PRIVATE_PROC(TRUE)

	if(length(all_quicksand_stages))
		return

	for(var/quicksand_stage_type in subtypesof(/datum/quicksand_stage))
		all_quicksand_stages[quicksand_stage_type] = new quicksand_stage_type()

/datum/component/quicksand/proc/on_entered(datum/source, atom/movable/entering)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)

	if(!isliving(entering))
		return

	INVOKE_ASYNC(src, PROC_REF(handle_living_mob), entering)

/datum/component/quicksand/proc/on_exited(datum/source, atom/movable/exiting)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)

	if(!isliving(exiting))
		return

	var/datum/quicksand_victim_holder/handled_victim = victims[exiting]
	if(handled_victim)
		INVOKE_ASYNC(src, PROC_REF(remove_victim), handled_victim)

/datum/component/quicksand/proc/handle_living_mob(mob/victim)
	PRIVATE_PROC(TRUE)

	if(!can_be_catched(victim))
		return

	start_suction(victim)

/datum/component/quicksand/proc/can_be_catched(mob/victim)
	PRIVATE_PROC(TRUE)

	if(HAS_TRAIT(victim, TRAIT_QUICKSAND_IMMUNE))
		return FALSE

	if(!isliving(victim))
		return prob(default_mob_catch_chance)

	var/mob/living/living_victim = victim
	if(living_victim.body_position == LYING_DOWN)
		return prob(lying_mob_catch_chance)

	return prob(default_mob_catch_chance)

/datum/component/quicksand/proc/start_suction(mob/living/victim)
	PRIVATE_PROC(TRUE)

	if(victim.buckling)
		victim.buckling.unbuckle_mob(victim, TRUE)

	var/datum/quicksand_victim_holder/victim_holder = new /datum/quicksand_victim_holder(victim, get_stage_prototypes())
	victims[victim] = victim_holder

	RegisterSignal(victim_holder, COMSIG_QUICKSAND_VICTIM_RELEASED, PROC_REF(remove_victim_holder))
	RegisterSignal(victim, SIGNAL_ADDTRAIT(TRAIT_QUICKSAND_IMMUNE), PROC_REF(remove_victim))
	RegisterSignal(victim, COMSIG_LIVING_AHEAL, PROC_REF(remove_victim))

/datum/component/quicksand/proc/remove_victim(mob/living/victim)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)

	remove_victim(victims[victim])

/datum/component/quicksand/proc/remove_victim_holder(datum/quicksand_victim_holder/victim_holder_to_remove)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)

	var/mob/living/actual_victim_mob = victim_holder_to_remove.get_victim()

	victims -= actual_victim_mob
	UnregisterSignal(victim_holder_to_remove, COMSIG_QUICKSAND_VICTIM_RELEASED)
	UnregisterSignal(actual_victim_mob, SIGNAL_ADDTRAIT(TRAIT_QUICKSAND_IMMUNE))
	UnregisterSignal(actual_victim_mob, COMSIG_LIVING_AHEAL)
	qdel(victim_holder_to_remove)

/datum/component/quicksand/proc/on_quicksand_trait_add(mob/living/victim)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)

	remove_victim(victims[victim])

/datum/component/quicksand/proc/get_stage_prototypes()
	PRIVATE_PROC(TRUE)

	if(!length(cached_stage_prototypes))
		for(var/stage_path in stage_types)
			cached_stage_prototypes += all_quicksand_stages[stage_path]

	return cached_stage_prototypes
