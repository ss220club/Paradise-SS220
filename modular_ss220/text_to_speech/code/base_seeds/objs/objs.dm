/obj/machinery
	tts_seed = "Glados"

/obj/machinery/computer
	tts_seed = null

/obj/machinery/autolathe
	tts_seed = null

/obj/machinery/mecha_part_fabricator
	tts_seed = null

/obj/item/taperecorder
	tts_seed = "Xenia"

/obj/item/ttsdevice
	tts_seed = "Xenia"

/obj/structure/mirror/magic/Initialize(mapload, newdir, building)
	. = ..()
	options |= list("TTS-Voice")

/obj/structure/mirror/magic/proc/tts_choose(choice, mob/living/carbon/human/H)
	H.tts_seed = get_random_tts_seed_gender(H.gender)
	H.dna.tts_seed_dna = H.tts_seed
