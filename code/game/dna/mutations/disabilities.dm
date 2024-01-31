/////////////////////
// DISABILITY MUTATIONS
//
//
//
// Mutation is always activated.
/////////////////////

/datum/mutation/disability
	name = "DISABILITY"

/datum/mutation/disability/can_activate(mob/M, flags)
	return TRUE // Always set!

/datum/mutation/disability/hallucinate
	name = "Hallucinate"
	activation_messages = list("Ваш разум говорит 'Привет'.")
	deactivation_messages = list("Рассудок возвращается. Или нет?")
	instability = -GENE_INSTABILITY_MODERATE

/datum/mutation/disability/hallucinate/New()
	..()
	block = GLOB.hallucinationblock

/datum/mutation/disability/hallucinate/on_life(mob/living/carbon/human/H)
	if(prob(1))
		H.AdjustHallucinate(45 SECONDS)

/datum/mutation/disability/epilepsy
	name = "Epilepsy"
	activation_messages = list("Вы чувствуете головную боль.")
	deactivation_messages = list("Ваша головная боль наконец-то прошла.")
	instability = -GENE_INSTABILITY_MODERATE

/datum/mutation/disability/epilepsy/New()
	..()
	block = GLOB.epilepsyblock

/datum/mutation/disability/epilepsy/on_life(mob/living/carbon/human/H)
	if((prob(1) && !H.IsParalyzed()))
		H.visible_message("<span class='danger'>У [H] начинается приступ!</span>","<span class='alert'>У вас начался приступ!</span>")
		H.Paralyse(20 SECONDS)
		H.Jitter(2000 SECONDS)

/datum/mutation/disability/cough
	name = "Coughing"
	activation_messages = list("Вы начинаете кашлять.")
	deactivation_messages = list("Ваше горло перестаёт болеть.")
	instability = -GENE_INSTABILITY_MINOR

/datum/mutation/disability/cough/New()
	..()
	block = GLOB.coughblock

/datum/mutation/disability/cough/on_life(mob/living/carbon/human/H)
	if((prob(5) && H.AmountParalyzed() <= 1))
		H.drop_item()
		H.emote("cough")

/datum/mutation/disability/clumsy
	name = "Clumsiness"
	activation_messages = list("Вы чувствуете легкомысленность.")
	deactivation_messages = list("К вам возвращается контроль над вашими движениями.")
	instability = -GENE_INSTABILITY_MINOR
	traits_to_add = list(TRAIT_CLUMSY)

/datum/mutation/disability/clumsy/New()
	..()
	block = GLOB.clumsyblock

/datum/mutation/disability/tourettes
	name = "Tourettes"
	activation_messages = list("Вы дёргаетесь.")
	deactivation_messages = list("Ваш рот на вкус как мыло.")

/datum/mutation/disability/tourettes/New()
	..()
	block = GLOB.twitchblock

/datum/mutation/disability/tourettes/on_life(mob/living/carbon/human/H)
	if(prob(10))
		switch(rand(1, 3))
			if(1)
				H.emote("twitch")
			if(2 to 3)
				H.say("[prob(50) ? ";" : ""][pick("ДЕРЬМО", "МОЧА", "БЛЯТЬ", "ПИЗДА", "ХУЕСОС", "УБЛЮДОК", "СИСЬКИ", "ХУЙ", "ЖОПА", "КОКПИТАН", "ХОС ХУЕСОС", "РД УЁБОК", "ПОШЁЛ НАХУЙ", "ВЫБЛЯДОК", "ОТСОСИ", "ДОЛБОЁБ", "КУКУРУЗА", "УБЛЮДОК", "МАТЬ ТВОЮ", "ГОВНО СОБАЧЬЕ", "ЕБАТЬ ТЕБЯ", "ОНАНИСТ ЧЕРТОВ", "ЕБАТЬ", "МРАЗЬ", "ХУЙНЯ", "КУДЛАТАЯ ХУЙНЯ", "ШЛЮХА", "ПРОФУРСЕТКА", "ШАЛАВА", "ПОХУЙ", "ИДИ НА ХУЙ", "ПАСКУДА", "СВОЛОЧЬ", "МУДАК", "ПОТАСКУХА", "УЕБАН", "МАНДАВОШКА", "БЛЭТ", "ПРИДУРОК", "ДУРАК", "ИДИОТ", "ОХУЕТЬ", "ХУЕТА", "ХУЕВО", "ЁБ ТВОЮ МАТЬ", "ГОВНЮК", "НАЕБЩИК")]!")
		var/x_offset_old = H.pixel_x
		var/y_offset_old = H.pixel_y
		var/x_offset = H.pixel_x + rand(-2, 2)
		var/y_offset = H.pixel_y + rand(-1, 1)
		animate(H, pixel_x = x_offset, pixel_y = y_offset, time = 1)
		animate(H, pixel_x = x_offset_old, pixel_y = y_offset_old, time = 1)

