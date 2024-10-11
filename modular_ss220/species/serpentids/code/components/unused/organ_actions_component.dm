/*
Компонент на органы, который бы позволяли объединять многочисленные действия органов в одну радиальную кнопку
*/

#define COMSIG_ORGAN_GROUP_ACTION_CALL "open_actions"
#define COMSIG_ORGAN_GROUP_ACTION_RESORT "resort_buttons"

#define COMSIG_ORGAN_GROUP_ACTION_ICON "get_return_icon"
#define COMSIG_ORGAN_GROUP_ACTION_STATE "get_return_state"
	#define ORGAN_GROUP_ACTION_ICON (1 << 0)
	#define ORGAN_GROUP_ACTION_STATE (1 << 0)

/datum/component/organ_action
	var/obj/item/organ/internal/organ
	var/radial_additive_state
	var/radial_additive_icon

/datum/component/organ_action/Initialize(caller_organ, state, icon)
	..()
	organ = caller_organ
	radial_additive_state = state
	radial_additive_icon = icon

/datum/component/organ_action/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ORGAN_GROUP_ACTION_CALL, PROC_REF(open_actions))
	RegisterSignal(parent, COMSIG_ORGAN_GROUP_ACTION_RESORT, PROC_REF(resort_buttons))
	RegisterSignal(parent, COMSIG_ORGAN_GROUP_ACTION_ICON, PROC_REF(get_return_icon))
	RegisterSignal(parent, COMSIG_ORGAN_GROUP_ACTION_STATE, PROC_REF(get_return_state))

/datum/component/organ_action/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_ORGAN_GROUP_ACTION_CALL)
	UnregisterSignal(parent, COMSIG_ORGAN_GROUP_ACTION_RESORT)
	UnregisterSignal(parent, COMSIG_ORGAN_GROUP_ACTION_ICON)
	UnregisterSignal(parent, COMSIG_ORGAN_GROUP_ACTION_STATE)

/datum/component/organ_action/proc/get_return_icon(datum/source, return_icon)
	SIGNAL_HANDLER

	return_icon = radial_additive_icon
	return ORGAN_GROUP_ACTION_ICON

/datum/component/organ_action/proc/get_return_state(datum/source, return_state)
	SIGNAL_HANDLER

	return_state = radial_additive_state
	return ORGAN_GROUP_ACTION_STATE


/datum/component/organ_action/proc/check_actions(mob/user)
	return (organ.owner && organ.owner == user && organ.owner.stat != DEAD && (organ in organ.owner.internal_organs))

//Прок, вызывается непосредственно в кнопке действия органа
/datum/component/organ_action/proc/open_actions(mob/user)
	var/list/choices = list()
	var/list/organs_list = list()
	for(var/obj/item/organ/internal/O in organ.owner.internal_organs)
		if(O.actions_types.len > 0 && !istype(O, /obj/item/organ/internal/cyberimp))
			organs_list += O

	for(var/obj/item/organ/internal/I in organs_list)
		var/datum/component/organ_action/return_state
		var/datum/component/organ_action/return_icon
		var/icon_override_returns = SEND_SIGNAL(user, COMSIG_ORGAN_GROUP_ACTION_ICON, return_icon)
		var/state_override_returns = SEND_SIGNAL(user, COMSIG_ORGAN_GROUP_ACTION_STATE, return_state)
		if((icon_override_returns & ORGAN_GROUP_ACTION_ICON) && (state_override_returns & ORGAN_GROUP_ACTION_STATE))
			choices["[I.name]"] = image(icon = return_icon.radial_additive_icon, icon_state = return_state.radial_additive_state)

	var/choice = show_radial_menu(user, user, choices, custom_check = CALLBACK(src, PROC_REF(check_actions), user))
	if(!check_actions(user))
		return

	var/obj/item/organ/internal/selected
	for(var/obj/item in organs_list)
		if(item.name == choice)
			selected = item
			break

	if(istype(selected) && (selected in organs_list))
		selected.switch_mode()

//Прок для ресортировки кнопок (убирает лишние дубли) (должен вызываться на insert/remove конкретного органа, чтобы не трогать остальные)
/datum/component/organ_action/proc/resort_buttons()
	SIGNAL_HANDLER

	var/list/organs_list = list()
	if(organ.owner)
		for(var/obj/item/organ/internal/O in organ.owner.internal_organs)
			if(O.actions_types.len > 0 && !istype(O, /obj/item/organ/internal/cyberimp))
				organs_list += O

		for(var/obj/item/organ/internal/O in organs_list)
			organs_list -= O
			for(var/obj/item/organ/internal/D in organs_list)
				var/datum/action/action_candidate = O.actions[1]
				if(D != O)
					if(action_candidate in organ.owner.actions)
						action_candidate.Remove(organ.owner)
				else
					if(!(action_candidate in organ.owner.actions))
						action_candidate.Grant(organ.owner)
				break

/obj/item/organ/internal/insert(mob/living/carbon/M, special = 0, dont_remove_slot = 0)
	. = .. ()
	SEND_SIGNAL(src, COMSIG_ORGAN_GROUP_ACTION_RESORT)

/obj/item/organ/internal/remove(mob/living/carbon/M, special = 0)
	. = .. ()
	SEND_SIGNAL(src, COMSIG_ORGAN_GROUP_ACTION_RESORT)

/obj/item/organ/internal/ui_action_click()
	SEND_SIGNAL(src, COMSIG_ORGAN_GROUP_ACTION_CALL, owner)

