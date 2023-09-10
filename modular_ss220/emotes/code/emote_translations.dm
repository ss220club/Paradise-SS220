//////////////////////
/// Living Emotes ///
////////////////////
/datum/emote/living/scream
	message = "кричит!"
	message_mime = "как будто кричит!"
	message_simple = "скулит."
	message_alien = "рычит!"
	message_postfix = "на %t!"
	emote_type = EMOTE_VISIBLE | EMOTE_MOUTH

/datum/emote/flip
	message = "делает кувырок!"

/datum/emote/spin
	key_third_person = "крутится"

/datum/emote/living/blush
	message = "краснеет."

/datum/emote/living/bow
	message = "кланяется."
	message_param = "кланяется %t."
	message_postfix = "%t."

/datum/emote/living/burp
	message = "отрыгивает."
	message_mime = "довольно противно открывает рот."

/datum/emote/living/collapse
	message = "падает!"

/datum/emote/living/dance
	message = "радостно танцует."
	var/dance_time = 3 SECONDS

/datum/emote/living/dance/run_emote(mob/living/user, params, type_override, intentional)
	. = ..()
	user.spin(dance_time, pick(0.1 SECONDS, 0.2 SECONDS))
	user.do_jitter_animation(rand(8 SECONDS, 16 SECONDS), dance_time / 4)

/datum/emote/living/deathgasp
	message = "цепенеет и расслабляется, взгляд становится пустым и безжизненным..."
	message_alien = "цепенеет и расслабляется, взгляд становится пустым и безжизненным..."
	message_robot = "на мгновение вздрагивает и замирает, глаза медленно темнеют."
	message_AI = "скрипит, экран мерцает, пока системы медленно выключаются."
	message_alien = "издает ослабевающий крик, зеленая кровь пузырится из пасти..."
	message_larva = "с тошнотворным шипением выдыхает воздух и падает на пол..."
	message_monkey = "издает слабый звон, когда рушится и перестает двигаться..."
	message_simple = "перестает двигаться..."

/datum/emote/living/drool
	message = "несет чепуху."

/datum/emote/living/quiver
	message = "дрожит."

/datum/emote/living/frown
	message = "хмурится."
	message_param = "хмурится, смотря на %t."

/datum/emote/living/gag
	message = "выворачивает содержимое желудка."
	message_mime = "будто бы выворачивает содержимое желудка."
	message_param = "выворачивает содержимое желудка на %t."

/datum/emote/living/glare
	message = "смотрит с ненавистью."
	message_param = "с ненавистью смотрит на %t."

/datum/emote/living/grin
	message = "скалится в улыбке."

/datum/emote/living/grimace
	message = "корчит рожицу."

/datum/emote/living/look
	message = "смотрит."
	message_param = "смотрит на %t."

/datum/emote/living/bshake
	message = "трясется."

/datum/emote/living/shudder
	message = "вздрагивает."

/datum/emote/living/point
	message = "показывает пальцем."
	message_param = "показывает пальцем на %t."

/datum/emote/living/pout
	message = "надувает губы."

/datum/emote/living/shake
	message = "трясет головой."

/datum/emote/living/shiver
	message = "дрожит."

/datum/emote/living/sigh/happy
	message = "Удовлетворённо вздыхает."
	message_mime = "кажется, удовлетворенно вздыхает"
	muzzled_noises = list("расслабленный", "довольный")

/datum/emote/living/sit
	message = "садится."

/datum/emote/living/smile
	message = "улыбается."
	message_param = "улыбается, смотря на %t."

/datum/emote/living/smug
	message = "самодовольно ухмыляется."
	message_param = "самодовольно ухмыляется, смотря на %t."

/datum/emote/living/nightmare
	message = "ворочается во сне."

/datum/emote/living/stare
	message = "пялится."
	message_param = "пялится на %t."

/datum/emote/living/strech
	message = "разминает руки."
	message_robot = "проверяет приводы."

/datum/emote/living/sulk
	message = "печально опускает руки."

/datum/emote/living/sway
	message = "качается на месте."

