/* Station */
/area/station/security/checkpoint/south
	name = "\proper Южный Контрольно-Пропускной Пункт СБ"

/area/station/security/podpilot
	name = "\proper Pod Pilot Bay"
	icon_state = "security"

/area/station/bridge/checkpoint
	name = "\proper Контрольно-Пропускной Пункт Командования"

/area/station/bridge/checkpoint/north
	name = "\proper Северный Контрольно-Пропускной Пункт Командования"

/area/station/bridge/checkpoint/south
	name = "\proper Южный Контрольно-Пропускной Пункт Командования"

/area/station/engineering/hallway
	name = "\proper Коридор Инженерного Отдела"
	icon_state = "engine_hallway"

/area/station/engineering/dronefabricator
	name = "\proper Комната Изготовления Дронов"
	icon_state = "engi"

/area/station/engineering/emergency
	name = "\proper Engineering Emergency Supplies"
	icon_state = "emergencystorage"

/area/station/engineering/supermatter_room
	name = "\proper Комната Суперматерии"
	icon_state = "engi"

/area/station/engineering/utility
	name = "\proper Инженерная Подсобка"
	icon_state = "engimaint"

/area/station/engineering/mechanic
	name = "\proper Гараж Под Механика"
	icon_state = "engi"

/area/station/engineering/atmos/storage
	name = "\proper Хранилище Атмосферного Отдела"
	icon_state = "atmos"

/area/station/supply/abandoned_boxroom
	name = "\proper Заброшенное Складское Помещение"
	icon_state = "cargobay"

/area/station/public/pool
	name = "\proper Бассейн"
	icon_state = "dorms"

/area/station/public/vacant_store
	name = "\proper Вакантный Офис"
	icon = 'modular_ss220/maps220/icons/areas.dmi'
	icon_state = "vacantstore"

/area/station/maintenance/dormitory_maintenance
	name = "\proper Технические Тоннели Дормиториев"
	icon_state = "smaint"

/area/station/maintenance/old_kitchen
	name = "\proper Старая Кухня"
	icon_state = "kitchen"

/area/station/maintenance/old_detective
	name = "\proper Старый офис Детектива"
	icon_state = "detective"

/area/station/maintenance/virology_maint
	name = "\proper Технические Тоннели Вирусологии. Строительная Зона"
	icon_state = "smaint"

/area/station/hallway/secondary/exit/maintenance
	name = "\proper Заброшенный Коридор Эвакуационного Шаттла"
	icon_state = "escape"

/* CentCom */
/area/centcom/ss220
	name = "\proper ЦК"
	icon_state = "centcom"
	requires_power = FALSE
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	nad_allowed = TRUE

/area/centcom/ss220/evac
	name = "\proper ЦК - Эвакуационный шаттл"
	icon_state = "centcom_evac"

/area/centcom/ss220/park
	name = "\proper ЦК - Парк"
	icon_state = "centcom"

/area/centcom/ss220/bar
	name = "\proper ЦК - Бар"
	icon_state = "centcom"

/area/centcom/ss220/general
	name = "\proper ЦК - Зона персонала"
	icon_state = "centcom"

/area/centcom/ss220/supply
	name = "\proper ЦК - Доставка"
	icon_state = "centcom_supply"

/area/centcom/ss220/admin1
	name = "\proper ЦК - Коридоры ЦК"
	icon_state ="centcom"

/area/centcom/ss220/admin2
	name = "\proper ЦК - Офисы"
	icon_state = "centcom"

/area/centcom/ss220/admin3
	name = "\proper ЦК - ОБР"
	icon_state = "centcom_specops"

/area/centcom/ss220/medbay
	name = "\proper ЦК - Лазарет"
	icon_state = "centcom"

/area/centcom/ss220/court
	name = "\proper ЦК - Зал суда"
	icon_state = "centcom"

/area/centcom/ss220/library
	name = "\proper ЦК - Библиотека"
	icon_state = "centcom"

/area/centcom/ss220/command
	name = "\proper ЦК - Командный центр"
	icon_state = "centcom_ctrl"

/area/centcom/ss220/jail
	name = "\proper ЦК - Тюрьма"
	icon_state = "centcom"

/* Syndicate Base - Mothership */
/area/syndicate_mothership
	name = "\proper Syndicate Forward Base"
	icon = 'modular_ss220/maps220/icons/areas.dmi'
	icon_state = "syndie-ship"
	requires_power = FALSE
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	nad_allowed = TRUE
	ambientsounds = HIGHSEC_SOUNDS

/area/syndicate_mothership/outside
	name = "\proper Syndicate Controlled Territory"
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	icon_state = "syndie-outside"

/area/syndicate_mothership/control
	name = "\proper Syndicate Control Room"
	icon_state = "syndie-control"

/area/syndicate_mothership/elite_squad
	name = "\proper Syndicate Elite Squad"
	icon_state = "syndie-elite"

/area/syndicate_mothership/infteam
	name = "\proper Syndicate Infiltrators"
	icon_state = "syndie-infiltrator"

/area/syndicate_mothership/jail
	name = "\proper Syndicate Jail"
	icon_state = "syndie-jail"

/area/syndicate_mothership/cargo
	name = "\proper Syndicate Cargo"
	icon_state = "syndie-cargo"
