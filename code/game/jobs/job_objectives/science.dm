/////////////////////////////////////////////////////////////////////////////////////////
// Research
/////////////////////////////////////////////////////////////////////////////////////////

// MAXIMUM SCIENCE
/datum/job_objective/further_research
	objective_name = "Производите исследования для NanoTrasen"
	description = "Используйте отсеки научного отдела станции для улучшения половины технологий выше второго уронвня, а также отправьте ящик с исследованиями на ЦК."
	gives_payout = TRUE
	completion_payment = 150

/datum/job_objective/further_research/check_for_completion()
	var/tech_above_two = 0
	for(var/tech in SSeconomy.tech_levels)
		if(SSeconomy.tech_levels[tech] > 2)
			tech_above_two++
	if(tech_above_two >= 6)
		return TRUE
	return FALSE

/////////////////////////////////////////////////////////////////////////////////////////
// Robotics
/////////////////////////////////////////////////////////////////////////////////////////

//Cyborgs
/datum/job_objective/make_cyborg
	objective_name = "Постройка дополнительных киборгов"
	description = "Постройте как минимум одного киборга для увеличения производительности станции."
	gives_payout = TRUE
	completion_payment = 100

/datum/job_objective/make_cyborg/check_for_completion()
	return completed

//RIPLEY's
/datum/job_objective/make_ripley
	objective_name = "Постройка меха Рипли"
	description = "Постройте меха Рипли для использования на станции."
	gives_payout = TRUE
	completion_payment = 200

/datum/job_objective/make_ripley/check_for_completion()
	return completed
