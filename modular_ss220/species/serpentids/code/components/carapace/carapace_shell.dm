/*
===Модуль хитина (карапаса)
Цепляется на конечность (в идеале торс).area
Опреедляет возможности тела серпентида, которые зависят от общего состояния хитина всех конечностей
*/
#define COMSIG_CARAPACE_SHELL_PROCESS "process_shell"

/datum/component/carapace_shell
	var/mob/living/carbon/human/H

/datum/component/carapace_shell/Initialize(caller)
	..()
	H = caller

/datum/component/carapace_shell/RegisterWithParent()
	RegisterSignal(H, COMSIG_CARAPACE_SHELL_PROCESS, PROC_REF(process_shell))

/datum/component/carapace_shell/UnregisterFromParent()
	UnregisterSignal(H, COMSIG_CARAPACE_SHELL_PROCESS)

//Прок на обновление сопротивления урона
/datum/component/carapace_shell/proc/process_shell()
	var/character_damage = H.get_damage_amount(BRUTE) + H.get_damage_amount(BURN)
	var/datum/species/specie = H.dna.species

	//Потеря брони при первом трешхолде
	if(character_damage <= SERPENTID_CARAPACE_NOARMOR_STATE)
		specie.brute_mod = 0.6
		specie.burn_mod = 1.1
		ADD_TRAIT(H, TRAIT_PIERCEIMMUNE, "carapace_state")
		H.clear_alert("carapace_break_armor")
	else
		specie.brute_mod = 1.3
		specie.burn_mod = 1.5
		REMOVE_TRAIT(H, TRAIT_PIERCEIMMUNE, "carapace_state")
		H.throw_alert("carapace_break_armor", /atom/movable/screen/alert/carapace_break_armor)

	//Потеря стелса при втором трешхолде
	var/obj/item/organ/internal/kidneys/serpentid/organ = H.get_int_organ("kidneys")
	if(character_damage <= SERPENTID_CARAPACE_NOCHAMELION_STATE)
		H.clear_alert("carapace_break_cloak")
	else
		H.throw_alert("carapace_break_cloak", /atom/movable/screen/alert/carapace_break_cloak)
		H.clear_alert("carapace_break_armor")
		if(istype(organ, /obj/item/organ/internal/kidneys/serpentid))
			organ.switch_mode(force_off = TRUE)

	//Потеря рига при третьем трешхолде
	var/cold = SERPENTID_ARMORED_COLD_THRESHOLD
	var/heat = SERPENTID_ARMORED_HEAT_THRESHOLD

	if(character_damage <= SERPENTID_CARAPACE_NOPRESSURE_STATE)
		specie.hazard_high_pressure = INFINITY
		specie.warning_high_pressure = INFINITY
		specie.warning_low_pressure = -INFINITY
		specie.hazard_low_pressure = -INFINITY
		cold = SERPENTID_ARMORED_COLD_THRESHOLD
		heat = SERPENTID_ARMORED_HEAT_THRESHOLD
		H.clear_alert("carapace_break_rig")
	else
		specie.hazard_high_pressure = HAZARD_HIGH_PRESSURE
		specie.warning_high_pressure = WARNING_HIGH_PRESSURE
		specie.warning_low_pressure = WARNING_LOW_PRESSURE
		specie.hazard_low_pressure = HAZARD_LOW_PRESSURE
		H.throw_alert("carapace_break_rig", /atom/movable/screen/alert/carapace_break_rig)
		H.clear_alert("carapace_break_armor")
		H.clear_alert("carapace_break_cloak")
		cold = SERPENTID_COLD_THRESHOLD_LEVEL_BASE
		heat = SERPENTID_HEAT_THRESHOLD_LEVEL_BASE

	var/up = SERPENTID_COLD_THRESHOLD_LEVEL_DOWN
	var/down = SERPENTID_COLD_THRESHOLD_LEVEL_DOWN
	specie.cold_level_1 = cold
	specie.cold_level_2 = specie.cold_level_1 - down
	specie.cold_level_3 = specie.cold_level_2 - down
	specie.heat_level_1 = heat
	specie.heat_level_2 = specie.heat_level_1 + up
	specie.heat_level_3 = specie.heat_level_2 + up

//Расширение проков урона и лечения для обращения к компоненту
/datum/species/handle_life(mob/living/carbon/human/H)
	. = ..()
	SEND_SIGNAL(H, COMSIG_CARAPACE_SHELL_PROCESS)
	return

