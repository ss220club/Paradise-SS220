/datum/quicksand_stage/feet
	duration = 30 SECONDS
	resist_chance = 50
	resist_duration = 3 SECONDS
	critical_failure_chance = 50
	on_apply_message = "Твои ноги засосало в зыбучие пески!"
	on_successful_resist_message = "Ты освобождаешь свои ноги и выбираешься из зыбучих песков."
	displacement_icon_state = "feet"
	on_apply_status_effect = /datum/status_effect/quicksand_stage_1

/datum/quicksand_stage/torso
	duration = 30 SECONDS
	resist_chance = 25
	resist_duration = 3 SECONDS
	critical_failure_chance = 25
	on_apply_message = "Какой ужас! Тебя по грудь поглотили зыбучие пески!"
	on_successful_resist_message = "Тебе удалось освободить свой торс!"
	displacement_icon_state = "torso"
	on_apply_status_effect = /datum/status_effect/quicksand_stage_2

/datum/quicksand_stage/head
	duration = 30 SECONDS
	resist_chance = 5
	resist_duration = 3 SECONDS
	critical_failure_chance = 25
	on_apply_message = "Песок засыпается тебе прямо в рот, попадает в глаза и уши. Кажется, это конец."
	on_successful_resist_message = "Ты уже думал что погибнешь, но каким-то чудом освобождаешь свою голову из песков!"
	displacement_icon_state = "head"
	on_apply_status_effect = /datum/status_effect/quicksand_stage_3
