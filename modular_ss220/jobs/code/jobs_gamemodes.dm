/datum/game_mode/changeling/New()
	. = ..()
	protected_jobs |= list("Security Cadet")

/datum/game_mode/cult/New()
	. = ..()
	restricted_jobs |= list("Security Cadet")

/datum/game_mode/revolution/New()
	. = ..()
	restricted_jobs |= list("Security Cadet")

/datum/game_mode/traitor/New()
	. = ..()
	protected_jobs |= list("Security Cadet")

/datum/game_mode/trifecta/New()
	. = ..()
	protected_jobs |= list("Security Cadet")

/datum/game_mode/traitor/vampire/New()
	. = ..()
	protected_jobs |= list("Security Cadet")

/datum/game_mode/vampire/New()
	. = ..()
	protected_jobs |= list("Security Cadet")
