#define KUDOS_UNIQUE_DAYS 30

SUBSYSTEM_DEF(kudos)
	name = "Kudos System"
	flags = SS_NO_FIRE | SS_BACKGROUND
	init_order = INIT_ORDER_DEFAULT
	runlevels = RUNLEVEL_GAME

// -----------------------------------------------------
// SYNC ENTRY POINT
// -----------------------------------------------------
/datum/controller/subsystem/kudos/proc/sync_round_kudos()
	if(!SSdbcore.IsConnected())
		return

	for(var/mob/M in GLOB.player_list)
		var/client/C = M.client
		if(!C || !C.ckey)
			continue

		var/list/from = C.persistent.kudos_received_from
		if(!from || !length(from))
			continue

		for(var/giver_ckey in from)
			_process_kudos(giver_ckey, C.ckey)

// -----------------------------------------------------
// INTERNAL PROCESSING
// -----------------------------------------------------
/datum/controller/subsystem/kudos/proc/_process_kudos(giver_ckey, receiver_ckey)
	giver_ckey = ckey(giver_ckey)
	receiver_ckey = ckey(receiver_ckey)

	if(!giver_ckey || !receiver_ckey || giver_ckey == receiver_ckey)
		return

	// 1. TOTAL KUDOS — ALWAYS ADD
	var/datum/db_query/Q = SSdbcore.NewQuery(
		"INSERT INTO kudos_log (giver, receiver, round_id, time) VALUES (?, ?, ?, NOW())",
		list(giver_ckey, receiver_ckey, GLOB.round_id)
	)
	Q.warn_execute()

	// 2. UNIQUE KUDOS — MOVE OR CREATE
	_update_unique_kudos(giver_ckey, receiver_ckey)

// -----------------------------------------------------
// UNIQUE KUDOS LOGIC
// -----------------------------------------------------
/datum/controller/subsystem/kudos/proc/_update_unique_kudos(giver_ckey, receiver_ckey)
	var/datum/db_query/Q = SSdbcore.NewQuery(
		"SELECT receiver, last_given FROM kudos_unique WHERE giver = ?",
		list(giver_ckey)
	)

	var/exists = FALSE
	var/last_given

	if(Q.warn_execute() && Q.NextRow())
		exists = TRUE
		last_given = Q.item[2]

	qdel(Q)

	if(exists)
		var/datum/db_query/Q2 = SSdbcore.NewQuery(
			"SELECT TIMESTAMPDIFF(DAY, last_given, NOW()) AS diff FROM kudos_unique WHERE giver = ?",
			list(giver_ckey)
		)
		if(Q2.warn_execute() && Q2.NextRow())
			if(Q2.item[1] > KUDOS_UNIQUE_DAYS)
				exists = FALSE
		qdel(Q2)

	if(exists)
		// MOVE unique kudos to new receiver
		var/datum/db_query/Q3 = SSdbcore.NewQuery(
			"UPDATE kudos_unique SET receiver = ?, last_given = NOW() WHERE giver = ?",
			list(receiver_ckey, giver_ckey)
		)
		Q3.warn_execute()
	else
		// CREATE new unique kudos
		var/datum/db_query/Q4 = SSdbcore.NewQuery(
			"INSERT INTO kudos_unique (giver, receiver, last_given) VALUES (?, ?, NOW())",
			list(giver_ckey, receiver_ckey)
		)
		Q4.warn_execute()

// -----------------------------------------------------
// API (UI / STATS)
// -----------------------------------------------------
/datum/controller/subsystem/kudos/proc/get_total_kudos(ckey)
	ckey = ckey(ckey)
	if(!ckey)
		return 0

	var/datum/db_query/Q = SSdbcore.NewQuery(
		"SELECT COUNT(*) FROM kudos_log WHERE receiver = ?",
		list(ckey)
	)

	if(!Q.warn_execute())
		qdel(Q)
		return 0

	Q.NextRow()
	var/amount = text2num(Q.item[1])
	qdel(Q)

	return amount

/datum/controller/subsystem/kudos/proc/get_unique_kudos(ckey)
	ckey = ckey(ckey)
	if(!ckey)
		return 0

	var/datum/db_query/Q = SSdbcore.NewQuery(
		"SELECT COUNT(*) FROM kudos_unique WHERE receiver = ? AND last_given >= DATE_SUB(NOW(), INTERVAL ? DAY)",
		list(ckey, KUDOS_UNIQUE_DAYS)
	)

	if(!Q.warn_execute())
		qdel(Q)
		return 0

	Q.NextRow()
	var/amount = text2num(Q.item[1])
	qdel(Q)

	return amount
