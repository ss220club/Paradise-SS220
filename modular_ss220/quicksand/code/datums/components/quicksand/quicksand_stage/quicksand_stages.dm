/datum/quicksand_stage/feet
	duration = 10 SECONDS
	resist_chance = 50
	resist_duration = 3 SECONDS
	assist_chance = 70
	critical_failure_chance = 50
	alpha_mask_y = 8
	on_apply_status_effect = /datum/status_effect/quicksand_stage_1
	on_apply_messages = list("Твои ноги засосало в зыбучие пески!")
	on_successful_resist_messages = list("Ты освобождаешь свои ноги и выбираешься из зыбучих песков.")

/datum/quicksand_stage/torso
	duration = 4 SECONDS
	resist_chance = 25
	resist_duration = 3 SECONDS
	assist_chance = 40
	critical_failure_chance = 25
	alpha_mask_y = 16
	on_apply_status_effect = /datum/status_effect/quicksand_stage_2
	on_apply_messages = list("Какой ужас! Тебя по грудь поглотили зыбучие пески!")
	on_successful_resist_messages = list("Тебе удалось освободить свой торс!")

/datum/quicksand_stage/head
	duration = 4 SECONDS
	resist_chance = 0
	resist_duration = 3 SECONDS
	assist_chance = 20
	critical_failure_chance = 25
	alpha_mask_y = 25
	on_apply_status_effect = /datum/status_effect/quicksand_stage_3
	on_apply_messages = list("Песок засыпается тебе прямо в рот, попадает в глаза и уши. Кажется, это конец.")
	on_successful_resist_messages = list("Ты уже думал что погибнешь, но каким-то чудом освобождаешь свою голову из песков!")
