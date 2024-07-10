// =======================================
// relate jobs for relate job slots
// =======================================
/datum/job/proc/try_relate_jobs()
	return FALSE

/datum/job
	var/relate_job // for relate positions and landmark
	var/is_relate_positions = FALSE	// Slots
	var/is_extra_job = FALSE // Special Jobs Window
	var/count_positions = TRUE // Do we add this position's amount for combined total/spawn positions?

/datum/job/doctor
	relate_job = "Medical Intern"
	is_relate_positions = TRUE

/datum/job/doctor/intern
	relate_job = "Medical Doctor"
	count_positions = FALSE

/datum/job/scientist
	relate_job = "Student Scientist"
	is_relate_positions = TRUE

/datum/job/scientist/student
	relate_job = "Scientist"
	count_positions = FALSE

/datum/job/engineer
	relate_job = "Trainee Engineer"
	is_relate_positions = TRUE

/datum/job/engineer/trainee
	relate_job = "Station Engineer"
	count_positions = FALSE

/datum/job/officer
	relate_job = "Security Cadet"
	is_relate_positions = TRUE

/datum/job/officer/cadet
	relate_job = "Security Officer"
	count_positions = FALSE

// ==============================
// PROCS
// ==============================

/datum/job/is_position_available()
	if(job_banned_gamemode)
		return FALSE
	if(check_hidden_from_job_prefs())
		return FALSE
	if(relate_job && is_relate_positions)
		return check_relate_total_positions()

	return ..()

/datum/job/is_spawn_position_available()
	if(job_banned_gamemode)
		return FALSE
	if(check_hidden_from_job_prefs())
		return FALSE
	if(relate_job && is_relate_positions)
		return check_relate_spawn_positions()

	return ..()

/datum/job/proc/check_relate_total_positions()
	var/datum/job/temp = SSjobs.GetJob(relate_job)
	if(!temp)
		return FALSE
	if(total_positions == -1 || temp.total_positions == -1)
		return TRUE

	var/relate_total_positions = 0
	if(count_positions)
		relate_total_positions += total_positions
	if(temp.count_positions)
		relate_total_positions += temp.total_positions

	return (current_positions + temp.current_positions < relate_total_positions)

/datum/job/proc/check_relate_spawn_positions()
	var/datum/job/temp = SSjobs.GetJob(relate_job)
	if(!temp)
		return FALSE
	if(spawn_positions == -1 || temp.spawn_positions == -1)
		return TRUE

	var/relate_spawn_positions = 0
	if(count_positions)
		relate_spawn_positions += spawn_positions
	if(temp.count_positions)
		relate_spawn_positions += temp.spawn_positions

	return (current_positions + temp.current_positions < relate_spawn_positions)

/datum/job/proc/check_hidden_from_job_prefs()
	if(hidden_from_job_prefs)
		for(var/job_title in GLOB.all_jobs_ss220)
			if(job_title in alt_titles)
				return TRUE
		if(title in GLOB.all_jobs_ss220)
			return TRUE
	return FALSE