/datum/mutation/disability/nervousness
	name = "Nervousness"
	activation_messages = list("Вы начинаете нервничать.")
	deactivation_messages = list("Вы чувствуете себя гораздно спокойнее.")

/datum/mutation/disability/nervousness/New()
	..()
	block = GLOB.nervousblock

/datum/mutation/disability/nervousness/on_life(mob/living/carbon/human/H)
	if(prob(10))
		H.Stuttering(20 SECONDS)

/datum/mutation/disability/blindness
	name = "Blindness"
	activation_messages = list("Кто-то выключил свет?")
	deactivation_messages = list("Теперь вы можете видеть, если вы этого не заметили...")
	instability = -GENE_INSTABILITY_MAJOR
	traits_to_add = list(TRAIT_BLIND)

/datum/mutation/disability/blindness/New()
	..()
	block = GLOB.blindblock

/datum/mutation/disability/blindness/activate(mob/M)
	..()
	M.update_blind_effects()

/datum/mutation/disability/blindness/deactivate(mob/M)
	..()
	M.update_blind_effects()


/datum/mutation/disability/colourblindness
	name = "Colourblindness"
	activation_messages = list("Вы чувствуете странное покалывание в глазах, в то время как ваше восприятие цвета меняется.")
	deactivation_messages = list("Ваши глаза неприятно пощипывает, но все вокруг кажется более красочным.")
	instability = -GENE_INSTABILITY_MODERATE
	traits_to_add = list(TRAIT_COLORBLIND)

/datum/mutation/disability/colourblindness/New()
	..()
	block = GLOB.colourblindblock

/datum/mutation/disability/colourblindness/activate(mob/M)
	..()
	M.update_client_colour() //Handle the activation of the colourblindness on the mob.
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.update_misc_effects()

/datum/mutation/disability/colourblindness/deactivate(mob/M)
	..()
	M.update_client_colour() //Handle the deactivation of the colourblindness on the mob.
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.update_misc_effects()

/datum/mutation/disability/deaf
	name = "Deafness"
	activation_messages = list("Здесь как-то тихо.")
	deactivation_messages = list("Вы снова можете слышать!")
	instability = -GENE_INSTABILITY_MAJOR
	traits_to_add = list(TRAIT_DEAF)

/datum/mutation/disability/deaf/New()
	..()
	block = GLOB.deafblock

/datum/mutation/disability/nearsighted
	name = "Nearsightedness"
	activation_messages = list("Всё вокруг стало мутным...")
	deactivation_messages = list("Теперь вы можете четко видеть")
	instability = -GENE_INSTABILITY_MODERATE
	traits_to_add = list(TRAIT_NEARSIGHT)

/datum/mutation/disability/nearsighted/New()
	..()
	block = GLOB.glassesblock

/datum/mutation/disability/nearsighted/activate(mob/living/M)
	..()
	M.update_nearsighted_effects()

/datum/mutation/disability/nearsighted/deactivate(mob/living/M)
	..()
	M.update_nearsighted_effects()

/datum/mutation/disability/lisp
	name = "Lisp"
	desc = "Интерешно, как это проишходит?"
	activation_messages = list("Что-то здесь не так.")
	deactivation_messages = list("Теперь вы чувствуете в себе силы произносить согласные звуки.")

/datum/mutation/disability/lisp/New()
	..()
	block = GLOB.lispblock

/datum/mutation/disability/lisp/on_say(mob/M, message)
	return replacetext(message,"s","th")

/datum/mutation/disability/comic
	name = "Comic"
	desc = "Это принесет только смерть и разрушение."
	activation_messages = list("<span class='sans'>Упс!</span>")
	deactivation_messages = list("Ну, слава богу, с этим покончено.")
	traits_to_add = list(TRAIT_COMIC_SANS)

