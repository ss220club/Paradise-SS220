#define BASIC_RECOVER_VALUE 0.02
#define BASIC_DECAY_VALUE 1
#define TOX_ORGANS_PROCESS 1

#define SERPENTID_STAMINA_DAMAGE_ON_MEPH 50
#define GAS_METH_HEART_COUNT 1

/obj/item/organ/internal
	var/decayable = FALSE
	var/recoverable = FALSE
	var/decay_rate = BASIC_DECAY_VALUE
	var/recover_rate = BASIC_RECOVER_VALUE
	var/is_destroying = FALSE
	var/chemical_consuption = 0
	var/sensitive = FALSE
	var/can_chem_process = FALSE
	var/chemical_id = ""
	var/organ_process_toxins = TOX_ORGANS_PROCESS

/obj/item/organ/internal/process()
	if(is_destroying)
		receive_damage(decay_rate, 1)
	if((damage <= (max_damage/4)) && (damage > 0) && !is_destroying && recoverable)
		heal_internal_damage(recover_rate, FALSE)
	if (decayable)
		var/is_dead = (owner.stat == DEAD)
		var/is_no_owner = isnull(owner)
		is_destroying = (is_dead || is_no_owner)

		if(owner.get_damage_amount(TOX) > 0)
			var/list/organs = owner.internal_organs
			var/obj/item/organ/internal/liver/target_liver = null
			var/obj/item/organ/internal/kidneys/target_kidney = null
			for(var/obj/item/organ/internal/O in organs)
				if (istype(O, /obj/item/organ/internal/liver))
					target_liver = O
				if (istype(O, /obj/item/organ/internal/kidneys))
					target_kidney = O
			if (src == target_kidney)
				receive_damage(owner.get_damage_amount(TOX) * organ_process_toxins, 1)
				owner.adjustToxLoss(-1 * owner.get_damage_amount(TOX) * organ_process_toxins)
			else if (target_kidney.status == ORGAN_DEAD && src == target_liver)
				receive_damage(owner.get_damage_amount(TOX) * organ_process_toxins, 1)
				owner.adjustToxLoss(-1 * owner.get_damage_amount(TOX) * organ_process_toxins)
			else if (target_liver.status == ORGAN_DEAD && target_kidney.status == ORGAN_DEAD)
				receive_damage(owner.get_damage_amount(TOX) * organ_process_toxins, 1)
	if (can_chem_process)
		chems_process()
	. = ..()

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
	var/chemical_volume = owner.get_chemical_value(chemical_id)
	var/datum/reagent/chemical = owner.get_chemical_path(chemical_id)
	if (chemical_volume < chemical_consuption)
		//Если коилчества недостаточно - выключить режим
		switch_mode(force_off = TRUE)
	else
		if(!isnull(chemical) && chemical_consuption > 0)
			//Убрать количество глутамата из тела
			chemical.holder.remove_reagent(chemical_id, chemical_consuption)

/obj/item/organ/internal/proc/switch_mode(var/force_off = FALSE)
	return

/datum/action/item_action/organ_action/toggle/serpentid_actions
	name = "Serpentid actions"
	desc = "Allow you to activate serpentid features."
	button_overlay_icon = 'icons/obj/items_cyborg.dmi'
	button_overlay_icon_state = "knife"

/obj/item/organ/internal/proc/check_actions(mob/user)
	return (owner && owner == user && owner.stat != DEAD && (src in owner.internal_organs))

/obj/item/organ/internal/proc/open_actions(mob/user)
	var/list/choices = list()
	var/list/organs_list = list()
	for(var/obj/item/organ/internal/O in owner.internal_organs)
		if (O.actions_types.len > 0 && !istype(O, /obj/item/organ/internal/cyberimp))
			organs_list += O
	for(var/obj/I in organs_list)
		choices["[I.name]"] = image(icon = I.icon, icon_state = I.icon_state)
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

/obj/item/organ/internal/proc/buttons_resort()
	var/list/organs_list = list()
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

