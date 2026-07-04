/////////////////////
// DISABILITY MUTATIONS
//
//
//
// Mutation is always activated.
/////////////////////

/datum/mutation/disability
	name = "ИНВАЛИДНОСТЬ"

/datum/mutation/disability/can_activate(mob/M, flags)
	return TRUE // Always set!

/datum/mutation/disability/hallucinate
	name = "Галлюцинации"
	activation_messages = list("Ваш разум здоровается с вами!")
	deactivation_messages = list("Здравый смысл вернулся. Правда ведь?")
	instability = -GENE_INSTABILITY_MAJOR

/datum/mutation/disability/hallucinate/New()
	..()
	block = GLOB.hallucinationblock

/datum/mutation/disability/hallucinate/on_life(mob/living/carbon/human/H)
	if(prob(1))
		H.AdjustHallucinate(45 SECONDS)

/datum/mutation/disability/epilepsy
	name = "Эпилепсия"
	activation_messages = list("Вы ощущаете стойкую головную боль.")
	deactivation_messages = list("Головная боль наконец прошла.")
	instability = -GENE_INSTABILITY_MODERATE

/datum/mutation/disability/epilepsy/New()
	..()
	block = GLOB.epilepsyblock

/datum/mutation/disability/epilepsy/on_life(mob/living/carbon/human/H)
	if((prob(1) && !H.IsParalyzed()))
		H.visible_message(SPAN_DANGER("Кажется у [H] начался припадок!"),SPAN_ALERT("У вас припадок!"))
		H.Paralyse(20 SECONDS)
		H.Jitter(2000 SECONDS)

/datum/mutation/disability/cough
	name = "Кашель"
	activation_messages = list("Вам захотелось прокашляться.")
	deactivation_messages = list("В горле перестало першить.")
	instability = -GENE_INSTABILITY_MINOR

/datum/mutation/disability/cough/New()
	..()
	block = GLOB.coughblock

/datum/mutation/disability/cough/on_life(mob/living/carbon/human/H)
	if((prob(5) && H.AmountParalyzed() <= 1))
		H.drop_item()
		H.emote("cough")

/datum/mutation/disability/clumsy
	name = "Неуклюжесть"
	activation_messages = list("У вас всё валится из рук...")
	deactivation_messages = list("Вы вернули контроль над своими движениями.")
	instability = -GENE_INSTABILITY_MODERATE
	traits_to_add = list(TRAIT_CLUMSY)

/datum/mutation/disability/clumsy/New()
	..()
	block = GLOB.clumsyblock

/datum/mutation/disability/nervousness
	name = "Нервозность"
	activation_messages = list("Вы нервничаете.")
	deactivation_messages = list("Вы чувствуете себя намного спокойнее.")

/datum/mutation/disability/nervousness/New()
	..()
	block = GLOB.nervousblock

/datum/mutation/disability/nervousness/on_life(mob/living/carbon/human/H)
	if(prob(10))
		H.Stuttering(20 SECONDS)

/datum/mutation/disability/blindness
	name = "Слепота"
	activation_messages = list("Вы совсем ничего не видите!")
	deactivation_messages = list("К вам вернулось зрение, если вы не заметили...")
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
	name = "Дальтонизм"
	activation_messages = list("Вы ощущаете лёгкое покалывание в глазах, а ваше цветовое восприятие вдруг меняется.")
	deactivation_messages = list("Ваши глаза неприятно покалывают, впрочем, всё вокруг становится намного красочнее.")
	instability = -GENE_INSTABILITY_MINOR
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
	name = "Глухота"
	activation_messages = list("Стало как-то тихо.")
	deactivation_messages = list("Вы вновь можете слышать!")
	instability = -GENE_INSTABILITY_MAJOR
	traits_to_add = list(TRAIT_DEAF)

/datum/mutation/disability/deaf/New()
	..()
	block = GLOB.deafblock

/datum/mutation/disability/nearsighted
	name = "Близорукость"
	activation_messages = list("Ваши глаза ощущают себя странно...")
	deactivation_messages = list("Вы вновь можете чётко видеть.")
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
	name = "Шепелявость"
	desc = "Интерещно, що оно делает?"
	activation_messages = list("Щто-то тощно не так...")
	deactivation_messages = list("Вы вновь способны чётко выговаривать слова.")

/datum/mutation/disability/lisp/New()
	..()
	block = GLOB.lispblock

