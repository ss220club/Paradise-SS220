/datum/dna
	var/tts_seed_dna

/datum/dna/Clone()
	. = ..()
	var/datum/dna/new_dna = .
	new_dna.tts_seed_dna = tts_seed_dna
	return new_dna

/mob/living/carbon/human/change_dna(datum/dna/new_dna, include_species_change, keep_flavor_text)
	. = ..()
	AddComponent(/datum/component/tts_component, dna.tts_seed_dna)
