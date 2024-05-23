/datum/controller/subsystem/mobs/proc/enable_hydration()
	GLOB.configuration.ss220_misc.hydration_enabled = TRUE
	for(var/mob/living/carbon/human/human in GLOB.human_list)
		return

/datum/controller/subsystem/mobs/proc/disable_hydration()
	GLOB.configuration.ss220_misc.hydration_enabled = FALSE
	for(var/mob/living/carbon/human/human in GLOB.human_list)
		return

/mob/living/carbon/human/proc/alert_hydration()
	hydration = initial(hydration)

