
/datum/announcement_configuration/begemot
	default_title = "Бегемот ревёт"
	global_announcement = TRUE
	sound = sound('modular_ss220/event/sound/begemore_rar.ogg')
	tts_seed = /datum/tts_seed/silero/anubarak

/datum/announcement_configuration/herald
	default_title = "Вестник - оглашает"
	global_announcement = TRUE
	sound = sound('modular_ss220/event/sound/bell_1.ogg')
	tts_seed = /datum/tts_seed/silero/deckard

/datum/announcement_configuration/cenral_comand
	default_title = "Внимание, ИСН «Кибериада»."
	global_announcement = TRUE
	sound = sound('sound/misc/notice2.ogg')
	tts_seed = /datum/tts_seed/silero/cassidy

GLOBAL_DATUM_INIT(begemot, /datum/announcer, new(config_type = /datum/announcement_configuration/begemot))
GLOBAL_DATUM_INIT(herald, /datum/announcer, new(config_type = /datum/announcement_configuration/herald))
GLOBAL_DATUM_INIT(cenral_comand, /datum/announcer, new(config_type = /datum/announcement_configuration/cenral_comand))


// Event begemot anounces

/proc/begemot_great()
	var/message = "Вы слышите далёкий рёв, пробирающий вас до костей. Станция начинает вибрировать, металл стонет и трещит под чудовищной нагрузкой, словно что-то огромное проходит совсем рядом."
	GLOB.begemot.Announce(message)

// CC event anounces

/proc/cc_atantion()
	var/title = "Внимание, ИСН «Кибериада»."
	var/message = "Зафиксированы сообщения об аномальном блюспейс-объекте в вашем секторе. \
	В ваш район направлен разведывательный шаттл ОБР для проведения разведки и последующего устранения аномалии. \
	Ожидайте дальнейших указаний. Слава Нанотрейзен."
	GLOB.cenral_comand.Announce(message, title)

/proc/cc_ert_lost()
	var/title = "Внимание, ИСН «Кибериада»."
	var/message = "Разведывательный шаттл ОБР уничтожен. Повторяю: разведывательный шаттл ОБР уничтожен. \
	АКН «Трурль» запрашивает поддержку флотилии для подавления угрозы уровня «Дельта». Прибытие флотилии ожидается в течение 4 часов. \
	Всему персоналу станции предписывается сдерживать угрозу до её прибытия."
	GLOB.cenral_comand.Announce(message, title)

// Herald anounces
/proc/herald_hello()
	var/title = "Слово Вестника"
	var/message = "Хромой Джонни ступал тяжко, глядел в глаза, слушал трёп ваш да рыскал по палубе - капитана искал. Пятерых он черной меткой пометил, да лишь один встанет во главе.\
	Бегемот и его команда жаждут капитана.\
	Пятеро вас - претенденты. Так докажите, за кем пойдут матросы. Собирайте команды из своих салаг, сколачивайте свору и ведите их.\
	И так уж быть - тот, кто устоит, капитаном станет, и его команда жить будет. А прочих Бегемот пожрёт вместе со станцией."

	GLOB.herald.Announce(message, title)