// ============ Органы внутренние ============
///почки - базовые c добавлением дикея, вырабатывают энзимы, которые позволяют ГБС скрываться
/obj/item/organ/internal/kidneys/serpentid
	name = "serpentid kidneys"
	icon = 'icons/obj/species_organs/unathi.dmi'
	decayable = TRUE
	recoverable = TRUE
	decay_rate = 4
	actions_types = list(/datum/action/item_action/organ_action/use)
	can_chem_process = TRUE
	chemical_id = SERPENTID_CHEM_REAGENT_ID
	organ_process_toxins = 0.01

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


///печень - вырабатывает глутамат натрия из нутриентов
/obj/item/organ/internal/liver/serpentid
	name = "serpentid liver"
	icon = 'icons/obj/species_organs/unathi.dmi'
	desc = "A large looking liver."
	alcohol_intensity = 2
	decayable = TRUE
	recoverable = TRUE
	decay_rate = 4
	chemical_id = SERPENTID_CHEM_REAGENT_ID
	organ_process_toxins = 0.05
	var/max_value = GAS_ORGAN_CHEMISTRY_MAX

/obj/item/organ/internal/liver/serpentid/on_life()
	. = ..()
	max_value = clamp((((max_damage - damage)/max_damage)*100),0,GAS_ORGAN_CHEMISTRY_MAX)
	if (owner.get_chemical_value(chemical_id) < max_value)
		for(var/datum/reagent/consumable/chemical in owner.reagents.reagent_list)
			if(!isnull(chemical))
				chemical.holder.remove_reagent(chemical.id, SERPENTID_CHEM_MULT_CONSUPTION*chemical.nutriment_factor)
				owner.reagents.add_reagent(chemical_id, SERPENTID_CHEM_MULT_PRODUCTION*chemical.nutriment_factor)
	else
		var/excess_value = owner.get_chemical_value(chemical_id) - max_value
		var/datum/reagent/chem = owner.get_chemical_path(chemical_id)
		chem.holder.remove_reagent(chemical_id, excess_value)

///Легкие - вырабатывают сальбутамол при наличии глутамата натрия
/obj/item/organ/internal/lungs/serpentid
	name = "serpentid lungs"
	icon = 'icons/obj/species_organs/unathi.dmi'
	organ_datums = list(/datum/organ/lungs/serpentid)
	decayable = TRUE
	recoverable = TRUE
	decay_rate = 3
	chemical_id = SERPENTID_CHEM_REAGENT_ID
	organ_process_toxins = 0.25
	chemical_consuption = 1
	var/obj/item/tank/internals/oxygen/serpentid_vault = new /obj/item/tank/internals/oxygen/serpentid_vault

/obj/item/tank/internals/oxygen/serpentid_vault
	volume = 5

/datum/organ/lungs/serpentid
	safe_oxygen_min = 21
	safe_toxins_max = 5

	cold_level_1_threshold = SERPENTID_COLD_THRESHOLD_LEVEL_BASE
	cold_level_2_threshold = SERPENTID_COLD_THRESHOLD_LEVEL_BASE - SERPENTID_COLD_THRESHOLD_LEVEL_DOWN
	cold_level_3_threshold = SERPENTID_COLD_THRESHOLD_LEVEL_BASE - 2*SERPENTID_COLD_THRESHOLD_LEVEL_DOWN

	heat_level_1_threshold = SERPENTID_HEAT_THRESHOLD_LEVEL_BASE
	heat_level_2_threshold = SERPENTID_HEAT_THRESHOLD_LEVEL_BASE + SERPENTID_HEAT_THRESHOLD_LEVEL_UP
	heat_level_3_threshold = SERPENTID_HEAT_THRESHOLD_LEVEL_BASE + 2*SERPENTID_HEAT_THRESHOLD_LEVEL_UP

