
// MARK: Directionals
/area/station/maintenance
	ambientsounds = MAINTENANCE_SOUNDS
	valid_territory = FALSE
	sound_environment = SOUND_AREA_TUNNEL_ENCLOSED
	airlock_wires = /datum/wires/airlock/maint
	area_icon_color = AREA_COLOR_MAINTENANCE

/area/station/maintenance/engimaint
	name = "Технические Тоннели Инженерии"
	icon_state = "engimaint"
	area_icon_text = "ENGI\nMAINT"

/area/station/maintenance/medmaint
	name = "Технические Тоннели Медицинского Отдела"
	icon_state = "medmaint"
	area_icon_text = "MED\nMAINT"

/area/station/maintenance/fpmaint
	name = "Северо-Западные Технические Тоннели"
	icon_state = "fpmaint"
	area_icon_text = "FORE\nPORT\nMAINT"


/area/station/maintenance/fpmaint2
	name = "Вспомогательные Северо-Западные Технические Тоннели"
	icon_state = "fpmaint"
	area_icon_text = "FORE\nPORT\nMAINT"

/area/station/maintenance/fsmaint
	name = "Северо-Восточные Технические Тоннели"
	icon_state = "fsmaint"
	area_icon_text = "FORE\nSTBD\nMAINT"

/area/station/maintenance/fsmaint2
	name = "Вспомогательные Северо-Восточные Технические Тоннели"
	icon_state = "fsmaint"
	area_icon_text = "FORE\nSTBD\nMAINT"

/area/station/maintenance/asmaint
	name = "Юго-Восточные Технические Тоннели"
	icon_state = "asmaint"
	area_icon_text = "AFT\nSTBD\nMAINT"

/area/station/maintenance/asmaint2
	name = "Вспомогательные Юго-Восточные Технические Тоннели"
	icon_state = "asmaint"
	area_icon_text = "AFT\nSTBD\nMAINT"

/area/station/maintenance/apmaint
	name = "Юго-Западные Технические Тоннели"
	icon_state = "apmaint"
	area_icon_text = "AFT\nPORT\nMAINT"

/area/station/maintenance/apmaint2
	name = "Вспомогательные Юго-Западные Технические Тоннели"
	icon_state = "apmaint"
	area_icon_text = "AFT\nPORT\nMAINT"

/area/station/maintenance/maintcentral
	name = "Центральные Технические Тоннели"
	icon_state = "maintcentral"
	area_icon_text = "CENT\nMAINT"

/area/station/maintenance/maintcentral2
	name = "Вспомогательные Центральные Технические Тоннели"
	icon_state = "maintcentral"

/area/station/maintenance/fore
	name = "Северные Технические Тоннели"
	icon_state = "fmaint"
	area_icon_text = "FORE\nMAINT"

/area/station/maintenance/fore2
	name = "Вспомогательные Северные Технические Тоннели"
	icon_state = "fmaint"

/area/station/maintenance/aft
	name = "Южные Технические Тоннели"
	icon_state = "amaint"
	area_icon_text = "AFT\nMAINT"

/area/station/maintenance/aft2
	name = "Вспомогательные Южные Технические Тоннели"
	icon_state = "amaint"
	area_icon_text = "AFT\nMAINT"

/area/station/maintenance/starboard
	name = "Восточные Технические Тоннели"
	icon_state = "smaint"
	area_icon_text = "STBD\nMAINT"

/area/station/maintenance/starboard2
	name = "Вспомогательные Восточные Технические Тоннели"
	icon_state = "smaint"
	area_icon_text = "STBD\nMAINT"

/area/station/maintenance/port
	name = "Западные Технические Тоннели"
	icon_state = "pmaint"
	area_icon_text = "PORT\nMAINT"

/area/station/maintenance/port2
	name = "Вспомогательные Западные Технические Тоннели"
	icon_state = "pmaint"
	area_icon_text = "PORT\nMAINT"

/area/station/maintenance/storage
	name = "Технические Тоннели Турбины"
	icon_state = "atmosmaint"
	area_icon_text = "ATMOS\nMAINT"

