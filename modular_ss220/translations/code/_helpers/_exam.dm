/proc/get_ru_brute_word(mob/living/carbon/human/H)
	var/male
	var/female
	var/neuter
	var/plural

	if(!ismachineperson(H) || H.calculate_ipc_masquerade_status())
		male = "травмирован"
		female = "травмирована"
		neuter = "травмировано"
		plural = "травмированы"
	else
		male = "повреждён"
		female = "повреждена"
		neuter = "повреждено"
		plural = "повреждены"

	if(istype(H, /mob/living/carbon/human/slime))
		return plural

	switch(H.gender)
		if(MALE)
			return male
		if(FEMALE)
			return female
		if(NEUTER)
			return neuter

	return male

/proc/ru_gender_adj(atom/A, male, female, neuter, plural)
	if(!A)
		return male

	switch(A.gender)
		if(FEMALE)
			return female
		if(NEUTER)
			return neuter
		if(PLURAL)
			return plural

	return male


/atom/proc/ru_blood_stained()
	return ru_gender_adj(src,
		"окровавленный",
		"окровавленная",
		"окровавленное",
		"окровавленные")


/atom/proc/ru_oil_stained()
	return ru_gender_adj(src,
		"замасленный",
		"замасленная",
		"замасленное",
		"замасленные")


/proc/ru_gender_word(atom/A, male, female, neuter, plural)
	if(!A)
		return male

	switch(A.gender)
		if(FEMALE)
			return female
		if(NEUTER)
			return neuter
		if(PLURAL)
			return plural

	return male

/obj/item/proc/ru_blood_stain()
	return ru_gender_word(src,
		"окровавленный",
		"окровавленную",
		"окровавленное",
		"окровавленные")

/obj/item/proc/ru_oil_stain()
	return ru_gender_word(src,
		"замасленный",
		"замасленную",
		"замасленное",
		"замасленные")
