/*
Расширение на органы, который бы позволяли объединять многочисленные действия органов в одну радиальную кнопку
*/

/obj/item/organ/internal
	var/radial_additive_state = ""
	var/radial_additive_icon = 'modular_ss220/species/icons/mob/human_races/organs.dmi'

/obj/item/organ/internal/proc/check_actions(mob/user)
	return (owner && owner == user && owner.stat != DEAD && (src in owner.internal_organs))

//Прок, вызывается непосредственно в кнопке действия органа
/obj/item/organ/internal/proc/open_actions(mob/user)
	var/list/choices = list()
	var/list/organs_list = list()
	for(var/obj/item/organ/internal/O in owner.internal_organs)
		if (O.actions_types.len > 0 && !istype(O, /obj/item/organ/internal/cyberimp))
			organs_list += O
	for(var/obj/item/organ/internal/I in organs_list)
		choices["[I.name]"] = image(icon = radial_additive_icon, icon_state = I.radial_additive_state)
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
/obj/item/organ/internal/proc/buttons_resort()
	var/list/organs_list = list()
	if (owner)
		for(var/obj/item/organ/internal/O in owner.internal_organs)
			if (O.actions_types.len > 0 && !istype(O, /obj/item/organ/internal/cyberimp))
				organs_list += O

		for(var/obj/item/organ/internal/O in organs_list)
			organs_list -= O
			for(var/obj/item/organ/internal/D in organs_list)
				var/datum/action/action_candidate = O.actions[1]
				if (D != O)
					if (action_candidate in owner.actions)
						action_candidate.Remove(owner)
				else
					if (!(action_candidate in owner.actions))
						action_candidate.Grant(owner)
				break
