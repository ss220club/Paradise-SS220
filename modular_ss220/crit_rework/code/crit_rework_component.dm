/datum/component/softcrit
	dupe_mode = COMPONENT_DUPE_UNIQUE

/datum/component/softcrit/Initialize(...)
	. = ..()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/softcrit/RegisterWithParent()
	RegisterSignal(parent, COMSIG_HUMAN_HANDLE_CRITICAL_CONDITION, PROC_REF(on_handle_critical_condition))
	RegisterSignal(parent, SIGNAL_ADDTRAIT(TRAIT_HEALTH_CRIT), PROC_REF(on_health_crit_trait_gain))
	RegisterSignal(parent, SIGNAL_REMOVETRAIT(TRAIT_HEALTH_CRIT), PROC_REF(on_health_crit_trait_loss))

/datum/component/softcrit/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_HUMAN_HANDLE_CRITICAL_CONDITION)
	UnregisterSignal(parent, SIGNAL_ADDTRAIT(TRAIT_HEALTH_CRIT))
	UnregisterSignal(parent, SIGNAL_REMOVETRAIT(TRAIT_HEALTH_CRIT))

/datum/component/softcrit/proc/on_health_crit_trait_gain()
	SIGNAL_HANDLER
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent, COMSIG_LIVING_LIFE, PROC_REF(check_health))
	ADD_TRAIT(parent, TRAIT_FLOORED, TRAIT_HEALTH_CRIT)
	ADD_TRAIT(parent, TRAIT_HANDS_BLOCKED, TRAIT_HEALTH_CRIT)
	return

/datum/component/softcrit/proc/on_health_crit_trait_loss()
	SIGNAL_HANDLER
	UnregisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	UnregisterSignal(parent, COMSIG_LIVING_LIFE, PROC_REF(check_health))
	REMOVE_TRAIT(parent, TRAIT_FLOORED, TRAIT_HEALTH_CRIT)
	REMOVE_TRAIT(parent, TRAIT_HANDS_BLOCKED, TRAIT_HEALTH_CRIT)
	return

/datum/component/softcrit/proc/on_examine(atom/A, mob/user, list/examine_list)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/owner = parent
	if(owner.stat == CONSCIOUS)
		examine_list += span_warning("<B>[owner] с трудом держится в сознании.\n</B>")

/datum/component/softcrit/proc/on_handle_critical_condition()
	SIGNAL_HANDLER
	var/mob/living/carbon/human/owner = parent
	if(owner.health <= HEALTH_THRESHOLD_CRIT)
		ADD_TRAIT(src, TRAIT_HEALTH_CRIT, SOFTCRIT_REWORK_TRAIT)

/datum/component/softcrit/proc/check_health()
	SIGNAL_HANDLER
	var/mob/living/carbon/human/owner = parent
	if(owner.health > HEALTH_THRESHOLD_CRIT)
		REMOVE_TRAIT(owner, TRAIT_HEALTH_CRIT, SOFTCRIT_REWORK_TRAIT)
