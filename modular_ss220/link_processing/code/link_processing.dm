// Bulk limb configuration for species with ALL_RPARTS.
/datum/preferences/proc/process_all_parts_limb(mob/user, new_state)
	var/list/all_parts = list("chest", "groin", "head", "l_arm", "r_arm", "l_leg", "r_leg", "l_hand", "r_hand", "l_foot", "r_foot")

	if(new_state == "Normal")
		for(var/part in all_parts)
			if(part == "head")
				active_character.m_styles["head"] = "None"
				active_character.h_style = GLOB.hair_styles_public_list["Bald"]
				active_character.f_style = GLOB.facial_hair_styles_list["Shaved"]
			active_character.organ_data[part] = null
			active_character.rlimb_data[part] = null
		return

	if(new_state == "Amputated")
		var/list/amputated_parts = list(
			"l_arm" = "l_hand",
			"r_arm" = "r_hand",
			"l_leg" = "l_foot",
			"r_leg" = "r_foot"
		)
		for(var/part in amputated_parts)
			active_character.organ_data[part] = "amputated"
			active_character.rlimb_data[part] = null
			var/child_part = amputated_parts[part]
			active_character.organ_data[child_part] = "amputated"
			active_character.rlimb_data[child_part] = null
		return

	if(new_state != "Prosthesis")
		return

	var/list/required_parts = list("chest", "groin", "head", "l_arm", "r_arm", "l_leg", "r_leg")
	var/list/robolimb_companies = list()
	for(var/limb_type in typesof(/datum/robolimb))
		var/datum/robolimb/robolimb = new limb_type()
		if(robolimb.unavailable_at_chargen || !robolimb.has_subtypes)
			continue
		var/has_all_parts = TRUE
		for(var/required_part in required_parts)
			if(!(required_part in robolimb.parts))
				has_all_parts = FALSE
				break
		if(has_all_parts)
			robolimb_companies[robolimb.company] = robolimb

	if(!length(robolimb_companies))
		to_chat(user, "<span class='warning'>No manufacturers offer full body prosthetics.</span>")
		return

	var/company = tgui_input_list(user, "Which manufacturer do you wish to use for full body replacement?", "All Parts - Prosthesis", robolimb_companies)
	if(!company)
		return

	var/datum/robolimb/selected_robolimb = GLOB.all_robolimbs[company]
	for(var/part in required_parts)
		var/model = company
		if(selected_robolimb.has_subtypes == 1)
			var/list/robolimb_models = list()
			for(var/limb_type in typesof(selected_robolimb))
				var/datum/robolimb/robolimb_model = new limb_type()
				if(part in robolimb_model.parts)
					robolimb_models[robolimb_model.company] = robolimb_model
					if(length(robolimb_models) == 1)
						model = robolimb_model.company

			if(length(robolimb_models) > 1)
				var/part_name = part
				switch(part)
					if("chest") part_name = "Torso"
					if("groin") part_name = "Lower Body"
					if("head") part_name = "Head"
					if("l_arm") part_name = "Left Arm"
					if("r_arm") part_name = "Right Arm"
					if("l_leg") part_name = "Left Leg"
					if("r_leg") part_name = "Right Leg"
				var/selected_model = tgui_input_list(user, "Which model of [company] [part_name] do you wish to use?", "All Parts - Prosthesis - [part_name]", robolimb_models)
				if(!selected_model)
					return
				model = selected_model

		if(part == "head")
			active_character.ha_style = "None"
			active_character.alt_head = null
			active_character.h_style = GLOB.hair_styles_public_list["Bald"]
			active_character.f_style = GLOB.facial_hair_styles_list["Shaved"]
			active_character.m_styles["head"] = "None"
		active_character.rlimb_data[part] = model
		active_character.organ_data[part] = "cyborg"

		var/child_part
		switch(part)
			if("l_arm") child_part = "l_hand"
			if("r_arm") child_part = "r_hand"
			if("l_leg") child_part = "l_foot"
			if("r_leg") child_part = "r_foot"
		if(child_part)
			active_character.rlimb_data[child_part] = model
			active_character.organ_data[child_part] = "cyborg"
// SS220 EDIT END
