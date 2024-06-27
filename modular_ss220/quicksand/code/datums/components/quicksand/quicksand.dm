/datum/component/quicksand
	/// Chance in percent of catching lying mob.
	VAR_PRIVATE/lying_mob_catch_chance = 5
	/// Chance in percent of catching walking or running mob.
	VAR_PRIVATE/default_mob_catch_chance = 30
	/// Steps that mob will come through
	/// Assoc list of mob currently being sucked to `/datum/quicksand_victim` object.
	VAR_PRIVATE/list/victims = list()
	/// List of `/atom/movable` that were completely devoured by quicksand.
	/// Includes bulky objects and dead mobs
	VAR_PRIVATE/list/devoured = list()
	/// List of stages stage types
	VAR_PRIVATE/list/stage_types = list(
		/datum/quicksand_stage/initial
	)
	/// List of cached stage prototypes
	VAR_PRIVATE/list/cached_stage_prototypes = list()
	/// List of all quicksand stages. Static, so shared by all components of this type
	VAR_PRIVATE/static/list/all_quicksand_stages = list()

/datum/component/quicksand/Initialize(lying_mob_catch_chance, default_mob_catch_chance, list/stage_types)
	. = ..()

	if(lying_mob_catch_chance >= 0)
		src.lying_mob_catch_chance = lying_mob_catch_chance

	if(default_mob_catch_chance > 0)
		src.default_mob_catch_chance = default_mob_catch_chance

	if(length(stage_types) > 0)
		src.stage_types = stage_types

	init_quicksand_stages()

/datum/component/quicksand/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ATOM_ENTERED, PROC_REF(on_entered))

/datum/component/quicksand/proc/init_quicksand_stages()
	PRIVATE_PROC(TRUE)

	if(length(all_quicksand_stages))
		return

	for(var/quicksand_stage_type in subtypesof(/datum/quicksand_stage))
		all_quicksand_stages[quicksand_stage_type] = new quicksand_stage_type()

/datum/component/quicksand/proc/on_entered(datum/source, atom/movable/entering)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)

	if(isitem(entering))
		handle_item(entering)
	else if(isliving(entering))
		handle_living_mob(entering)

/datum/component/quicksand/proc/handle_living_mob(mob/victim)
	PRIVATE_PROC(TRUE)

	if(!can_be_catched(victim))
		return

	start_suction(victim)

/datum/component/quicksand/proc/can_be_catched(mob/victim)
	PRIVATE_PROC(TRUE)

	if(!isliving(victim))
		return prob(default_mob_catch_chance)

	var/mob/living/living_victim = victim
	if(living_victim.body_position == LYING_DOWN)
		return prob(lying_mob_catch_chance)

	return prob(default_mob_catch_chance)

/datum/component/quicksand/proc/handle_item(obj/item/target)
	PRIVATE_PROC(TRUE)

	// If the item is at least bulky, we just devour it, otherwise it will be left on top of the sands
	if(target.w_class < WEIGHT_CLASS_BULKY)
		return

	devour(target)

/datum/component/quicksand/proc/start_suction(mob/victim)
	PRIVATE_PROC(TRUE)

	victims[victim] = new /datum/quicksand_victim(victim, get_stage_prototypes())

/datum/component/quicksand/proc/get_stage_prototypes()
	PRIVATE_PROC(TRUE)

	if(!length(cached_stage_prototypes))
		for(var/stage_path in stage_types)
			cached_stage_prototypes += all_quicksand_stages[stage_path]

	return cached_stage_prototypes

/datum/component/quicksand/proc/devour()
	return
