//-----BASIC-----//

/area/lazarus
	icon_state = "outdoors"
	has_gravity = TRUE
	nad_allowed = TRUE

//-----OUTDOORS-----//

/area/lazarus/outdoors
	icon_state = "away"
	name = "Ледяные пустоши"
	always_unpowered = TRUE
	requires_power = TRUE
	poweralm = FALSE
	apc_starts_off = TRUE
	outdoors = TRUE
	ambientsounds = MINING_SOUNDS
	flags = NONE
	sound_environment = SOUND_AREA_STANDARD_STATION
	min_ambience_cooldown = 70 SECONDS
	max_ambience_cooldown = 220 SECONDS

/area/lazarus/outdoors/rod
	icon_state = "away1"
	name = "Окрестности аванпост ''Род''"

/area/lazarus/outdoors/yarilo
	icon_state = "away2"
	name = "Окрестности аванпост ''Ярило''"

/area/lazarus/outdoors/stribog
	icon_state = "away3"
	name = "Окрестности аванпост ''Стрибог''"

/area/lazarus/outdoors/svarog
	icon_state = "away4"
	name = "Окрестности аванпост ''Сварог''"

/area/lazarus/outdoors/ice_lake
	icon_state = "awaycontent1"
	name = "Замёрзшее озеро"

//-----OUTPOST-----//

/area/lazarus/outpost
	name = "Аванпост комплекса ''Лазарь''"
	icon_state = "crew_quarters"
	sound_environment = SOUND_AREA_STANDARD_STATION

//---ROD---//

/area/lazarus/outpost/rod
	name = "Аванпост ''Род''"

// Living

/area/lazarus/outpost/rod/living
	name = "Жилой отсек (Род)"
	icon_state = "dorms"

/area/lazarus/outpost/rod/living/cryo
	name = "Жилой отсек низкого класса (Род)"

/area/lazarus/outpost/rod/living/a
	name = "Жилой отсек среднего класса 'A' (Род)"

/area/lazarus/outpost/rod/living/b
	name = "Жилой отсек среднего класса 'Б' (Род)"

/area/lazarus/outpost/rod/living/sec
	name = "Жилой отсек среднего класса 'SEC' (Род)"

/area/lazarus/outpost/rod/living/locker
	name = "Комната отдыха (Род)"

// Sec

/area/lazarus/outpost/rod/sec
	name = "Отсек охраны (Род)"
	icon_state = "security"

/area/lazarus/outpost/rod/sec/briefing
	name = "Комната брифинга (Род)"
	icon_state = "securityoffice"

/area/lazarus/outpost/rod/sec/interrogation
	name = "Допросная (Род)"
	icon_state = "interrogation"

/area/lazarus/outpost/rod/sec/arsenal
	name = "Арсенал (Род)"
	icon_state = "armory"

/area/lazarus/outpost/rod/sec/hos
	name = "Офис начальника охраны (Род)"
	icon_state = "hos"

//Other

/area/lazarus/outpost/rod/med
	name = "Медпункт (Род)"
	icon_state = "medbay"

/area/lazarus/outpost/rod/bar
	name = "Бар (Род)"
	icon_state = "bar"

/area/lazarus/outpost/rod/kitchen
	name = "Кухня (Род)"
	icon_state = "kitchen"

/area/lazarus/outpost/rod/botany
	name = "Гидропоника (Род)"
	icon_state = "hydro"

/area/lazarus/outpost/rod/hop
	name = "Офис менеджера комплекса 'Лазарь' (Род)"
	icon_state = "hop"

/area/lazarus/outpost/rod/exit
	name = "Шлюз (Род)"
	icon_state = "entry"

/area/lazarus/outpost/rod/iaa
	name = "Офис юриста (Род)"
	icon_state = "law"

/area/lazarus/outpost/rod/toilet
	name = "Уборная (Род)"
	icon_state = "toilet"

/area/lazarus/outpost/rod/maint
	name = "Подстанция (Род)"
	icon_state = "engi"

