// ВСЁ ДЛЯ РАБОТЫ ГЕНА "Вульгарщина"
/proc/sortTextByLength(list/L)
	L = L.Copy()
	sortTim(L, /proc/cmp_text_len_desc)
	return L


/proc/cmp_text_len_desc(a, b)
	return length(b) - length(a)

/datum/mutation/disability/speech/chav/on_say(mob/M, message)
	var/list/keys = chavlinks.Copy()

	// длинные фразы сначала (важно для multi-word)
	keys = sortTextByLength(keys)

	for(var/k in keys)
		message = replace_word_safe(message, k, chavlinks[k])

	return message

/datum/mutation/disability/speech/chav/proc/replace_word_safe(text, key, replacement)
	var/list/words = splittext(text, " ")
	var/i

	for(i = 1 to words.len)
		if(lowertext(words[i]) == lowertext(key))
			words[i] = apply_case(words[i], replacement)

	return jointext(words, " ")


/datum/mutation/disability/speech/chav/proc/apply_case(original, replacement)
	if(original == uppertext(original))
		return uppertext(replacement)

	if(original == capitalize(original))
		return capitalize(replacement)

	return replacement

