SUBSYSTEM_DEF(kudos)
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_DBCORE

	var/list/round_votes = list()
	var/static/list/weight_steps = list(1.0, 0.85, 0.72, 0.61, 0.50, 0.40, 0.32, 0.25, 0.18, 0.10)

/datum/controller/subsystem/kudos/Initialize()
	if(!SSdbcore.IsConnected())
		return
	check_monthly_reset()

/datum/controller/subsystem/kudos/proc/update_data(target_ckey, client/C)
	if(!SSdbcore.IsConnected() || !C || !target_ckey)
		return

	var/from_ckey = C.ckey
	if(target_ckey == from_ckey)
		to_chat(C, span_warning("Вы не можете хвалить самого себя."))
		return

	if(!round_votes[from_ckey])
		round_votes[from_ckey] = list()

	if(target_ckey in round_votes[from_ckey])
		to_chat(C, span_warning("Вы уже похвалили этого игрока в этом раунде."))
		return

	var/datum/db_query/q_count = SSdbcore.NewQuery(
		"SELECT COUNT(id) FROM kudos_history WHERE giver = :giver AND receiver = :receiver",
		list("giver" = from_ckey, "receiver" = target_ckey)
	)

	if(!q_count.Execute())
		qdel(q_count)
		return

	var/times_given = 0
	if(q_count.NextRow())
		times_given = text2num(q_count.item[1])
	qdel(q_count)

	var/weight_index = times_given + 1
	var/voice_weight = (weight_index <= weight_steps.len) ? weight_steps[weight_index] : weight_steps[weight_steps.len]

	var/datum/db_query/q_hist = SSdbcore.NewQuery(
		"INSERT INTO kudos_history (giver, receiver, points, round_id, timestamp) VALUES (:giver, :receiver, :points, :round_id, NOW())",
		list(
			"giver" = from_ckey,
			"receiver" = target_ckey,
			"points" = voice_weight,
			"round_id" = GLOB.round_id || 0
		)
	)
	q_hist.Execute()
	qdel(q_hist)

	var/datum/db_query/q_total = SSdbcore.NewQuery(
		"INSERT INTO kudos_totals (receiver, total_score) VALUES (:receiver, :score) ON DUPLICATE KEY UPDATE total_score = total_score + :score",
		list("receiver" = target_ckey, "score" = voice_weight)
	)

	q_total.Execute()
	qdel(q_total)

	round_votes[from_ckey] += target_ckey
	to_chat(C, span_notice("Вы успешно похвалили игрока."))

/datum/controller/subsystem/kudos/proc/check_monthly_reset()
	var/current_day = time2text(world.realtime, "DD")
	var/day_month_mark = time2text(world.realtime, "DD-MM")

	if(current_day != "01")
		return

	var/datum/db_query/q_check = SSdbcore.NewQuery("SELECT month_mark FROM kudos_archive ORDER BY id DESC LIMIT 1")

	if(!q_check.Execute())
		qdel(q_check)
		return

	if(q_check.NextRow())
		var/last_mark = q_check.item[1]

		if(last_mark == day_month_mark)
			qdel(q_check)
			return

	qdel(q_check)

		var/datum/db_query/q_mark = SSdbcore.NewQuery("INSERT INTO kudos_archive (receiver, total_score, month_mark) SELECT receiver, total_score, :month_mark FROM kudos_totals",
		list("month_mark" = day_month_mark))

	if(!q_mark.Execute())
		qdel(q_mark)
		return
	qdel(q_mark)

	var/datum/db_query/q_reset_history = SSdbcore.NewQuery("TRUNCATE TABLE kudos_history")
	q_reset_history.Execute()
	qdel(q_reset_history)

	var/datum/db_query/q_reset_totals = SSdbcore.NewQuery("TRUNCATE TABLE kudos_totals")
	q_reset_totals.Execute()
	qdel(q_reset_totals)
