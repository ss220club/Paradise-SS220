#define PLAYER "player"
#define PLAYED "played"
#define GHOST "ghost"
#define LOBBY "lobby"
#define YES "Инициировать эвакуацию"
#define NO "Продолжить раунд"

// Crew transfer vote
/datum/vote/crew_transfer
	question = "Окончание смены"
	choices = list("Инициировать эвакуацию", "Продолжить раунд")
	vote_type_text = "эвакуацию"
	/// Players on the server
	var/clients
	/// Assoc list of players and their types
	var/list/players = list(PLAYER = list(), PLAYED = list(), GHOST = list(), LOBBY = list())
	/// Assoc list for evac
	var/list/voted_for = list(
		YES = list(PLAYER = 0, PLAYED = 0, GHOST = 0, LOBBY = 0),
		NO = list(PLAYER = 0, PLAYED = 0, GHOST = 0, LOBBY = 0),
	)
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
	assign_votes()
	SSblackbox.record_feedback("associative", "crew_transfer", 1, list(
		"clients" = clients,
		"player_types" = player_data,
		"voted_for" = vote_data,
		"total_votes" = total_votes,
		"didnt_vote" = didnt_vote,
	), ignore_seal = TRUE)

/datum/vote/crew_transfer/start()
	..()
	assign_players()

/datum/vote/crew_transfer/proc/assign_players()
	clients = length(GLOB.clients)

	for(var/mob/mob in GLOB.alive_mob_list)
		if(mob.client)
			players[PLAYER] |= mob.ckey

	for(var/mob/mob in GLOB.dead_mob_list)
		if(mob.client)
			if(isobserver(mob) && mob.started_as_observer)
				players[GHOST] |= mob.ckey
			else
				players[PLAYED] |= mob.ckey

	for(var/mob/mob in GLOB.new_player_mobs)
		if(mob.client)
			players[LOBBY] |= mob.ckey

/datum/vote/crew_transfer/proc/assign_votes()
	if(!length(voted))
		return

	var/list/player_types = list(PLAYER, PLAYED, GHOST, LOBBY)
	for(var/ckey in voted)
		var/vote = voted[ckey]
		if(vote == "Инициировать эвакуацию" || vote == "Продолжить раунд")
			for(var/type in player_types)
				if(ckey in players[type])
					voted_for[vote][type]++
					break

	var/list/player_data = list(
		"player" = length(players[PLAYER]),
		"played" = length(players[PLAYED]),
		"ghost" = length(players[GHOST]),
		"lobby" = length(players[LOBBY]),
	)

	var/list/vote_data = list(
		"yes" = list(
			"player" = voted_for[YES][PLAYER],
			"played" = voted_for[YES][PLAYED],
			"ghost" = voted_for[YES][GHOST],
			"lobby" = voted_for[YES][LOBBY]
		),
		"no" = list(
			"player" = voted_for[NO][PLAYER],
			"played" = voted_for[NO][PLAYED],
			"ghost" = voted_for[NO][GHOST],
			"lobby" = voted_for[NO][LOBBY]
		),
	)

	total_votes = length(voted)
	didnt_vote = clients - total_votes

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