/datum/mutation/disability/lisp/on_say(mob/M, message)
	message = replacetext(message, "s", "th")
	message = replacetext(message, "z", "th")
	message = replacetext(message, "с", "ш")
	message = replacetext(message, "з", "ж")
	message = replacetext(message, "ч", "щ")
	return message

/datum/mutation/disability/comic
	name = "Комик"
	desc = "Это приведёт лишь к смертям и разрушению."
	activation_messages = list(SPAN_SANS("Ой ой!"))
	deactivation_messages = list("Слава богу это закончилось.")
	traits_to_add = list(TRAIT_COMIC_SANS)

/datum/mutation/disability/comic/New()
	..()
	block = GLOB.comicblock

/datum/mutation/disability/wingdings
	name = "Чужеродная речь"
	desc = "Искажает голос собеседника, превращая его в непонятную речь."
	activation_messages = list("<span class='wingdings'>Ваши голосовые связки кажутся чужеродными.</span>")
	deactivation_messages = list("Ваши голосовые связки утратили возможность говорить чужеродно.")
	instability = -GENE_INSTABILITY_MODERATE
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
// MARK: Totally Crippling
////////////////////////////////////////

// WAS: /datum/bioEffect/mute
/datum/mutation/disability/mute
	name = "Немота"
	desc = "Полностью отключает речевой центр в мозге испытуемого."
	activation_messages = list("Вы совершенно не способны выразить свои мысли словами.")
	deactivation_messages = list("Вы вновь в состоянии говорить свободно.")
	instability = -GENE_INSTABILITY_MAJOR
	traits_to_add = list(TRAIT_MUTE)

/datum/mutation/disability/mute/New()
	..()
	block = GLOB.muteblock

/datum/mutation/disability/mute/on_say(mob/M, message)
	return ""

/datum/mutation/disability/paraplegic
	name = "Паралич"
	desc = "Ваши ноги отказываются работать, даже протезы."
	activation_messages = list("МОИ НОГИ!")
	deactivation_messages = list("Вы вновь можете чувствовать свои ноги.")
	instability = -GENE_INSTABILITY_MAJOR
	traits_to_add = list(TRAIT_PARAPLEGIC)

/datum/mutation/disability/paraplegic/New()
	..()
	block = GLOB.paraplegicblock

////////////////////////////////////////
// MARK: Harmful to everyone
////////////////////////////////////////

/datum/mutation/disability/radioactive
	name = "Радиоактивность"
	desc = "Обследуемый страдает от постоянной лучевой болезни и заражает находящуюся рядом органику."
	activation_messages = list("Вы ощущаете странное болезненное ощущение, что пронизывает ваше тело.")
	deactivation_messages = list("Вы более не чувствуете себя так отвратно и болезненно как раньше.")
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
	radiation_pulse(H, 80, ALPHA_RAD)

/datum/mutation/disability/radioactive/on_draw_underlays(mob/M, g)
	return "rads_s"

////////////////////////////////////////
// MARK: Other disabilities
////////////////////////////////////////

// WAS: /datum/bioEffect/fat
/datum/mutation/disability/fat
	name = "Ожирение"
	desc = "Значительно замедляет метаболизм, что приводит к большему накоплению жиров в теле."
	activation_messages = list("Вы чувствуете себя упитанным и вялым!")
	deactivation_messages = list("Вы пришли в форму!")
	traits_to_add = list(TRAIT_SLOWDIGESTION)

/datum/mutation/disability/fat/New()
	..()
	block = GLOB.fatblock

