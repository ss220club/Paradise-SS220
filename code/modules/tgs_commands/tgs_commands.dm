/datum/tgs_chat_command/tgscheck
	name = "check"
	help_text = "Gets the playercount, gamemode, and address of the server"

/datum/tgs_chat_command/tgscheck/Run(datum/tgs_chat_user/sender, params)
	return new /datum/tgs_message_content("[GLOB.round_id ? "Round #[GLOB.round_id]: " : ""][GLOB.clients.len] players. \nGamemode: [GLOB.master_mode]. \nMap: [station_name()]. \ Round [SSticker.HasRoundStarted() ? (SSticker.IsRoundInProgress() ? "Active" : "Finishing") : "Starting"] -- [GLOB.configuration.general.server_name] - [GLOB.configuration.url.server_url]")

/datum/tgs_chat_command/tgsinfo
	name = "info"
	help_text = "Gets the playercount, gamemode, and address of the server"

/datum/tgs_chat_command/tgsinfo/Run(datum/tgs_chat_user/sender, params)
	var/list/staff_counts = get_online_staff_counts()

	var/status = "**[GLOB.round_id ? "Round #[GLOB.round_id]" : ""]**\n"
	status += "**Players ([GLOB.clients.len]):** [english_list(GLOB.clients)]\n"
	status += "**Active Players:** [get_active_player_count()]\n"
	status += "**Living Players:** [get_living_players_count()]\n\n"

	status += "**Admins: [staff_counts["admins"]]**\n"
	status += "**Mentors: [staff_counts["mentors"]]**\n"
	status += "**Developers: [staff_counts["developers"]]**\n\n"

	status += "**Gamemode:** [GLOB.master_mode]\n"
	status += "**Map:** [station_name()]\n\n"

	status += "**Status:** [SSticker.HasRoundStarted() ? (SSticker.IsRoundInProgress() ? "Active" : "Finishing") : "Starting"]\n"
	status += "**Name:** [GLOB.configuration.general.server_name]\n"
	status += "**Address:** [GLOB.configuration.url.server_url]"
	return new /datum/tgs_message_content(status)
