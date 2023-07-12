/datum/modpack/example
	/// A string name for the modpack. Used for looking up other modpacks in init.
	name = "Title Screen"
	/// A string desc for the modpack. Can be used for modpack verb list as description.
	desc = "Updates Title Screen to be an image"
	/// A string with authors of this modpack.
	author = "larentoun"

/datum/modpack/example/pre_initialize()
	. = ..()

/datum/modpack/example/initialize()
	. = ..()

/datum/modpack/example/post_initialize()
	. = ..()
