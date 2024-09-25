#define GAS_ORGAN_MULT_DAMAGE 0.1
#define GAS_ORGAN_MULT_RECOVER 0.02
#define BASIC_DECAY_VALUE 1
#define GAS_ORGAN_CHEMISTRY_EYES 0.75
#define GAS_ORGAN_CHEMISTRY_EARS 0.25
#define GAS_ORGAN_CHEMISTRY_HEART 25
#define GAS_ORGAN_CHEMISTRY_LUNGS 0.5
#define GAS_ORGAN_CHEMISTRY_KIDNEYS 0.6

#define SERPENTID_CHEM_MULT_CONSUPTION 0.75
#define SERPENTID_CHEM_MULT_PRODUCTION 0.6
#define STAMINA_DAMAGE_ON_MEPH 50

#define SERPENTID_TOX_LIVER_LOSS 0.01
#define SERPENTID_TOX_KIDNEY_LOSS 0.1
#define SERPENTID_TOX_ORGAN_LOSS 0.025

#define SERPENTID_EYES_LOW_VISIBLE_VALUE 0.33
#define SERPENTID_EYES_MAX_VISIBLE_VALUE 1

#define GAS_ORGAN_CHEMISTRY_MAX 100

/obj/item/organ/internal
	var/decayable = FALSE
	var/recoverable = FALSE
	var/decay_rate = BASIC_DECAY_VALUE
	var/is_destroying = FALSE
	var/chemical_consuption = 0
	var/sensitive = FALSE

/obj/item/organ/internal/process()
	if(is_destroying)
		receive_damage(decay_rate * GAS_ORGAN_MULT_DAMAGE, 1)
	if((damage <= (max_damage/4)) && (damage > 0) && !is_destroying && recoverable)
		heal_internal_damage(GAS_ORGAN_MULT_RECOVER, FALSE)
	. = ..()
	if (decayable)
		var/is_dead = (owner.stat == DEAD)
		var/is_no_owner = isnull(owner)
		is_destroying = (is_dead || is_no_owner)

		if(owner.get_damage_amount(TOX) > 0)
			var/list/organs = owner.internal_organs
			var/obj/item/organ/internal/liver/serpentid/target_liver = null
			var/obj/item/organ/internal/kidneys/serpentid/target_kidney = null
			for(var/obj/item/organ/internal/O in organs)
				if (istype(O, /obj/item/organ/internal/liver/serpentid))
					target_liver = O
				if (istype(O, /obj/item/organ/internal/kidneys/serpentid))
					target_kidney = O
			if (src == target_liver)
				receive_damage(owner.get_damage_amount(TOX) * SERPENTID_TOX_LIVER_LOSS, 1)
				owner.adjustToxLoss(-1 * owner.get_damage_amount(TOX) * SERPENTID_TOX_LIVER_LOSS)
			else if (target_liver.status == ORGAN_DEAD && src == target_kidney)
				receive_damage(owner.get_damage_amount(TOX) * SERPENTID_TOX_KIDNEY_LOSS, 1)
				owner.adjustToxLoss(-1 * owner.get_damage_amount(TOX) * SERPENTID_TOX_KIDNEY_LOSS)
			else if (target_liver.status == ORGAN_DEAD && target_kidney.status == ORGAN_DEAD)
				receive_damage(owner.get_damage_amount(TOX) * SERPENTID_TOX_ORGAN_LOSS, 1)
		chems_process()

/mob/living/carbon/human/proc/get_chemical_value(var/id)
	for(var/datum/reagent/R in src.reagents.reagent_list)
		if (R.id == id)
			return R.volume
	return 0

/mob/living/carbon/human/proc/get_chemical_path(var/id)
	for(var/datum/reagent/R in src.reagents.reagent_list)
		if (R.id == id)
			return R
	return null

/obj/item/organ/internal/proc/chems_process()
	if(isnull(owner))
		return TRUE
	var/chemical_volume = owner.get_chemical_value(SERPENTID_CHEM_REAGENT_ID)
	var/datum/reagent/chemical = owner.get_chemical_path(SERPENTID_CHEM_REAGENT_ID)
	if (chemical_volume < chemical_consuption)
		//Если коилчества недостаточно - выключить режим
		switch_mode(force_off = TRUE)
	else
		if(!isnull(chemical) && chemical_consuption > 0)
			//Убрать количество глутамата из тела
			chemical.holder.remove_reagent(SERPENTID_CHEM_REAGENT_ID, chemical_consuption)

/obj/item/organ/internal/proc/switch_mode(var/force_off = FALSE)
	return

/obj/item/organ/external
	var/carapice_state = SERPENTID_CARAPICE_MAX_STATE
	var/carapice_limb = FALSE
	var/can_change_visual = FALSE
	var/change_visual = FALSE
	var/alt_visual_icon = null

/obj/item/organ/external/proc/update_visual()
	if (can_change_visual && change_visual)
		icon_name = alt_visual_icon
	if (can_change_visual && !(change_visual))
		icon_name = initial(icon_name)
	owner.update_body()

/obj/item/organ/external/receive_damage(brute, burn, sharp, used_weapon = null, list/forbidden_limbs = list(), ignore_resists = FALSE, updating_health = TRUE)
	. = ..()
	if (carapice_limb)
		carapice_state -= brute
		if (carapice_state < SERPENTID_CARAPICE_BROKEN_STATE)
			fracture()
		for(var/obj/item/organ/internal/O in internal_organs)
			O.receive_damage(burn * ((SERPENTID_CARAPICE_MAX_STATE - carapice_state)/SERPENTID_CARAPICE_MAX_STATE))
		if (status & ORGAN_BROKEN)
			brute_mod = (100 + SERPENTID_CARAPICE_BROKEN_STATE - carapice_state)/100
		else
			brute_mod = 0.6
		burn_mod = brute_mod + 0.2
		if (carapice_state  < 0)
			carapice_state  = 0
		if ((status & ORGAN_BROKEN) && carapice_state  > SERPENTID_CARAPICE_BROKEN_STATE)
			mend_fracture()
		if (carapice_state  > SERPENTID_CARAPICE_MAX_STATE)
			carapice_state  = SERPENTID_CARAPICE_MAX_STATE
	return

