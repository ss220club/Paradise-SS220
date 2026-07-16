// Bulk limb configuration for species with ALL_RPARTS.
/datum/preferences/proc/process_all_parts_limb(mob/user, new_state)
	var/list/all_parts = list("chest", "groin", "head", "l_arm", "r_arm", "l_leg", "r_leg", "l_hand", "r_hand", "l_foot", "r_foot")

	// Временные переменные
	var/list/temp_organ_data = list()
	var/list/temp_rlimb_data = list()
	var/apply_head_changes = FALSE
	var/temp_ha_style
	var/temp_alt_head
	var/temp_h_style
	var/temp_f_style
	var/list/temp_m_styles = list()

	if(new_state == "Normal")
		for(var/part in all_parts)
			if(part == "head")
				apply_head_changes = TRUE
				temp_m_styles["head"] = "None"
				temp_h_style = GLOB.hair_styles_public_list["Bald"]
				temp_f_style = GLOB.facial_hair_styles_list["Shaved"]
			temp_organ_data[part] = null
			temp_rlimb_data[part] = null


	else if(new_state == "Amputated")
		var/list/amputated_parts = list(
			"l_arm" = "l_hand",
			"r_arm" = "r_hand",
			"l_leg" = "l_foot",
			"r_leg" = "r_foot"
		)
		for(var/part in amputated_parts)
			temp_organ_data[part] = "amputated"
			temp_rlimb_data[part] = null
			var/child_part = amputated_parts[part]
			temp_organ_data[child_part] = "amputated"
			temp_rlimb_data[child_part] = null


	else if(new_state == "Prosthesis")
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
				apply_head_changes = TRUE
				temp_ha_style = "None"
				temp_alt_head = null
				temp_h_style = GLOB.hair_styles_public_list["Bald"]
				temp_f_style = GLOB.facial_hair_styles_list["Shaved"]
				temp_m_styles["head"] = "None"

			temp_rlimb_data[part] = model
			temp_organ_data[part] = "cyborg"

			var/child_part
			switch(part)
				if("l_arm") child_part = "l_hand"
				if("r_arm") child_part = "r_hand"
				if("l_leg") child_part = "l_foot"
				if("r_leg") child_part = "r_foot"
			if(child_part)
				temp_rlimb_data[child_part] = model
				temp_organ_data[child_part] = "cyborg"

	var/confirm = tgui_alert(user, "Apply these changes to all parts?", "Confirm Changes", list("Yes", "No"))
	if(confirm != "Yes")
		return

	if(apply_head_changes)
		active_character.ha_style = temp_ha_style
		active_character.alt_head = temp_alt_head
		active_character.h_style = temp_h_style
		active_character.f_style = temp_f_style
		for(var/k in temp_m_styles)
			active_character.m_styles[k] = temp_m_styles[k]

	for(var/part in temp_organ_data)
		active_character.organ_data[part] = temp_organ_data[part]
	for(var/part in temp_rlimb_data)
		active_character.rlimb_data[part] = temp_rlimb_data[part]
// SS220 EDIT END
