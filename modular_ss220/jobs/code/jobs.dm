// =======================================
// relate jobs for relate job slots
// =======================================
/datum/job/proc/try_relate_jobs()
	return FALSE

/datum/job
	var/relate_job // for relate positions and landmark
	var/is_extra_job = FALSE // Special Jobs Window
	var/is_sub_job = FALSE // Do we stay under related job slots?

/datum/job/doctor
	relate_job = "Medical Intern"

/datum/job/doctor/intern
	relate_job = "Medical Doctor"
	is_sub_job = TRUE

/datum/job/scientist
	relate_job = "Student Scientist"

/datum/job/scientist/student
	relate_job = "Scientist"
	is_sub_job = TRUE

/datum/job/engineer
	relate_job = "Trainee Engineer"

/datum/job/engineer/trainee
	relate_job = "Station Engineer"
	is_sub_job = TRUE

/datum/job/officer
	relate_job = "Security Cadet"

/datum/job/officer/cadet
	relate_job = "Security Officer"
	is_sub_job = TRUE

// ==============================
// PROCS
// ==============================

/datum/job/is_position_available()
	if(job_banned_gamemode)
		return FALSE
	if(check_hidden_from_job_prefs())
		return FALSE
	if(relate_job)
		return check_relate_total_positions()

	return ..()

/datum/job/is_spawn_position_available()
	if(job_banned_gamemode)
		return FALSE
	if(check_hidden_from_job_prefs())
		return FALSE
	if(relate_job)
		return check_relate_spawn_positions()

	return ..()

/datum/job/proc/check_relate_total_positions()
	var/datum/job/temp = SSjobs.GetJob(relate_job)
	if(!temp)
		return FALSE
	var/relate_current_positions = current_positions + temp.current_positions

	if(total_positions == -1)
		if(!is_sub_job) // Infinite jobs (inf. SecOffs)
			return TRUE
		if(is_sub_job) // Infinite subjobs...
			if(temp.total_positions == -1) // ... AND jobs? We ball (inf. Cadets, period)
				return TRUE
			return relate_current_positions < temp.total_positions // ... WITHIN relate job (any number of Cadets within SecOff job)

	var/relate_total_positions = is_sub_job ? temp.total_positions : total_positions // Subjob (Cadets) check for related (SecOffs), a regular job (SecOffs) just takes itself (SecOffs)
	return relate_current_positions < relate_total_positions

/datum/job/proc/check_relate_spawn_positions()
	var/datum/job/temp = SSjobs.GetJob(relate_job)
	if(!temp)
		return FALSE
	var/relate_current_positions = current_positions + temp.current_positions

	if(spawn_positions == -1)
		if(!is_sub_job) // Infinite jobs (inf. SecOffs)
			return TRUE
		if(is_sub_job) // Infinite subjobs...
			if(temp.spawn_positions == -1) // ... AND jobs? We ball (inf. Cadets, period)
				return TRUE
			return relate_current_positions < temp.spawn_positions // ... WITHIN relate job (any number of Cadets within SecOff job)

	var/relate_spawn_positions = is_sub_job ? temp.spawn_positions : spawn_positions // Subjob (Cadets) check for related (SecOffs), a regular job (SecOffs) just takes itself (SecOffs)
	return relate_current_positions < relate_spawn_positions

/datum/job/proc/check_hidden_from_job_prefs()
	if(hidden_from_job_prefs)
		for(var/job_title in GLOB.all_jobs_ss220)
			if(job_title in alt_titles)
				return TRUE
		if(title in GLOB.all_jobs_ss220)
			return TRUE
	return FALSE
