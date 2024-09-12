/obj/effect/mob_spawn/human/alive/spacebase_syndicate/create/proc/create_saved(ckey, flavour = TRUE, mob/user = usr)
	var/datum/character_save/save_to_load
	if(tgui_alert(user, "Would you like to use one of your saved characters in your character creator?", "Ghost Bar", list("Yes", "No")) == "Yes")
		var/list/our_characters_names = list()
		var/list/our_character_saves = list()
		for(var/index in 1 to length(user.client.prefs.character_saves))
			var/datum/character_save/saves = user.client.prefs.character_saves[index]
			var/slot_name = "[saves.real_name] (Slot #[index])"
			our_characters_names += slot_name
			our_character_saves += list("[slot_name]" = saves)

		var/character_name = tgui_input_list(user, "Select a character", "Character selection", our_characters_names)
		if(!character_name)
			return
		if(QDELETED(user))
			return
		save_to_load = our_character_saves[character_name]
	else
		if(QDELETED(user))
			return
		save_to_load = new
		save_to_load.randomise()
/obj/effect/mob_spawn/human/alive/spacebase_syndicate/create(ckey, flavour = TRUE, name, mob/user = usr)
  if tgui_alert(user, "Хочешь за своего перса зайти?", list("Да, хочу", "Нет, не хочу") = Да)
  return create_saved()
  else
  return ..()
