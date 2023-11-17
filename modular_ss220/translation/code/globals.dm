/**
 * Returns the correct word based on an inputted `gender`.
 */
/proc/genderize(gender, male_word, female_word, neuter_word, multiple_word)
	switch(gender)
		if(MALE)
			. = male_word
		if(FEMALE)
			. = female_word
		if(PLURAL)
			. = multiple_word
		else
			. = neuter_word

/**
 * Returns the correct word based on an inputted `gender` - whether plural or singular (any other gender).
 */
/proc/pluralize(gender, singular_word, plural_word)
	return gender == PLURAL ? plural_word : singular_word

/**
 * Returns the correct word based on a preceding `number`.
 *
 * Refers to a "grammatical number" feature of nouns. Implements Russian grammar rules of declension with numerals.
 */
/proc/declension_number(number, singular_word, dual_word, plural_word)
	if(!isnum(number) || round(number) != number)
		return dual_word // fractional numbers
	if(((number % 10) == 1) && ((number % 100) != 11)) // 1, not 11
		return singular_word
	if(((number % 10) in 2 to 4) && !((number % 100) in 12 to 14)) // 2, 3, 4, not 12, 13, 14
		return dual_word
	return plural_word // 5, 6, 7, 8, 9, 0
