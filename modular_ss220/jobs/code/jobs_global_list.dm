
// ===================== STATION =====================
GLOBAL_LIST_INIT(medical_positions_ss220, list(
	"Intern",
))

GLOBAL_LIST_INIT(science_positions_ss220, list(
	"Student Scientist",
))

GLOBAL_LIST_INIT(engineering_positions_ss220, list(
	"Trainee Engineer",
))

GLOBAL_LIST_INIT(security_positions_ss220, list(
	"Security Cadet",
))


// ====================== DONOR ======================
GLOBAL_LIST_INIT(donor_tier_1_jobs, list(
	"Prisoner",	// Заключенный
))

GLOBAL_LIST_INIT(donor_tier_2_jobs, list(
	"Barber",	// Парикмахер
	"Bath",	// Банщик
	"Casino",	// Крупье
	"Waiter",	// Официант
	"Acolyte",	// Послушник
	"Courier",	// Курьер
	"Wrestler",	// Боксёр, Рефери
	"Painter",	// Художник
	"Musician",	// Музыкант
	"Actor",	// Актёр
))

GLOBAL_LIST_INIT(donor_tier_3_jobs, list(
	"Administrator",	// Сервис-Администратор
	"Tourist TSF",	// Турист ТСФ
	"Tourist USSP",	// Турист ССП
	"Manager Janitor",	// Менеджер по Клинингу
	"Apprentice",	// Подмастерье
	"Guard",	// Охранник Шестерочки
	"Migrant",	// Мигрант
	"Uncertain",	// Забытый Ассистент
))

GLOBAL_LIST_INIT(donor_tier_4_jobs, list(
	"Adjutant",	// Адъютант
	"Butler",	// Дворецкий
	"Maid",	// Горничная
	"Representative TSF",	// Представитель ТСФ
	"Representative USSP",	// Представитель ССП
	"Dealer",	// Независимый Торговец
))

GLOBAL_LIST_INIT(donor_tier_5_jobs, list(
	"VIP Corporate Guest",	// VIP гость
	"Banker",	// Банкир
	"Security Clown",	// Клоун Службы Безопасности
))

GLOBAL_LIST_INIT(security_donor_jobs, list(
	"Security Clown",
))
GLOBAL_LIST_INIT(all_donor_jobs, donor_tier_1_jobs + donor_tier_2_jobs + donor_tier_3_jobs + donor_tier_4_jobs + donor_tier_5_jobs)

GLOBAL_LIST_INIT(service_donor_jobs, all_donor_jobs - security_donor_jobs)


// ====================== SPECIAL ======================
// cant be antags
GLOBAL_LIST_INIT(restricted_jobs_ss220, security_positions_ss220 + (
	donor_tier_4_jobs + donor_tier_5_jobs
))


// ===================== ALL JOBS =====================

GLOBAL_LIST_INIT(all_jobs_ss220, (list() + (
	medical_positions_ss220 + science_positions_ss220 + engineering_positions_ss220 + security_positions_ss220 + all_donor_jobs)))


// ====================== TITLE ======================
/proc/get_alt_titles(list/positions)
	var/list/all_titles = list()
	for(var/rank in positions)
		var/datum/job/job = SSjobs.GetJob(rank)
		if(length(job.alt_titles))
			all_titles |= job.alt_titles
	return all_titles

/proc/get_all_medical_alt_titles_ss220()
	return get_alt_titles(GLOB.medical_positions_ss220)

/proc/get_all_security_alt_titles_ss220()
	return get_alt_titles(GLOB.security_positions_ss220)

/proc/get_all_engineering_alt_titles_ss220()
	return get_alt_titles(GLOB.engineering_positions_ss220)

/proc/get_all_science_alt_titles_ss220()
	return get_alt_titles(GLOB.science_positions_ss220)

/proc/get_all_donor_alt_titles_ss220()
	return get_alt_titles(GLOB.all_donor_jobs)

/proc/get_all_alt_titles_ss220()
	return get_all_medical_alt_titles_ss220() + get_all_security_alt_titles_ss220() + get_all_engineering_alt_titles_ss220() + get_all_science_alt_titles_ss220() + get_all_donor_alt_titles_ss220()

