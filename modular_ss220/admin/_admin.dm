/datum/modpack/admin
	name = "Инструменты для админов"
	desc = "Различные улучшения и добавления в админском инструментарии"
	author = "furior"

/datum/modpack/admin/initialize()
	GLOB.admin_verbs_server |= /client/proc/view_pingstat
