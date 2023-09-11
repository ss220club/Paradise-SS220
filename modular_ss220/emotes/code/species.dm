/datum/species
	scream_verb = "кричит"
	var/male_giggle_sound = list(
		'modular_ss220/emotes/audio/male/giggle_male_1.ogg',
		'modular_ss220/emotes/audio/male/giggle_male_2.ogg')
	var/female_giggle_sound = list(
		'modular_ss220/emotes/audio/female/giggle_female_1.ogg',
		'modular_ss220/emotes/audio/female/giggle_female_2.ogg',
		'modular_ss220/emotes/audio/female/giggle_female_3.ogg',
		'modular_ss220/emotes/audio/female/giggle_female_4.ogg')
	var/male_laugh_sound = list(
		'modular_ss220/emotes/audio/male/laugh_male_1.ogg',
		'modular_ss220/emotes/audio/male/laugh_male_2.ogg',
		'modular_ss220/emotes/audio/male/laugh_male_3.ogg')
	var/female_laugh_sound = list(
		'modular_ss220/emotes/audio/female/laugh_female_1.ogg',
		'modular_ss220/emotes/audio/female/laugh_female_2.ogg',
		'modular_ss220/emotes/audio/female/laugh_female_3.ogg')
	var/female_gasp_sound = list(
		'modular_ss220/emotes/audio/female/gasp_female_1.ogg',
		'modular_ss220/emotes/audio/female/gasp_female_2.ogg',
		'modular_ss220/emotes/audio/female/gasp_female_3.ogg',
		'modular_ss220/emotes/audio/female/gasp_female_4.ogg',
		'modular_ss220/emotes/audio/female/gasp_female_5.ogg',
		'modular_ss220/emotes/audio/female/gasp_female_6.ogg',
		'modular_ss220/emotes/audio/female/gasp_female_7.ogg')
	gasp_sound = list(
		'modular_ss220/emotes/audio/male/gasp_male_1.ogg',
		'modular_ss220/emotes/audio/male/gasp_male_2.ogg',
		'modular_ss220/emotes/audio/male/gasp_male_3.ogg',
		'modular_ss220/emotes/audio/male/gasp_male_4.ogg',
		'modular_ss220/emotes/audio/male/gasp_male_5.ogg',
		'modular_ss220/emotes/audio/male/gasp_male_6.ogg',
		'modular_ss220/emotes/audio/male/gasp_male_7.ogg')
	female_scream_sound = list(
		'modular_ss220/emotes/audio/female/scream_female_1.ogg',
		'modular_ss220/emotes/audio/female/scream_female_2.ogg',
		'modular_ss220/emotes/audio/female/scream_female_3.ogg')
	male_cough_sounds = list(
		'modular_ss220/emotes/audio/male/cough_male_1.ogg',
		'modular_ss220/emotes/audio/male/cough_male_2.ogg',
		'modular_ss220/emotes/audio/male/cough_male_3.ogg')
	female_cough_sounds = list(
		'modular_ss220/emotes/audio/female/cough_female_1.ogg',
		'modular_ss220/emotes/audio/female/cough_female_2.ogg',
		'modular_ss220/emotes/audio/female/cough_female_3.ogg')
	female_sneeze_sound = 'modular_ss220/emotes/audio/female/sneeze_female.ogg'
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
	scream_verb = "жужжит"
	female_giggle_sound = 'modular_ss220/emotes/audio/moth/mothchitter.ogg'
	male_giggle_sound = 'modular_ss220/emotes/audio/moth/mothchitter.ogg'
	male_scream_sound = 'modular_ss220/emotes/audio/moth/scream_moth.ogg'
	female_scream_sound = 'modular_ss220/emotes/audio/moth/scream_moth.ogg'
	male_sneeze_sound = 'modular_ss220/emotes/audio/moth/mothsneeze.ogg'
	female_sneeze_sound = 'modular_ss220/emotes/audio/moth/mothsneeze.ogg'
	female_laugh_sound = 'modular_ss220/emotes/audio/moth/mothlaugh.ogg'
	male_laugh_sound = 'modular_ss220/emotes/audio/moth/mothlaugh.ogg'
	female_cough_sounds = 'modular_ss220/emotes/audio/moth/mothcough.ogg'
	male_cough_sounds = 'modular_ss220/emotes/audio/moth/mothcough.ogg'
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
		"пытается откусить себе язык!",
		"вонзает когти себе в глазницы!",
		"сворачивает себе шею!",
		"задерживает дыхание!")

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