/area/station/engineering/atmos/asteroid_maint
	name = "Asteroid Filtering Maintenance"
	icon_state = "asteroid_maint"
	area_icon_text = "ASTER\nOID\nMAINT"
	area_icon_color = AREA_COLOR_ENGI_ASTEROID

/area/station/maintenance/xenobio_north
	name = "Xenobiology North Maintenance"
	icon_state = "xenobio_north_maint"
	area_icon_text = "NORTH\nXENO\nMAINT"

/area/station/maintenance/xenobio_south
	name = "Xenobiology South Maintenance"
	icon_state = "xenobio_south_maint"
	area_icon_text = "SOUTH\nXENO\nMAINT"

// MARK: Maint Rooms
/area/station/maintenance/assembly_line
	name = "\improper Assembly Line"
	icon_state = "ass_line"
	area_icon_text = "ASS.\nLINE"
	apc_starts_off = TRUE

/area/station/maintenance/abandoned_garden
	name = "\improper Abandoned Garden"
	icon_state = "hydro"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/maintenance/library
	name = "\improper Abandoned Library"
	icon_state = "library"
	apc_starts_off = TRUE

/area/station/maintenance/abandoned_office
	name = "\improper Abandoned Office"
	icon_state = "abandoned_office"
	area_icon_text = "CLOSED\nOFFICE"
	apc_starts_off = TRUE

/area/station/maintenance/electrical_shop
	name = "\improper Electronics Den"
	icon_state = "elect"
	area_icon_text = "ELECT"
	area_icon_color = AREA_COLOR_ENGINEERING

/area/station/maintenance/gambling_den
	name = "\improper Gambling Den"
	icon_state = "gambling_den"
	area_icon_text = "GAME\nDEN"
	area_icon_color = AREA_COLOR_SERVICE

/area/station/maintenance/theatre
	name = "\improper Abandoned Theatre"
	icon_state = "Theatre"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/station/maintenance/electrical
	name = "\improper Electrical Maintenance"
	icon_state = "elect"
	area_icon_text = "ELECT"
	area_icon_color = AREA_COLOR_ENGINEERING

/area/station/maintenance/incinerator
	name = "Мусоросжигатель"
	icon_state = "incin"
	area_icon_text = "INCIN"
	area_icon_color = AREA_COLOR_SUPPLY

/area/station/maintenance/electrical/fore
	name = "Fore Electrical Maintenance"

/area/station/maintenance/electrical/aft
	name = "Aft Electrical Maintenance"

/area/station/maintenance/electrical/port
	name = "Port Electrical Maintenance"

/area/station/maintenance/electrical/starboard
	name = "Starboard Electrical Maintenance"

/area/station/maintenance/electrical/fore_port
	name = "Fore Port Electrical Maintenance"

/area/station/maintenance/electrical/aft_port
	name = "Aft Port Electrical Maintenance"

/area/station/maintenance/electrical/fore_starboard
	name = "Fore Starboard Electrical Maintenance"

/area/station/maintenance/electrical/aft_starboard
	name = "Aft Starboard Electrical Maintenance"

/area/station/maintenance/abandonedbar
	name = "Заброшенный Бар"
	icon_state = "oldbar"
	area_icon_text = "OLD\nBAR"
	apc_starts_off = TRUE

/area/station/maintenance/abandonedservers
	name = "Заброшенная Серверная"
	icon_state = "oldserver"
	area_icon_text = "OLD\nSERVER"
	apc_starts_off = TRUE

/area/station/maintenance/spacehut
	name = "Космическая Хижина"
	icon_state = "spacehut"
	area_icon_text = "SPACE\nHUT"
	apc_starts_off = TRUE

/area/station/maintenance/turbine
	name = "Турбина"
	icon_state = "turbine"
	area_icon_text = "TURBIN"
	area_icon_color = AREA_COLOR_ENGINEERING