/datum/mutation/disability/comic/New()
	..()
	block = GLOB.comicblock

/datum/mutation/disability/wingdings
	name = "Alien Voice"
	desc = "Загрязняет голос субъекта, превращая его в непонятную речь."
	activation_messages = list("<span class='wingdings'>Ваши голосовые связки кажутся чужими</span>")
	deactivation_messages = list("Ваши голосовые связки перестали казаться чужыми.")
	instability = -GENE_INSTABILITY_MINOR
	traits_to_add = list(TRAIT_WINGDINGS)

/datum/mutation/disability/wingdings/New()
	..()
	block = GLOB.wingdingsblock

/datum/mutation/disability/wingdings/on_say(mob/M, message)
	var/garbled_message = ""
	for(var/i in 1 to length(message))
		if(message[i] in GLOB.alphabet_uppercase)
			garbled_message += pick(GLOB.alphabet_uppercase)
		else if(message[i] in GLOB.alphabet)
			garbled_message += pick(GLOB.alphabet)
		else
			garbled_message += message[i]
	message = garbled_message
	return message

//////////////////
// DISABILITIES //
//////////////////

////////////////////////////////////////
// Totally Crippling
////////////////////////////////////////

// WAS: /datum/bioEffect/mute
/datum/mutation/disability/mute
	name = "Mute"
	desc = "Полностью отключает речевой центр мозга испытуемого."
	activation_messages = list("Вы чувствуете неспособность выражать свои мысли.")
	deactivation_messages = list("Вы чувсствуете, что снова можете говорить.")
	instability = -GENE_INSTABILITY_MODERATE
	traits_to_add = list(TRAIT_MUTE)

/datum/mutation/disability/mute/New()
	..()
	block = GLOB.muteblock

/datum/mutation/disability/mute/on_say(mob/M, message)
	return ""

////////////////////////////////////////
// Harmful to others as well as self
////////////////////////////////////////

/datum/mutation/disability/radioactive
	name = "Radioactive"
	desc = "Объект страдает от постоянной лучевой болезни и вызывает такую же у близлежащей органики."
	activation_messages = list("Вы чувствуете, как все тело охватывает странное недомогание")
	deactivation_messages = list("Вы больше не чувствуете себя ужасно больным.")
	instability = -GENE_INSTABILITY_MAJOR

/datum/mutation/disability/radioactive/New()
	..()
	block = GLOB.radblock


/datum/mutation/disability/radioactive/can_activate(mob/M, flags)
	if(!..())
		return FALSE
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(HAS_TRAIT(H, TRAIT_RADIMMUNE) && !(flags & MUTCHK_FORCED))
			return FALSE
	return TRUE

/datum/mutation/disability/radioactive/on_life(mob/living/carbon/human/H)
	radiation_pulse(H, 20)

/datum/mutation/disability/radioactive/on_draw_underlays(mob/M, g)
	return "rads_s"

////////////////////////////////////////
// Other disabilities
////////////////////////////////////////

// WAS: /datum/bioEffect/fat
/datum/mutation/disability/fat
	name = "Obesity"
	desc = "Сильно замедляет метаболизм, способствуя большему накоплению липидной ткани."
	activation_messages = list("Вы ощущаете себя пузатым и вялым!")
	deactivation_messages = list("Вы ощущаете себя в хорошей форме!")
	instability = -GENE_INSTABILITY_MINOR
	traits_to_add = list(TRAIT_SLOWDIGESTION)

/datum/mutation/disability/fat/New()
	..()
	block = GLOB.fatblock

