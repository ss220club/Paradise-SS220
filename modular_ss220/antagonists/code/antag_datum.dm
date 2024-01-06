/datum/antagonist/proc/create_mob(spawn_loc, species_name = null, list/possible_species, try_use_preference = FALSE)
	var/mob/living/carbon/human/H = new(spawn_loc)
	var/datum/character_save/character

	var/client/client = owner.current.client	// !!!!!!! проверить что клиент вообще вызывается даже у гостов
	if(try_use_preference && client && client.prefs && length(client.prefs.character_saves))
		for(var/datum/character_save/character_save in client.prefs.character_saves)
			var/temp_species_name = species_name
			if(!temp_species_name)
				if(length(possible_species))
					temp_species_name = pick(possible_species)
				else
					temp_species_name = "Human"
			if(character_save.species == temp_species_name)
				character = character_save
				species_name = temp_species_name
				break
	else
		// Randomize appearance
		character = new
		character.species = species_name ? species_name : get_random_species(TRUE)
		character.randomise()

	character.copy_to(H)

	// species
	//H.dna.species.create_organs(H)	// !!!!!! Проверить есть ли НУЖНЫЕ органы
	H.cleanSE() //No fat/blind/colourblind/epileptic/whatever ops.
	H.overeatduration = 0
	H.flavor_text = null
	H.update_body()

	owner.store_memory("<B> Я Вокс-Рейдер, основа моя: беречь стаю, тащить ценности. </B>.")
