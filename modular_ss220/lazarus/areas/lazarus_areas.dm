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

	temperature = AREA_TEMPERATURE_OUTSIDE

/area/lazarus/outdoors/rod
	icon_state = "awaycontent1"
	name = "Окрестности аванпост ''Род''"

/area/lazarus/outdoors/yarilo
	icon_state = "awaycontent2"
	name = "Окрестности аванпост ''Ярило''"

/area/lazarus/outdoors/stribog
	icon_state = "awaycontent3"
	name = "Окрестности аванпост ''Стрибог''"

/area/lazarus/outdoors/svarog
	icon_state = "awaycontent4"
	name = "Окрестности аванпост ''Сварог''"

/area/lazarus/outdoors/veles
	icon_state = "awaycontent5"
	name = "Окрестности аванпост ''Велес''"

/area/lazarus/outdoors/ice_lake
	icon_state = "away1"
	name = "Замёрзшее озеро"

//-----MISC LOCATIONS-----//

//---Cabins---//

/area/lazarus/cabin
	icon_state = "oldbar"
	name = "Хижина в лесу"
	sound_environment = SOUND_AREA_WOODFLOOR

	temperature = AREA_TEMPERATURE_INSIDE

/area/lazarus/cabin/crusader
	name = "Хижина крестоносца"

/area/lazarus/cabin/bar
	name = "Тайный бар"

//---Other---//

//Geotherm

/area/lazarus/geotherm
	name = "Геотермальная электростанция"
	icon_state = "engine"
	sound_environment = SOUND_AREA_STANDARD_STATION

	temperature = AREA_TEMPERATURE_INSIDE

/area/lazarus/geotherm/rod
	name = "Геотермальная электростанция (Род)"

/area/lazarus/geotherm/yarilo
	name = "Геотермальная электростанция (Ярило)"

/area/lazarus/geotherm/stribog
	name = "Геотермальная электростанция (Стрибог)"

/area/lazarus/geotherm/svarog
	name = "Геотермальная электростанция (Сварог)"

/area/lazarus/geotherm/veles
	name = "Геотермальная электростанция (Велес)"

//-----OUTPOST-----//

/area/lazarus/outpost
	name = "Аванпост комплекса ''Лазарь''"
	icon_state = "crew_quarters"
	sound_environment = SOUND_AREA_STANDARD_STATION

	temperature = AREA_TEMPERATURE_INSIDE

//---ROD---//

/area/lazarus/outpost/rod
	name = "Аванпост ''Род''"

// Living

/area/lazarus/outpost/rod/living
	name = "Жилой отсек (Род)"
	icon_state = "dorms"

/area/lazarus/outpost/rod/living/cryo
	name = "Жилой отсек низкого класса (Род)"
	icon_state = "cryo"

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

//---YARILO---//

/area/lazarus/outpost/yarilo
	name = "Аванпост ''Ярило''"

// Living

/area/lazarus/outpost/yarilo/living
	name = "Жилой отсек (Ярило)"
	icon_state = "dorms"

/area/lazarus/outpost/yarilo/living/cryo
	name = "Жилой отсек низкого класса (Ярило)"
	icon_state = "cryo"

/area/lazarus/outpost/yarilo/living/locker
	name = "Комната отдыха (Ярило)"

/area/lazarus/outpost/yarilo/living/dinner
	name = "Столовая (Ярило)"
	icon_state = "kitchen"

// Med

/area/lazarus/outpost/yarilo/med
	name = "Медбей (Ярило)"
	icon_state = "medbay"

/area/lazarus/outpost/yarilo/med/exam
	name = "Медбей (Ярило)"
	icon_state = "exam_room"

/area/lazarus/outpost/yarilo/med/chem
	name = "Химия (Ярило)"
	icon_state = "chem"

/area/lazarus/outpost/yarilo/med/surgery
	name = "Хирургия (Ярило)"
	icon_state = "surgery"

/area/lazarus/outpost/yarilo/med/cmo
	name = "Офис главного врача (Ярило)"
	icon_state = "CMO"

/area/lazarus/outpost/yarilo/med/cryo
	name = "Отсек криогеники (Ярило)"
	icon_state = "cryo"

/area/lazarus/outpost/yarilo/med/virology
	name = "Вирусология (Ярило)"
	icon_state = "virology"

/area/lazarus/outpost/yarilo/med/morgue
	name = "Морг (Ярило)"
	icon_state = "morgue"

// Engi

/area/lazarus/outpost/yarilo/engi
	name = "Инженерия (Ярило)"
	icon_state = "engi"

/area/lazarus/outpost/yarilo/engi/storage
	name = "Малый склад (Ярило)"
	icon_state = "engine_storage"

/area/lazarus/outpost/yarilo/engi/storage/secured
	name = "Главный склад (Ярило)"

/area/lazarus/outpost/yarilo/engi/power
	name = "Главный склад (Ярило)"
	icon_state = "engine"

/area/lazarus/outpost/yarilo/engi/ce
	name = "Главный склад (Ярило)"
	icon_state = "ce"

//Other

/area/lazarus/outpost/yarilo/exit
	name = "Шлюз (Ярило)"
	icon_state = "entry"

/area/lazarus/outpost/yarilo/toilet
	name = "Уборная (Ярило)"
	icon_state = "toilet"

//---STRIBOG---//

/area/lazarus/outpost/stribog
	name = "Аванпост ''Стрибог''"

/area/lazarus/outpost/stribog/storage
	name = "Склад (Стрибог)"
	icon_state = "storage"

/area/lazarus/outpost/stribog/landing
	name = "Посадочная площадка (Стрибог)"
	icon_state = "escape"

/area/lazarus/outpost/stribog/maint
	name = "Подстанция (Стрибог)"
	icon_state = "engi"