/datum/organ/lungs/serpentid/proc/in_danger_zone(datum/gas_mixture/breath)

	//Получение данных
	var/ox_pressure = (breath ? breath.get_breath_partial_pressure(breath.oxygen()) : 0)
	var/n2_pressure = (breath ? breath.get_breath_partial_pressure(breath.nitrogen()) : 0)
	var/tox_pressure = (breath ? breath.get_breath_partial_pressure(breath.toxins()) : 0)
	var/co2_pressure = (breath ? breath.get_breath_partial_pressure(breath.carbon_dioxide()) : 0)
	var/sa_pressure = (breath ? breath.get_breath_partial_pressure(breath.sleeping_agent()) : 0)

	// Проверка кислорода
	var/O2_above_max = (safe_oxygen_max == 0? FALSE : ox_pressure > safe_oxygen_max)
	var/O2_below_min = (safe_oxygen_min == 0? FALSE : ox_pressure < safe_oxygen_min)
	var/O2_pp = O2_above_max || O2_below_min

	// Проверка азота
	var/N2_above_max = (safe_nitro_max == 0? FALSE : n2_pressure > safe_nitro_max)
	var/N2_below_min = (safe_nitro_min == 0? FALSE : n2_pressure < safe_nitro_min)
	var/N2_pp = N2_above_max || N2_below_min

	// Проверка токсинов
	var/Toxins_above_max = (safe_toxins_max == 0? FALSE : tox_pressure > safe_toxins_max)
	var/Toxins_below_min = (safe_toxins_min == 0? FALSE : tox_pressure < safe_toxins_min)
	var/Toxins_pp = Toxins_above_max || Toxins_below_min

	// Проверка углекислого газа
	var/CO2_above_max = (safe_co2_max == 0? FALSE : co2_pressure > safe_co2_max)
	var/CO2_below_min = (safe_co2_min == 0? FALSE : co2_pressure < safe_co2_min)
	var/CO2_pp = CO2_above_max || CO2_below_min

	// Проверка сонного газа
	var/SA_pp = (SA_para_min == 0? FALSE : sa_pressure > SA_para_min)

	// Общая проверка зоны опасности
	var/danger_zone = O2_pp || N2_pp || Toxins_pp || CO2_pp || SA_pp

	return danger_zone

/obj/item/organ/internal/lungs/serpentid/proc/get_turf_air(turf/T)
	RETURN_TYPE(/datum/gas_mixture)
	// This is one of two intended places to call this otherwise-unsafe proc.
	var/datum/gas_mixture/bound_to_turf/air = T.private_unsafe_get_air()
	if(air.lastread < SSair.times_fired)
		var/list/milla_tile = new/list(MILLA_TILE_SIZE)
		get_tile_atmos(T, milla_tile)
		air.copy_from_milla(milla_tile)
		air.lastread = SSair.times_fired
		air.readonly = null
		air.dirty = FALSE
	if(!air.synchronized)
		air.synchronized = TRUE
		SSair.bound_mixtures += air
	return air

/obj/item/organ/internal/lungs/serpentid/on_life()
	.=..()
	var/turf/T = get_turf(owner)
	var/datum/gas_mixture/environment = get_turf_air(T)
	var/datum/gas_mixture/breath
	breath = owner.serpen_lugns(BREATH_VOLUME)
	if(!breath)
		var/breath_moles = 0
		if(environment)
			breath_moles = environment.total_moles()*BREATH_PERCENTAGE
		breath = environment.get_by_amount(breath_moles)
	breath_secretion(breath)

#define QUANTIZE(variable)		(round(variable, 0.0001))
/datum/gas_mixture/proc/get_by_amount(amount)

	var/sum = total_moles()
	amount = min(amount, sum) //Can not take more air than tile has!
	if(amount <= 0)
		return null

	var/datum/gas_mixture/atmo_value = new

	atmo_value.private_oxygen = QUANTIZE((private_oxygen / sum) * amount)
	atmo_value.private_nitrogen = QUANTIZE((private_nitrogen/  sum) * amount)
	atmo_value.private_carbon_dioxide = QUANTIZE((private_carbon_dioxide / sum) * amount)
	atmo_value.private_toxins = QUANTIZE((private_toxins / sum) * amount)
	atmo_value.private_sleeping_agent = QUANTIZE((private_sleeping_agent / sum) * amount)
	atmo_value.private_agent_b = QUANTIZE((private_agent_b / sum) * amount)
	atmo_value.private_temperature = private_temperature

	return atmo_value
#undef QUANTIZE

