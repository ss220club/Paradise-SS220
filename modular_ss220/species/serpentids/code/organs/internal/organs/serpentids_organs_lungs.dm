///Легкие - вырабатывают сальбутамол при наличии глутамата натрия, имеют собственный мешок, из которого дышат, мешок заполняется в безопасной среде
#define SERPENTID_COLD_THRESHOLD_LEVEL_BASE 100
#define SERPENTID_COLD_THRESHOLD_LEVEL_DOWN 40
#define SERPENTID_HEAT_THRESHOLD_LEVEL_BASE 350
#define SERPENTID_HEAT_THRESHOLD_LEVEL_UP 60

/obj/item/organ/internal/lungs/serpentid
	name = "thacheal bag"
	icon = 'icons/obj/species_organs/unathi.dmi'
	organ_datums = list(/datum/organ/lungs/serpentid)
	desc = "A large looking lugns with big breating bag."
	actions_types = 		list(/datum/action/item_action/organ_action/toggle/gas)
	action_icon = 			list(/datum/action/item_action/organ_action/toggle/gas = 'modular_ss220/species/serpentids/icons/organs.dmi')
	action_icon_state = 	list(/datum/action/item_action/organ_action/toggle/gas = "gas_abilities")
	var/chemical_id = SERPENTID_CHEM_REAGENT_ID
	var/chemical_consuption = 1
	var/obj/item/tank/internals/oxygen/serpentid_vault = new /obj/item/tank/internals/oxygen/serpentid_vault_tank
	var/decay_rate = 0.3
	var/decay_recovery = BASIC_RECOVER_VALUE
	var/organ_process_toxins = 0.05
	var/chem_to_oxy_mult = 0.1
	var/danger_air = FALSE
	var/hand_active = FALSE
	radial_action_state = "ballon"
	radial_action_icon = 'modular_ss220/species/serpentids/icons/organs.dmi'

/obj/item/organ/internal/lungs/serpentid/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/organ_decay, decay_rate, decay_recovery)
	AddComponent(/datum/component/organ_toxin_damage, organ_process_toxins)
	AddComponent(/datum/component/organ_action, caller_organ = src, state = radial_action_state, icon = radial_action_icon)

/obj/item/tank/internals/oxygen/serpentid_vault_tank
	name = "serpentid oxygen vault"
	volume = 5

/obj/item/tank/internals/oxygen/serpentid_vault_tank/populate_gas()
	air_contents.set_oxygen((0.5 * ONE_ATMOSPHERE) * volume / (R_IDEAL_GAS_EQUATION * T20C))
	distribute_pressure = 22

/datum/organ/lungs/serpentid
	safe_oxygen_min = 21
	safe_toxins_max = 5

	cold_level_1_threshold = SERPENTID_COLD_THRESHOLD_LEVEL_BASE
	cold_level_2_threshold = SERPENTID_COLD_THRESHOLD_LEVEL_BASE - SERPENTID_COLD_THRESHOLD_LEVEL_DOWN
	cold_level_3_threshold = SERPENTID_COLD_THRESHOLD_LEVEL_BASE - 2*SERPENTID_COLD_THRESHOLD_LEVEL_DOWN

	heat_level_1_threshold = SERPENTID_HEAT_THRESHOLD_LEVEL_BASE
	heat_level_2_threshold = SERPENTID_HEAT_THRESHOLD_LEVEL_BASE + SERPENTID_HEAT_THRESHOLD_LEVEL_UP
	heat_level_3_threshold = SERPENTID_HEAT_THRESHOLD_LEVEL_BASE + 2*SERPENTID_HEAT_THRESHOLD_LEVEL_UP

/obj/item/organ/internal/lungs/serpentid/switch_mode(force_off = FALSE)
	.=..()
	if(!hand_active)
		owner.internal = serpentid_vault
		hand_active = TRUE
	else
		owner.internal = null
		hand_active = FALSE

/obj/item/organ/internal/lungs/serpentid/on_life()
	.=..()
	SEND_SIGNAL(src, COMSIG_ORGAN_CHEM_CALL, chemical_consuption)
	var/can_secretion = owner.get_chemical_value(chemical_id) > chemical_consuption
	var/danger_state = owner.getOxyLoss() > 0
	var/datum/reagent/chemical = owner.get_chemical_path(chemical_id)
	var/datum/gas_mixture/breath
	var/datum/organ/lungs/serpentid/lung_data = organ_datums[organ_tag]
	var/breath_moles = 0
	var/turf/T = get_turf(owner)
	var/datum/gas_mixture/environment = get_turf_air(T)

	if(environment)
		breath_moles = environment.total_moles()*BREATH_PERCENTAGE
	breath = environment.get_by_amount(breath_moles)
	danger_air = lung_data.in_danger_zone(breath)

	if(danger_state && can_secretion)
		var/mob/living/carbon/human/human_owner = owner
		human_owner.reagents.add_reagent("salbutamol", chemical_consuption)
		chemical.holder.remove_reagent(chemical_id, chemical_consuption)

	if(!hand_active)
		if(danger_air && (owner.stat == UNCONSCIOUS))
			if(!owner.internal)
				owner.internal = serpentid_vault
		else if(!danger_air && owner.internal == serpentid_vault)
			owner.internal = null

	var/datum/gas_mixture/int_tank_air = serpentid_vault.air_contents
	var/pressure_value = int_tank_air.return_pressure()
	if(pressure_value < 50)
		var/replenish_value = 0
		if(danger_air && can_secretion)
			replenish_value = chemical_consuption * chem_to_oxy_mult
			chemical.holder.remove_reagent(chemical_id, chemical_consuption)
		if(!danger_air)
			if(environment)
				breath_moles = environment.total_moles()*BREATH_PERCENTAGE
			var/datum/gas_mixture/replenish_gas = environment.get_by_amount(breath_moles)
			replenish_value = replenish_gas.private_oxygen
		var/oxygen_value = (0.5 * ONE_ATMOSPHERE) * serpentid_vault.volume  * replenish_value
		var/gas_mix_value = R_IDEAL_GAS_EQUATION * T20C
		var/value_to_replenish = ( oxygen_value / gas_mix_value )
		if(value_to_replenish > 0)
			serpentid_vault.air_contents.set_oxygen(serpentid_vault.air_contents.oxygen() + value_to_replenish)

