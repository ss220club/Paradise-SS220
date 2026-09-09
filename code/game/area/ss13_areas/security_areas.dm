
/area/station/security
	ambientsounds = HIGHSEC_SOUNDS
	sound_environment = SOUND_AREA_STANDARD_STATION
	airlock_wires = /datum/wires/airlock/security
	area_icon_color = AREA_COLOR_SECURITY
	area_light_color = LIGHT_COLOR_STATION_WORK
	area_nightlight_color = LIGHT_COLOR_STATION_WORK_NIGHT

/area/station/security/main
	name = "Офис Службы Безопасности"
	icon_state = "securityoffice"
	area_icon_text = "SEC\nOFFICE"
	request_console_flags = RC_ASSIST | RC_INFO
	request_console_name = "Security"

/area/station/security/lobby
	name = "Лобби Службы Безопасности"
	icon_state = "securitylobby"
	area_icon_text = "SEC\nLOBBY"

/area/station/security/brig
	name = "Бриг"
	icon_state = "brig"
	area_icon_text = "BRIG"
	request_console_flags = RC_ASSIST | RC_INFO
	request_console_name = "Security"

/area/station/security/brig/prison_break()
	for(var/obj/structure/closet/secure_closet/brig/temp_closet in src)
		temp_closet.locked = FALSE
		temp_closet.close()
	for(var/obj/machinery/door_timer/temp_timer in src)
		temp_timer.releasetime = 1
	..()

/area/station/security/permabrig
	name = "Тюремное Крыло. Пермабриг"
	icon_state = "sec_prison_perma"
	area_icon_text = "PRISON\nPERMA"
	fast_despawn = TRUE
	can_get_auto_cryod = FALSE

/area/station/security/prison
	name = "Тюремное Крыло"
	icon_state = "sec_prison"
	area_icon_text = "PRISON"
	can_get_auto_cryod = FALSE

/area/station/security/prison/prison_break()
	for(var/obj/structure/closet/secure_closet/brig/temp_closet in src)
		temp_closet.locked = FALSE
		temp_closet.close()
		temp_closet.update_icon()
	for(var/obj/machinery/door_timer/temp_timer in src)
		temp_timer.releasetime = 1
	..()

/area/station/security/prison/cell_block
	name = "Тюремный Блок"
	icon_state = "brig"

/area/station/security/prison/cell_block/a
	name = "Тюремный Блок А"
	icon_state = "brigcella"
	area_icon_text = "CELL\nBLOCK\nA"

/area/station/security/execution
	name = "Комната Казни"
	icon_state = "execution"
	area_icon_text = "EXECUTE"
	can_get_auto_cryod = FALSE

/area/station/security/processing
	name = "Процедурная Службы Безопасности"
	icon_state = "prisonerprocessing"
	area_icon_text = "PRISON\nPROCESS"
	can_get_auto_cryod = FALSE

/area/station/security/interrogation
	name = "Допросная"
	icon_state = "interrogation"
	area_icon_text = "INTERR."
	can_get_auto_cryod = FALSE

/area/station/security/storage
	name = "Склад Снаряжения Службы Безопасности"
	icon_state = "securityequipmentstorage"
	area_icon_text = "SEC\nEQUIP\nSTORE"
	request_console_flags = RC_ASSIST | RC_INFO
	request_console_name = "Security"

/area/station/security/evidence
	name = "Комната Хранения Улик"
	icon_state = "evidence"
	area_icon_text = "EVIDENCE"

/area/station/security/prisonlockers
	name = "Комната Шкафов Заключенных"
	icon_state = "sec_prison_lockers"
	area_icon_text = "PRISON\nLOCKER"
	can_get_auto_cryod = FALSE

/area/station/security/prisonershuttle
	name = "Челнок Службы Безопасности Для Заключенных"
	icon_state = "security"
	area_icon_text = "SEC"
	can_get_auto_cryod = FALSE

/area/station/security/warden
	name = "Офис Смотрителя"
	icon_state = "Warden"
	area_icon_text = "WARDEN"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR
	request_console_flags = RC_ASSIST | RC_SUPPLY | RC_INFO
	request_console_name = "Warden"

/area/station/security/armory
	name = "Оружейная"
	icon_state = "armory"
	area_icon_text = "ARMORY"

/area/station/security/armory/secure
	name = "Защищенная Оружейная"
	icon_state = "secarmory"
	area_icon_text = "SECURE\nARMORY"
	request_console_flags = RC_ASSIST | RC_SUPPLY | RC_INFO
	request_console_name = "Warden"

/area/station/security/detective
	name = "Офис Детектива"
	icon_state = "detective"
	area_icon_text = "DET\nOFFICE"
	ambientsounds = list('sound/ambience/ambidet1.ogg', 'sound/ambience/ambidet2.ogg')
	request_console_flags = RC_ASSIST | RC_INFO
	request_console_name = "Detective"

/area/station/security/range
	name = "Стрельбище"
	icon_state = "firingrange"
	area_icon_text = "FIRING\nRANGE"

/area/station/security/defusal
	name = "Учебный Сапёрный Пункт"
	icon_state = "defusal"
	area_icon_text = "DEF"

/area/station/security/gamma_dock_access
	name = "\improper Gamma Armory Dock Access"
	icon_state = "gamma_access"
	area_icon_text = "GAMMA\nACCESS"

/area/station/security/gamma_dock
	name = "\improper Gamma Armory Dock"
	icon_state = "gamma_dock"
	area_icon_text = "GAMMA\nDOCK"

// Checkpoints

/area/station/security/checkpoint
	name = "Контрольно-Пропускной Пункт Службы Безопасности"
	icon_state = "checkpoint1"
	area_icon_text = "SEC\nCHECK\nPOINT"

/area/station/security/checkpoint/secondary
	request_console_flags = RC_ASSIST | RC_INFO
	request_console_name = "Security"

// Solitary
/area/station/security/permasolitary
	name = "Одиночная Камера"
	icon_state = "solitary"
	area_icon_text = "SOLITARY"
