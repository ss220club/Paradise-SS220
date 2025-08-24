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
	production_icon = "pills"
	sprites = list("autoinjector")
	item_type = /obj/item/reagent_containers/hypospray/autoinjector/custom
	max_items_amount = 20
	max_units_per_item = 30
	name_suffix = " medipen"

/datum/chemical_production_mode/autoinjectors/get_base_placeholder_name(datum/reagents/reagents, amount_per_item)
	return reagents.get_master_reagent_name()