//Без этого псевдо-баллон не работает (отрубается так как не проходит проверки основы)
/mob/living/carbon/breathe(datum/gas_mixture/environment)
	var/obj/item/organ/internal/lungs/lugns = null
	for(var/obj/item/organ/internal/O in src.internal_organs)
		if(istype(O, /obj/item/organ/internal/lungs))
			lugns = O
	if(istype(lugns, /obj/item/organ/internal/lungs/serpentid))
		var/obj/item/organ/internal/lungs/serpentid/serpentid_lungs = lugns
		if(src.internal == serpentid_lungs.serpentid_vault)
			var/mob/living/carbon/human/puppet = src
			var/breath = puppet.serpen_lugns(BREATH_VOLUME)
			check_breath(breath)
			if(breath)
				environment.merge(breath)
				if(ishuman(src) && !internal && environment.temperature() < 273 && environment.return_pressure() > 20) //foggy breath :^)
					new /obj/effect/frosty_breath(loc, src)

			return
	. = ..()

/mob/living/carbon/human/proc/serpen_lugns(volume_needed)
	if(internal)
		return internal.remove_air_volume(volume_needed)
	return null

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
/*




/obj/item/organ/internal/lungs/serpentid/on_life()
	.=..()
	SEND_SIGNAL(src, COMSIG_ORGAN_CHEM_CALL, chemical_consuption)
	var/turf/T = get_turf(owner)
	var/datum/gas_mixture/environment = get_turf_air(T)
	var/datum/gas_mixture/breath
	var/datum/organ/lungs/serpentid/lung_data = organ_datums[organ_tag]
	var/breath_moles = 0
	if(environment)
		breath_moles = environment.total_moles()*BREATH_PERCENTAGE
	breath = environment.get_by_amount(breath_moles)
	danger_air = lung_data.in_danger_zone(breath)
	if(danger_air)
		breath = owner.serpen_lugns(BREATH_VOLUME)
	breath_secretion(breath)



/obj/item/organ/internal/lungs/serpentid/proc/breath_secretion(datum/gas_mixture/breath)
	var/can_secretion = owner.get_chemical_value(chemical_id) > chemical_consuption
	var/danger_state = owner.getOxyLoss() > 0
	var/datum/reagent/chemical = owner.get_chemical_path(chemical_id)
	if(danger_air)
		if(!owner.internal)
			owner.internal = serpentid_vault
	else
		if(owner.internal)
			owner.internal = null

	var/datum/gas_mixture/int_tank_air = serpentid_vault.air_contents
	var/pressure_value = int_tank_air.return_pressure()
	if(pressure_value < 100)
		var/replenish_value = 0
		if(danger_air && can_secretion)
			replenish_value = chemical_consuption * chem_to_oxy_mult
			chemical.holder.remove_reagent(chemical_id, chemical_consuption)
		if(!danger_air)
			var/turf/T = get_turf(owner)
			var/datum/gas_mixture/environment = get_turf_air(T)
			var/breath_moles = 0
			if(environment)
				breath_moles = environment.total_moles()*BREATH_PERCENTAGE
			var/datum/gas_mixture/replenish_gas = environment.get_by_amount(breath_moles)
			replenish_value = replenish_gas.private_oxygen
		var/oxygen_value = ((ONE_ATMOSPHERE) * serpentid_vault.volume  * replenish_value + pressure_value)
		var/gas_mix_value = (R_IDEAL_GAS_EQUATION * T20C)
		var/value_to_replenish = ( oxygen_value / gas_mix_value )
		if(value_to_replenish > 0)
			serpentid_vault.air_contents.set_oxygen(value_to_replenish)

	if(danger_state && can_secretion)
		var/mob/living/carbon/human/human_owner = owner
		human_owner.reagents.add_reagent("salbutamol", chemical_consuption)
		chemical.holder.remove_reagent(chemical_id, chemical_consuption)
*/

#undef SERPENTID_COLD_THRESHOLD_LEVEL_BASE
#undef SERPENTID_COLD_THRESHOLD_LEVEL_DOWN
#undef SERPENTID_HEAT_THRESHOLD_LEVEL_BASE
#undef SERPENTID_HEAT_THRESHOLD_LEVEL_UP
