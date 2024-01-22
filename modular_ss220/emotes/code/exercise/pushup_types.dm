/datum/pushup/correct
	name = "На ноги и руки"
	message = "перенес свой вес на руки и ноги."
	self_message = "Вы переносите свой вес на руки и ноги."

/datum/pushup/correct/safety
	name = "На ноги и руки - безопасный"
	will_do_more_due_to_oxy_damage = FALSE

/datum/pushup/knees
	name = "На колени"
	message = "переносит свой вес на колени. Жалкое зрелище."
	self_message = "Вы сместили вес на колени. СЛАБАК!"
	message_pushup = "на коленях"
	can_non_humans_do = FALSE
	difficulty_mod = 0.6

/datum/pushup/one_arm
	name = "На одной руке"
	message = "перенес свой вес на ОДНУ РУКУ! Мощно!"
	self_message = "Вы переносите свой вес на одну руку. Сильно!"
	message_pushup = "на одной руке"
	can_non_humans_do = FALSE
	is_bold_message = TRUE
	difficulty_mod = 2

/datum/pushup/clap
	name = "На ноги и руки с хлопком"
	message = "перенес свой вес на руки и ноги и приготовился для хлопков! Хоп!"
	self_message = "Вы переносите свой вес на руки и ноги и приготовились для хлопков. Хоп!"
	message_pushup = "с хлопком"
	can_non_humans_do = FALSE
	is_bold_message = TRUE
	staminaloss_per_pushup = 15
	sounds = list(
		'modular_ss220/emotes/audio/claps/clap1.ogg',
		'modular_ss220/emotes/audio/claps/clap2.ogg',
		'modular_ss220/emotes/audio/claps/clap3.ogg',
		)

/datum/pushup/clap/fast
	name = "На ноги и руки с хлопком - быстрый"
	difficulty_mod = 1.25
	time_mod = 0.6
	split_message = 5

/datum/pushup/clap/one_arm
	name = "На одной руке с хлопком"
	message = "перенес свой вес на ОДНУ РУКУ и приготовил вторую для ХЛОПКА! НЕВЕРОЯТНО!"
	self_message = "Вы переносите свой вес на одну руку, а вторую приготовили для хлопка. Невероятно!"
	message_pushup = "на одной руке с хлопком"
	is_bold_message = TRUE
	staminaloss_per_pushup = 15
	difficulty_mod = 2

/datum/pushup/correct/slow
	name = "На ноги и руки - медленный"
	message_pushup = "медленно"
	difficulty_mod = 0.8
	time_mod = 2
	split_message = 5

/datum/pushup/correct/slow/very
	name = "На ноги и руки - очень медленный"
	message_pushup = "крайне медленно"
	difficulty_mod = 0.6
	time_mod = 4

/datum/pushup/correct/fast
	name = "На ноги и руки - быстрый"
	message_pushup = "быстро"
	difficulty_mod = 1.25
	time_mod = 0.6
	split_message = 10

/datum/pushup/correct/fast/very
	name = "На ноги и руки - очень быстрый"
	message_pushup = "крайне быстро"
	difficulty_mod = 2
	time_mod = 0.3
	split_message = 15

/datum/pushup/correct/foot
	name = "На ступнях"
	message = "переносит свой вес на ступни и убрал руки за спину! КАК ОН ЭТО ДЕЛАЕТ?!"
	self_message = "Вы сместили вес на ступни и убрали руки. ЭТО БУДЕТ НЕВОЗМОЖНО!"
	message_pushup = "на ступнях и без рук"
	staminaloss_per_pushup = 30
	difficulty_mod = 10
	is_bold_message = TRUE
	will_do_more_due_to_oxy_damage = FALSE
	can_non_humans_do = FALSE
