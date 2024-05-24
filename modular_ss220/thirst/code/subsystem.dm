/datum/controller/subsystem/mobs/proc/enable_hydration()
	GLOB.configuration.ss220_misc.hydration_enabled = TRUE
	for(var/mob/living/carbon/human/human in GLOB.human_list)
		human.hydration = initial(human.hydration)
		if(!human.hydration_display || HAS_TRAIT(human, TRAIT_NO_THIRST))
			continue
		human.hydration_display.icon_state = "water_notice_me"
		addtimer(VARSET_CALLBACK(human.hydration_display, icon_state, "water_well_hydrated"), 8 SECONDS)

/datum/controller/subsystem/mobs/proc/disable_hydration()
	GLOB.configuration.ss220_misc.hydration_enabled = FALSE
	for(var/mob/living/carbon/human/human in GLOB.human_list)
		human.hydration = initial(human.hydration)
		if(!human.hydration_display)
			continue
		human.hydration_display.icon_state = null

/datum/controller/subsystem/mobs/vv_get_dropdown()
	. = ..()
	.["Thirst - Enable"] = "?_src_=vars;thirst_enable=[UID()]"
	.["Thirst - Disable"] = "?_src_=vars;thirst_disable=[UID()]"

/client/view_var_Topic(href, href_list, hsrc)
	. = ..()
	if(!check_rights(R_ADMIN|R_MOD, FALSE) \
		&& !((href_list["datumrefresh"] || href_list["Vars"] || href_list["VarsList"]) && check_rights(R_VIEWRUNTIMES, FALSE)) \
		&& !((href_list["proc_call"]) && check_rights(R_PROCCALL, FALSE)) \
	)
		return
	if(view_var_Topic_list(href, href_list, hsrc))
		return
	if(href_list["thirst_enable"])
		var/datum/controller/subsystem/mobs/subsystem = locateUID(href_list["thirst_enable"])
		subsystem.enable_hydration()
		return
	if(href_list["thirst_disable"])
		var/datum/controller/subsystem/mobs/subsystem = locateUID(href_list["thirst_disable"])
		subsystem.disable_hydration()
		return
