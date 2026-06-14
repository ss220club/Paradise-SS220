/proc/get_ru_brute_word(mob/living/carbon/human/H)
	var/is_organic_text = !ismachineperson(H) || H.calculate_ipc_masquerade_status()

	return is_organic_text \
		? ru_gender_word(H, "травмирован", "травмирована", "травмировано", "травмированы") \
		: ru_gender_word(H, "повреждён", "повреждена", "повреждено", "повреждены")

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


/proc/ru_blood_stained(atom/A)
	return ru_gender_word(A,
		"окровавленный",
		"окровавленная",
		"окровавленное",
		"окровавленные")


/proc/ru_oil_stained(atom/A)
	return ru_gender_word(A,
		"замасленный",
		"замасленная",
		"замасленное",
		"замасленные")
