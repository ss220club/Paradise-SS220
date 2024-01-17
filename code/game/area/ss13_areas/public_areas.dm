// Contains the public areas of the station, such has hallways and dorms


// Hallways

/area/station/hallway
	valid_territory = FALSE //too many areas with similar/same names, also not very interesting summon spots
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/station/hallway/primary/fore
	name = "\improper Основной Коридор"
	icon_state = "hallF"

/area/station/hallway/primary/fore/west
	name = "\improper Основной Западный Коридор"

/area/station/hallway/primary/fore/east
	name = "\improper Основной Восточный Коридор"

/area/station/hallway/primary/fore/north
	name = "\improper Основной Северный Коридор"

/area/station/hallway/primary/fore/south
	name = "\improper Основной Восточный Коридор"

/area/station/hallway/primary/starboard
	name = "\improper Основной Коридор Правого Борта"
	icon_state = "hallS"

/area/station/hallway/primary/starboard/west
	name = "\improper Starboard West Hallway"

/area/station/hallway/primary/starboard/east
	name = "\improper Starboard East Hallway"

/area/station/hallway/primary/starboard/north
	name = "\improper Starboard North Hallway"

/area/station/hallway/primary/starboard/south
	name = "\improper Starboard South Hallway"

/area/station/hallway/primary/aft
	name = "\improper Основной Коридор Кормы"
	icon_state = "hallA"

/area/station/hallway/primary/aft/west
	name = "\improper Aft West Hallway"

/area/station/hallway/primary/aft/east
	name = "\improper Aft East Hallway"

/area/station/hallway/primary/aft/north
	name = "\improper Aft North Hallway"

/area/station/hallway/primary/aft/south
	name = "\improper Aft South Hallway"


/area/station/hallway/primary/port
	name = "\improper Основной Коридор Порта"
	icon_state = "hallP"

/area/station/hallway/primary/port/west
	name = "\improper Port West Hallway"

/area/station/hallway/primary/port/east
	name = "\improper Port East Hallway"

/area/station/hallway/primary/port/north
	name = "\improper Port North Hallway"

/area/station/hallway/primary/port/south
	name = "\improper Port South Hallway"

/area/station/hallway/primary/central
	name = "\improper Центральный Основной Коридор"
	icon_state = "hallC"

/area/station/hallway/primary/central/north
/area/station/hallway/primary/central/south
/area/station/hallway/primary/central/west
/area/station/hallway/primary/central/east
/area/station/hallway/primary/central/nw
/area/station/hallway/primary/central/ne
/area/station/hallway/primary/central/sw
/area/station/hallway/primary/central/se

/area/station/hallway/spacebridge
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	icon_state = "hall_space"

/area/station/hallway/spacebridge/dockmed
	name = "Docking-Medical Bridge"

/area/station/hallway/spacebridge/scidock
	name = "Science-Docking Bridge"

/area/station/hallway/spacebridge/servsci
	name = "Service-Science Bridge"

/area/station/hallway/spacebridge/serveng
	name = "Service-Engineering Bridge"

/area/station/hallway/spacebridge/engmed
	name = "Engineering-Medical Bridge"

/area/station/hallway/spacebridge/medcargo
	name = "Medical-Cargo Bridge"

/area/station/hallway/spacebridge/cargocom
	name = "Cargo-AI-Command Bridge"

/area/station/hallway/spacebridge/sercom
	name = "Command-Service Bridge"

/area/station/hallway/spacebridge/comeng
	name = "Command-Engineering Bridge"

/area/station/hallway/secondary/exit
	name = "\improper Коридор Эвакуационного Шаттла"
	icon_state = "escape"

/area/station/hallway/secondary/garden
	name = "\improper Сад"
	icon_state = "garden"

/area/station/hallway/secondary/entry
	name = "\improper Коридор Шаттла Прибытия"
	icon_state = "entry"

/area/station/hallway/secondary/entry/north

/area/station/hallway/secondary/entry/south

/area/station/hallway/secondary/entry/lounge
	name = "\improper Зал Прибытия"

/area/station/hallway/secondary/bridge
	name = "\improper Коридор Командования"
	icon_state = "hallC"
// Other public areas


/area/station/public/dorms
	name = "\improper Дормитории"
	icon_state = "dorms"
	sound_environment = SOUND_AREA_STANDARD_STATION


/area/crew_quarters/toilet/aux
	name = "\improper Auxiliary Toilets"

/area/station/public/sleep
	name = "\improper Криохранилище Дормиторий"
	icon_state = "Sleep"
	valid_territory = FALSE

/area/station/public/sleep/secondary
	name = "\improper Secondary Cryogenic Dormitories"
	icon_state = "Sleep"

/area/station/public/sleep_male
	name = "\improper Male Dorm"
	icon_state = "Sleep"

/area/station/public/sleep_female
	name = "\improper Female Dorm"
	icon_state = "Sleep"

/area/station/public/locker
	name = "\improper Раздевалка"
	icon_state = "locker"

/area/station/public/toilet
	name = "\improper Туалеты Дормиториев"
	icon_state = "toilet"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/public/toilet/male
	name = "\improper Male Toilets"

/area/station/public/toilet/female
	name = "\improper Female Toilets"

/area/station/public/toilet/unisex
	name = "\improper Unisex Restroom"

/area/station/public/toilet/lockerroom
	name = "\improper Locker Toilets"

/area/station/public/fitness
	name = "\improper Комната Для Фитнеса"
	icon_state = "fitness"

/area/station/public/arcade
	name = "\improper Аркада"
	icon_state = "arcade"

/area/station/public/mrchangs
	name = "\improper Офис Мистера Чанга"
	icon_state = "changs"

/area/station/public/clothing
	name = "\improper Магазин Одежды"
	icon_state = "Theatre"

/area/station/public/pet_store
	name = "\improper Магазин Питомцев"
	icon_state = "pet_store"

/area/station/public/vacant_office
	name = "\improper Вакантный Офис"
	icon_state = "vacantoffice"

/area/station/public/vacant_office/secondary

//Storage
/area/station/public/storage
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/station/public/storage/tools/auxiliary
	name = "Вспомогательное Хранилище Инструментов"
	icon_state = "auxstorage"

/area/station/public/storage/tools
	name = "Основное Хранилище Инструментов"
	icon_state = "primarystorage"

/area/station/public/storage/autolathe
	name = "Autolathe Storage"
	icon_state = "storage"

/area/station/public/storage/art
	name = "Art Supply Storage"
	icon_state = "storage"

/area/station/public/storage/emergency
	name = "Starboard Emergency Storage"
	icon_state = "emergencystorage"

/area/station/public/storage/emergency/port
	name = "Port Emergency Storage"
	icon_state = "emergencystorage"

/area/station/public/storage/office
	name = "Office Supplies"
	icon_state = "office_supplies"

/area/station/public/recreation
	name = "\improper Recreation Area"

/area/station/public/construction
	name = "\improper Зона Для Строительства"
	icon_state = "construction"
	ambientsounds = ENGINEERING_SOUNDS
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/station/public/quantum/security
	name = "Security Quantum Pad"

/area/station/public/quantum/docking
	name = "Docking Quantum Pad"

/area/station/public/quantum/science
	name = "Science Quantum Pad"

/area/station/public/quantum/cargo
	name = "Cargo Quantum Pad"
