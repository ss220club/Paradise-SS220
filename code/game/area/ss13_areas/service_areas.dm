/area/station/service/cafeteria
	name = "\improper Кафетерий"
	icon_state = "cafeteria"


/area/station/service/kitchen
	name = "\improper Кухня"
	icon_state = "kitchen"

/area/station/service/bar
	name = "\improper Бар"
	icon_state = "bar"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/station/service/bar/atrium
	name = "Атриум"
	icon_state = "bar"

/area/station/service/theatre
	name = "\improper Театр"
	icon_state = "Theatre"
	sound_environment = SOUND_AREA_WOODFLOOR


/area/station/service/library
	name = "\improper Библиотека"
	icon_state = "library"
	sound_environment = SOUND_AREA_LARGE_SOFTFLOOR

/area/station/service/chapel
	name = "\improper Церковь"
	icon_state = "chapel"
	ambientsounds = HOLY_SOUNDS
	is_haunted = TRUE
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	valid_territory = FALSE

/area/station/service/chapel/office
	name = "\improper Офис Священника"
	icon_state = "chapeloffice"

/area/station/service/clown
	name = "\improper Офис Клоуна"
	icon_state = "clown_office"

/area/station/service/clown/secret
	name = "\improper Top Secret Clown HQ"
	requires_power = FALSE

/area/station/service/mime
	name = "\improper Офис Мима"
	icon_state = "mime_office"

/area/station/service/barber
	name = "\improper Парикмахерская"
	icon_state = "barber"

/area/station/service/janitor
	name = "\improper Каморка Уборщика"
	icon_state = "janitor"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/service/hydroponics
	name = "Гидропоника"
	icon_state = "hydro"
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/station/service/expedition
	name = "\improper Комната Экспедиции"
	icon_state = "expedition"
	ambientsounds = ENGINEERING_SOUNDS
	sound_environment = SOUND_AREA_STANDARD_STATION
