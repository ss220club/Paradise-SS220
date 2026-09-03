/datum/tgs_chat_command/tgscheck
	name = "check"
	help_text = "Gets the playercount, gamemode, and address of the server"

/datum/tgs_chat_command/tgscheck/Run(datum/tgs_chat_user/sender, params)
	var/server = GLOB.configuration.general.server_name
	return new /datum/tgs_message_content("[GLOB.round_id ? "Round #[GLOB.round_id]: " : ""][GLOB.clients.len] players. \nGamemode: [GLOB.master_mode]. \nMap: [station_name()]. \ Round [SSticker.HasRoundStarted() ? (SSticker.IsRoundInProgress() ? "Active" : "Finishing") : "Starting"] -- [server ? server : "[world.internet_address]:[world.port]"]")

/datum/tgs_chat_command/tgsinfo
	name = "info"
	help_text = "Gets the playercount, gamemode, and address of the server"

/datum/tgs_chat_command/tgsinfo/Run(datum/tgs_chat_user/sender, params)
	var/server = GLOB.configuration.general.server_name
	var/list/admin = get_admin_counts()
	var/list/all_admin = admin["total"]
	var/status = "**[GLOB.round_id ? "Round #[GLOB.round_id]" : ""]**\n"
	status += "**Players ([GLOB.clients.len]):** [english_list(GLOB.clients)]\n"
	status += "**Active Players:** [get_active_player_count()]\n"
	status += "**Living Players:** [get_living_players_count()]\n\n"
	status += "**Admins: ([num_admins_online])**\n"
	status += "**Mentors: ([num_mentors_online])]\n"
	status += "**Developers: ([num_devs_online])]\n\n"
	status += "**Gamemode:** [GLOB.master_mode]\n"
	status += "**Map:** [station_name()]\n\n"
	status += "**Status:** [SSticker.HasRoundStarted() ? (SSticker.IsRoundInProgress() ? "Active" : "Finishing") : "Starting"]\n"
	status += "**Address:** [server ? server : "[world.internet_address]:[world.port]"]"
	return new /datum/tgs_message_content(status)
