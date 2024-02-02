/datum/game_mode/changeling/New()
	. = ..()
	protected_jobs |= GLOB.restricted_jobs_ss220

/datum/game_mode/cult/New()
	. = ..()
	restricted_jobs |= GLOB.restricted_jobs_ss220

/datum/game_mode/revolution/New()
	. = ..()
	restricted_jobs |= GLOB.restricted_jobs_ss220

/datum/game_mode/traitor/New()
	. = ..()
	protected_jobs |= GLOB.restricted_jobs_ss220

/datum/game_mode/trifecta/New()
	. = ..()
	protected_jobs |= GLOB.restricted_jobs_ss220

/datum/game_mode/traitor/vampire/New()
	. = ..()
	protected_jobs |= GLOB.restricted_jobs_ss220

/datum/game_mode/vampire/New()
	. = ..()
	protected_jobs |= GLOB.restricted_jobs_ss220

// antag mix scenarious
/datum/antag_scenario/traitor/New()
	. = ..()
	protected_roles |= GLOB.restricted_jobs_ss220

/datum/antag_scenario/changeling/New()
	. = ..()
	protected_roles |= GLOB.restricted_jobs_ss220

/datum/antag_scenario/vampire/New()
	. = ..()
	protected_roles |= GLOB.restricted_jobs_ss220

/datum/antag_scenario/team/blood_brothers/New()
	. = ..()
	protected_roles |= GLOB.restricted_jobs_ss220
