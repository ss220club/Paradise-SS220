/datum/world_topic_handler/queue_status_220
	topic_key = "queue_status_220"
	requires_commskey = TRUE

/datum/world_topic_handler/queue_status_220/execute(list/input, key_valid)
	var/ckey_check = input["ckey_check"]

	if(!ckey_check)
		return json_encode(list("allow_player" = TRUE, "error" = "No ckey supplied", "reason" = "Проблема с парсингом сикея"))

	var/player_ckey = ckey(ckey_check)
	sanitize()
	var/list/output_data = list()
	output_data["queue_enabled"] = SSqueue.queue_enabled
	output_data["donator_level"] = 0

	if(SSqueue.queue_enabled)
		if(player_ckey in SSqueue.queue_bypass_list)
			output_data["reason"] = "Вы недавно были на сервере"
			output_data["allow_player"] = TRUE
			return json_encode(output_data)

		if(length(GLOB.player_list) < SSqueue.queue_threshold)
			output_data["reason"] = "На сервере есть свободное место"
			output_data["allow_player"] = TRUE
			return json_encode(output_data)

		// THERE IS QUEUE

		// DB CHECKS
		if(SSdbcore.IsConnected())
			if(have_right_to_pass_queue(player_ckey))
				output_data["reason"] = "Вы имеете право обойти очередь"
				output_data["allow_player"] = TRUE
				return json_encode(output_data)

			var/donator_level = client_donator_level(player_ckey)
			if(donator_level)
				output_data["reason"] = "Вы перемещаетесь в очередь с приоритетом [donator_level]-ого уровня подписки"
				output_data["donator_level"] = donator_level
				output_data["allow_player"] = FALSE
				return json_encode(output_data)

		// NO QUEUE BONUSES
		output_data["reason"] = "Вы перемещаетесь в очередь"
		output_data["allow_player"] = FALSE
		return json_encode(output_data)
	else
		output_data["reason"] = "На сервере отключена очередь"
		output_data["allow_player"] = TRUE
		return json_encode(output_data)

/datum/world_topic_handler/queue_status_220/proc/client_donator_level(ckey)
	var/datum/db_query/query = SSdbcore.NewQuery({"
		SELECT CAST(SUM(amount) as UNSIGNED INTEGER) FROM budget
		WHERE ckey=:ckey
			AND is_valid=true
			AND date_start <= NOW()
			AND (NOW() < date_end OR date_end IS NULL)
		GROUP BY ckey
	"}, list("ckey" = ckey))

	if(!query.warn_execute())
		qdel(query)
		return 0 // Not false, just a zero-tier donator

	while(query.NextRow())
		var/total = query.item[1]
		qdel(query)

		switch(total)
			if(0 to 219)
				return 0
			if(220 to 439)
				return 1
			if(440 to 999)
				return 2
			if(1000 to 2219)
				return 3
			if(2220 to 9999)
				return 4
			if(10000 to INFINITY)
				return DONATOR_LEVEL_MAX


/datum/world_topic_handler/queue_status_220/proc/have_right_to_pass_queue(ckey)
	var/datum/db_query/query = SSdbcore.NewQuery(
		"SELECT admin_rank FROM admin WHERE ckey=:ckey",
		list("ckey" = ckey)
	)

	if(!query.warn_execute())
		qdel(query)
		return FALSE

	var/list/allowed_to_skip = list("Банда", "Братюня", "Стример", "Ведущий Разработчик", "Разработчик", "Максон", "Game Admin")
	while(query.NextRow())
		var/admin_rank = query.item[1]
		qdel(query)

		return (admin_rank in allowed_to_skip)