/datum/emote/living/swear
	message = "ругается!"
	message_param = "говорит нелестное слово %t!"
	message_mime = "показывает оскорбительный жест!"
	message_simple = "издает недовольный звук!"
	message_robot = "издает особенно оскорбительную серию звуковых сигналов!"
	message_postfix = ", обращаясь к %t!"

/datum/emote/living/tilt
	message = "наклоняет голову в сторону."

/datum/emote/living/tremble
	message = "дрожит от страха!"

/datum/emote/living/twitch
	message = "сильно дёргается."

/datum/emote/living/twitch_s
	message = "дергается."

/datum/emote/living/whimper
	message = "хнычет."
	message_mime = "кажется, поранился."
	muzzled_noises = list("слабый", "жалкий")

/datum/emote/living/wsmile
	message = "слабо улыбается."

///////////////////////////////////
/// Living Emotes - With Sound ///
/////////////////////////////////
/datum/emote/living/sigh
	message = "вздыхает."
	message_mime = "беззвучно вздыхает."
	emote_type = EMOTE_AUDIBLE | EMOTE_MOUTH

/datum/emote/living/sigh/get_sound(mob/living/user)
	. = ..()
	if(user.gender == FEMALE)
		return "modular_ss220/emotes/audio/female/sigh_female.ogg"
	else
		return "modular_ss220/emotes/audio/male/sigh_male.ogg"

/datum/emote/living/choke
	message = "подавился!"
	message_mime = "отчаянно хватается за горло!"
	emote_type = EMOTE_AUDIBLE | EMOTE_MOUTH
	audio_cooldown = 3 SECONDS

/datum/emote/living/choke/get_sound(mob/living/user)
	. = ..()
	if(user.gender == FEMALE)
		return pick(
			"modular_ss220/emotes/audio/female/choke_female_1.ogg",
			"modular_ss220/emotes/audio/female/choke_female_2.ogg",
			"modular_ss220/emotes/audio/female/choke_female_3.ogg")
	else
		return pick(
			"modular_ss220/emotes/audio/male/choke_male_1.ogg",
			"modular_ss220/emotes/audio/male/choke_male_2.ogg",
			"modular_ss220/emotes/audio/male/choke_male_3.ogg")

/datum/emote/living/sniff
	message = "нюхает."
	message_mime = "бесшумно нюхнул."
	cooldown = 5 SECONDS
	audio_cooldown = 3 SECONDS

/datum/emote/living/sniff/get_sound(mob/living/user)
	. = ..()
	if(user.gender == FEMALE)
		return "modular_ss220/emotes/audio/female/sniff_female.ogg"
	else
		return "modular_ss220/emotes/audio/male/sniff_male.ogg"

/datum/emote/living/snore
	message = "храпит."
	message_mime = "крепко спит."
	message_simple = "ворочается во сне."
	message_robot = "мечтает об электроовцах"
	emote_type = EMOTE_AUDIBLE | EMOTE_SOUND
	stat_allowed = CONSCIOUS
	max_stat_allowed = CONSCIOUS
	unintentional_stat_allowed = CONSCIOUS
	max_unintentional_stat_allowed = CONSCIOUS

/datum/emote/living/snore/get_sound(mob/living/user)
	. = ..()
	if(iscarbon(user))
		return pick(
			"modular_ss220/emotes/audio/snore_1.ogg",
			"modular_ss220/emotes/audio/snore_2.ogg",
			"modular_ss220/emotes/audio/snore_3.ogg",
			"modular_ss220/emotes/audio/snore_4.ogg",
			"modular_ss220/emotes/audio/snore_5.ogg",
			"modular_ss220/emotes/audio/snore_6.ogg",
			"modular_ss220/emotes/audio/snore_7.ogg")

//////////////////////
/// Carbon Emotes ///
////////////////////
/datum/emote/living/carbon/blink
	message = "моргает."

/datum/emote/living/carbon/blink_r
	key = "blink_r"
	message = "быстро моргает."

/datum/emote/living/carbon/clap
	message = "хлопает."
	message_mime = "бесшумно хлопает."
	message_param = "хлопает %t."
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE

/datum/emote/living/carbon/chuckle
	message = "усмехается."
	message_mime = "бесшумно усмехается."
	emote_type = EMOTE_AUDIBLE | EMOTE_MOUTH | EMOTE_VISIBLE
	muzzled_noises = list("радостно", "оптимистично")