// WAS: /datum/bioEffect/chav
/datum/mutation/disability/speech/chav
	name = "Вульгарщина"
	desc = "Заставляет языковой центр мозга испытуемого строить предложения более примитивным образом."
	activation_messages = list("Чё-то ты внатуре тупишь, не?")
	deactivation_messages = list("Вы унимаете свою дерзость и грубое отношение к окружающим.")
	traits_to_add = list(TRAIT_CHAV)
	//List of swappable words. Normal word first, chav word second.
	var/static/list/chavlinks = list(
		"арест" = "на нары",
		"арестован" = "за решеткой",
		"жопа" = "срака",
		"плохой" = "фиговый",
		"бар" = "кабак",
		"мозг" = "котелок",
		"сломать" = "въебать",
		"сломан" = "въёбан",
		"сломанный" = "въёбанный",
		"врач" = "док",
		"класс" = "огонь",
		"классный" = "огонь",
		"псих" = "шизанутый",
		"пиво" = "пивас",
		"уничтожен" = "крякнут",
		"придурок" = "мудила",
		"разочарован" = "убит",
		"мерзкий" = "блевотный",
		"мерзко" = "блевотно",
		"мусорка" = "свалка",
		"выпить" = "бухнуть",
		"инженер" = "технарь",
		"инженера" = "технаря",
		"инженеры" = "технари",
		"инженеров" = "технарей",
		"взволнован" = "на взводе",
		"драка" = "махач",
		"слабый" = "соплячок",
		"слабак" = "сопляк",
		"еда" = "жратва",
		"кушать" = "жрать",
		"супер" = "отпад",
		"друг" = "кореш",
		"враг" = "чмырь",
		"лицо" = "морда",
		"эй" = "слыш",
		"человек" = "чувак",
		"люди" = "чуваки",
		"таяра" = "котяра",
		"вульпканин" = "дворняга",
		"вульпа" = "псина",
		"скрелл" = "жаба",
		"унатх" = "крокодил",
		"слайм" = "жидкий",
		"вокс" = "курица",
		"драск" = "кальмар",
		"серый" = "яйцеголовый",
		"дионея" = "бревно",
		"диона" = "куст",
		"кпб" = "консерва",
		"робот" = "микроволновка",
		"борг" = "рухлядь",
		"кидан" = "жучара",
		"ниан" = "слепень",
		"нуклеация" = "свечка",
		"гбс" = "гадюка",
		"скулакин" = "паукан",
		"сккулакин" = "паучара",
		"отдай" = "гони",
		"девушка" = "крошка",
		"выйди" = "свали",
		"хорошо" = "нормас",
		"отлично" = "четко",
		"радуется" = "лыбится",
		"счастлив" = "на кайфе",
		"грустный" = "в тоске",
		"испуган" = "на измене",
		"привет" = "йоу",
		"деньги" = "бабки",
		"дом" = "хата",
		"офицер" = "ментура",
		"кадет" =  "щенок",
		"варден" = "вертухай",
		"гсб" = "начальник",
		"хос" = "управитель",
		"идиот" = "тупица",
		"убить" = "замочить",
		"убил" = "замочил",
		"убила" = "замочила",
		"убили" = "замочили",
		"убит" = "грохнут",
		"ударить" = "втащить",
		"ударю" = "втащу",
		"ударил" = "втащил",
		"убежать" = "свалить",
		"парень" = "мужик",
		"беспорядок" = "срач",
		"ошибка" = "косяк",
		"нет" = "неа",
		"реально" = "внатуре",
		"крутой" = "ровный",
		"бежать" = "драпать",
		"сб" = "менты",
		"служба" = "прислуга",
		"глупый" = "отсталый",
		"воровать" = "тырить",
		"украл" = "стырил",
		"удивлен" = "обалдел",
		"подозрительный" = "мутный",
		"устал" = "заманался",
		"влажный" = "сырой",
		"что" = "че",
		"преступник" = "фраер",
		"преступление" = "мокруха",
		"да" = "дэ",
		"емае" = "епта",
		"обыск" = "шмон",
		"обыскивал" = "шмонал",
		"обыскивала" = "шмонала",
		"обыскивали" = "шмонали",
		"обыскивать" = "шмонать",
		"пока" = "бывай",
		"сигареты" = "курево",
		"сигары" = "сигарчухи"
	)

/datum/mutation/disability/speech/chav/New()
	..()
	block = GLOB.chavblock

/* SS220 EDIT START - Отключен для работоспособности переведенного гена в модуле
/datum/mutation/disability/speech/chav/on_say(mob/M, message)
	var/static/regex/R = regex("\\b([chavlinks.Join("|")])\\b", "g")
	message = R.Replace(message, /datum/mutation/disability/speech/chav/proc/replace_speech)
	return message

/datum/mutation/disability/speech/chav/proc/replace_speech(matched)
	REGEX_REPLACE_HANDLER
	return chavlinks[matched]
SS220 EDIT END */

// WAS: /datum/bioEffect/swedish
/datum/mutation/disability/speech/swedish
	name = "Горный акцент"
	desc = "Заставляет языковой центр мозга испытуемого строить предложения в манере, отдаленно напоминающий горное наречие."
	activation_messages = list("В вашем наречии стало преобладать нечто горное, что бы это ни значило.")
	deactivation_messages = list("Ваша разгоряченность горным акцентом начала спадать.")

/datum/mutation/disability/speech/swedish/New()
	..()
	block = GLOB.swedeblock

