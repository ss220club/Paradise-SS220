/datum/preferences/process_link(mob/user, list/href_list)
	if(!user)
		return
	var/datum/species/S = GLOB.all_species[active_character.species]
	switch(href_list["task"])
		if("input")
			switch(href_list["preference"])
				if("limbs")
					var/valid_limbs = list("Left Leg", "Right Leg", "Left Arm", "Right Arm", "Left Foot", "Right Foot", "Left Hand", "Right Hand")
					if(S.bodyflags & ALL_RPARTS)
						valid_limbs = list("All Parts", "Torso", "Lower Body", "Head", "Left Leg", "Right Leg", "Left Arm", "Right Arm", "Left Foot", "Right Foot", "Left Hand", "Right Hand")
					var/limb_name = tgui_input_list(user, "Which limb do you want to change?", "Limbs and Parts", valid_limbs)
					if(!limb_name) return

					var/limb = null
					var/second_limb = null
					var/third_limb = null
					var/valid_limb_states = list("Normal", "Amputated", "Prosthesis")
					var/no_amputate = 0

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

					var/new_state = tgui_input_list(user, "What state do you wish the limb to be in?", "[limb_name]", valid_limb_states)
					if(!new_state) return

					switch(new_state)
						if("Normal")
							if(limb == "all")
								var/list/all_parts = list("chest", "groin", "head", "l_arm", "r_arm", "l_leg", "r_leg", "l_hand", "r_hand", "l_foot", "r_foot")
								for(var/part in all_parts)
									if(part == "head")
										active_character.m_styles["head"] = "None"
										active_character.h_style = GLOB.hair_styles_public_list["Bald"]
										active_character.f_style = GLOB.facial_hair_styles_list["Shaved"]
									active_character.organ_data[part] = null
									active_character.rlimb_data[part] = null
							else
								if(limb == "head")
									active_character.m_styles["head"] = "None"
									active_character.h_style = GLOB.hair_styles_public_list["Bald"]
									active_character.f_style = GLOB.facial_hair_styles_list["Shaved"]
								active_character.organ_data[limb] = null
								active_character.rlimb_data[limb] = null
								if(third_limb)
									active_character.organ_data[third_limb] = null
									active_character.rlimb_data[third_limb] = null
						if("Amputated")
							if(!no_amputate)
								if(limb == "all")
									var/list/amputate_parts = list("l_arm", "r_arm", "l_leg", "r_leg")
									for(var/part in amputate_parts)
										active_character.organ_data[part] = "amputated"
										active_character.rlimb_data[part] = null
										if(part == "l_arm")
											active_character.organ_data["l_hand"] = "amputated"
											active_character.rlimb_data["l_hand"] = null
										else if(part == "r_arm")
											active_character.organ_data["r_hand"] = "amputated"
											active_character.rlimb_data["r_hand"] = null
										else if(part == "l_leg")
											active_character.organ_data["l_foot"] = "amputated"
											active_character.rlimb_data["l_foot"] = null
										else if(part == "r_leg")
											active_character.organ_data["r_foot"] = "amputated"
											active_character.rlimb_data["r_foot"] = null
								else
									active_character.organ_data[limb] = "amputated"
									active_character.rlimb_data[limb] = null
									if(second_limb)
										active_character.organ_data[second_limb] = "amputated"
										active_character.rlimb_data[second_limb] = null
						if("Prosthesis")
							var/choice
							var/subchoice
							var/datum/robolimb/R = new()
							var/in_model
							var/robolimb_companies = list()

							if(limb == "all")
								// Для All Parts - ищем производителя, у которого есть ВСЕ основные части
								for(var/limb_type in typesof(/datum/robolimb))
									R = new limb_type()
									if(!R.unavailable_at_chargen && R.has_subtypes)
										var/has_all = 1
										var/list/required_parts = list("chest", "groin", "head", "l_arm", "r_arm", "l_leg", "r_leg")
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

								// Для каждой части отдельно выбираем модель
								var/list/all_parts = list("chest", "groin", "head", "l_arm", "r_arm", "l_leg", "r_leg")
								for(var/part in all_parts)
									choice = R.company
									subchoice = null
									in_model = 0
									if(R.has_subtypes == 1)
										var/list/robolimb_models = list()
										for(var/limb_type in typesof(R))
											var/datum/robolimb/L = new limb_type()
											if(part in L.parts)
												robolimb_models[L.company] = L
												if(length(robolimb_models) == 1)
													subchoice = L.company
										if(length(robolimb_models) > 1)
											var/part_name = part
											if(part == "chest") part_name = "Torso"
											else if(part == "groin") part_name = "Lower Body"
											else if(part == "head") part_name = "Head"
											else if(part == "l_arm") part_name = "Left Arm"
											else if(part == "r_arm") part_name = "Right Arm"
											else if(part == "l_leg") part_name = "Left Leg"
											else if(part == "r_leg") part_name = "Right Leg"
											subchoice = tgui_input_list(user, "Which model of [choice] [part_name] do you wish to use?", "All Parts - Prosthesis - [part_name]", robolimb_models)

										if(subchoice)
											choice = subchoice

									// Применяем выбранную модель к этой части
									if(part == "head")
										active_character.ha_style = "None"
										active_character.alt_head = null
										active_character.h_style = GLOB.hair_styles_public_list["Bald"]
										active_character.f_style = GLOB.facial_hair_styles_list["Shaved"]
										active_character.m_styles["head"] = "None"
									active_character.rlimb_data[part] = choice
									active_character.organ_data[part] = "cyborg"

									// Для рук и ног также применяем к кистям/стопам
									if(part == "l_arm")
										active_character.rlimb_data["l_hand"] = choice
										active_character.organ_data["l_hand"] = "cyborg"
									else if(part == "r_arm")
										active_character.rlimb_data["r_hand"] = choice
										active_character.organ_data["r_hand"] = "cyborg"
									else if(part == "l_leg")
										active_character.rlimb_data["l_foot"] = choice
										active_character.organ_data["l_foot"] = "cyborg"
									else if(part == "r_leg")
										active_character.rlimb_data["r_foot"] = choice
										active_character.organ_data["r_foot"] = "cyborg"
							else
								// Оригинальная логика для одиночных частей
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
									var/list/robolimb_models = list()
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
									if(subchoice)
										choice = subchoice
								if(limb in list("head", "chest", "groin"))
									if(!(S.bodyflags & ALL_RPARTS))
										return
									if(limb == "head")
										active_character.ha_style = "None"
										active_character.alt_head = null
										active_character.h_style = GLOB.hair_styles_public_list["Bald"]
										active_character.f_style = GLOB.facial_hair_styles_list["Shaved"]
										active_character.m_styles["head"] = "None"
								active_character.rlimb_data[limb] = choice
								active_character.organ_data[limb] = "cyborg"
								if(second_limb)
									if(subchoice)
										if(in_model)
											active_character.rlimb_data[second_limb] = choice
											active_character.organ_data[second_limb] = "cyborg"
									else
										active_character.rlimb_data[second_limb] = choice
										active_character.organ_data[second_limb] = "cyborg"
					return
	. = ..()
