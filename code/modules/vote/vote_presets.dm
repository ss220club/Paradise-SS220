#define PLAYER "playing"
#define PLAYED "dead"
#define GHOST "ghost"
#define LOBBY "in lobby"
#define UNKNOWN "unknown"
#define YES "Инициировать эвакуацию"
#define NO "Продолжить раунд"

// Crew transfer vote
/datum/vote/crew_transfer
	question = "Окончание смены"
	choices = list("Инициировать эвакуацию", "Продолжить раунд")
	vote_type_text = "эвакуацию"
	/// Amount of players on the server
	var/clients
	/// Assoc list of clients and their types
	var/list/client_types = list(PLAYER = list(), PLAYED = list(), GHOST = list(), LOBBY = list(), UNKNOWN = list())
	/// Holder for blackbox. Contains ckey, client type and vote. Doesn't include those who didn't vote
	var/list/player_data = list()
	/// Players that voted
	var/total_votes = 0
	/// Players that didn't vote
	var/didnt_vote = 0

/datum/vote/crew_transfer/New()
	if(SSticker.current_state < GAME_STATE_PLAYING)
		CRASH("Попытка вызвать голосование за шаттл до начала!")
	..()

/datum/vote/crew_transfer/handle_result(result)
	if(result == "Инициировать эвакуацию")
		init_shift_change(null, TRUE)
	if(assign_votes())
		SSblackbox.record_feedback("associative", "crew_transfer", 1, list(
			"clients" = clients,
			"total_votes" = total_votes,
			"didnt_vote" = didnt_vote,
			"player_data" = player_data,
		), ignore_seal = TRUE)

/datum/vote/crew_transfer/start()
	..()
	assign_players()

/datum/vote/crew_transfer/proc/assign_players()
	clients = length(GLOB.clients)

	for(var/client/client in GLOB.clients)
		if(client.mob in GLOB.alive_mob_list)
			client_types[PLAYER] |= client.ckey
		else if(client.mob in GLOB.new_player_mobs)
			client_types[LOBBY] |= client.ckey
		else if(client.mob in GLOB.dead_mob_list)
			if(isobserver(client.mob))
				var/mob/dead/observer/ghost = client.mob
				if(ghost.started_as_observer)
					client_types[GHOST] |= client.ckey
				else
					client_types[PLAYED] |= client.ckey
			else
				client_types[PLAYED] |= client.ckey
		else // shouldn't happen
			client_types[UNKNOWN] |= client.ckey

/datum/vote/crew_transfer/proc/assign_votes()
	if(!length(voted))
		return FALSE

	var/list/player_types = list(PLAYER, PLAYED, GHOST, LOBBY, UNKNOWN)
	for(var/ckey in voted)
		var/client_type
		for(var/type in player_types)
			if(ckey in client_types[type])
				client_type = type
				break
		player_data[ckey] = list("status" = client_type, "vote" = voted[ckey])

	total_votes = length(voted)
	didnt_vote = clients - total_votes
	return TRUE

// Map vote
/datum/vote/map
	question = "Голосование за карту"
	vote_type_text = "карту"

/datum/vote/map/generate_choices()
	for(var/x in subtypesof(/datum/map))
		var/datum/map/M = x
		if(!initial(M.voteable))
			continue
		// Skip the current map if IF
		// - Map rotate doesnt have a mode for today and the config is enabled for it
		// - Map rotate has a mode for the day and it ISNT full random
		if(((!SSmaprotate.setup_done) && GLOB.configuration.vote.non_repeating_maps) || (SSmaprotate.setup_done && (SSmaprotate.rotation_mode == MAPROTATION_MODE_NO_DUPLICATES)))
			// And of course, if the current map is the same
			if(istype(SSmapping.map_datum, M))
				continue
		choices.Add("[initial(M.fluff_name)] ([initial(M.technical_name)])")

/datum/vote/map/announce()
	..()
	for(var/mob/M in GLOB.player_list)
		M.throw_alert("Голосование за карту", /atom/movable/screen/alert/notify_mapvote, timeout_override = GLOB.configuration.vote.vote_time)

/datum/vote/map/handle_result(result)
	// Find target map.
	if(!result)
		return
	var/datum/map/top_voted_map
	for(var/x in subtypesof(/datum/map))
		var/datum/map/M = x
		if(initial(M.voteable))
			// Set top voted map
			if(result == "[initial(M.fluff_name)] ([initial(M.technical_name)])")
				top_voted_map = M
	to_chat(world, "<span class='interface'>Карта следующего раунда: [initial(top_voted_map.fluff_name)] ([initial(top_voted_map.technical_name)])</span>")
	SSmapping.next_map = new top_voted_map

#undef PLAYER
#undef PLAYED
#undef GHOST
#undef LOBBY
#undef YES
#undef NO
#undef UNKNOWN