// MARK: Solars
/area/station/maintenance/solar_maintenance
	name = "Пункт Контроля Солнечных Панелей"
	icon_state = "general_solar_control"
	area_icon_text = "SOLAR\nCTRL"

/area/station/maintenance/solar_maintenance/fore
	name = "Пункт Контроля Северных Солнечных Панелей"
	icon_state = "fore_solar_control"
	area_icon_text = "FORE\nSOLAR\nCTRL"

/area/station/maintenance/solar_maintenance/fore_starboard
	name = "Пункт Контроля Северо-Восточных Солнечных Панелей"
	icon_state = "fore_starboard_solar_control"
	area_icon_text = "FORE\nSTBD\nSOLAR\nCTRL"

/area/station/maintenance/solar_maintenance/fore_port
	name = "Пункт Контроля Северо-Западных Солнечных Панелей"
	icon_state = "fore_port_solar_control"
	area_icon_text = "FORE\nPORT\nSOLAR\nCTRL"

/area/station/maintenance/solar_maintenance/aft
	name = "Пункт Контроля Южных Солнечных Панелей"
	icon_state = "aft_solar_control"
	area_icon_text = "AFT\nSOLAR\nCTRL"

/area/station/maintenance/solar_maintenance/aft_starboard
	name = "Пункт Контроля Юго-Восточных Солнечных Панелей"
	icon_state = "aft_starboard_solar_control"
	area_icon_text = "AFT\nSTBD\nSOLAR\nCTRL"

/area/station/maintenance/solar_maintenance/aft_port
	name = "Пункт Контроля Юго-Западных Солнечных Панелей"
	icon_state = "aft_port_solar_control"
	area_icon_text = "AFT\nPORT\nSOLAR\nCTRL"

/area/station/maintenance/solar_maintenance/starboard
	name = "Пункт Контроля Восточных Солнечных Панелей"
	icon_state = "starboard_solar_control"
	area_icon_text = "STBD\nSOLAR\nCTRL"

/area/station/maintenance/solar_maintenance/port
	name = "Пункт Контроля Западных Солнечных Панелей"
	icon_state = "port_solar_control"
	area_icon_text = "PORT\nSOLAR\nCTRL"

// MARK: Disposals
/area/station/maintenance/disposal
	name = "Комната Утилизации"
	icon_state = "disposals"
	area_icon_text = "DISPOS."
	area_icon_color = AREA_COLOR_SUPPLY

/area/station/maintenance/disposal/southwest
	name = "Юго-Западный Мусоропровод"

/area/station/maintenance/disposal/south
	name = "Южный Мусоропровод"

/area/station/maintenance/disposal/east
	name = "Восточный Мусоропровод"

/area/station/maintenance/disposal/northeast
	name = "Северо-Восточный Мусоропровод"

/area/station/maintenance/disposal/north
	name = "Северный Мусоропровод"

/area/station/maintenance/disposal/northwest
	name = "Северо-Западный Мусоропровод"

/area/station/maintenance/disposal/west
	name = "Западный Мусоропровод"

/area/station/maintenance/disposal/westalt
	name = "Вспомогательный Западный Мусоропровод"

/area/station/maintenance/disposal/external/southwest
	name = "Внешний Юго-Западный Мусоропровод"

/area/station/maintenance/disposal/external/southeast
	name = "Внешний Юго-Восточный Мусоропровод"

/area/station/maintenance/disposal/external/north
	name = "Внешний Северный Мусоропровод"

// MARK: Dorms
/area/station/maintenance/dorms
	name = "Технические Тоннели Дормиториев"
	icon_state = "dorms_maint"
	area_icon_text = "DORMS\nMAINT"

/area/station/maintenance/dorms/port
	name = "Западные Технические Тоннели Дормиториев"
	icon_state = "dorms_maint_port"
	area_icon_text = "DORMS\nMAINT\nPORT"

/area/station/maintenance/dorms/starboard
	name = "Восточные Технические Тоннели Дормиториев"
	icon_state = "dorms_maint_starboard"
	area_icon_text = "DORMS\nMAINT\nSTAR"

