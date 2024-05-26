/datum/status_effect/terror/regeneration
	id = "terror_regen"
	duration = 250
	alert_type = null

/datum/status_effect/terror/regeneration/tick()
	owner.adjustBruteLoss(-6)
