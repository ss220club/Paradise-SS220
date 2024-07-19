/datum/language/treacherous_flesh
	name = "Разум Улья Биомофров"
	desc = "Биоморфы удивительным образом способны общаться на большие растояния при помощи испускаемых ими радиоволн."
	speech_verb = "says"
	colour = "changeling"
	key = "~"
	flags = RESTRICTED | HIVEMIND | NOBABEL
	follow = TRUE

/datum/language/treacherous_flesh/broadcast(mob/living/speaker, message, speaker_mask)
	..(speaker, message)
