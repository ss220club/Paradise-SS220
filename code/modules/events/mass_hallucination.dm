/// at least 75% rad armor is required to be immune to this event
#define RAD_ARMOR_TO_IMMUNITY 150

/datum/event/mass_hallucination/setup()
	announceWhen = rand(0, 20)

/datum/event/mass_hallucination/start()
	for(var/mob/living/carbon/human/human as anything in GLOB.human_list)
		if(human.stat == DEAD)
			continue
		var/turf/turf = get_turf(human)
		if(!is_station_level(turf?.z))
			continue
		if(HAS_TRAIT(human, TRAIT_RADIMMUNE) || human.getarmor(armor_type = RAD) >= RAD_ARMOR_TO_IMMUNITY) // Leave radiation-immune species/rad armored players completely unaffected
			continue
		human.AdjustHallucinate(rand(50 SECONDS, 100 SECONDS))

/datum/event/mass_hallucination/announce()
	GLOB.minor_announcement.Announce("[station_name()] проходит через радиационное поле низкой интенсивности. Возможно появление галлюцинаций, но не более.")

#undef RAD_ARMOR_TO_IMMUNITY
