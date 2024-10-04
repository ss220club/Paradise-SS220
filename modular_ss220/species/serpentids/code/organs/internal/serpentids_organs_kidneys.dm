///почки - базовые c добавлением дикея, вырабатывают энзимы, которые позволяют ГБС скрываться
/obj/item/organ/internal/kidneys/serpentid
	name = "serpentid kidneys"
	icon = 'icons/obj/species_organs/unathi.dmi'
	actions_types = 		list(/datum/action/item_action/organ_action/toggle)
	action_icon = 			list(/datum/action/item_action/organ_action/toggle = 'modular_ss220/species/serpentids/icons/organs.dmi')
	action_icon_state = 	list(/datum/action/item_action/organ_action/toggle = "gas_stealth")
	can_chem_process = TRUE
	chemical_id = SERPENTID_CHEM_REAGENT_ID
	var/decay_rate = 4
	var/decay_recovery = BASIC_RECOVER_VALUE
	var/organ_process_toxins = 0.1
	var/cloak_engaged = FALSE

/obj/item/organ/internal/kidneys/serpentid/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/organ_decay, decay_rate, decay_recovery)
	AddComponent(/datum/component/organ_toxin_damage, organ_process_toxins)

/obj/item/organ/internal/kidneys/serpentid/ui_action_click()
	switch_mode()

/obj/item/organ/internal/kidneys/serpentid/on_life()
	. = .. ()
	if((owner.m_intent != MOVE_INTENT_RUN || owner.body_position == LYING_DOWN || (world.time - owner.last_movement) >= 10) && (!owner.stat && (owner.mobility_flags & MOBILITY_STAND) && !owner.restrained() && cloak_engaged))
		if(owner.invisibility != INVISIBILITY_LEVEL_TWO)
			owner.alpha -= 51
	else
		owner.reset_visibility()
		owner.alpha = 255
	if(owner.alpha == 0)
		owner.make_invisible()

/obj/item/organ/internal/kidneys/serpentid/switch_mode(var/force_off = FALSE)
	.=..()
	if(!force_off && owner.get_chemical_value(chemical_id) >= GAS_ORGAN_CHEMISTRY_KIDNEYS && !cloak_engaged)
		cloak_engaged = TRUE
		chemical_consuption = GAS_ORGAN_CHEMISTRY_KIDNEYS
	else
		cloak_engaged = FALSE
		chemical_consuption = 0
	radial_additive_state = "gas_cloak_[cloak_engaged]"