/datum/emote/living/carbon/gurgle
	message = "издает неприятное бульканье."
	muzzled_noises = list("недовольно", "гортанно")

/datum/emote/living/carbon/inhale
	message = "вдыхает."
	muzzled_noises = list("воздушно")

/datum/emote/living/carbon/inhale/sharp
	message = "глубоко вдыхает!"

/datum/emote/living/carbon/kiss
	message = "целует."
	message_param = "целует %t!"
	muzzled_noises = list("smooching")

/datum/emote/living/carbon/wave
	message = "машет."
	message_param = "машет %t."

/datum/emote/living/carbon/exhale
	message = "выдыхает."

/datum/emote/living/carbon/scowl
	message = "хмурится."

/datum/emote/living/groan
	message = "болезненно вздыхает!"
	message_mime = "как будто болезненно вздыхает!"
	message_param = "болезненно вздыхает на %t."
	muzzled_noises = list("болезненно")

/datum/emote/living/carbon/sign
	message = "показывает несколько пальцев."
	message_param = "показывает %t пальцев."
	param_desc = "число(0-10)"

/datum/emote/living/carbon/faint
	message = "падает в обморок."

///////////////////////////////////
/// Carbon Emotes - With Sound ///
/////////////////////////////////
/datum/emote/living/carbon/moan
	message = "стонет!"
	message_mime = "как будто стонет!"
	muzzled_noises = list("болезненно")
	emote_type = EMOTE_VISIBLE

/datum/emote/living/carbon/moan/get_sound(mob/living/user)
	. = ..()
	if(user.gender == FEMALE)
		return pick(
			"modular_ss220/emotes/audio/female/moan_female_1.ogg",
			"modular_ss220/emotes/audio/female/moan_female_2.ogg",
			"modular_ss220/emotes/audio/female/moan_female_3.ogg")
	else
		return pick(
			"modular_ss220/emotes/audio/male/moan_male_1.ogg",
			"modular_ss220/emotes/audio/male/moan_male_2.ogg",
			"modular_ss220/emotes/audio/male/moan_male_3.ogg")

/datum/emote/living/carbon/laugh
	message = "смеется."
	message_mime = "бесшумно смеется!"
	message_param = "смеется над %t."
	muzzled_noises = list("счастливо", "весело")
	emote_type = EMOTE_AUDIBLE | EMOTE_MOUTH | EMOTE_VISIBLE

/datum/emote/living/carbon/laugh/get_sound(mob/living/user)
	. = ..()
	if(user.gender == FEMALE)
		return pick(
			"modular_ss220/emotes/audio/female/laugh_female_1.ogg",
			"modular_ss220/emotes/audio/female/laugh_female_2.ogg",
			"modular_ss220/emotes/audio/female/laugh_female_3.ogg")
	else
		return pick(
			"modular_ss220/emotes/audio/male/laugh_male_1.ogg",
			"modular_ss220/emotes/audio/male/laugh_male_2.ogg",
			"modular_ss220/emotes/audio/male/laugh_male_3.ogg")

/datum/emote/living/carbon/yawn
	message = "зевает."
	muzzled_noises = list("устало", "медленно", "сонно")
	emote_type = EMOTE_AUDIBLE | EMOTE_MOUTH | EMOTE_SOUND

/datum/emote/living/carbon/yawn/get_sound(mob/living/user)
	. = ..()
	if(user.gender == FEMALE)
		return pick(
			"modular_ss220/emotes/audio/female/yawn_female_1.ogg",
			"modular_ss220/emotes/audio/female/yawn_female_2.ogg",
			"modular_ss220/emotes/audio/female/yawn_female_3.ogg")
	else
		return pick(
			"modular_ss220/emotes/audio/male/yawn_male_1.ogg",
			"modular_ss220/emotes/audio/male/yawn_male_2.ogg")

/datum/emote/living/carbon/giggle
	message = "хихикает."
	message_mime = "бесшумно хихикает!"
	muzzled_noises = list("булькающе")

