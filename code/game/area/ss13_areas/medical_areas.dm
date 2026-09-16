
/area/station/medical
	ambientsounds = MEDICAL_SOUNDS
	sound_environment = SOUND_AREA_STANDARD_STATION
	min_ambience_cooldown = 90 SECONDS
	max_ambience_cooldown = 180 SECONDS
	airlock_wires = /datum/wires/airlock/medbay
	area_icon_color = AREA_COLOR_MEDBAY

/area/station/medical/medbay
	name = "Медицинский Отдел"
	icon_state = "medbay"
	area_icon_text = "MED"
	request_console_flags = RC_ASSIST

//Medbay is a large area, these additional areas help level out APC load.
/area/station/medical/medbay2
	name = "Медицинский Отдел"
	icon_state = "medbay"
	area_icon_text = "MED"

/area/station/medical/medbay3
	name = "Медицинский Отдел"
	icon_state = "medbay"
	area_icon_text = "MED"

/area/station/medical/storage
	name = "Склад Медицинского Отдела"
	icon_state = "medbaystorage"
	area_icon_text = "MED\nSTORE"
	request_console_flags = RC_ASSIST
	request_console_name = "Медицинский Отдел"

/area/station/medical/reception
	name = "Ресепшен Медицинского Отдела"
	icon_state = "medbaylobby"
	area_icon_text = "MED\nLOBBY"
	request_console_flags = RC_ASSIST
	request_console_name = "Медицинский Отдел"

/area/station/medical/psych
	name = "Офис Психолога"
	icon_state = "medbaypsych"
	area_icon_text = "PSYCH"
	request_console_flags = RC_SUPPLY
	request_console_name = "Psychiatrist"

/area/station/medical/break_room
	name = "Комната Отдыха Медицинского Отдела"
	icon_state = "medbaybreak"
	area_icon_text = "MED\nBREAK"

/area/station/medical/patients_rooms
	name = "Психиатрические Палаты"
	icon_state = "patients"
	area_icon_text = "PATIENT\nROOM"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/station/medical/patients_rooms1
	name = "Палаты Пациентов"
	icon_state = "patients"
	area_icon_text = "PATIENT\nROOM"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/station/medical/patients_rooms_secondary
	name = "Вспомогательные Палаты Пациентов"
	icon_state = "patients"
	area_icon_text = "PATIENT\nROOM"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/station/medical/coldroom
	name = "Морозильная Камера Медицинского Отдела"
	icon_state = "coldroom"
	area_icon_text = "COLD\nROOM"

/area/station/medical/storage/secondary
	name = "Дополнительный Склад Медицинского Отдела"
	icon_state = "medbaysecstorage"
	area_icon_text = "MED\n2ND\nSTORE"

/area/station/medical/virology
	name = "Вирусология"
	icon_state = "virology"
	area_icon_text = "VIRO"
	request_console_flags = RC_ASSIST | RC_SUPPLY

/area/station/medical/virology/lab
	name = "Лаборатория Вирусологии"

/area/station/medical/morgue
	name = "Морг"
	icon_state = "morgue"
	area_icon_text = "MORGUE"
	ambientsounds = SPOOKY_SOUNDS
	is_haunted = TRUE
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	request_console_flags = RC_ASSIST | RC_INFO

/area/station/medical/chemistry
	name = "Химическая Лаборатория Медицинского Отдела"
	icon_state = "chem"
	area_icon_text = "MED\nCHEM"
	request_console_flags = RC_ASSIST | RC_SUPPLY

/area/station/medical/surgery
	name = "Операционное Отделение"
	icon_state = "surgery"
	area_icon_text = "SURGERY"

/area/station/medical/surgery/primary
	name = "Первая Операционная"
	icon_state = "surgery1"
	area_icon_text = "SURGERY\nONE"

/area/station/medical/surgery/secondary
	name = "Вторая Операционная"
	icon_state = "surgery2"
	area_icon_text = "SURGERY\nTWO"

/area/station/medical/surgery/observation
	name = "Комната Оперативного Наблюдения"

/area/station/medical/cryo
	name = "Криогеника"
	icon_state = "cryo"
	area_icon_text = "CRYO"

/area/station/medical/exam_room
	name = "Комната Осмотра Медицинского Отдела"
	icon_state = "exam_room"
	area_icon_text = "EXAM\nROOM"

/area/station/medical/cloning
	name = "Лаборатория Клонирования"
	icon_state = "cloning"
	area_icon_text = "CLONE"

/area/station/medical/sleeper
	name = "Центр Медицинского Лечения"
	icon_state = "exam_room"

/area/station/medical/paramedic
	name = "Офис Парамедика"
	icon_state = "paramedic"
	area_icon_text = "PARA\nMED"
	request_console_flags = RC_ASSIST
