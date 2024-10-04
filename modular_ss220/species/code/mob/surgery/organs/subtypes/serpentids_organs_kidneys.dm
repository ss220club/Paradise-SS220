///почки - базовые c добавлением дикея, вырабатывают энзимы, которые позволяют ГБС скрываться
/obj/item/organ/internal/kidneys/serpentid
	name = "serpentid kidneys"
	icon = 'icons/obj/species_organs/unathi.dmi'
	actions_types = 		list(/datum/action/item_action/organ_action/toggle)
	action_icon = 			list(/datum/action/item_action/organ_action/toggle = 'modular_ss220/species/icons/mob/human_races/organs.dmi')
	action_icon_state = 	list(/datum/action/item_action/organ_action/toggle = "gas_abilities")
	can_chem_process = TRUE
	chemical_id = SERPENTID_CHEM_REAGENT_ID
	radial_additive_state = "gas_stealth"
	var/decay_rate = 4
	var/decay_recovery = BASIC_RECOVER_VALUE
	var/organ_process_toxins = 0.1

/obj/item/organ/internal/kidneys/serpentid/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/organ_decay, decay_rate, decay_recovery)
	AddComponent(/datum/component/organ_toxin_damage, organ_process_toxins)

/obj/item/organ/internal/kidneys/serpentid/insert(mob/living/carbon/M, special = 0, dont_remove_slot = 0)
	. = .. ()
	buttons_resort()

/obj/item/organ/internal/kidneys/serpentid/remove(mob/living/carbon/M, special = 0)
	. = .. ()
	buttons_resort()

/obj/item/organ/internal/kidneys/serpentid/ui_action_click()
	open_actions(owner)

/obj/item/organ/internal/kidneys/serpentid/switch_mode(var/force_off = FALSE)
	.=..()
	var/datum/species/serpentid/spiece = owner.dna.species
	if (istype(spiece, /datum/species/serpentid))
		if(!force_off && owner.get_chemical_value(chemical_id) >= GAS_ORGAN_CHEMISTRY_KIDNEYS && !spiece.cloak_engaged)
			spiece.cloak_engaged = TRUE
			chemical_consuption = GAS_ORGAN_CHEMISTRY_KIDNEYS
		else
			spiece.cloak_engaged = FALSE
			chemical_consuption = 0
		radial_additive_state = "gas_cloak_[spiece.cloak_engaged]"