/area/station/maintenance/dorms/aft
	name = "Южные Технические Тоннели Дормиториев"
	icon_state = "dorms_maint_aft"
	area_icon_text = "DORMS\nMAINT\nAFT"

/area/station/maintenance/dorms/fore
	name = "Северные Технические Тоннели Дормиториев"
	icon_state = "dorms_maint_fore"
	area_icon_text = "DORMS\nMAINT\nFORE"

// MARK: Command
/area/station/maintenance/command
	name = "Технические Тоннели Мостика"
	icon_state = "cmd_maint"
	area_icon_text = "CMD\nMAINT"

/area/station/maintenance/command/fore
	name = "Северные Технические Тоннели Мостика"
	icon_state = "cmd_maint_fore"
	area_icon_text = "CMD\nMAINT\nFORE"

/area/station/maintenance/command/fore_starboard
	name = "Северо-Восточные Технические Тоннели Мостика"
	icon_state = "cmd_maint_fore_starboard"
	area_icon_text = "CMD\nMAINT\nFORE\nSTBD"

/area/station/maintenance/command/fore_port
	name = "Северо-Западные Технические Тоннели Мостика"
	icon_state = "cmd_maint_fore_port"
	area_icon_text = "CMD\nMAINT\nFORE\nPORT"

/area/station/maintenance/command/aft
	name = "Южные Технические Тоннели Мостика"
	icon_state = "cmd_maint_aft"
	area_icon_text = "CMD\nMAINT\nAFT"

/area/station/maintenance/command/aft_starboard
	name = "Юго-Восточные Технические Тоннели Мостика"
	icon_state = "cmd_maint_aft_starboard"
	area_icon_text = "CMD\nMAINT\nAFT\nSTBD"

/area/station/maintenance/command/aft_port
	name = "Юго-Западные Технические Тоннели Мостика"
	icon_state = "cmd_maint_aft_port"
	area_icon_text = "CMD\nMAINT\nAFT\nPORT"

/area/station/maintenance/command/starboard
	name = "Восточные Технические Тоннели Мостика"
	icon_state = "cmd_maint_starboard"
	area_icon_text = "CMD\nMAINT\nSTBD"

/area/station/maintenance/command/port
	name = "Западные Технические Тоннели Мостика"
	icon_state = "cmd_maint_port"
	area_icon_text = "CMD\nMAINT\nPORT"

// MARK: Security
/area/station/maintenance/security
	name = "Технические Тоннели Брига"
	icon_state = "sec_maint"
	area_icon_text = "SEC\nMAINT"

/area/station/maintenance/security/fore
	name = "Северные Технические Тоннели Брига"
	icon_state = "sec_maint_fore"
	area_icon_text = "SEC\nMAINT\nFORE"

/area/station/maintenance/security/fore_starboard
	name = "Северо-Восточные Технические Тоннели Брига"
	icon_state = "sec_maint_fore_starboard"
	area_icon_text = "SEC\nMAINT\nFORE\nSTBD"

/area/station/maintenance/security/fore_port
	name = "Северо-Западные Технические Тоннели Брига"
	icon_state = "sec_maint_fore_port"
	area_icon_text = "SEC\nMAINT\nFORE\nPORT"

/area/station/maintenance/security/aft
	name = "Южные Технические Тоннели Брига"
	icon_state = "sec_maint_aft"
	area_icon_text = "SEC\nMAINT\nAFT"

/area/station/maintenance/security/aft_starboard
	name = "Юго-Восточные Технические Тоннели Брига"
	icon_state = "sec_maint_aft_starboard"
	area_icon_text = "SEC\nMAINT\nAFT\nSTBD"

/area/station/maintenance/security/aft_port
	name = "Юго-Западные Технические Тоннели Брига"
	icon_state = "sec_maint_aft_port"
	area_icon_text = "SEC\nMAINT\nAFT\nPORT"

/area/station/maintenance/security/starboard
	name = "Восточные Технические Тоннели Брига"
	icon_state = "sec_maint_starboard"
	area_icon_text = "SEC\nMAINT\nSTBD"

