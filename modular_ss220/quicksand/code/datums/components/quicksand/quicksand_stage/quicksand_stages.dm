/datum/quicksand_stage/feet
	duration = 10 SECONDS
	resist_chance = 50
	critical_failure_chance = 50
	on_apply_message = "Твои ноги засосало в зыбучие пески!"
	on_remove_message = "Ты освобождаешь свои ноги и выбираешься из зыбучих песков."
	on_apply_status_effect = /datum/status_effect/quicksand_stage_1

/datum/quicksand_stage/torso
	duration = 10 SECONDS
	resist_chance = 25
	critical_failure_chance = 25
	on_apply_message = "Какой ужас! Тебя по грудь поглотили зыбучие пески!"
	on_remove_message = "Тебе удалось освободить свой торс!"
	on_apply_status_effect = /datum/status_effect/quicksand_stage_2

/datum/quicksand_stage/head
	duration = 10 SECONDS
	resist_chance = 5
	critical_failure_chance = 25
	on_apply_message = "Песок засыпается тебе прямо в рот, попадает в глаза и уши. Кажется, это конец."
	on_remove_message = "Ты уже думал что погибнешь, но каким-то чудом освобождаешь свою голову из песков!"
	on_apply_status_effect = /datum/status_effect/quicksand_stage_3
