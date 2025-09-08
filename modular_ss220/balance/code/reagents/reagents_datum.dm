#define DEFAULT_DAMAGE 0.05
#define ADDITIONAL_DAMAGE 0.0075 // each cycle damage is increased by this value

/datum/reagent
	// how quickly the used cycle var decays - 0.5 means 33% uptime, higher rate means higher uptime
	var/cycle_decay_rate = 0.5

/datum/reagent/handle_addiction(mob/living/M, consumption_rate)
	if(addiction_chance)
		M.reagents.cycle_used[type]++
	return ..()

/datum/reagent/pump_up/proc/calculate_heart_damage()
	var/heart_damage = DEFAULT_DAMAGE
	var/recent_consumption = holder.cycle_used[type]
	heart_damage += ADDITIONAL_DAMAGE * recent_consumption // 0.05 at 1st cycle, 0.8 at 100th. Death in 120 (127 for slime people) cycles without treatment
	return heart_damage

#undef DEFAULT_DAMAGE
#undef ADDITIONAL_DAMAGE

/datum/chemical_production_mode/patches
	max_units_per_item = 20

/datum/chemical_production_mode/pills
	max_units_per_item = 20

/datum/chemical_production_mode/autoinjectors
	mode_id = "medipens"
	production_name = "Medipens"
	production_icon = "syringe"
	sprites = list("medipen")
	item_type = /obj/item/reagent_containers/hypospray/autoinjector/custom
	max_items_amount = 20
	max_units_per_item = 30
	name_suffix = " medipen"
	var/static/list/safe_chem_list = list("antihol", "charcoal", "epinephrine", "insulin", "teporone", "salbutamol",
									"omnizine", "stimulants", "synaptizine", "potass_iodide", "oculine", "mannitol",
									"spaceacillin", "salglu_solution", "sal_acid", "cryoxadone", "blood", "synthflesh",
									"hydrocodone", "mitocholide", "rezadone", "menthol", "diphenhydramine", "ephedrine",
									 "iron", "sanguine_reagent", "kelotane", "bicaridine", "pen_acid", "atropine")

/datum/chemical_production_mode/autoinjectors/get_base_placeholder_name(datum/reagents/reagents)
	return reagents.get_master_reagent_name()

/datum/chemical_production_mode/autoinjectors/proc/safety_check(datum/reagents/R)
	for(var/datum/reagent/A in R.reagent_list)
		if(!safe_chem_list.Find(A.id))
			return FALSE
	if(R.chem_temp < SAFE_MIN_TEMPERATURE || R.chem_temp > SAFE_MAX_TEMPERATURE)
		return FALSE
	return TRUE

/datum/chemical_production_mode/autoinjectors/configure_item(data, datum/reagents/R, obj/item/reagent_containers/hypospray/P)
	. = ..()
	var/chemicals_is_safe = data["chemicals_is_safe"]

	if(isnull(chemicals_is_safe))
		chemicals_is_safe = safety_check(R)
		data["chemicals_is_safe"] = chemicals_is_safe

	if(chemicals_is_safe)
		P.instant_application = TRUE