/obj/item/organ/internal/lungs/serpentid/proc/breath_secretion(datum/gas_mixture/breath)
	var/can_secretion = owner.get_chemical_value(chemical_id) > chemical_consuption
	var/danger_state = owner.getOxyLoss() > 0
	var/datum/organ/lungs/serpentid/lung_data = organ_datums[organ_tag]
	var/danger_air = lung_data.in_danger_zone(breath)
	var/datum/reagent/chemical = owner.get_chemical_path(chemical_id)
	if (danger_air)
		if (!owner.internal)
			owner.internal = serpentid_vault
		var/inner_oxygen_value = serpentid_vault.volume < 100
		if(inner_oxygen_value && serpentid_vault && can_secretion)
			serpentid_vault.air_contents.set_oxygen((ONE_ATMOSPHERE) * serpentid_vault.volume / (R_IDEAL_GAS_EQUATION * T20C))
			chemical.holder.remove_reagent(chemical_id, chemical_consuption)
	else
		if (owner.internal)
			owner.internal = null

	if(danger_state && can_secretion)
		var/mob/living/carbon/human/human_owner = owner
		human_owner.reagents.add_reagent("salbutamol", chemical_consuption)
		chemical.holder.remove_reagent(chemical_id, chemical_consuption)

/mob/living/carbon/breathe(datum/gas_mixture/environment)
	var/obj/item/organ/internal/lungs/lugns = null
	for(var/obj/item/organ/internal/O in src.internal_organs)
		if (istype(O, /obj/item/organ/internal/lungs))
			lugns = O
	if(istype(lugns, /obj/item/organ/internal/lungs/serpentid))
		var/obj/item/organ/internal/lungs/serpentid/serpentid_lungs = lugns
		if (src.internal == serpentid_lungs.serpentid_vault)
			return
	. = ..()

/mob/living/carbon/human/proc/serpen_lugns(volume_needed) //making this call the parent would be far too complicated
	if(internal) //check for hud updates every time this is called
		return internal.remove_air_volume(volume_needed) //returns the valid air

	return null

///Сердце - вырабатывают мефедрон при активации, но за каждый тик сжирает стамину ГБС, получает урон при ударе электричеством
/obj/item/organ/internal/heart/serpentid
	name = "serpentid heart"
	decayable = TRUE
	recoverable = TRUE
	decay_rate = 5
	actions_types = list(/datum/action/item_action/organ_action/use)
	chemical_id = SERPENTID_CHEM_REAGENT_ID
	organ_process_toxins = 1
	var/meph_injected = FALSE
	var/inject_drug_id = "mephedrone"
	var/inject_drug = /datum/reagent/mephedrone

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
	var/mob/living/heart_owner = owner
	if(owner.get_chemical_value(chemical_id) >= GAS_ORGAN_CHEMISTRY_HEART && heart_owner.get_damage_amount(STAMINA) <= SERPENTID_STAMINA_DAMAGE_ON_MEPH)
		var/mob/living/carbon/human/human_owner = owner
		var/datum/reagent/chem = owner.get_chemical_path(chemical_id)
		var/datum/reagent/meph_handler = inject_drug
		chem.holder.remove_reagent(chemical_id, GAS_ORGAN_CHEMISTRY_HEART)
		human_owner.reagents.add_reagent(inject_drug_id, GAS_METH_HEART_COUNT + meph_handler.overdose_threshold)
		heart_owner.apply_damage(SERPENTID_STAMINA_DAMAGE_ON_MEPH, STAMINA)
		meph_injected = TRUE

/obj/item/organ/internal/heart/serpentid/on_life()
	. = ..()
	var/datum/reagent/meph_handler = inject_drug
	var/overdose_threshold = meph_handler.overdose_threshold
	var/datum/reagent/meph_value = owner.get_chemical_value(inject_drug_id)
	if (meph_injected)
		if(meph_value <= overdose_threshold)
			meph_handler = owner.get_chemical_path(inject_drug_id)
			meph_handler.holder.remove_reagent(inject_drug_id, overdose_threshold)
			meph_injected = FALSE

/obj/item/organ/internal/ears/serpentid
	name = "serpentid ears"
	decayable = TRUE
	recoverable = TRUE
	decay_rate = 2
	organ_process_toxins = 0.25

