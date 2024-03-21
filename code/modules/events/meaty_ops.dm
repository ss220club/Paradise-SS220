/datum/event/meteor_wave/goreop/announce()
	var/meteor_declaration = "Метеоритные Оперативники заявили о своем намерении полностью уничтожить [station_name()] своими телами, и бросают вызов экипажу, чтобы они попытались остановить их."
	GLOB.major_announcement.Announce(meteor_declaration, "Объявление 'Войны'", 'sound/effects/siren.ogg')

/datum/event/meteor_wave/goreop/setup()
	waves = 3

/datum/event/meteor_wave/goreop/get_meteor_count()
	return 5

/datum/event/meteor_wave/goreop/get_meteors()
	return GLOB.meteors_ops

/datum/event/meteor_wave/goreop/end()
	GLOB.minor_announcement.Announce("Все Метеоритные Оперативники мертвы. Безоговорочная победа станции!", "Метеоритные Оперативники.")
