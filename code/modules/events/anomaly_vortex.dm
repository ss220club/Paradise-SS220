/datum/event/anomaly/anomaly_vortex
	name = "Vortex Anomaly"
	startWhen = 10
	announceWhen = 3
	anomaly_path = /obj/effect/anomaly/bhole
	prefix_message = "На сканерах дальнего действия обнаружена вихревая аномалия высокой интенсивности."
	announce_sound = 'sound/AI/anomaly_vortex.ogg'
	role_weights = list(ASSIGNMENT_SCIENCE = 1, ASSIGNMENT_ENGINEERING = 1)
	role_requirements = list(ASSIGNMENT_SCIENCE = 1, ASSIGNMENT_ENGINEERING = 3)
