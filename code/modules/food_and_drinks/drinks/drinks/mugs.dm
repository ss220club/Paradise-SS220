
/obj/item/reagent_containers/drinks/mug
	name = "coffee mug"
	desc = "Кружка для питья горячих напитков."
	icon = 'icons/obj/mugs.dmi'
	icon_state = "mug"
	var/novelty = FALSE
	var/preset = FALSE

/obj/item/reagent_containers/drinks/mug/novelty
	name = "novelty coffee mug"
	desc = "Забавная кружка для кофе или других горячих напитков!"
	novelty = TRUE

/datum/novelty_mug
	var/name = "novelty coffee mug"
	var/description = "Забавная кружка для кофе или других горячих напитков!"
	var/state = "mug"

/datum/novelty_mug/peace
	name = "peaceful mug"
	description = "Она такая... умиротворяющая, чувак."
	state = "mug_peace"

/datum/novelty_mug/fire
	name = "fire mug"
	description = "Осторожно: содержимое и дизайн могут быть очень горячими."
	state = "mug_fire"

/datum/novelty_mug/best
	name = "best mug"
	description = "По указу этой кружки, ты лучший!"
	state = "mug_best"

/datum/novelty_mug/best/New()
	var/locale = pick("Room's", "Department's", "Station's", "World's", "Sector's", "System's", "Galaxy's", "Universe's", "Multi-verse's", "Nanotrasen's", "Syndicate's")
	var/what = pick("Crewmember", "Spessman", "Employee", "Coffee", "Coffee-drinker", "Survivor", "Personality", "Lifeform", "Doctor", "Scientist", "Engineer", "Officer", "Assistant", "Captain", "Agent")
	name = "\"[locale] Best [what]\" mug"

/datum/novelty_mug/worst
	name = "worst mug"
	description = "По указу этой кружки, ты худший!"
	state = "mug_worst"

/datum/novelty_mug/worst/New()
	var/locale = pick("Room's", "Department's", "Station's", "World's", "Sector's", "System's", "Galaxy's", "Universe's", "Multi-verse's", "Nanotrasen's", "Syndicate's")
	var/what = pick("Crewmember", "Spessman", "Employee", "Coffee", "Coffee-drinker", "Survivor", "Personality", "Lifeform", "Doctor", "Scientist", "Engineer", "Officer", "Assistant", "Captain", "Agent")
	name = "\"[locale] Worst [what]\" mug"

/datum/novelty_mug/insult
	name = "insulting coffee mug"
	description = "Как грубо!"
	state = "mug_insult"

/datum/novelty_mug/insult/New()
	var/insult = pick("Здесь недостаточно кофе, чтобы сделать тебя терпимым.", "Я пью кофе, чтобы притворяться, что мне нравятся люди.", "Я еще не выпил кофе... А какая у тебя причина?", "Этот кофе крепче тебя.", "Латте — для слабаков, таких как ты.")
	description = "Кружка говорит:\"[insult]\""

/datum/novelty_mug/pda
	name = "PDA mug"
	description = "Наконец-то, нашлось применение для ПДА!"
	state = "mug_pda"

/datum/novelty_mug/rad
	name = "radioactive mug"
	description = "Должен ли кофе быть зелёным... и светящимся?"
	state = "mug_rad"

/datum/novelty_mug/tide
	name = "greytide mug"
	description = "Этот кофе бьёт так сильно, как и тулбокс по лицу!"
	state = "mug_tide"

/datum/novelty_mug/happy
	name = "happy mug"
	description = "Даже когда ты не счастлив, эта кружка помогает выглядеть радостным среди коллег."
	state = "mug_happy"

/datum/novelty_mug/pills
	name = "prescription mug"
	description = "Рецепт: кофеин. Дозировка: столько, сколько нужно."
	state = "mug_pill"

/datum/novelty_mug/rainbow
	name = "rainbow mug"
	description = "Так завораживающе!"
	state = "mug_rainbow"

/obj/item/reagent_containers/drinks/mug/Initialize(mapload)
	. = ..()
	if(preset)
		return
	if(novelty)
		var/novelty_type = pick(subtypesof(/datum/novelty_mug))
		var/datum/novelty_mug/selected = new novelty_type
		name = selected.name
		desc = selected.description
		icon_state = selected.state
	else
		icon_state = pick("mug_black", "mug_white", "mug_red", "mug_blue", "mug_green", "mug_pink")

/obj/item/reagent_containers/drinks/mug/eng
	name = "engineer's mug"
	desc = "Кружка, спроектированная для того, чтобы держать ваш напиток... В КОСМОСЕ!"
	icon_state = "mug_eng"
	preset = TRUE

/obj/item/reagent_containers/drinks/mug/med
	name = "doctor's mug"
	desc = "Кружка, которая может содержать лекарство от всех ваших болезней!"
	icon_state = "mug_med"
	preset = TRUE

/obj/item/reagent_containers/drinks/mug/sci
	name = "scientist's mug"
	desc = "Ничто не помогает исследованиям, как кружка с кофе... или грантовые деньги!"
	icon_state = "mug_sci"
	preset = TRUE

/obj/item/reagent_containers/drinks/mug/sec
	name = "officer's mug"
	desc = "Идеальный партнер для пончика с посыпкой и дубинки!"
	icon_state = "mug_sec"
	preset = TRUE

/obj/item/reagent_containers/drinks/mug/serv
	name = "crewmember's mug"
	desc = "Утоли жажду лучше, чем остальной экипаж!"
	icon_state = "mug_serv"
	preset = TRUE

/obj/item/reagent_containers/drinks/mug/ce
	name = "chief engineer's mug"
	desc = "Сломан и сварен заново бесчисленное количество раз, как и станция! Вероятно, безопасен для микроволновки."
	icon_state = "mug_ce"
	preset = TRUE

/obj/item/reagent_containers/drinks/mug/hos
	name = "head of security's mug"
	desc = "Если бы только ваши офицеры были такими же крепкими, как вкус этого кофе!"
	icon_state = "mug_hos"
	preset = TRUE

/obj/item/reagent_containers/drinks/mug/rd
	name = "research director's mug"
	desc = "Уровень энергетических технологий: 99."
	icon_state = "mug_rd"
	preset = TRUE

/obj/item/reagent_containers/drinks/mug/cmo
	name = "chief medical officer's mug"
	desc = "Наполните кружку чем-то, чтобы не заснуть, пока пытаетесь спасти экипаж."
	icon_state = "mug_cmo"
	preset = TRUE

/obj/item/reagent_containers/drinks/mug/qm
	name = "quartermaster's mug"
	desc = "Новая импортная кружка доставленная экспресс-доставкой."
	icon_state = "mug_qm"
	preset = TRUE

/obj/item/reagent_containers/drinks/mug/hop
	name = "head of personnel's mug"
	desc = "На дне пятна от кофе или чернил?"
	icon_state = "mug_hop"
	preset = TRUE

/obj/item/reagent_containers/drinks/mug/cap
	name = "captain's mug"
	desc = "На боку надпись: \"Лучший капитан 2559\"... В последний раз, когда на станции был достойный капитан."
	icon_state = "mug_cap"
	preset = TRUE