// WAS: /datum/bioEffect/chav
/datum/mutation/disability/speech/chav
	name = "Chav"
	desc = "Заставляет языковой центр мозга испытуемого строить предложения в более примитивной манере."
	activation_messages = list("Ты чувствуешь себя настоящим придурком, не так ли?")
	deactivation_messages = list("Тебе больше не хочется быть грубым и нахальным.")
	traits_to_add = list(TRAIT_CHAV)
	//List of swappable words. Normal word first, chav word second.
	var/static/list/chavlinks = list(
	"arrest" = "nick",
	"arrested" = "nicked",
	"ass" = "arse",
	"bad" = "pants",
	"bar" = "spoons",
	"brain" = "noggin",
	"break" = "smash",
	"broke" = "smashed",
	"broken" = "gone kaput",
	"comdom" = "knob'ed",
	"cool" = "ace",
	"crazy" = "well mad",
	"cup of tea" = "cuppa",
	"destroyed" = "rekt",
	"dick" = "prat",
	"disappointed" = "gutted",
	"disgusting" = "minging",
	"disposals" = "bins",
	"drink" = "bevvy",
	"engineer" = "sparky",
	"excited" = "jacked",
	"fight" = "scuffle",
	"food" = "nosh",
	"friend" = "blud",
	"fuck" = "fook",
	"get" = "giz",
	"girl" = "bird",
	"go away" = "jog on",
	"good" = "mint",
	"great" = "bangin'",
	"happy" = "chuffed",
	"hello" = "orite",
	"hi" = "sup",
	"idiot" = "twit",
	"isn't it" = "innit",
	"kill" = "bang",
	"killed" = "banged",
	"man" = "bloke",
	"mess" = "shambles",
	"mistake" = "cock-up",
	"murder" = "hench",
	"murdered" = "henched",
	"no" = "naw",
	"really" = "propa",
	"robust" = "'ard",
	"run" = "leg it",
	"sec" = "cops",
	"security" = "coppers",
	"silly" = "daft",
	"steal" = "nick",
	"stole" = "nicked",
	"surprised" = "gobsmacked",
	"suspicious" = "dodgy",
	"tired" = "knackered",
	"wet" = "moist",
	"what" = "wot",
	"window" = "windy",
	"windows" = "windies",
	"yes" = "ye",
	"yikes" = "blimey",
	"your" = "yur"
	)

/datum/mutation/disability/speech/chav/New()
	..()
	block = GLOB.chavblock

/datum/mutation/disability/speech/chav/on_say(mob/M, message)
	var/static/regex/R = regex("\\b([chavlinks.Join("|")])\\b", "g")
	message = R.Replace(message, /datum/mutation/disability/speech/chav/proc/replace_speech)
	return message

/datum/mutation/disability/speech/chav/proc/replace_speech(matched)
	REGEX_REPLACE_HANDLER
	return chavlinks[matched]

// WAS: /datum/bioEffect/swedish
/datum/mutation/disability/speech/swedish
	name = "Swedish"
	desc = "Заставляет языковой центр мозга субъекта формировать предложения своеобразным образом, напоминающим древнескандинавский стиль."
	activation_messages = list("Вы чувствуете себя шведом, как бы это не звучало.")
	deactivation_messages = list("Ощущение шведскости проходит.")

/datum/mutation/disability/speech/swedish/New()
	..()
	block = GLOB.swedeblock

/datum/mutation/disability/speech/swedish/on_say(mob/living/M, message)
	// svedish
	message = replacetextEx(message,"W","V")
	message = replacetextEx(message,"w","v")
	message = replacetextEx(message,"J","Y")
	message = replacetextEx(message,"j","y")
	message = replacetextEx(message,"A",pick("Å","Ä","Æ","A"))
	message = replacetextEx(message,"a",pick("å","ä","æ","a"))
	message = replacetextEx(message,"BO","BJO")
	message = replacetextEx(message,"Bo","Bjo")
	message = replacetextEx(message,"bo","bjo")
	message = replacetextEx(message,"O",pick("Ö","Ø","O"))
	message = replacetextEx(message,"o",pick("ö","ø","o"))
	if(prob(30) && !M.is_muzzled() && !M.is_facehugged())
		message += " Bork[pick("",", bork",", bork, bork")]!"
	return message

// WAS: /datum/bioEffect/unintelligable
/datum/mutation/disability/unintelligable
	name = "Unintelligable"
	desc = "Сильно портит часть мозга, ответственную за формирование устных предложений."
	activation_messages = list("Кажется, ты не можешь сформулировать ни одной связной мысли!")
	deactivation_messages = list("Ваш разум становится более ясным.")
	instability = -GENE_INSTABILITY_MINOR

/datum/mutation/disability/unintelligable/New()
	..()
	block = GLOB.scrambleblock

