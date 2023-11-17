/atom
	/**
	 * List of an atom's name in different cases.
	 *
	 * Example:
	 * name_cases = list("челюсти жизни", "челюстей жизни", "челюстям жизни", "челюсти жизни", "челюстями жизни", "челюстях жизни")
	 * name_cases = list(NOMINATIVE = "челюсти жизни", GENITIVE = "челюстей жизни", DATIVE = "челюстям жизни", ACCUSATIVE = "челюсти жизни", INSTRUMENTAL = "челюстями жизни", PREPOSITIONAL = "челюстях жизни")
	 */
	var/list/name_cases

/**
 * Returns an atom's name in the selected grammatical case.
 *
 * Different cases of the name are defined in [name_cases][/atom/var/list/name_cases].
 * If selected case is not defined, proc tries to get a name in a `NOMINATIVE` case, otherwise returns an atom's original `name`.
 *
 * Arguments:
 * * case - NOMINATIVE, GENITIVE, DATIVE, ACCUSATIVE, INSTRUMENTAL, PREPOSITIONAL
 * * name_cases_override - optional list of object names in different cases
 */
/atom/proc/declension_case(case, list/name_cases_override)
	var/list/case_list = name_cases_override || name_cases
	if(length(case_list) && isnum(case))
		var/case_index = InRange(case, 1, length(case_list)) ? case : NOMINATIVE
		return case_list[case_index] || name
	return name
