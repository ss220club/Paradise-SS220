// =======================================
// relate jobs for relate job slots
// =======================================
/datum/job/proc/try_relate_jobs()
	return FALSE

/datum/job
	var/relate_job // for novice role and etc

/datum/job/doctor
	relate_job = "Intern"
/datum/job/doctor/intern
	relate_job = "Medical Doctor"

/datum/job/scientist
	relate_job = "Student Scientist"
/datum/job/scientist/student
	relate_job = "Scientist"

/datum/job/engineer
	relate_job = "Trainee Engineer"
/datum/job/engineer/trainee
	relate_job = "Station Engineer"

/datum/job/officer
	relate_job = "Security Cadet"
/datum/job/officer/cadet
	relate_job = "Security Officer"

// ==============================
// PROCS
// ==============================

/datum/job/is_position_available()
	if(job_banned_gamemode)
		return FALSE

	if(check_hidden_from_job_prefs())
		return FALSE

	return relate_job ? check_relate_positions() : ..()

/datum/job/proc/check_relate_positions()
	var/datum/job/temp = SSjobs.GetJob(relate_job)

	var/current_count_positions = current_positions + temp.current_positions
	var/total_count_positions = total_positions + temp.total_positions

	if(total_positions == -1)
		total_count_positions = -1

	return (current_count_positions < total_count_positions) || (total_count_positions == -1)

/datum/job/proc/check_hidden_from_job_prefs()
	if(hidden_from_job_prefs)
		for(var/job_title in GLOB.all_jobs_ss220)
			if(job_title in alt_titles)
				return TRUE
		if(title in GLOB.all_jobs_ss220)
			return TRUE
	return FALSE

// Делаем "обходку" для профессий выбранных через job.alt_titles (например DONOR)
/datum/controller/subsystem/jobs/EquipRank(mob/living/carbon/human/H, rank, joined_late = 0) // Equip and put them in an area
	if(!H)
		return null

	rank = get_rank_ss220(H, rank)

	. = ..(H, rank, joined_late)

/datum/controller/subsystem/jobs/proc/get_rank_ss220(mob/living/carbon/human/H, rank)
	var/list/bad_ranks = get_donor_ranks_for_choose()
	if(H.mind.role_alt_title in bad_ranks) // Random pick jobs
		var/datum/job/job = GetJob(rank)
		rank = pick(job.alt_titles)
		H.mind.role_alt_title = rank
	// Make rank from current choosen title
	else if(H.mind.role_alt_title in GLOB.all_donor_jobs)
		rank = H.mind.role_alt_title

	return rank
