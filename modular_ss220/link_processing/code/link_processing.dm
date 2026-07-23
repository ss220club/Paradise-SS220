// Bulk limb configuration for species with ALL_RPARTS.
/datum/preferences/proc/process_all_parts_limb(mob/user, new_state)
	var/static/list/all_parts = list(
		BODY_ZONE_CHEST, BODY_ZONE_PRECISE_GROIN, BODY_ZONE_HEAD,
		BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG,
		BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_PRECISE_L_FOOT, BODY_ZONE_PRECISE_R_FOOT
	)

	var/static/list/ipc_all_parts = list(
		BODY_ZONE_CHEST, BODY_ZONE_PRECISE_GROIN, BODY_ZONE_HEAD,
		BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG
	)

	var/static/list/limb_children = list(
		BODY_ZONE_L_ARM = BODY_ZONE_PRECISE_L_HAND,
		BODY_ZONE_R_ARM = BODY_ZONE_PRECISE_R_HAND,
		BODY_ZONE_L_LEG = BODY_ZONE_PRECISE_L_FOOT,
		BODY_ZONE_R_LEG = BODY_ZONE_PRECISE_R_FOOT
	)

	var/static/list/part_names = list(
		BODY_ZONE_CHEST = "Torso",
		BODY_ZONE_PRECISE_GROIN = "Lower Body",
		BODY_ZONE_HEAD = "Head",
		BODY_ZONE_L_ARM = "Left Arm",
		BODY_ZONE_R_ARM = "Right Arm",
		BODY_ZONE_L_LEG = "Left Leg",
		BODY_ZONE_R_LEG = "Right Leg"
	)

	var/list/pending_organ_data = list()
	var/list/pending_rlimb_data = list()
	var/apply_head_changes = FALSE
	var/pending_head_accessory_style
	var/pending_alt_head
	var/pending_hair_style
	var/pending_facial_hair_style
	var/list/pending_marking_styles = list()

	if(new_state == "Normal")
		for(var/part in all_parts)
			if(part == BODY_ZONE_HEAD)
				apply_head_changes = TRUE
				pending_marking_styles[BODY_ZONE_HEAD] = "None"
				pending_hair_style = GLOB.hair_styles_public_list["Bald"]
				pending_facial_hair_style = GLOB.facial_hair_styles_list["Shaved"]
			pending_organ_data[part] = null
			pending_rlimb_data[part] = null

	else if(new_state == "Amputated")
		for(var/part in limb_children)
			var/child_part = limb_children[part]
			pending_organ_data[part] = "amputated"
			pending_rlimb_data[part] = null
			pending_organ_data[child_part] = "amputated"
			pending_rlimb_data[child_part] = null

	else if(new_state != "Prosthesis")
		return

	var/list/available_robolimb_companies = list()
	for(var/limb_type in typesof(/datum/robolimb))
		var/datum/robolimb/robolimb = new limb_type()
		if(robolimb.unavailable_at_chargen || !robolimb.has_subtypes)
			continue
		var/has_all_parts = TRUE
		for(var/required_part in ipc_all_parts)
			if(!(required_part in robolimb.parts))
				has_all_parts = FALSE
				break
		if(has_all_parts)
			available_robolimb_companies[robolimb.company] = robolimb

	if(!length(available_robolimb_companies))
		to_chat(user, "<span class='warning'>No manufacturers offer full body prosthetics.</span>")
		return

	var/company = tgui_input_list(user, "Which manufacturer do you wish to use for full body replacement?", "All Parts - Prosthesis", available_robolimb_companies)
	if(!company)
		return

	var/datum/robolimb/selected_robolimb = GLOB.all_robolimbs[company]
	for(var/part in ipc_all_parts)
		var/model = company
		if(selected_robolimb.has_subtypes)
			var/list/robolimb_models = list()
			for(var/limb_type in typesof(selected_robolimb))
				var/datum/robolimb/robolimb_model = new limb_type()
				if(part in robolimb_model.parts)
					robolimb_models[robolimb_model.company] = robolimb_model
					if(length(robolimb_models) == 1)
						model = robolimb_model.company

			if(length(robolimb_models) > 1)
				var/part_name = part_names[part]
				var/selected_model = tgui_input_list(user, "Which model of [company] [part_name] do you wish to use?", "All Parts - Prosthesis - [part_name]", robolimb_models)
				if(!selected_model)
					return
				model = selected_model

		if(part == BODY_ZONE_HEAD)
			apply_head_changes = TRUE
			pending_head_accessory_style = "None"
			pending_alt_head = null
			pending_hair_style = GLOB.hair_styles_public_list["Bald"]
			pending_facial_hair_style = GLOB.facial_hair_styles_list["Shaved"]
			pending_marking_styles[BODY_ZONE_HEAD] = "None"

		pending_rlimb_data[part] = model
		pending_organ_data[part] = "cyborg"

		var/child_part = limb_children[part]
		if(child_part)
			pending_rlimb_data[child_part] = model
			pending_organ_data[child_part] = "cyborg"

	var/confirm = tgui_alert(user, "Apply these changes to all parts?", "Confirm Changes", list("Yes", "No"))
	if(confirm != "Yes")
		return

	if(apply_head_changes)
		active_character.ha_style = pending_head_accessory_style
		active_character.alt_head = pending_alt_head
		active_character.h_style = pending_hair_style
		active_character.f_style = pending_facial_hair_style
		for(var/k in pending_marking_styles)
			active_character.m_styles[k] = pending_marking_styles[k]

	for(var/part in pending_organ_data)
		active_character.organ_data[part] = pending_organ_data[part]
	for(var/part in pending_rlimb_data)
		active_character.rlimb_data[part] = pending_rlimb_data[part]
