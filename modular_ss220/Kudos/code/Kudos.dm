/*
Маркера '___SYSTEM___' и 'SYSTEM_ARCHIVE_DONE' используются в БД что бы пропустить проверку _try_monthly_reset
и не проводить повторно обнуление каждый раунд первого числа.
*/

SUBSYSTEM_DEF(kudos)
    name = "Kudos System"
    flags = SS_NO_FIRE | SS_BACKGROUND
    init_order = INIT_ORDER_DEFAULT
    runlevels = RUNLEVEL_GAME

// Синхронизация с БД
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

//Обнуление
/datum/controller/subsystem/kudos/proc/_try_monthly_reset(current_month_count)
	//Если сегодня не первое число, пропускаем проверку
    if(time2text(world.realtime, "DD") != "01")
        return

    var/today_date = time2text(world.realtime, "YYYY-MM-DD")
	//Временной маркер
    var/datum/db_query/Q_check = SSdbcore.NewQuery(
        "SELECT id FROM kudos_log WHERE giver = '___SYSTEM___' AND receiver = 'SYSTEM_ARCHIVE_DONE' AND DATE(time) = ?",
        list(today_date)
    )

    if(!Q_check.warn_execute() || Q_check.NextRow())
        qdel(Q_check)
        return
    qdel(Q_check)
	//Передача значения с текущего месяца на "прошлый"
    var/datum/db_query/Q_archive = SSdbcore.NewQuery(
        "UPDATE kudos_unique SET past_month_count = current_month_count, current_month_count = 0, last_update = NOW()",
		list(current_month_count)
    )
	//Установка маркеров
    if(Q_archive.warn_execute())
        log_admin("Данные Kudos за месяц успешно архивированы.")
        var/datum/db_query/Q_mark = SSdbcore.NewQuery(
            "INSERT INTO kudos_log (giver, receiver, time) VALUES ('___SYSTEM___', 'SYSTEM_ARCHIVE_DONE', NOW())"
        )
        Q_mark.warn_execute()
        qdel(Q_mark)

    qdel(Q_archive)

//Логика выдачи
/datum/controller/subsystem/kudos/proc/_process_kudos(giver_ckey, receiver_ckey)
    giver_ckey = ckey(giver_ckey)
    receiver_ckey = ckey(receiver_ckey)
	//На случай внезапного абуза
    if(!giver_ckey || !receiver_ckey || giver_ckey == receiver_ckey)
        return
    var/datum/db_query/Q_log = SSdbcore.NewQuery(
        "INSERT INTO kudos_log (giver, receiver, round_id, time) VALUES (?, ?, ?, NOW())",
        list(giver_ckey, receiver_ckey, GLOB.round_id)
    )
    Q_log.warn_execute()
    qdel(Q_log)
    _update_unique_kudos(giver_ckey, receiver_ckey)

//Учёт уникальных
/datum/controller/subsystem/kudos/proc/_update_unique_kudos(giver_ckey, receiver_ckey, current_month_count)
    var/datum/db_query/Q_check = SSdbcore.NewQuery(
        "SELECT id FROM kudos_log WHERE giver = ? AND receiver = ? AND MONTH(time) = MONTH(NOW()) AND YEAR(time) = YEAR(NOW()) AND id != (SELECT LAST_INSERT_ID())",
        list(giver_ckey, receiver_ckey)
    )

    if(!Q_check.warn_execute())
        qdel(Q_check)
        return

    if(Q_check.NextRow())
        qdel(Q_check)
        return
    qdel(Q_check)

    var/datum/db_query/Q_inc = SSdbcore.NewQuery(
        "INSERT INTO kudos_unique (receiver, current_month_count, last_update) VALUES (?, 1, NOW()) ON DUPLICATE KEY UPDATE current_month_count = current_month_count + 1, last_update = NOW()",
        list(receiver_ckey, current_month_count)
    )
    Q_inc.warn_execute()
    qdel(Q_inc)