/datum/emote/living/carbon/giggle/get_sound(mob/living/user)
	. = ..()
	if(user.gender == FEMALE)
		return pick(
			"modular_ss220/emotes/audio/female/giggle_female_1.ogg",
			"modular_ss220/emotes/audio/female/giggle_female_2.ogg",
			"modular_ss220/emotes/audio/female/giggle_female_3.ogg",
			"modular_ss220/emotes/audio/female/giggle_female_4.ogg")
	else
		return pick(
			"modular_ss220/emotes/audio/male/giggle_male_1.ogg",
			"modular_ss220/emotes/audio/male/giggle_male_2.ogg")

/datum/emote/living/carbon/cough
	message = "кашляет!"
	message_mime = "бесшумно кашляет!"
	emote_type = EMOTE_VISIBLE | EMOTE_MOUTH

/datum/emote/living/carbon/cough/get_sound(mob/living/user)
	. = ..()
	if(user.gender == FEMALE)
		return pick(
			"modular_ss220/emotes/audio/female/cough_female_1.ogg",
			"modular_ss220/emotes/audio/female/cough_female_2.ogg",
			"modular_ss220/emotes/audio/female/cough_female_3.ogg")
	else
		return pick(
			"modular_ss220/emotes/audio/male/cough_male_1.ogg",
			"modular_ss220/emotes/audio/male/cough_male_2.ogg",
			"modular_ss220/emotes/audio/male/cough_male_2.ogg")

/////////////////////
/// Human Emotes ///
///////////////////
/datum/emote/living/carbon/human/airguitar
	message = "натягивает струны и бьет головой, как шимпанзе в сафари."

/datum/emote/living/carbon/human/crack
	message = "хрустит пальцами."

/datum/emote/living/carbon/human/eyebrow
	message = "приподнимает бровь."
	message_param = "приподнимает бровь на %t."

/datum/emote/living/carbon/human/grumble
	message = "ворчит!"
	message_mime = "как будто ворчит!"
	message_postfix = "на %t!"
	muzzled_noises = list("беспокойно")

/datum/emote/living/carbon/human/hug
	message = "обнимает себя."
	message_param = "обнимает %t."

/datum/emote/living/carbon/human/mumble
	message = "бормочет!"
	message_mime = "кажется, что он говорит приятное ничто!"
	message_postfix = "на %t!"

/datum/emote/living/carbon/human/nod
	message = "кивает."
	message_param = "кивает, обращаясь к %t."

/datum/emote/living/carbon/human/shake
	message = "трясет головой."
	message_param = "трясет головой, обращяясь к %t."

/datum/emote/living/carbon/human/pale
	message = "на секунду бледнеет."

/datum/emote/living/carbon/human/raise
	message = "поднимает руку."

/datum/emote/living/carbon/human/shrug
	message = "пожимает плечами."

/datum/emote/living/carbon/human/johnny
	message = "затягивается сигаретой и выдыхает дым в форме своего имени."
	message_param = "тупо"

/datum/emote/living/carbon/human/sneeze
	message = "чихает."
	muzzled_noises = list("странно", "остро")

/datum/emote/living/carbon/human/wink
	message = "подмигивает."

/datum/emote/living/carbon/human/snap
	message = "щелкает пальцами."
	message_param = "щелкает пальцами на %t."

/datum/emote/living/carbon/human/fart
	message = "пердит."
	message_param = "пердит в направлении %t."

/datum/emote/living/carbon/sign/signal
	message_param = "показывает %t пальцев."
	param_desc = "число(0-10)"

/datum/emote/living/carbon/human/wag
	message = "начинает вилять хвостом."

/datum/emote/living/carbon/human/wag/stop
	message = "перестает вилять хвостом."

/datum/emote/living/carbon/human/scream/screech
	message = "визжит!"
	message_param = "визжит на %t!"

/datum/emote/living/carbon/human/scream/screech/roar
	message = "ревет!"
	message_param = "ревет на %t!"

/datum/emote/living/carbon/human/monkey/roll
	message = "кружится."

/datum/emote/living/carbon/human/monkey/scratch
	message = "чешется."

/datum/emote/living/carbon/human/monkey/tail
	message = "машет хвостом."

/datum/emote/living/carbon/human/flap
	message = "хлопает крыльями."

