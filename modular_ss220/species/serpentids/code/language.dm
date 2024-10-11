/datum/language/serpentid
	name = "Nabberian"
	desc = "Звук, издаваемый этим языком похоже на кононаду из скрежета мандибул, лезвий, стука конечностей, трения антенн и утробного рева"
	speech_verb = "стучит клинками"
	ask_verb = "стучит жвалами"
	exclaim_verbs = list("издает утробный рёв")
	colour = "serpentid"
	key = "4"
	flags = RESTRICTED | WHITELISTED
	syllables = list("click","clack","cling","clang","cland","clog")

/datum/language/serpentid/get_random_name(gender)
	var/new_name = ""
	if(gender == FEMALE)
		new_name = capitalize(pick(GLOB.first_names_female))
	else
		new_name = capitalize(pick(GLOB.first_names_male))
	new_name += "[rand(10000)]"
	return new_name
