/datum/preferences/process_link(mob/user, list/href_list)
	if(!user || !active_character)
		return
	var/datum/species/S = GLOB.all_species[active_character.species]
	if(!S)
		return
	switch(href_list["task"])
		if("input")
			switch(href_list["preference"])
				if("limbs")
					var/list/valid_limbs = list("Left Leg", "Right Leg", "Left Arm", "Right Arm", "Left Foot", "Right Foot", "Left Hand", "Right Hand")
					var/limb_name
					var/limb = null
					var/second_limb = null
					var/third_limb = null
					var/list/valid_limb_states = list("Normal", "Amputated", "Prosthesis")
					var/new_state
					var/no_amputate = 0
					var/choice
					var/subchoice
					var/datum/robolimb/R
					var/in_model
					var/list/robolimb_companies = list()
					var/list/robolimb_models
					var/list/all_parts = list()
					var/list/amputate_parts
					var/list/required_parts
					var/part_name
					var/has_all

					// Temporary storage for changes
					var/list/temp_organ_data = list()
					var/list/temp_rlimb_data = list()
					var/temp_ha_style
					var/temp_alt_head
					var/temp_h_style
					var/temp_f_style
					var/list/temp_m_styles = list()

					if(S.bodyflags & ALL_RPARTS)
						valid_limbs = list("All Parts", "Torso", "Lower Body", "Head", "Left Leg", "Right Leg", "Left Arm", "Right Arm", "Left Foot", "Right Foot", "Left Hand", "Right Hand")

					limb_name = tgui_input_list(user, "Which limb do you want to change?", "Limbs and Parts", valid_limbs)
					if(!limb_name) return

					switch(limb_name)
						if("All Parts")
							limb = "all"
						if("Torso")
							limb = "chest"
							second_limb = "groin"
							no_amputate = 1
						if("Lower Body")
							limb = "groin"
							no_amputate = 1
						if("Head")
							limb = "head"
							no_amputate = 1
						if("Left Leg")
							limb = "l_leg"
							second_limb = "l_foot"
						if("Right Leg")
							limb = "r_leg"
							second_limb = "r_foot"
						if("Left Arm")
							limb = "l_arm"
							second_limb = "l_hand"
						if("Right Arm")
							limb = "r_arm"
							second_limb = "r_hand"
						if("Left Foot")
							limb = "l_foot"
							if(!(S.bodyflags & ALL_RPARTS))
								third_limb = "l_leg"
						if("Right Foot")
							limb = "r_foot"
							if(!(S.bodyflags & ALL_RPARTS))
								third_limb = "r_leg"
						if("Left Hand")
							limb = "l_hand"
							if(!(S.bodyflags & ALL_RPARTS))
								third_limb = "l_arm"
						if("Right Hand")
							limb = "r_hand"
							if(!(S.bodyflags & ALL_RPARTS))
								third_limb = "r_arm"

					new_state = tgui_input_list(user, "What state do you wish the limb to be in?", "[limb_name]", valid_limb_states)
					if(!new_state) return

					switch(new_state)
						if("Normal")
							if(limb == "all")
								all_parts = list("chest", "groin", "head", "l_arm", "r_arm", "l_leg", "r_leg", "l_hand", "r_hand", "l_foot", "r_foot")
								for(var/part in all_parts)
									if(part == "head")
										temp_m_styles["head"] = "None"
										temp_h_style = GLOB.hair_styles_public_list["Bald"]
										temp_f_style = GLOB.facial_hair_styles_list["Shaved"]
									temp_organ_data[part] = null
									temp_rlimb_data[part] = null
							else
								if(limb == "head")
									temp_m_styles["head"] = "None"
									temp_h_style = GLOB.hair_styles_public_list["Bald"]
									temp_f_style = GLOB.facial_hair_styles_list["Shaved"]
								temp_organ_data[limb] = null
								temp_rlimb_data[limb] = null
								if(third_limb)
									temp_organ_data[third_limb] = null
									temp_rlimb_data[third_limb] = null
						if("Amputated")
							if(!no_amputate)
								if(limb == "all")
									amputate_parts = list("l_arm", "r_arm", "l_leg", "r_leg")
									for(var/part in amputate_parts)
										temp_organ_data[part] = "amputated"
										temp_rlimb_data[part] = null
										if(part == "l_arm")
											temp_organ_data["l_hand"] = "amputated"
											temp_rlimb_data["l_hand"] = null
										else if(part == "r_arm")
											temp_organ_data["r_hand"] = "amputated"
											temp_rlimb_data["r_hand"] = null
										else if(part == "l_leg")
											temp_organ_data["l_foot"] = "amputated"
											temp_rlimb_data["l_foot"] = null
										else if(part == "r_leg")
											temp_organ_data["r_foot"] = "amputated"
											temp_rlimb_data["r_foot"] = null
								else
									temp_organ_data[limb] = "amputated"
									temp_rlimb_data[limb] = null
									if(second_limb)
										temp_organ_data[second_limb] = "amputated"
										temp_rlimb_data[second_limb] = null
						if("Prosthesis")
							R = new()

							if(limb == "all")
								required_parts = list("chest", "groin", "head", "l_arm", "r_arm", "l_leg", "r_leg")
								for(var/limb_type in typesof(/datum/robolimb))
									R = new limb_type()
									if(!R.unavailable_at_chargen && R.has_subtypes)
										has_all = 1
										for(var/req_part in required_parts)
											if(!(req_part in R.parts))
												has_all = 0
												break
										if(has_all)
											robolimb_companies[R.company] = R
								R = new()

								if(!length(robolimb_companies))
									to_chat(user, "<span class='warning'>No manufacturers offer full body prosthetics.</span>")
									return

								choice = tgui_input_list(user, "Which manufacturer do you wish to use for full body replacement?", "All Parts - Prosthesis", robolimb_companies)
								if(!choice)
									return
								R.company = choice
								R = GLOB.all_robolimbs[R.company]

								all_parts = list("chest", "groin", "head", "l_arm", "r_arm", "l_leg", "r_leg")
								for(var/part in all_parts)
									choice = R.company
									subchoice = null
									in_model = 0
									if(R.has_subtypes == 1)
										robolimb_models = list()
										for(var/limb_type in typesof(R))
											var/datum/robolimb/L = new limb_type()
											if(part in L.parts)
												robolimb_models[L.company] = L
												if(length(robolimb_models) == 1)
													subchoice = L.company
										if(length(robolimb_models) > 1)
											if(part == "chest") part_name = "Torso"
											else if(part == "groin") part_name = "Lower Body"
											else if(part == "head") part_name = "Head"
											else if(part == "l_arm") part_name = "Left Arm"
											else if(part == "r_arm") part_name = "Right Arm"
											else if(part == "l_leg") part_name = "Left Leg"
											else if(part == "r_leg") part_name = "Right Leg"
											subchoice = tgui_input_list(user, "Which model of [choice] [part_name] do you wish to use?", "All Parts - Prosthesis - [part_name]", robolimb_models)
											if(!subchoice)
												return
										if(subchoice)
											choice = subchoice

									if(part == "head")
										temp_ha_style = "None"
										temp_alt_head = null
										temp_h_style = GLOB.hair_styles_public_list["Bald"]
										temp_f_style = GLOB.facial_hair_styles_list["Shaved"]
										temp_m_styles["head"] = "None"
									temp_rlimb_data[part] = choice
									temp_organ_data[part] = "cyborg"

									if(part == "l_arm")
										temp_rlimb_data["l_hand"] = choice
										temp_organ_data["l_hand"] = "cyborg"
									else if(part == "r_arm")
										temp_rlimb_data["r_hand"] = choice
										temp_organ_data["r_hand"] = "cyborg"
									else if(part == "l_leg")
										temp_rlimb_data["l_foot"] = choice
										temp_organ_data["l_foot"] = "cyborg"
									else if(part == "r_leg")
										temp_rlimb_data["r_foot"] = choice
										temp_organ_data["r_foot"] = "cyborg"
							else
								for(var/limb_type in typesof(/datum/robolimb))
									R = new limb_type()
									if(!R.unavailable_at_chargen && (limb in R.parts) && R.has_subtypes)
										robolimb_companies[R.company] = R
								R = new()

								choice = tgui_input_list(user, "Which manufacturer do you wish to use for this limb?", "[limb_name] - Prosthesis", robolimb_companies)
								if(!choice)
									return
								R.company = choice
								R = GLOB.all_robolimbs[R.company]
								if(R.has_subtypes == 1)
									robolimb_models = list()
									for(var/limb_type in typesof(R))
										var/datum/robolimb/L = new limb_type()
										if(limb in L.parts)
											robolimb_models[L.company] = L
											if(length(robolimb_models) == 1)
												subchoice = L.company
											if(second_limb in L.parts)
												in_model = 1
									if(length(robolimb_models) > 1)
										subchoice = tgui_input_list(user, "Which model of [choice] [limb_name] do you wish to use?", "[limb_name] - Prosthesis - Model", robolimb_models)
										if(!subchoice)
											return
									if(subchoice)
										choice = subchoice
								if(limb in list("head", "chest", "groin"))
									if(!(S.bodyflags & ALL_RPARTS))
										return
									if(limb == "head")
										temp_ha_style = "None"
										temp_alt_head = null
										temp_h_style = GLOB.hair_styles_public_list["Bald"]
										temp_f_style = GLOB.facial_hair_styles_list["Shaved"]
										temp_m_styles["head"] = "None"
								temp_rlimb_data[limb] = choice
								temp_organ_data[limb] = "cyborg"
								if(second_limb)
									if(subchoice)
										if(in_model)
											temp_rlimb_data[second_limb] = choice
											temp_organ_data[second_limb] = "cyborg"
									else
										temp_rlimb_data[second_limb] = choice
										temp_organ_data[second_limb] = "cyborg"

					// Confirmation dialog
					var/confirm = tgui_alert(user, "Apply these changes?", "Confirm Changes", list("Yes", "No"))
					if(confirm != "Yes")
						return

					// Apply all changes
					if(length(temp_m_styles))
						for(var/style_key in temp_m_styles)
							active_character.m_styles[style_key] = temp_m_styles[style_key]
					if(temp_h_style)
						active_character.h_style = temp_h_style
					if(temp_f_style)
						active_character.f_style = temp_f_style
					if(temp_ha_style)
						active_character.ha_style = temp_ha_style
					if(temp_alt_head)
						active_character.alt_head = temp_alt_head
					else if(temp_ha_style)
						active_character.alt_head = null

					for(var/part in temp_organ_data)
						active_character.organ_data[part] = temp_organ_data[part]
					for(var/part in temp_rlimb_data)
						active_character.rlimb_data[part] = temp_rlimb_data[part]

					ShowChoices(user)
					return
	. = ..()
