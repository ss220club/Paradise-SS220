#define BREAD_SERVICE_JOBS_LIST list("Waiter", "Butler", "Maid")

/obj/item/envelope/security/Initialize(mapload)
	job_list |= GLOB.security_positions_ss220 + GLOB.security_donor_jobs
	return ..()

/obj/item/envelope/science/Initialize(mapload)
	job_list |= GLOB.science_positions_ss220
	return ..()

/obj/item/envelope/supply/Initialize(mapload)
	job_list |= GLOB.supply_donor_jobs
	return ..()

/obj/item/envelope/medical/Initialize(mapload)
	job_list |= GLOB.medical_positions_ss220
	return ..()

/obj/item/envelope/engineering/Initialize(mapload)
	job_list |= GLOB.engineering_positions_ss220
	return ..()

/obj/item/envelope/bread/Initialize(mapload)
	job_list |= BREAD_SERVICE_JOBS_LIST
	return ..()

/obj/item/envelope/circuses/Initialize(mapload)
	job_list |= GLOB.service_donor_jobs - BREAD_SERVICE_JOBS_LIST
	return ..()

/obj/item/envelope/misc/Initialize(mapload)
	job_list |= GLOB.assistant_donor_jobs // amazing multitool for a prisoner
	return ..()

#undef BREAD_SERVICE_JOBS_LIST
