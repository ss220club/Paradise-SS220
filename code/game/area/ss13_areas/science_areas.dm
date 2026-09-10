// Robotics areas

/area/station/science/robotics
	name = "Робототехника"
	icon_state = "robo"
	area_icon_text = "ROBO"
	request_console_flags = RC_SUPPLY
	request_console_name = "Robotics"

/area/station/science/robotics/chargebay
	name = "Мех. Отсек РНД"
	icon_state = "mechbay"
	area_icon_text = "MECH\nBAY"

/area/station/science/robotics/showroom
	name = "Салон Робототехники"
	icon_state = "showroom"
	area_icon_text = "SHOW\nROOM"

/area/station/science/research
	name = "Отдел Исследований"
	icon_state = "sci"
	area_icon_text = "SCI"

/area/station/science/lobby
	name = "Фойе Отдела Исследований"
	icon_state = "sci"

/area/station/science/testrange
	name = "Отдел Исследовательских Испытаний"
	icon_state = "sci"

/area/station/science/break_room
	name = "Комната Отдыха РНД"
	icon_state = "scibreak"
	area_icon_text = "SCI\nBREAK"

/area/station/science/genetics
	name = "Лаборатория Генетики"
	icon_state = "genetics"
	area_icon_text = "GENES"
	request_console_flags = RC_ASSIST
	request_console_name = "Genetics"

/area/station/science
	sound_environment = SOUND_AREA_STANDARD_STATION
	airlock_wires = /datum/wires/airlock/science
	area_icon_color = AREA_COLOR_SCIENCE

/area/station/science/rnd
	name = "Отдел Исследований"
	icon_state = "rnd"
	area_icon_text = "RND"
	request_console_flags = RC_SUPPLY
	request_console_name = "Science"

/area/station/science/hallway
	name = "Коридор РНД"
	icon_state = "sci"

/area/station/science/xenobiology
	name = "Лаборатория Ксенобиологии"
	icon_state = "xenobio"
	area_icon_text = "XENO\nBIO"
	xenobiology_compatible = TRUE
	request_console_flags = RC_ASSIST | RC_INFO
	request_console_name = "Xenobiology"

/area/station/science/storage
	name = "Хранилище Токсинов РНД"
	icon_state = "toxstorage"
	area_icon_text = "TOXINS\nSTORE"

/area/station/science/toxins/test
	name = "Тестовая Комната Токиснов РНД"
	icon_state = "toxtest"
	area_icon_text = "TOXINS\nTEST"
	valid_territory = FALSE

/area/station/science/toxins/mixing
	name = "Комната Смешивания Токсинов РНД"
	icon_state = "toxmix"
	area_icon_text = "TOXINS\nMIXING"
	request_console_flags = RC_SUPPLY
	request_console_name = "Science"

/area/station/science/toxins/launch
	name = "Комната Запуска Токсинов РНД"
	icon_state = "toxlaunch"
	area_icon_text = "TOXINS\nLAUNCH"
	request_console_flags = RC_SUPPLY
	request_console_name = "Science"

/area/station/science/misc_lab
	name = "Лаборатория Химии РНД"
	icon_state = "scichem"
	area_icon_text = "SCI\nCHEM"
	request_console_flags = RC_SUPPLY
	request_console_name = "Science"

/area/station/science/test_chamber
	name = "Камера Химии РНД"
	icon_state = "scitest"
	area_icon_text = "SCI\nTEST"

/area/station/science/server
	name = "Серверная Комната"
	icon_state = "server"
	airlock_wires = /datum/wires/airlock/command // Like every one has command doors.

/area/station/science/server/coldroom
	name = "Холодильная Камера Серверной"
	icon_state = "servercold"
	area_icon_text = "SERVER\nCOLD"
