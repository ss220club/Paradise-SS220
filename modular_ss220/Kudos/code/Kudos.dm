/datum/kudos
    var/list/round_votes = list()
    var/static/list/weight_steps = list(1.0, 0.85, 0.72, 0.61, 0.50, 0.40, 0.32, 0.25, 0.18, 0.10)

/datum/kudos/proc/update_data(target_ckey, client/C)
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

    // Считаем, сколько раз giver уже хвалил этого игрока за все время
    var/datum/db_query/q_count = SSdbcore.NewQuery(
        "SELECT COUNT(id) FROM kudos_history WHERE giver = '[from_ckey]' AND receiver = '[target_ckey]'"
    )

    if(!q_count.Execute())
        qdel(q_count)
        return

    var/times_given = 0
    if(q_count.NextRow())
        times_given = text2num(q_count.item[1])
    qdel(q_count)

    // Расчет прогрессивного веса
    var/weight_index = times_given + 1
    var/voice_weight = (weight_index <= weight_steps.len) ? weight_steps[weight_index] : weight_steps[weight_steps.len]

    // ИСПРАВЛЕНО: Теперь записываем points в историю
    var/datum/db_query/q_hist = SSdbcore.NewQuery(
        "INSERT INTO kudos_history (giver, receiver, points, round_id, timestamp) VALUES ('[from_ckey]', '[target_ckey]', [voice_weight], [GLOB.round_id || 0], NOW())"
    )
    q_hist.Execute()
    qdel(q_hist)

    // ИСПРАВЛЕНО: Обновление общего зачета (Float)
    var/datum/db_query/q_total = SSdbcore.NewQuery(
        "INSERT INTO kudos_totals (receiver, total_score) VALUES ('[target_ckey]', [voice_weight]) ON DUPLICATE KEY UPDATE total_score = total_score + [voice_weight]"
    )

    q_total.Execute()
    qdel(q_total)

    round_votes[from_ckey] += target_ckey
    to_chat(C, span_notice("Вы успешно похвалили игрока."))

/datum/kudos/proc/check_monthly_reset()
    var/current_month = time2text(world.realtime, "MM-YYYY")
    var/current_day = time2text(world.realtime, "DD")

    if(current_day != "01")
        return

    var/datum/db_query/q_check = SSdbcore.NewQuery("SELECT id FROM kudos_archive WHERE month_mark = '[current_month]' LIMIT 1")

    if(!q_check.Execute())
        qdel(q_check)
        return
