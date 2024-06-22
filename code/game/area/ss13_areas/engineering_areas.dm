// Atmos
/area/station/engineering/atmos
	name = "Атмосферный Отдел"
	icon_state = "atmos"

/area/station/engineering/atmos/control
	name = "Комната Контроля Атмосферы"
	icon_state = "atmosctrl"

/area/station/engineering/atmos/distribution
	name = "Атмосферный Распределительный Контур"
	icon_state = "atmos"

// general engineering
/area/station/engineering
	ambientsounds = ENGINEERING_SOUNDS
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/station/engineering/smes
	name = "Инженерные СМЕСы"
	icon_state = "engine_smes"
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED

/area/station/engineering/control
	name = "Инженерный Отдел"
	icon_state = "engine_control"

/area/station/engineering/break_room
	name = "Фойе Инженерного Отдела"
	icon_state = "engibreak"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/engineering/break_room/secondary
	name = "Дополнительное Фойе Инженерного Отдела"

/area/station/engineering/equipmentstorage
	name = "Инженерный Склад Снаряжения"
	icon_state = "engilocker"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/engineering/hardsuitstorage
	name = "Инженерный Склад ВКД"
	icon_state = "engi"

/area/station/engineering/controlroom
	name = "Инженерная Комната Управления"
	icon_state = "engine_monitoring"

/area/station/engineering/gravitygenerator
	name = "Генератор Гравитации"
	icon_state = "gravgen"

/area/station/engineering/ai_transit_tube
	name = "Транзитная Труба Спутника ИИ"
	icon_state = "ai"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

// engine areas

/area/station/engineering/engine
	name = "Двигатель"
	icon_state = "engine"

/area/station/engineering/engine/supermatter
	name = "Двигатель Суперматерии"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

//Solars

/area/station/engineering/solar
	requires_power = FALSE
	valid_territory = FALSE
	dynamic_lighting = DYNAMIC_LIGHTING_IFSTARLIGHT
	ambientsounds = ENGINEERING_SOUNDS
	sound_environment = SOUND_AREA_SPACE

/area/station/engineering/solar/auxport
	name = "Северо-Западные Солнечные Панели"
	icon_state = "FPsolars"

/area/station/engineering/solar/auxstarboard
	name = "Северо-Восточные Солнечные Панели"
	icon_state = "FSsolars"

/area/station/engineering/solar/starboard
	name = "Восточные Солнечные Панели"
	icon_state = "Ssolars"

/area/station/engineering/solar/starboard/aft
	name = "Юго-Восточные Солнечные Панели"
	icon_state = "ASsolars"

/area/station/engineering/solar/port
	name = "Юго-Западные Солнечные Панели"
	icon_state = "APsolars"

/area/station/engineering/secure_storage
	name = "Инженерное Защищенное Хранилище"
	icon_state = "engine_storage"

/area/station/engineering/tech_storage
	name = "Техническое Хранилище"
	icon_state = "techstorage"
