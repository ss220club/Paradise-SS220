/datum/modpack/bureaucracy
	name = "Бюрократия"
	desc = "Добавляет бланки в ксероксе"
	author = "Aylong220, Furior, RV666"

GLOBAL_LIST_INIT(bureaucratic_forms, list())

/datum/modpack/bureaucracy/initialize()
	. = ..()
	for(var/datum/bureaucratic_form/form as anything in subtypesof(/datum/bureaucratic_form))
		GLOB.bureaucratic_forms["[form]"] = new form
