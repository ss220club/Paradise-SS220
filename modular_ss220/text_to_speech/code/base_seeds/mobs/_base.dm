//Fallback values for TTS voices

/mob/living/carbon/human/Initialize(mapload, datum/species/new_species)
	. = ..()
	if(dna)
		dna.tts_seed_dna = get_tts_seed()

/mob/living/simple_animal/add_tts_component()
	AddComponent(/datum/component/tts_component, "Angel")
