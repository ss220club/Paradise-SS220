/datum/modpack/DoItAdmin
	/// A string name for the modpack. Used for looking up other modpacks in init.
	name = "Make yourself"
	/// A string desc for the modpack. Can be used for modpack verb list as description.
	desc = "Набор всяких приколюх с более открытой логикой для спавна и настройки без влезания в сборку"
	/// A string with authors of this modpack.
	author = "Tetra_del"

/datum/modpack/example/initialize()
	. = ..()
	#define ANNOUNCE_VIS_LIVING    (1 << 0)  // 1  — живые
	#define ANNOUNCE_VIS_GHOSTS    (1 << 1)  // 2  — госты (мёртвые с клиентом)
	#define ANNOUNCE_VIS_LOBBY     (1 << 2)  // 4  — игроки в лобби
	#define ANNOUNCE_VIS_SILICONS  (1 << 3)  // 8  — синтетики (ИИ, борги)
	#define ANNOUNCE_VIS_OBSERVERS (1 << 4)  // 16 — обсерверы (observer-мобы, если есть отдельно)

	#define ANNOUNCE_VIS_ALL       (ANNOUNCE_VIS_LIVING | ANNOUNCE_VIS_GHOSTS | ANNOUNCE_VIS_LOBBY | ANNOUNCE_VIS_SILICONS | ANNOUNCE_VIS_OBSERVERS)
	#define ANNOUNCE_VIS_DEFAULT   (ANNOUNCE_VIS_LIVING | ANNOUNCE_VIS_GHOSTS)

/datum/modpack/example/pre_initialize()
	. = ..()

/datum/modpack/example/post_initialize()
	. = ..()