/area/station/maintenance/security/port
	name = "Западные Технические Тоннели Брига"
	icon_state = "sec_maint_port"
	area_icon_text = "SEC\nMAINT\nPORT"

// MARK: Service
/area/station/maintenance/service
	name = "Технические Тоннели Сервиса"
	icon_state = "serv_maint"
	area_icon_text = "SERV\nMAINT"

/area/station/maintenance/service/fore
	name = "Северные Технические Тоннели Сервиса"
	icon_state = "serv_maint_fore"
	area_icon_text = "SERV\nMAINT\nFORE"

/area/station/maintenance/service/fore_starboard
	name = "Северо-Восточные Технические Тоннели Сервиса"
	icon_state = "serv_maint_fore_starboard"
	area_icon_text = "SERV\nMAINT\nFORE\nSTBD"

/area/station/maintenance/service/fore_port
	name = "Северо-Западные Технические Тоннели Сервиса"
	icon_state = "serv_maint_fore_port"
	area_icon_text = "SERV\nMAINT\nFORE\nPORT"

/area/station/maintenance/service/aft
	name = "Южные Технические Тоннели Сервиса"
	icon_state = "serv_maint_aft"
	area_icon_text = "SERV\nMAINT\nAFT"

/area/station/maintenance/service/aft_starboard
	name = "Юго-Восточные Технические Тоннели Сервиса"
	icon_state = "serv_maint_aft_starboard"
	area_icon_text = "SERV\nMAINT\nAFT\nSTBD"

/area/station/maintenance/service/aft_port
	name = "Юго-Западные Технические Тоннели Сервиса"
	icon_state = "serv_maint_aft_port"
	area_icon_text = "SERV\nMAINT\nAFT\nPORT"

/area/station/maintenance/service/starboard
	name = "Восточные Технические Тоннели Сервиса"
	icon_state = "serv_maint_starboard"
	area_icon_text = "SERV\nMAINT\nSTBD"

/area/station/maintenance/service/port
	name = "Западные Технические Тоннели Сервиса"
	icon_state = "serv_maint_port"
	area_icon_text = "SERV\nMAINT\nPORT"

// MARK: Science
/area/station/maintenance/science
	name = "\improper Science Maintenance"
	icon_state = "sci_maint"
	area_icon_text = "SCI\nMAINT"

/area/station/maintenance/science/fore
	name = "\improper Fore Science Maintenance"
	icon_state = "sci_maint_fore"
	area_icon_text = "SCI\nMAINT\nFORE"

/area/station/maintenance/science/fore_starboard
	name = "\improper Fore-Starboard Science Maintenance"
	icon_state = "sci_maint_fore_starboard"
	area_icon_text = "SCI\nMAINT\nFORE\nSTBD"

/area/station/maintenance/science/fore_port
	name = "\improper Fore-Port Science Maintenance"
	icon_state = "sci_maint_fore_port"
	area_icon_text = "SCI\nMAINT\nFORE\nPORT"

/area/station/maintenance/science/aft
	name = "\improper Aft Science Maintenance"
	icon_state = "sci_maint_aft"
	area_icon_text = "SCI\nMAINT\nAFT"

/area/station/maintenance/science/aft_starboard
	name = "\improper Aft-Starboard Science Maintenance"
	icon_state = "sci_maint_aft_starboard"
	area_icon_text = "SCI\nMAINT\nAFT\nSTBD"

/area/station/maintenance/science/aft_port
	name = "\improper Aft-Port Science Maintenance"
	icon_state = "sci_maint_aft_port"
	area_icon_text = "SCI\nMAINT\nAFT\nPORT"

/area/station/maintenance/science/starboard
	name = "\improper Starboard Science Maintenance"
	icon_state = "sci_maint_starboard"
	area_icon_text = "SCI\nMAINT\nSTBD"

/area/station/maintenance/science/port
	name = "\improper Port Science Maintenance"
	icon_state = "sci_maint_port"
	area_icon_text = "SCI\nMAINT\nPORT"
