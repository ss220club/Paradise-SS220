/// печень - вырабатывает глутамат натрия из нутриентов
/obj/item/organ/internal/liver/serpentid
	name = "chemical processor"
	icon = 'modular_ss220/species/serpentids/icons/organs.dmi'
	icon_state = "liver"
	desc = "A large looking liver with some storages."
	alcohol_intensity = 2
	var/max_value = SERPENTID_ORGAN_CHEMISTRY_MAX

/obj/item/organ/internal/liver/serpentid/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/organ_decay, 0.04, BASIC_RECOVER_VALUE)
	AddComponent(/datum/component/organ_toxin_damage, 0.1)

/obj/item/organ/internal/liver/serpentid/on_life()
	. = ..()
	max_value = clamp((((max_damage - damage)/max_damage)*100), 0, SERPENTID_ORGAN_CHEMISTRY_MAX)
	if(!owner)
		return
	if(owner.get_chemical_value(SERPENTID_CHEM_REAGENT_ID) < max_value)
		for(var/datum/reagent/consumable/chemical in owner.reagents.reagent_list)
			if(!isnull(chemical))
				if(chemical.nutriment_factor > 0)
					chemical.holder.remove_reagent(chemical.id, SERPENTID_CHEM_MULT_CONSUPTION*chemical.nutriment_factor)
					owner.reagents.add_reagent(SERPENTID_CHEM_REAGENT_ID, SERPENTID_CHEM_MULT_PRODUCTION*chemical.nutriment_factor)
	else
		var/excess_value = owner.get_chemical_value(SERPENTID_CHEM_REAGENT_ID) - max_value
		var/datum/reagent/chem = owner?.get_chemical_path(SERPENTID_CHEM_REAGENT_ID)
		chem?.holder.remove_reagent(SERPENTID_CHEM_REAGENT_ID, excess_value)

