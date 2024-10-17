/*
===Модуль хитина (карапаса)
Цепляется на конечность (в идеале торс).area
Опреедляет возможности тела серпентида, которые зависят от общего состояния хитина всех конечностей
*/
/datum/component/carapace_shell
	var/mob/living/carbon/human/H
	var/state_1_threshold = 0
	var/state_2_threshold = 0
	var/state_3_threshold = 0
	var/armored_cold_threshold = 0
	var/armored_heat_threshold = 0
	var/armored_temp_progression = 0

/datum/component/carapace_shell/Initialize(caller, treshold_1, treshold_2, treshold_3, threshold_cold, threshold_heat, temp_progression)
	H = caller

	state_1_threshold = treshold_1
	state_2_threshold = treshold_2
	state_3_threshold = treshold_3
	armored_cold_threshold = threshold_cold
	armored_heat_threshold = threshold_heat
	armored_temp_progression = temp_progression

/datum/component/carapace_shell/RegisterWithParent()
	RegisterSignal(H, COMSIG_LIVING_LIFE, PROC_REF(process_shell))

/datum/component/carapace_shell/UnregisterFromParent()
	UnregisterSignal(H, COMSIG_LIVING_LIFE)

//Прок на обновление сопротивления урона
/datum/component/carapace_shell/proc/process_shell()
	var/character_damage = H.get_damage_amount(BRUTE) + H.get_damage_amount(BURN)
	var/datum/species/specie = H.dna.species

	//Потеря брони при первом трешхолде
	if(character_damage <= state_1_threshold)
		specie.brute_mod = 0.6
		specie.burn_mod = 1.1
		ADD_TRAIT(H, TRAIT_PIERCEIMMUNE, "carapace_state")
		H.clear_alert("carapace_break_armor")
	else
		specie.brute_mod = 1.3
		specie.burn_mod = 1.5
		REMOVE_TRAIT(H, TRAIT_PIERCEIMMUNE, "carapace_state")
		H.throw_alert("carapace_break_armor", /atom/movable/screen/alert/carapace/break_armor)

	//Потеря стелса при втором трешхолде
	var/obj/item/organ/internal/kidneys/serpentid/organ = H.get_int_organ("kidneys")
	if(character_damage <= state_2_threshold)
		H.clear_alert("carapace_break_cloak")
	else
		H.throw_alert("carapace_break_cloak", /atom/movable/screen/alert/carapace/break_cloak)
		H.clear_alert("carapace_break_armor")
		if(istype(organ, /obj/item/organ/internal/kidneys/serpentid))
			organ.switch_mode(force_off = TRUE)

	//Потеря рига при третьем трешхолде
	var/cold = armored_cold_threshold
	var/heat = armored_heat_threshold

	if(character_damage <= state_3_threshold)
		specie.hazard_high_pressure = INFINITY
		specie.warning_high_pressure = INFINITY
		specie.warning_low_pressure = -INFINITY
		specie.hazard_low_pressure = -INFINITY
		H.clear_alert("carapace_break_rig")
	else
		specie.hazard_high_pressure = HAZARD_HIGH_PRESSURE
		specie.warning_high_pressure = WARNING_HIGH_PRESSURE
		specie.warning_low_pressure = WARNING_LOW_PRESSURE
		specie.hazard_low_pressure = HAZARD_LOW_PRESSURE
		H.throw_alert("carapace_break_rig", /atom/movable/screen/alert/carapace/break_rig)
		H.clear_alert("carapace_break_armor")
		H.clear_alert("carapace_break_cloak")
		cold = initial(specie.cold_level_1)
		heat = initial(specie.heat_level_2)

	specie.cold_level_1 = cold
	specie.cold_level_2 = specie.cold_level_1 - armored_temp_progression
	specie.cold_level_3 = specie.cold_level_2 - armored_temp_progression
	specie.heat_level_1 = heat
	specie.heat_level_2 = specie.heat_level_1 + armored_temp_progression
	specie.heat_level_3 = specie.heat_level_2 + armored_temp_progression
