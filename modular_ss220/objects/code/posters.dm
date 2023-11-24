/obj/structure/sign/poster/randomise(base_type)
	var/list/poster_types = subtypesof(base_type)
	var/list/approved_types = list()
	for(var/t in poster_types)
		var/obj/structure/sign/poster/T = t
		if(initial(T.icon_state) && !initial(T.never_random))
			approved_types |= T

	var/obj/structure/sign/poster/selected = pick(approved_types)

	name = initial(selected.name)
	desc = initial(selected.desc)
	icon = initial(selected.icon)
	icon_state = initial(selected.icon_state)
	poster_item_name = initial(selected.poster_item_name)
	poster_item_desc = initial(selected.poster_item_desc)
	poster_item_icon_state = initial(selected.poster_item_icon_state)
	ruined = initial(selected.ruined)

// Contraband
/obj/structure/sign/poster/contraband/fun_police
	icon = 'modular_ss220/objects/icons/posters.dmi'
	icon_state = "contraband1"

/obj/structure/sign/poster/contraband/lusty_xenomorph
	icon = 'modular_ss220/objects/icons/posters.dmi'
	icon_state = "contraband2"

/obj/structure/sign/poster/contraband/power_people
	icon = 'modular_ss220/objects/icons/posters.dmi'
	icon_state = "contraband3"

/obj/structure/sign/poster/contraband/lady
	name = "Соблазнительная Красотка"
	desc = "На плакате изображена крайне сексуальная девушка."
	icon = 'modular_ss220/objects/icons/posters.dmi'
	icon_state = "contraband4"

/obj/structure/sign/poster/contraband/very_robust
	name = "Робаст"
	desc = "Вы видите слегка потрёпанный плакат, на котором изображен КРАСНЫЙ туллбокс! На плакате написано \"Опасно, робастное!\", некоторые утверждают, что эта красная краска на плакате сделана из настоящей крови."
	icon = 'modular_ss220/objects/icons/posters.dmi'
	icon_state = "contraband5"

/obj/structure/sign/poster/contraband/vodka
	name = "Водка"
	desc = "Рекламный плакат водки, напитка от настоящих мужчин для настоящих мужчин. Почувствуй себя космическим медведем."
	icon = 'modular_ss220/objects/icons/posters.dmi'
	icon_state = "contraband6"

/obj/structure/sign/poster/contraband/wanted
	name = "Вотер Потассиумович"
	desc = "На плакате вы видите: лысый, черноглазый мужчина, лет 30, и его разыскивают на просторах всего космоса. Что он сделал, чтобы его так разыскивали..."
	icon = 'modular_ss220/objects/icons/posters.dmi'
	icon_state = "contraband7"

// Legit
/obj/structure/sign/poster/official/mars
	name = "Плакат Марса"
	desc = "Это плакат, выпущенный компанией Generic Space в рамках серии памятных плакатов, посвящённых чудесам космоса."
	icon = 'modular_ss220/objects/icons/posters.dmi'
	icon_state = "legit1"

/obj/structure/sign/poster/official/wild_west
	name = "Дикое Карго"
	desc = "Красивое дикое место с собственным шерифом."
	icon = 'modular_ss220/objects/icons/posters.dmi'
	icon_state = "legit2"

/obj/structure/sign/poster/official/razumause
	name = "Разумышь"
	desc = "Хей-хей! Что может пойти не так, да?"
	icon = 'modular_ss220/objects/icons/posters.dmi'
	icon_state = "legit3"

/obj/structure/sign/poster/official/assist_pride
	name = "Гордость ассистента"
	desc = "Даже в космосе профессия ассистента востребована. И этот плакат демонстрирует их красоту."
	icon = 'modular_ss220/objects/icons/posters.dmi'
	icon_state = "legit4"