/datum/mutation/disability/unintelligable/on_say(mob/M, message)
	var/prefix = copytext(message,1,2)
	if(prefix == ";")
		message = copytext(message,2)
	else if(prefix in list(":","#"))
		prefix += copytext(message,2,3)
		message = copytext(message,3)
	else
		prefix=""

	var/list/words = splittext(message," ")
	var/list/rearranged = list()
	for(var/i=1;i<=words.len;i++)
		var/cword = pick(words)
		words.Remove(cword)
		var/suffix = copytext(cword,length(cword)-1,length(cword))
		while(length(cword)>0 && (suffix in list(".",",",";","!",":","?")))
			cword  = copytext(cword,1              ,length(cword)-1)
			suffix = copytext(cword,length(cword)-1,length(cword)  )
		if(length(cword))
			rearranged += cword
	return "[prefix][uppertext(jointext(rearranged," "))]!!"

//////////////////
// USELESS SHIT //
//////////////////

// WAS: /datum/bioEffect/strong
/datum/mutation/disability/strong
	// pretty sure this doesn't do jack shit, putting it here until it does
	name = "Strong"
	desc = "Усиливает способность субъекта формировать и сохранять крупные мышцы."
	activation_messages = list("Ты чувствуешь себя бодрее!")
	deactivation_messages = list("Вы чувствуете себя слабым и немощным.")

/datum/mutation/disability/strong/New()
	..()
	block = GLOB.strongblock

// WAS: /datum/bioEffect/horns
/datum/mutation/disability/horns
	name = "Horns"
	desc = "Позволяет формировать компактное кератиновое образование на голове субъекта."
	activation_messages = list("Из твоей головы вырывается пара рогов.")
	deactivation_messages = list("Ваши рога рассыпаются в прах.")

/datum/mutation/disability/horns/New()
	..()
	block = GLOB.hornsblock

/datum/mutation/disability/horns/on_draw_underlays(mob/M, g)
	return "horns_s"

/datum/mutation/grant_spell/immolate
	name = "Incendiary Mitochondria"
	desc = "Субъект становится способным преобразовывать избыточную клеточную энергию в тепловую энергию."
	activation_messages = list("Вам внезапно стало очень жарко.")
	deactivation_messages = list("Вы больше не чувствуете дискомфорта от жары.")
	spelltype = /obj/effect/proc_holder/spell/immolate

/datum/mutation/grant_spell/immolate/New()
	..()
	block = GLOB.immolateblock

/obj/effect/proc_holder/spell/immolate
	name = "Incendiary Mitochondria"
	desc = "Субъект приобретает способность преобразовывать избыточную клеточную энергию в тепловую."
	panel = "Abilities"

	base_cooldown = 600

	clothes_req = FALSE
	stat_allowed = CONSCIOUS
	invocation_type = "none"
	var/list/compatible_mobs = list(/mob/living/carbon/human)

	action_icon_state = "genetic_incendiary"

/obj/effect/proc_holder/spell/immolate/create_new_targeting()
	return new /datum/spell_targeting/self

/obj/effect/proc_holder/spell/immolate/cast(list/targets, mob/living/user = usr)
	var/mob/living/carbon/L = user
	L.adjust_fire_stacks(0.5)
	L.visible_message("<span class='danger'>[L.name]</b> suddenly bursts into flames!</span>")
	L.IgniteMob()
	playsound(L.loc, 'sound/effects/bamf.ogg', 50, 0)

/datum/mutation/disability/speech/loud
	name = "Loud"
	desc = "Заставляет речевой центр мозга испытуемого выкрикивать каждое предложение."
	activation_messages = list("ВАМ ХОЧЕТСЯ КРИЧАТЬ!")
	deactivation_messages = list("Вам хочется побыть в тишине...")

/datum/mutation/disability/speech/loud/New()
	..()
	block = GLOB.loudblock



/datum/mutation/disability/speech/loud/on_say(mob/M, message)
	message = replacetext(message,".","!")
	message = replacetext(message,"?","?!")
	message = replacetext(message,"!","!!")
	return uppertext(message)

/datum/mutation/disability/dizzy
	name = "Dizzy"
	desc = "Вызывает отключение функций мозжечка в некоторых местах."
	activation_messages = list("Вы чувствуете сильное головокружение...")
	deactivation_messages = list("Вы вновь обретаете равновесие.")
	instability = -GENE_INSTABILITY_MINOR

/datum/mutation/disability/dizzy/New()
	..()
	block = GLOB.dizzyblock


/datum/mutation/disability/dizzy/on_life(mob/living/carbon/human/M)
	if(!istype(M))
		return
	M.Dizzy(600 SECONDS)

/datum/mutation/disability/dizzy/deactivate(mob/living/M)
	..()
	M.SetDizzy(0)
