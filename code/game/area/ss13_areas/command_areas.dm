
//Command

/area/station/command
	airlock_wires = /datum/wires/airlock/command
	area_light_color = LIGHT_COLOR_STATION_WORK
	area_nightlight_color = LIGHT_COLOR_STATION_WORK_NIGHT
	area_icon_color = AREA_COLOR_COMMAND

/area/station/command/bridge
	name = "Мостик"
	icon_state = "bridge"
	area_icon_text = "BRIDGE"
	ambientsounds = list('sound/ambience/signal.ogg')
	sound_environment = SOUND_AREA_STANDARD_STATION
	request_console_flags = RC_ASSIST | RC_INFO
	request_console_announces = TRUE

/area/station/command/meeting_room
	name = "Конференц-Зал Командования"
	icon_state = "meeting"
	area_icon_text = "MEET"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR
	request_console_flags = RC_ASSIST | RC_INFO
	request_console_name = "Bridge"
	request_console_announces = TRUE

/area/station/command/office
	area_light_color = LIGHT_COLOR_STATION_OFFICE
	area_nightlight_color = LIGHT_COLOR_STATION_OFFICE_NIGHT

/area/station/command/office/captain
	name = "Офис Капитана"
	icon_state = "captainoffice"
	area_icon_text = "CAPT.\nOFFICE"
	sound_environment = SOUND_AREA_WOODFLOOR
	request_console_flags = RC_ASSIST | RC_INFO
	request_console_name = "Captain's Desk"
	request_console_announces = TRUE

/area/station/command/office/captain/bedroom
	name = "Каюта Капитана"
	icon_state = "captain"
	area_icon_text = "CAPT.\nQUART."

/area/station/command/office/hop
	name = "Кабинет Главы Персонала"
	icon_state = "hop"
	area_icon_text = "HOP"
	request_console_flags = RC_ASSIST | RC_INFO
	request_console_name = "Head of Personnel's Desk"
	request_console_announces = TRUE

/area/station/command/office/rd
	name = "Кабинет Директора Исследований"
	icon_state = "rd"
	area_icon_text = "RD"
	request_console_flags = RC_ASSIST | RC_SUPPLY | RC_INFO
	request_console_name = "Research Director's Desk"
	request_console_announces = TRUE

/area/station/command/office/ce
	name = "Кабинет Главного Инженера"
	icon_state = "ce"
	area_icon_text = "CE"
	request_console_flags = RC_ASSIST | RC_SUPPLY | RC_INFO
	request_console_name = "Chief Engineer's Desk"
	request_console_announces = TRUE

/area/station/command/office/hos
	name = "Кабинет Главы Службы Безопасности"
	icon_state = "hos"
	area_icon_text = "HOS"
	request_console_flags = RC_ASSIST | RC_INFO
	request_console_name = "Head of Security's Desk"
	request_console_announces = TRUE

/area/station/command/office/cmo
	name = "Кабинет Главного Врача"
	icon_state = "CMO"
	area_icon_text = "CMO"
	request_console_flags = RC_ASSIST | RC_INFO
	request_console_name = "Chief Medical Officer's Desk"
	request_console_announces = TRUE

/area/station/command/office/ntrep
	name = "Кабинет Представителя НТ"
	icon_state = "ntrep"
	area_icon_text = "NT\nREP"
	request_console_flags = RC_ASSIST | RC_INFO
	request_console_name = "NT Representative"
	request_console_announces = TRUE

/area/station/command/office/blueshield
	name = "Кабинет Синего Щита"
	icon_state = "blueshield"
	area_icon_text = "BLUE\nSHIELD"
	request_console_flags = RC_ASSIST | RC_INFO
	request_console_name = "Blueshield"
	request_console_announces = TRUE

/area/station/command/office/dignitary
	name = "\improper Dignitary's Office"
	icon_state = "dig_office"
	area_icon_text = "DIG.\nOFFICE"
	request_console_flags = RC_ASSIST | RC_INFO
	request_console_name = "Dignitary"
	request_console_announces = TRUE

/area/station/command/teleporter
	name = "Телепортерная"
	icon_state = "teleporter"
	area_icon_text = "TELE"
	ambientsounds = ENGINEERING_SOUNDS

/area/station/command/vault
	name = "Хранилище"
	icon_state = "nuke_storage"
	area_icon_text = "NUKE"

/area/station/command/server
	name = "Серверная Комната Обработки Сообщений"
	icon_state = "server"
	area_icon_text = "SERVER"
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/station/command/customs
	name = "Контрольно-Пропускной Пункт Командования"
	icon_state = "checkpoint1"
