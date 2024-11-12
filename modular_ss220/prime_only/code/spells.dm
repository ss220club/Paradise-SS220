/datum/spell_handler/flayer/can_cast(mob/user, charge_check, show_message, datum/spell/spell)
	if(user.mind.offstation_role == 1)
		return TRUE
	return ..()

/datum/spell/flayer/self/overclock/no_heat
	heat_per_tick = 0