/datum/emote/living/carbon/human/flutter
	message = "зло хлопает крыльями."

/datum/emote/living/carbon/human/flutter
	message = "трепещет крыльями."

/datum/emote/living/carbon/human/quill
	message = "шелестят перьями."
	message_param = "шелестят перьями на %t."

/datum/emote/living/carbon/human/clack
	message = "клацает своими мандибулами."
	message_param = "клацает своими мандибулами на %t."

/datum/emote/living/carbon/human/clack/click
	key = "click"
	key_third_person = "clicks"
	message = "щелкает своими мандибулами."
	message_param = "щелкает своими мандибулами на %t."

/datum/emote/living/carbon/human/drask_talk/drone
	message = "жужжит."
	message_param = "жужжит на %t."


/datum/emote/living/carbon/human/drask_talk/hum
	message = "напевает."
	message_param = "напевает %t."

/datum/emote/living/carbon/human/drask_talk/rumble
	message = "урчит."
	message_param = "урчит на %t."

/datum/emote/living/carbon/human/hiss
	message = "шипит."
	message_param = "шипит на %t."
	muzzled_noises = list("слабое шипение")

/datum/emote/living/carbon/human/creak
	message = "скрипит."
	message_param = "скрипит на %t."

/datum/emote/living/carbon/human/howl
	message = "воет."
	message_mime = "беззвучно воет."
	message_param = "воет на %t."

/datum/emote/living/carbon/human/growl
	message = "рычит."
	message_mime = "бесшумно рычит."
	message_param = "рычит на %t."
	muzzled_noises = list("раздражённо")

/datum/emote/living/carbon/human/rattle
	message = "гремит костями."
	message_param = "гремит костями на %t."

/datum/emote/living/carbon/human/crack/slime
	message = "сминает костяшки пальцев!"

/datum/emote/living/carbon/human/crack/diona
	message = "трещит ветками!"

/datum/emote/living/carbon/human/snuffle
	key = "snuffle"
	key_third_person = "snuffles"
	message = "шмыгает носом."
	message_param = "шмыгает носом на %t."

/datum/emote/living/carbon/human/hem
	key = "hem"
	key_third_person = "hems"
	message = "хмыкает."
	message_param = "хмыкает %t."

/datum/emote/living/carbon/human/scratch
	key = "scratch"
	key_third_person = "scratch"
	message = "чешется."
	message_param = "чешет %t."

//////////////////////////////////
/// Human Emotes - With Sound ///
////////////////////////////////
/datum/emote/living/carbon/human/scream
	message = "кричит!"
	message_mime = "как будто кричит!"
	message_simple = "скулит."
	message_alien = "рычит!"
	message_postfix = "на %t!"
	muzzled_noises = list("очень громко")
	emote_type = EMOTE_VISIBLE | EMOTE_MOUTH

/datum/emote/living/carbon/human/scream/select_message_type(mob/user, msg, intentional)
	. = ..()
	var/mob/living/carbon/human/H = user
	if(H.dna.species?.scream_verb)
		if(H.mind?.miming)
			return "как будто [H.dna.species?.scream_verb]!"
		else
			return "[H.dna.species?.scream_verb]!"

/datum/emote/living/carbon/human/scream/get_sound(mob/living/user)
	. = ..()
	if(user.gender == FEMALE)
		return pick(
			"modular_ss220/emotes/audio/female/scream_female_1.ogg",
			"modular_ss220/emotes/audio/female/scream_female_2.ogg",
			"modular_ss220/emotes/audio/female/scream_female_3.ogg")
	else
		return "modular_ss220/emotes/audio/male/scream_male.ogg"

/datum/emote/living/carbon/human/whistle
	key = "whistle"
	key_third_person = "whistles"
	message = "свистит."
	message_param = "свистит на %t."
	emote_type = EMOTE_AUDIBLE | EMOTE_MOUTH | EMOTE_VISIBLE
	sound = "modular_ss220/emotes/audio/whistle.ogg"

/datum/emote/living/carbon/human/cry
	message = "плачет."
	muzzled_noises = list("слабо", "жалко", "грустно")
	emote_type = EMOTE_AUDIBLE | EMOTE_MOUTH | EMOTE_VISIBLE

