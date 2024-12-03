/datum/spell/flayer
	var/requiers_antag_datum = TRUE

/datum/spell_handler/flayer/can_cast(mob/user, charge_check, show_message, datum/spell/flayer/spell)
	if(!spell.requiers_antag_datum)
		return TRUE
	return ..()

/datum/spell/flayer/self/overclock/no_heat
	heat_per_tick = 0
