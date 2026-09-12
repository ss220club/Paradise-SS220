// CENTCOM

/area/centcom
	name = "\improper Centcom"
	icon_state = "centcom"
	area_icon_text = "CC"
	area_icon_color = AREA_COLOR_CENTCOM
	requires_power = FALSE
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	nad_allowed = TRUE

/area/centcom/control
	name = "\improper Centcom Control"
	icon_state = "centcom_ctrl"
	area_icon_text = "CC\nCTRL"

/area/centcom/evac
	name = "\improper Centcom Emergency Shuttle"
	icon_state = "centcom_evac"
	area_icon_text = "CC\nEVAC"

/area/centcom/suppy
	name = "\improper Centcom Supply Shuttle"
	icon_state = "centcom_supply"
	area_icon_text = "CC\nSUPPLY"

/area/centcom/ferry
	name = "\improper Centcom Transport Shuttle"
	icon_state = "centcom_ferry"
	area_icon_text = "CC\nFERRY"

/area/centcom/shuttle
	name = "\improper Centcom Administration Shuttle"

/area/centcom/test
	name = "\improper Centcom Testing Facility"

/area/centcom/living
	name = "\improper Centcom Living Quarters"

/area/centcom/specops
	name = "\improper Centcom Special Ops"
	icon_state = "centcom_specops"
	area_icon_text = "CC\nSPEC\nOPS"

/area/centcom/gamma
	name = "\improper Centcom Gamma Armory"
	icon_state = "centcom_gamma"
	area_icon_text = "CC\nGAMMA"

/area/centcom/holding
	name = "\improper Holding Facility"

/area/centcom/bathroom
	name = "\improper Centcom Emergency Shuttle Bathrooms"

/area/centcom/docks
	name = "\improper Central Command Docks"

// Admin areas

/area/admin
	name = "\improper Admin Room"
	icon_state = "start"
	requires_power = FALSE
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	hide_attacklogs = TRUE


/area/adminconstruction
	name = "\improper Admin Testing Area"
	icon_state = "start"
	requires_power = FALSE
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	hide_attacklogs = TRUE

//EXTRA

/area/tdome
	name = "Тандердом"
	icon_state = "thunder"
	area_icon_text = "TDOME"
	area_icon_color = AREA_COLOR_AWAY1
	requires_power = FALSE
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	hide_attacklogs = TRUE


/area/tdome/arena_source
	name = "Тандердом - Шаблон Арены"

/area/tdome/arena
	name = "Тандердом - Арена"

/area/tdome/tdomeadmin
	name = "Тандердом - Комната Управления"
	icon_state = "purple"

/area/tdome/tdomeobserve
	name = "Тандердом - Трибуны"
	icon_state = "purple"

// Other Areas on centcom z level

/area/abductor_ship
	name = "Корабль Абдукторов"
	icon_state = "yellow"
	requires_power = FALSE

/area/wizard_station
	name = "Логово Волшебника"
	icon_state = "yellow"
	requires_power = FALSE
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED

/area/ninja
	name = "\improper Ninja Area Parent"
	icon_state = "ninjabase"
	area_icon_text = "NINJA"
	area_icon_color = AREA_COLOR_AWAY1
	requires_power = FALSE
	no_teleportlocs = TRUE
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED

/area/ninja/outpost
	name = "Аванпост Клана Паука"

/area/ninja/holding
	name = "Убежище Клана Паука"

/area/trader_station
	name = "Торговая Станция"
	icon_state = "yellow"
	requires_power = FALSE
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED

/area/trader_station/sol
	name = "Торговая Станция ТСФ"

/area/ghost_bar
	name = "Призрачный Бар"
	icon_state = "observatory"
	area_icon_text = "OBSERV."
	area_icon_color = AREA_COLOR_AWAY1
	requires_power = FALSE
	hide_attacklogs = TRUE

/area/backrooms
	name = "Закулисье"
	icon_state = "yellow"
	requires_power = FALSE
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
