// Atmos
/area/station/engineering/atmos
	name = "Атмосферный Отдел"
	icon_state = "atmos"

/area/station/engineering/atmos/control
	name = "Комната Контроля Атмосферы"
	icon_state = "atmosctrl"

/area/station/engineering/atmos/distribution
	name = "Atmospherics Distribution Loop"
	icon_state = "atmos"

// general engineering
/area/station/engineering
	ambientsounds = ENGINEERING_SOUNDS
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/station/engineering/smes
	name = "\improper Инженерные СМЕСы"
	icon_state = "engine_smes"
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED

/area/station/engineering/control
	name = "Инженерный Отдел"
	icon_state = "engine_control"

/area/station/engineering/break_room
	name = "\improper Фойе Инженерного Отдела"
	icon_state = "engibreak"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/engineering/break_room/secondary
	name = "\improper Secondary Engineering Foyer"

/area/station/engineering/equipmentstorage
	name = "Инженерный Склад Снаряжения"
	icon_state = "engilocker"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/engineering/hardsuitstorage
	name = "\improper Инженерный Склад ВКД"
	icon_state = "engi"

/area/station/engineering/controlroom
	name = "\improper Инженерная Комната Управления"
	icon_state = "engine_monitoring"

/area/station/engineering/gravitygenerator
	name = "\improper Генератор Гравитации"
	icon_state = "gravgen"

/area/station/engineering/ai_transit_tube
	name = "\improper Транзитная Труба Спутника ИИ"
	icon_state = "ai"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

// engine areas

/area/station/engineering/engine
	name = "\improper Engine"
	icon_state = "engine"

/area/station/engineering/engine/supermatter
	name = "\improper Двигатель Суперматерии"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

//Solars

/area/station/engineering/solar
	requires_power = FALSE
	valid_territory = FALSE
	dynamic_lighting = DYNAMIC_LIGHTING_IFSTARLIGHT
	ambientsounds = ENGINEERING_SOUNDS
	sound_environment = SOUND_AREA_SPACE

/area/station/engineering/solar/auxport
	name = "\improper Fore Port Solar Array"
	icon_state = "FPsolars"

/area/station/engineering/solar/auxstarboard
	name = "\improper Fore Starboard Solar Array"
	icon_state = "FSsolars"

/area/station/engineering/solar/fore
	name = "\improper Fore Solar Array"
	icon_state = "yellow"

/area/station/engineering/solar/aft
	name = "\improper Aft Solar Array"
	icon_state = "aft"

/area/station/engineering/solar/starboard
	name = "\improper Starboard Solar Array"
	icon_state = "ASsolars"

/area/station/engineering/solar/starboard/aft
	name = "\improper Aft Starboard Solar Array"
	icon_state = "ASsolars"

/area/station/engineering/solar/port
	name = "\improper Aft Port Solar Array"
	icon_state = "APsolars"

/area/station/engineering/secure_storage
	name = "Инженерное Защищенное Хранилище"
	icon_state = "engine_storage"

/area/station/engineering/tech_storage
	name = "Техническое Хранилище"
	icon_state = "techstorage"
