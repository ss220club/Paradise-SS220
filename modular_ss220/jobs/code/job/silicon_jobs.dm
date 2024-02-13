/datum/job/ai
	alt_titles = list("Automated Overseer", "Station Intelligence")

/datum/job/cyborg/New()
	. = ..()
	alt_titles |= list("Android")