/datum/mutation/disability/speech/swedish/on_say(mob/living/M, message)
	// svedish
	message = replacetextEx(message,"Ц","Тс")
	message = replacetextEx(message,"ц","тс")
	message = replacetextEx(message,"Е","Э")
	message = replacetextEx(message,"е","э")
	message = replacetextEx(message,"Эй","Лее")
	message = replacetextEx(message,"ь","и")
	message = replacetextEx(message,"ъ","ы")
	message = replacetextEx(message,"Ч","Тщ")
	message = replacetextEx(message,"ч","тщ")
	message = replacetextEx(message,"ё","йо")
	message = replacetextEx(message,"Ё","Йо")
	message = replacetextEx(message,"Ш","Щ")
	message = replacetextEx(message,"ш","щ")
	message = replacetextEx(message,"сь","с")
	message = replacetextEx(message,"и","ы")
	if(prob(30) && !M.is_muzzled() && !M.is_facehugged())
		message += " Дап[pick("", ", дап", ", дап, дап")]!"
	return message

// WAS: /datum/bioEffect/unintelligable
/datum/mutation/disability/unintelligable
	name = "Неразборчивость"
	desc = "Серьезно повреждает ту часть мозга, которая отвечает за формирование устных предложений."
	activation_messages = list("Вы, кажется, и двух слов нормально связать не можете!")
	deactivation_messages = list("Вы вновь можете внятно доносить свою мысль.")
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
	for(var/i=1;i<=length(words);i++)
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
// MARK: USELESS SHIT
//////////////////

// WAS: /datum/bioEffect/strong
/datum/mutation/disability/strong
	// pretty sure this doesn't do jack shit, putting it here until it does
	name = "Нарциссизм"
	desc = "Заставляет носителя думать, что ему всё по плечу, когда на деле является лишь эффектом плацебо."
	activation_messages = list("Вы ощущаете прилив сил! Наверное...")
	deactivation_messages = list("Вы чувствуете себя слабым и хилым, впрочем как и раньше.")

/datum/mutation/disability/strong/New()
	..()
	block = GLOB.strongblock

// WAS: /datum/bioEffect/horns
/datum/mutation/disability/horns
	name = "Рога"
	desc = "Способствует росту плотного кератинового образования на голове пациента."
	activation_messages = list("На вашей голове вдруг выросла пара рогов.")
	deactivation_messages = list("Ваши рога отваливаются и рассыпаются в пыль.")

/datum/mutation/disability/horns/New()
	..()
	block = GLOB.hornsblock

/datum/mutation/disability/horns/on_draw_underlays(mob/M, g)
	return "horns_s"

/datum/mutation/grant_spell/immolate
	name = "Зажигательные митохондрии"
	desc = "У носителя появляется способность преобразовывать избыточную клеточную энергию в тепловую."
	activation_messages = list("Внезапно вам стало довольно жарко.")
	deactivation_messages = list("Вы больше не чувствуете несвойственную жару.")
	spelltype = /datum/spell/immolate

/datum/mutation/grant_spell/immolate/New()
	..()
	block = GLOB.immolateblock

/datum/spell/immolate
	name = "Самовоспламенение"
	desc = "Поджигает ваше тело. Удобно, чтобы поджечь, помимо себя, сигарету или неприятеля."

	base_cooldown = 600

	clothes_req = FALSE
	var/list/compatible_mobs = list(/mob/living/carbon/human)

	action_icon_state = "genetic_incendiary"

/datum/spell/immolate/create_new_targeting()
	return new /datum/spell_targeting/self

/datum/spell/immolate/cast(list/targets, mob/living/user = usr)
	var/mob/living/carbon/L = user
	L.adjust_fire_stacks(0.5)
	L.visible_message(SPAN_DANGER("[L.declent_ru(NOMINATIVE)]</b> внезапно вспыхивает ярким пламенем!"))
	L.IgniteMob()
	playsound(L.loc, 'sound/effects/bamf.ogg', 50, 0)

/datum/mutation/disability/speech/loud
	name = "Крикун"
	desc = "Заставляет центр речи в мозге испытуемого выкрикивать каждое предложение."
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
	name = "Головокружение"
	desc = "Вызывает в некоторых местах отключение мозжечка."
	activation_messages = list("Вы чувствуете сильное головокружение...")
	deactivation_messages = list("Вы восстанавливаете равновесие.")
	instability = -GENE_INSTABILITY_MODERATE

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