/obj/item/organ/internal/ears/serpentid/insert(mob/living/carbon/M, special = 0, dont_remove_slot = 0)
	. = .. ()
	buttons_resort()

/obj/item/organ/internal/ears/serpentid/remove(mob/living/carbon/M, special = 0)
	. = .. ()
	buttons_resort()

/obj/item/organ/internal/ears/serpentid/on_life()
	.=..()
	if (prob((max_damage - damage)/max_damage) * 100)
		sense_creatures()

/obj/item/organ/internal/ears/serpentid/proc/sense_creatures()
	for(var/mob/living/creature in range(9, owner))
		var/last_movement_timer = world.time - creature.l_move_time
		if(creature == owner || creature.stat == DEAD || last_movement_timer > 50)
			continue
		new /obj/effect/temp_visual/sonar_ping(owner.loc, owner, creature)

/obj/item/organ/internal/eyes/serpentid
	name = "serpentid eyes"
	icon = 'modular_ss220/species/icons/obj/surgery.dmi'
	icon_state = "crystal-eyes"
	light_color = "#1C1C00"
	decayable = TRUE
	recoverable = TRUE
	decay_rate = 1
	see_in_dark = 2
	flash_protect = FLASH_PROTECTION_EXTRA_SENSITIVE
	actions_types = list(/datum/action/item_action/organ_action/use)
	organ_process_toxins = 0.35
	chemical_id = SERPENTID_CHEM_REAGENT_ID
	var/eye_shielded = FALSE

/obj/item/organ/internal/eyes/serpentid/generate_icon(mob/living/carbon/human/HA)
	var/mob/living/carbon/human/H = HA
	if(!istype(H))
		H = owner
	var/icon/eyes_icon = new /icon('modular_ss220/species/icons/mob/human_races/serpentid_eyes.dmi', H.dna.species.eyes)
	eyes_icon.Blend(eye_color, ICON_ADD)

	return eyes_icon

/obj/item/organ/internal/eyes/serpentid/ui_action_click()
	open_actions(owner)

/obj/item/organ/internal/eyes/serpentid/switch_mode(var/force_off = FALSE)
	vision_flags = initial(vision_flags)
	if(eye_shielded)
		flash_protect = FLASH_PROTECTION_EXTRA_SENSITIVE
		tint = FLASH_PROTECTION_NONE
		owner.update_sight()
		eye_shielded = FALSE
	else
		flash_protect = FLASH_PROTECTION_WELDER
		tint = FLASH_PROTECTION_WELDER
		owner.update_sight()
		eye_shielded = TRUE

/obj/item/organ/internal/eyes/serpentid/on_life()
	. = ..()
	if(!isnull(owner))
		var/mob/mob = owner
		mob.update_client_colour(time = 10)

/obj/item/organ/internal/eyes/serpentid/get_colourmatrix() //Returns a special colour matrix
	var/chem_value = (owner.get_chemical_value(chemical_id) + GAS_ORGAN_CHEMISTRY_MAX/2)/GAS_ORGAN_CHEMISTRY_MAX
	var/vision_chem = clamp(chem_value, SERPENTID_EYES_LOW_VISIBLE_VALUE, SERPENTID_EYES_MAX_VISIBLE_VALUE)
	var/vision_concentration = (1 - vision_chem/SERPENTID_EYES_MAX_VISIBLE_VALUE)*SERPENTID_EYES_LOW_VISIBLE_VALUE

	var/k = 1
	vision_concentration = SERPENTID_EYES_LOW_VISIBLE_VALUE * (1 - chem_value**k)
	var/vision_adjust = clamp(vision_concentration, 0, SERPENTID_EYES_LOW_VISIBLE_VALUE/2)

	var/vision_matrix = list(vision_chem, vision_adjust, vision_adjust,\
		vision_adjust, vision_chem, vision_adjust,\
		vision_adjust, vision_adjust, vision_chem)
	return vision_matrix

/obj/item/organ/internal/brain/serpentid
	name = "serpentid brain"
	icon = 'modular_ss220/species/icons/obj/surgery.dmi'
	icon_state = "crystal-brain"
