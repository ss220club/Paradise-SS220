///Сердце - вырабатывают особое вещество (серпадрон) за глютамат натрия.
#define GAS_METH_HEART_COUNT 1

/obj/item/organ/internal/heart/serpentid
	name = "serpentid heart"
	actions_types = 		list(/datum/action/item_action/organ_action/use)
	action_icon = 			list(/datum/action/item_action/organ_action/use = 'modular_ss220/species/icons/mob/human_races/organs.dmi')
	action_icon_state = 	list(/datum/action/item_action/organ_action/use = "gas_abilities")
	chemical_id = SERPENTID_CHEM_REAGENT_ID
	radial_additive_state = "gas_heart"
	var/meph_injected = FALSE
	var/inject_drug_id = "serpadrone"
	var/inject_drug = /datum/reagent/mephedrone

	var/decay_rate = 5
	var/decay_recovery = BASIC_RECOVER_VALUE
	var/organ_process_toxins = 0.1

/obj/item/organ/internal/heart/serpentid/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/organ_decay, decay_rate, decay_recovery)
	AddComponent(/datum/component/organ_toxin_damage, organ_process_toxins)

/obj/item/organ/internal/heart/serpentid/insert(mob/living/carbon/M, special = 0, dont_remove_slot = 0)
	. = .. ()
	buttons_resort()

/obj/item/organ/internal/heart/serpentid/remove(mob/living/carbon/M, special = 0)
	. = .. ()
	buttons_resort()

/obj/item/organ/internal/heart/serpentid/ui_action_click()
	open_actions(owner)

/obj/item/organ/internal/heart/serpentid/switch_mode(var/force_off = FALSE)
	.=..()
	if(owner.get_chemical_value(chemical_id) >= GAS_ORGAN_CHEMISTRY_HEART)
		var/mob/living/carbon/human/human_owner = owner
		var/datum/reagent/chem = owner.get_chemical_path(chemical_id)
		chem.holder.remove_reagent(chemical_id, GAS_ORGAN_CHEMISTRY_HEART)
		human_owner.reagents.add_reagent(inject_drug_id, GAS_METH_HEART_COUNT)
		meph_injected = TRUE
