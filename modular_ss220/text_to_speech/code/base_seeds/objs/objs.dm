/obj/machinery/add_tts_component()
	AddComponent(/datum/component/tts_component, "Glados")

/obj/machinery/computer/add_tts_component()
	return

/obj/machinery/autolathe/add_tts_component()
	return

/obj/machinery/mecha_part_fabricator/add_tts_component()
	return

/obj/item/taperecorder/add_tts_component()
	AddComponent(/datum/component/tts_component, "Xenia")

/obj/item/ttsdevice/add_tts_component()
	AddComponent(/datum/component/tts_component, "Xenia")

/obj/structure/mirror/magic/Initialize(mapload, newdir, building)
	. = ..()
	options |= list("Voice TTS")

/obj/structure/mirror/magic/proc/tts_choose(choice, mob/living/carbon/human/human_to_update)
	if(choice == "Voice TTS")
		human_to_update.change_tts_seed(human_to_update, TRUE, TRUE)
