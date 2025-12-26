SUBSYSTEM_DEF(kudos)
	name = "Kudos System"
	flags = SS_NO_FIRE | SS_BACKGROUND
	init_order = INIT_ORDER_DEFAULT
	runlevels = RUNLEVEL_GAME

/datum/controller/subsystem/kudos/proc/sync_round_kudos()
	if(!SSdbcore.IsConnected())
		return

	_try_monthly_reset()

	for(var/mob/M in GLOB.player_list)
		var/client/C = M.client
		if(!C || !C.ckey)
			continue

		var/list/received = C.persistent.kudos_received_from
		if(!received || !length(received))
			continue

		for(var/giver_ckey in received)
			_process_kudos(giver_ckey, C.ckey)

		C.persistent.kudos_received_from.Cut()

/datum/controller/subsystem/kudos/proc/_try_monthly_reset()
	if(time2text(world.realtime, "DD") != "01")
		return

	var/today_date = time2text(world.realtime, "YYYY-MM-DD")

	var/datum/db_query/Q_check = SSdbcore.NewQuery(
		"SELECT id FROM kudos_log WHERE giver = '___SYSTEM___' AND receiver = 'SYSTEM_ARCHIVE_DONE' AND DATE(time) = ?",
		list(today_date)
	)

	if(!Q_check.warn_execute() || Q_check.NextRow())
		qdel(Q_check)
		return
	qdel(Q_check)

	var/sql_archive = "INSERT INTO kudos_log (giver, receiver, past_unique, time) SELECT '___SYSTEM___', receiver, COUNT(*), NOW() FROM kudos_unique GROUP BY receiver"
	var/datum/db_query/Q_archive = SSdbcore.NewQuery(sql_archive)

	if(Q_archive.warn_execute())
		log_admin("Kudos System: Данные архивированы.")

		var/datum/db_query/Q_reset = SSdbcore.NewQuery(
			"DELETE FROM kudos_unique WHERE last_given < DATE_FORMAT(NOW() ,'%Y-%m-01')"
		)
		Q_reset.warn_execute()
		qdel(Q_reset)

		var/datum/db_query/Q_mark = SSdbcore.NewQuery(
			"INSERT INTO kudos_log (giver, receiver, past_unique, time) VALUES ('___SYSTEM___', 'SYSTEM_ARCHIVE_DONE', 0, NOW())"
		)
		Q_mark.warn_execute()
		qdel(Q_mark)

	qdel(Q_archive)

/datum/controller/subsystem/kudos/proc/_process_kudos(giver_ckey, receiver_ckey)
	giver_ckey = ckey(giver_ckey)
	receiver_ckey = ckey(receiver_ckey)

	if(!giver_ckey || !receiver_ckey || giver_ckey == receiver_ckey)
		return

	var/datum/db_query/Q_log = SSdbcore.NewQuery(
		"INSERT INTO kudos_log (giver, receiver, round_id, time) VALUES (?, ?, ?, NOW())",
		list(giver_ckey, receiver_ckey, GLOB.round_id)
	)
	Q_log.warn_execute()
	qdel(Q_log)

	_update_unique_kudos(giver_ckey, receiver_ckey)

/datum/controller/subsystem/kudos/proc/_update_unique_kudos(giver_ckey, receiver_ckey)
	var/datum/db_query/Q = SSdbcore.NewQuery(
		"SELECT id FROM kudos_unique WHERE giver = ? AND MONTH(last_given) = MONTH(NOW()) AND YEAR(last_given) = YEAR(NOW())",
		list(giver_ckey)
	)

	if(!Q.warn_execute())
		qdel(Q)
		return

	if(Q.NextRow())
		var/datum/db_query/UP = SSdbcore.NewQuery(
			"UPDATE kudos_unique SET receiver = ?, last_given = NOW() WHERE giver = ?",
			list(receiver_ckey, giver_ckey))
		UP.warn_execute()
		qdel(UP)
	else
		var/datum/db_query/INS = SSdbcore.NewQuery(
			"INSERT INTO kudos_unique (giver, receiver, last_given) VALUES (?, ?, NOW())",
			list(giver_ckey, receiver_ckey)
		)
		INS.warn_execute()
		qdel(INS)
	qdel(Q)

/datum/controller/subsystem/kudos/proc/get_current_month_kudos(ckey)
	ckey = ckey(ckey)
	var/datum/db_query/Q = SSdbcore.NewQuery(
		"SELECT COUNT(*) FROM kudos_unique WHERE receiver = ? AND MONTH(last_given) = MONTH(NOW()) AND YEAR(last_given) = YEAR(NOW())",
		list(ckey)
	)
	if(!Q.warn_execute() || !Q.NextRow())
		if(Q) qdel(Q)
		return
	var/amount = text2num(Q.item[1])
	return amount

/datum/controller/subsystem/kudos/proc/get_last_month_kudos(ckey)
	ckey = ckey(ckey)
	var/datum/db_query/Q = SSdbcore.NewQuery(
		"SELECT past_unique FROM kudos_log WHERE giver = '___SYSTEM___' AND receiver = ? ORDER BY time DESC LIMIT 1",
		list(ckey)
	)
	if(!Q.warn_execute() || !Q.NextRow())
		if(Q) qdel(Q)
		return
	var/amount = text2num(Q.item[1])
	return amount

/datum/controller/subsystem/kudos/proc/get_total_kudos(ckey)
	ckey = ckey(ckey)
	var/datum/db_query/Q = SSdbcore.NewQuery(
		"SELECT COUNT(*) FROM kudos_log WHERE receiver = ? AND giver != '___SYSTEM___'",
		list(ckey)
	)
	if(!Q.warn_execute() || !Q.NextRow())
		if(Q) qdel(Q)
		return
	var/amount = text2num(Q.item[1])
	return amount
