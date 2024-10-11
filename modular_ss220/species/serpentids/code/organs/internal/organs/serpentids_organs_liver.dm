///печень - вырабатывает глутамат натрия из нутриентов
/obj/item/organ/internal/liver/serpentid
	name = "chemical processor"
	icon = 'modular_ss220/species/serpentids/icons/organs.dmi'
	icon_state = "liver0"
	desc = "A large looking liver with some storages."
	alcohol_intensity = 2
	var/chemical_id = SERPENTID_CHEM_REAGENT_ID
	var/max_value = GAS_ORGAN_CHEMISTRY_MAX
	var/decay_rate = 4
	var/decay_recovery = BASIC_RECOVER_VALUE
	var/organ_process_toxins = 0.05

/obj/item/organ/internal/liver/serpentid/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/organ_decay, decay_rate, decay_recovery)
	AddComponent(/datum/component/organ_toxin_damage, organ_process_toxins)

/obj/item/organ/internal/liver/serpentid/on_life()
	. = ..()
	max_value = clamp((((max_damage - damage)/max_damage)*100),0,GAS_ORGAN_CHEMISTRY_MAX)
	if(owner.get_chemical_value(chemical_id) < max_value)
		for(var/datum/reagent/consumable/chemical in owner.reagents.reagent_list)
			if(!isnull(chemical))
				if(chemical.nutriment_factor > 0)
					chemical.holder.remove_reagent(chemical.id, SERPENTID_CHEM_MULT_CONSUPTION*chemical.nutriment_factor)
					owner.reagents.add_reagent(chemical_id, SERPENTID_CHEM_MULT_PRODUCTION*chemical.nutriment_factor)
	else
		var/excess_value = owner.get_chemical_value(chemical_id) - max_value
		var/datum/reagent/chem = owner.get_chemical_path(chemical_id)
		chem.holder.remove_reagent(chemical_id, excess_value)