/datum/emote/living/carbon/human/cry/get_sound(mob/living/user)
	. = ..()
	if(user.gender == FEMALE)
		return pick(
			"modular_ss220/emotes/audio/female/cry_female_1.ogg",
			"modular_ss220/emotes/audio/female/cry_female_2.ogg",
			"modular_ss220/emotes/audio/female/cry_female_3.ogg",)
	else
		return pick(
			"modular_ss220/emotes/audio/male/cry_male_1.ogg",
			"modular_ss220/emotes/audio/male/cry_male_2.ogg",)

/datum/emote/living/carbon/human/gasp
	message = "задыхается!"
	message_mime = "кажется, задыхается!"
	emote_type = EMOTE_AUDIBLE | EMOTE_MOUTH | EMOTE_VISIBLE

/datum/emote/living/carbon/human/gasp/get_sound(mob/living/user)
	. = ..()
	if(user.gender == FEMALE)
		return pick(
			"modular_ss220/emotes/audio/female/gasp_female_1.ogg",
			"modular_ss220/emotes/audio/female/gasp_female_2.ogg",
			"modular_ss220/emotes/audio/female/gasp_female_3.ogg",
			"modular_ss220/emotes/audio/female/gasp_female_4.ogg",
			"modular_ss220/emotes/audio/female/gasp_female_5.ogg",
			"modular_ss220/emotes/audio/female/gasp_female_6.ogg",
			"modular_ss220/emotes/audio/female/gasp_female_7.ogg")
	else
		return pick(
			"modular_ss220/emotes/audio/male/gasp_male_1.ogg",
			"modular_ss220/emotes/audio/male/gasp_male_2.ogg",
			"modular_ss220/emotes/audio/male/gasp_male_3.ogg",
			"modular_ss220/emotes/audio/male/gasp_male_4.ogg",
			"modular_ss220/emotes/audio/male/gasp_male_5.ogg",
			"modular_ss220/emotes/audio/male/gasp_male_6.ogg",
			"modular_ss220/emotes/audio/male/gasp_male_7.ogg")

/datum/emote/living/carbon/human/salute
	message = "салютует."
	message_param = "салютует %t."
	emote_type = EMOTE_VISIBLE

/datum/emote/living/carbon/human/salute/get_sound(mob/living/user)
	var/mob/living/carbon/human/H = user
	if(!is_type_in_list(H.shoes, funny_shoes))
		return 'sound/effects/salute.ogg'
	if(is_type_in_list(H.shoes, funny_shoes))
		return 'sound/items/toysqueak1.ogg'

/////////////////////
/// Alien Emotes ///
///////////////////
/datum/emote/living/carbon/alien/humanoid/roar
	message = "ревет!"
	message_param = "ревет на %t!"

/datum/emote/living/carbon/alien/humanoid/hiss
	message = "шипит!"
	message_param = "шипит %t!"

/datum/emote/living/carbon/alien/humanoid/gnarl
	message = "оскаливается и показывает зубы."
	message_param = "оскаливается и показывает зубы %t."

/////////////////////
/// Brain Emotes ///
///////////////////
/datum/emote/living/carbon/brain/alarm
	message = "подает сигнал тревоги."
	self_message = "Вы подаете сигнал тревоги."

/datum/emote/living/carbon/brain/alert
	message = "издаёт страдальческий звук."
	self_message = "Вы издаёте страдальческий звук."

/datum/emote/living/carbon/brain/notice
	message = "воспроизводит громкий звук."
	self_message = "Вы воспроизводите громкий звук."

/datum/emote/living/carbon/brain/flash
	message = "начинает быстро мигать лампочками!"

/datum/emote/living/carbon/brain/whistle
	message = "свистит."
	self_message = "Вы свистите."
	emote_type = EMOTE_AUDIBLE | EMOTE_MOUTH | EMOTE_SOUND
	sound = "modular_ss220/emotes/audio/whistle.ogg"

/datum/emote/living/carbon/brain/beep
	message = "бипает."
	self_message = "Вы бипаете."

/datum/emote/living/carbon/brain/boop
	message = "бупает."
	self_message = "вы бупаете."

