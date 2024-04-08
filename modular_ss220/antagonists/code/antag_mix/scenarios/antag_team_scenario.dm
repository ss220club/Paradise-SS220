/datum/antag_scenario/team
	/// Path of team, that antags will be joined to. This is required property.
	var/datum/team/antag_team = /datum/team
	/// Size the team should match.
	var/team_size = 1
	/// List of lists of player's minds, picked for teams. Each nested list represents one team.
	var/list/picked_teams = list()


/datum/antag_scenario/team/pre_execute(population)
	if(!ispath(antag_team))
		error("'antag_team' in '[type]' team antag scenario is '[antag_team]' which is invalid.")
		log_debug("'antag_team' in '[type]' team antag scenario is '[antag_team]' which is invalid.")

	var/max_teams = FLOOR((get_total_antag_cap(population) / team_size), 1)
	message_admins("Max teams: [max_teams]")
	log_debug("Max teams: [max_teams]")
	if(!max_teams)
		log_debug("Max teams: ERROR; team_size: [team_size]; antag_cap: [get_total_antag_cap(population)]; population: [population]")
		return FALSE

	var/teams_before = length(picked_teams)
	modif_chance_recommended_species()
	for(var/i in 1 to max_teams)
		var/list/datum/mind/members = list()
		for(var/j in 1 to team_size)
			if(!length(candidates))
				log_debug("Antag scenario team 'candidates' null length")
				break

			var/string_names = ""
			for(var/mob/new_player/c in candidates)
				string_names += "[c.name](ckey:[c.ckey]), "
			log_debug("pre_execute: length(candidates): [length(candidates)]; candidates: [string_names];")

			var/mob/new_player/team_member = pickweight(candidates)
			candidates.Remove(team_member)
			if(!team_member || !team_member.mind)
				error("For some reason 'null' or mindless candidate was present in [type] 'candidates' list")
				log_debug("For some reason 'null' or mindless candidate was present in [type] 'candidates' list.")
				continue

			var/datum/mind/chosen_mind = team_member.mind
			log_debug("pre_execute mind: [team_member.ckey], [chosen_mind.name], [chosen_mind.current ? "[chosen_mind.current.real_name]" : ""]")
			chosen_mind.special_role = antag_special_role
			if(!is_crew_antag)
				chosen_mind.assigned_role = antag_special_role
			chosen_mind.restricted_roles |= restricted_roles

			members += chosen_mind
			assigned |= chosen_mind

		var/string_names = ""
		for(var/datum/mind/m in members)
			string_names += "[m.name](ckey:[ckey(m.key)]), "
		log_debug("pre_execute: members: [string_names];")

		var/string_names_ass = ""
		for(var/datum/mind/m in assigned)
			string_names_ass += "[m.name](ckey:[ckey(m.key)]), "
		log_debug("pre_execute: assigned: [string_names_ass];")

		message_admins("Members: [json_encode(members)]")
		// If for some reason, not enough members were found - we will try again
		if(team_size > length(members))
			max_teams++
			message_admins("Picked team of: [json_encode(members)]")
			log_debug("Picked team of: [json_encode(members)]")
			picked_teams += list(members)

	if(!(length(picked_teams) - teams_before > 0))
		log_debug("pre_execute team == [length(picked_teams) - teams_before > 0]: [length(picked_teams)], [teams_before], [max_teams]. ")
	return length(picked_teams) - teams_before > 0


/datum/antag_scenario/team/execute()
	for(var/list/team_members in picked_teams)
		if(!length(team_members))
			error("Invalid antag scenario team execute - not enough team_members.")
			continue

		message_admins("Creating team of [json_encode(team_members)]")
		var/datum/team/new_team = new antag_team(team_members, FALSE)
		for(var/datum/mind/team_member as anything in new_team.members)
			team_member.add_antag_datum(antag_datum, new_team)
		if(!is_crew_antag)
			try_make_characters(new_team.members)

	return TRUE
