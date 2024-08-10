#define SPY_SPIDER_FREQ 1251

/datum/modpack/prime_only
	name = "Эксклюзивы прайма"
	desc = "Всё что попросили стримеры эксклюзивно для прайма."
	author = "dj-34, Vallat и все кто сюда полез в принципе."

/datum/modpack/prime_only/pre_initialize()
	. = ..()

/datum/modpack/prime_only/initialize()
	. = ..()
	SSradio.radiochannels |= list("Spy Spider" = SPY_SPIDER_FREQ)

/datum/modpack/prime_only/post_initialize()
	. = ..()
