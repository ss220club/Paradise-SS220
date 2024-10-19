//Уши серпентидов позволяют постоянно сканировать окружение в поисках существ в зависимости от их состояния
/obj/item/organ/internal/ears/serpentid
	name = "acoustic sensor"
	icon = 'modular_ss220/species/serpentids/icons/organs.dmi'
	icon_state = "ears"
	desc = "An organ that can sense vibrations."
	actions_types = 		list(/datum/action/item_action/organ_action/toggle/gas)
	action_icon = 			list(/datum/action/item_action/organ_action/toggle/gas = 'modular_ss220/species/serpentids/icons/organs.dmi')
	action_icon_state = 	list(/datum/action/item_action/organ_action/toggle/gas = "gas_abilities")
	var/decay_rate = 0.2
	var/decay_recovery = BASIC_RECOVER_VALUE
	var/organ_process_toxins = 0.05
	var/chemical_consuption = GAS_ORGAN_CHEMISTRY_EARS
	var/chemical_id = SERPENTID_CHEM_REAGENT_ID
	var/active = FALSE
	radial_action_state = "gas_hear"
	radial_action_icon = 'modular_ss220/species/serpentids/icons/organs.dmi'

/obj/item/organ/internal/ears/serpentid/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/organ_decay, decay_rate, decay_recovery)
	AddComponent(/datum/component/organ_toxin_damage, organ_process_toxins)
	AddComponent(/datum/component/chemistry_organ, chemical_id)
	AddComponent(/datum/component/organ_action, caller_organ = src, state = radial_action_state, icon = radial_action_icon)

/obj/item/organ/internal/ears/serpentid/on_life()
	.=..()
	SEND_SIGNAL(src, COMSIG_ORGAN_CHEM_CALL, chemical_consuption)
	if(chemical_consuption <= owner.get_chemical_value(chemical_id) && active)
		if(prob(((max_damage - damage)/max_damage) * 100))
			sense_creatures()

/obj/item/organ/internal/ears/serpentid/switch_mode(force_off = FALSE)
	.=..()
	if(!force_off && owner.get_chemical_value(chemical_id) >= chemical_consuption && !(status & ORGAN_DEAD))
		active = TRUE
		chemical_consuption = initial(chemical_consuption)
	else
		active = FALSE
		chemical_consuption = 0

/obj/item/organ/internal/ears/serpentid/proc/sense_creatures()
	var/last_movement_threshold = 5 SECONDS
	for(var/mob/living/creature in range(9, owner))
		var/last_movement_timer = world.time - creature.l_move_time
		if(creature == owner || creature.stat == DEAD || last_movement_timer > last_movement_threshold)
			continue
		new /obj/effect/temp_visual/sonar_ping(owner.loc, owner, creature)
