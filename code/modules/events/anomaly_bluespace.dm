/datum/event/anomaly/anomaly_bluespace
	name = "Bluespace Anomaly"
	startWhen = 3
	announceWhen = 10
	anomaly_path = /obj/effect/anomaly/bluespace
	prefix_message = "На сканерах дальнего действия обнаружена нестабильная блюспейс-аномалия."
	announce_sound = 'sound/AI/anomaly_bluespace.ogg'
	role_weights = list(ASSIGNMENT_SCIENCE = 1, ASSIGNMENT_ENGINEERING = 1)
	role_requirements = list(ASSIGNMENT_SCIENCE = 1, ASSIGNMENT_ENGINEERING = 2)