////////////////////
/// Keybindings ///
//////////////////
/datum/keybinding/emote/carbon/human/hem
	linked_emote = /datum/emote/living/carbon/human/hem
	name = "Хныкать"

/datum/keybinding/emote/carbon/human/scratch
	linked_emote = /datum/emote/living/carbon/human/scratch
	name = "Чесаться"

/datum/keybinding/emote/carbon/human/whistle
	linked_emote = /datum/emote/living/carbon/human/whistle
	name = "Свистеть"

/datum/keybinding/emote/carbon/human/snuffle
	linked_emote = /datum/emote/living/carbon/human/snuffle
	name = "Шмыгать носом"

////////////////
/// ОСУЖДАЮ ///
//////////////
/datum/species
	scream_verb = "кричит"
	suicide_messages = list(
		"пытается откусить себе язык!",
		"выдавливает свои глазницы большими пальцами!",
		"сворачивает себе шею!",
		"задерживает дыхание!")

/datum/species/diona
	suicide_messages = list(
		"теряет ветви!",
		"вытаскивает из тайника бутыль с гербицидом и делает большой глоток!",
		"разваливается на множество нимф!")

/datum/species/drask
	suicide_messages = list(
		"трёт себя до возгорания!",
		"давит пальцами на свои большие глаза!",
		"втягивает теплый воздух!",
		"задерживает дыхание!")

/datum/species/golem
	suicide_messages = list(
		"рассыпается в прах!",
		"разбивает своё тело на части!")

/datum/species/kidan
	suicide_messages = list(
		"пытается откусить себе усики!",
		"вонзает когти в свои глазницы!",
		"сворачивает себе шею!",
		"разбивает себе панцирь",
		"протыкает себя челюстями!",
		"задерживает дыхание!")

/datum/species/machine
	suicide_messages = list(
		"отключает питание!",
		"разбивает свой монитор!",
		"выкручивает себе шею!",
		"загружает дополнительную оперативную память!",
		"замыкает свои микросхемы!",
		"блокирует свой вентиляционный порт!")

/datum/species/moth
	suicide_messages = list(
		"откусывает свои усики!",
		"вспарывает себе живот!",
		"отрывает себе крылья!",
		"заддерживает своё дыхание!")

/datum/species/plasmaman
	suicide_messages = list(
		"сворачивает себе шею!",
		"впускает себе немного O2!",
		"осознает экзистенциальную проблему быть рождённым из плазмы!",
		"показывает свою истинную природу, которая оказывается плазмой!")

/datum/species/shadow
	suicide_messages = list(
		"пытается откусить себе язык!",
		"выдавливает большими пальцами себе глазницы!",
		"сворачивает себе шею!",
		"пялится на ближайший источник света!")

/datum/species/skeleton
	suicide_messages = list(
		"ломает себе кости!",
		"сваливается в кучу!",
		"разваливается!",
		"откручивает себе череп!")

/datum/species/skrell
	suicide_messages = list(
		"пытается откусить себе язык!",
		"выдавливает большими пальцами свои глазницы!",
		"сворачивает себе шею!",
		"задыхается словно рыба!",
		"душит себя собственными усиками!")

/datum/species/slime
	suicide_messages = list(
		"тает в лужу!",
		"растекается в лужу!",
		"становится растаявшим желе!",
		"вырывает собственное ядро!",
		"становится коричневым, тусклым и растекается в лужу!")

/datum/species/tajaran
	suicide_messages = list(
		"пытается откусить себе язык!",
		"вонзает когти себе в глазницы!",
		"сворачивает себе шею!",
		"задерживает дыхание!")

/datum/species/unathi
	suicide_messages = list(
		"is attempting to bite their tongue off!",
		"is jamming their claws into their eye sockets!",
		"is twisting their own neck!",
		"is holding their breath!")

/datum/species/vox
	suicide_messages = list(
		"пытается откусить себе язык!",
		"вонзает когти себе в глазницы!",
		"сворачивает себе шею!",
		"задерживает дыхание!",
		"глубоко вдыхает кислород!")

/datum/species/vulpkanin
	suicide_messages = list(
		"пытается откусить себе язык!",
		"выдавливает когтями свои глазницы!",
		"сворачивает себе шею!",
		"задерживает дыхание!")
