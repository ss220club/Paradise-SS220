///Сердце - вырабатывают особое вещество (серпадрон) за глютамат натрия.
#define GAS_METH_HEART_COUNT 1

/obj/item/organ/internal/heart/serpentid
	name = "serpentid heart"
	chemical_id = SERPENTID_CHEM_REAGENT_ID

	var/decay_rate = 5
	var/decay_recovery = BASIC_RECOVER_VALUE
	var/organ_process_toxins = 0.1

/obj/item/organ/internal/heart/serpentid/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/organ_decay, decay_rate, decay_recovery)
	AddComponent(/datum/component/organ_toxin_damage, organ_process_toxins)
	AddComponent(/datum/component/defib_heart, owner, chemical_id)

/*
Старый режим работы сердца - ввод серпадрона
/obj/item/organ/internal/heart/serpentid/switch_mode(var/force_off = FALSE)
	.=..()
	if(owner.get_chemical_value(chemical_id) >= GAS_ORGAN_CHEMISTRY_HEART)
		var/mob/living/carbon/human/human_owner = owner
		var/datum/reagent/chem = owner.get_chemical_path(chemical_id)
		chem.holder.remove_reagent(chemical_id, GAS_ORGAN_CHEMISTRY_HEART)
		human_owner.reagents.add_reagent(inject_drug_id, GAS_METH_HEART_COUNT)
		meph_injected = TRUE
*/
