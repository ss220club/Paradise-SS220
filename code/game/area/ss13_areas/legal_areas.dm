/area/station/legal
	airlock_wires = /datum/wires/airlock/security
	area_icon_color = AREA_COLOR_LEGAL

/area/station/legal/courtroom
	name = "Зал Суда"
	icon_state = "courtroom"
	area_icon_text = "COURT\nROOM"
	request_console_flags = RC_ASSIST | RC_SUPPLY

/area/station/legal/courtroom/gallery
	name = "Галерея Зала Суда"
	request_console_name = "Courtroom"

/area/station/legal/lawoffice
	name = "Юридический Отдел"
	icon_state = "law"
	area_icon_text = "LAW\nOFFICE"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR
	request_console_name = "Internal Affairs Office"
	area_light_color = LIGHT_COLOR_STATION_OFFICE
	area_nightlight_color = LIGHT_COLOR_STATION_OFFICE_NIGHT

/area/station/legal/magistrate
	name = "Офис Магистрата"
	icon_state = "magistrate"
	area_icon_text = "MAGI"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR
	request_console_flags = RC_ASSIST | RC_INFO
	request_console_name = "Magistrate"
	area_light_color = LIGHT_COLOR_STATION_OFFICE
	area_nightlight_color = LIGHT_COLOR_STATION_OFFICE_NIGHT

/area/station/legal/legaloffice
	name = "\improper Legal Office"
	icon_state = "legal"
	area_icon_text = "LEGAL\nOFFICE"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR
	request_console_flags = RC_ASSIST | RC_INFO
	request_console_name = "Legal Office"
	area_light_color = LIGHT_COLOR_STATION_OFFICE
	area_nightlight_color = LIGHT_COLOR_STATION_OFFICE_NIGHT
