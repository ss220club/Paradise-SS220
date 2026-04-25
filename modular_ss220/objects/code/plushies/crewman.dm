/obj/item/toy/plushie/crewmanplushie
	name = "medic tajaran plushie"
	desc = "Мягкая белая игрушка с доброй, но пугливой улыбкой."
	icon = 'modular_ss220/objects/icons/plushies.dmi'
	icon_state = "crewman"
	lefthand_file = 'modular_ss220/objects/icons/inhands/plushies_lefthand.dmi'
	righthand_file = 'modular_ss220/objects/icons/inhands/plushies_righthand.dmi'

/obj/item/toy/plushie/crewmanplushie/examine_more(mob/user)
	. = ..()
	. += SPAN_NOTICE("Тайара-медик выглядит точно так же, как её реальный прототип – с трогательно поджатыми ушками, большими добрыми глазами и той самой знаменитой улыбкой, \
		перед которой не может устоять даже самый хмурый член экипажа. \
		\"Является медицинским изделием. Заменяет психотерапевта. При острых приступах тоски рекомендуется гладить по голове не менее 3 минут непрерывно\". \"Не бойся, я тут!\"")

/obj/item/toy/plushie/beer_demon
	name = "Хмельной парень"
	desc = "Мягкая игрушка, на её поверхности видны следы разных жидкостей, но она всё ещё мягкая и готова составить вам компанию."
	icon = 'modular_ss220/objects/icons/plushies.dmi'
	icon_state = "beer_demon"
	lefthand_file = 'modular_ss220/objects/icons/inhands/plushies_lefthand.dmi'
	righthand_file = 'modular_ss220/objects/icons/inhands/plushies_righthand.dmi'
	var/cooldown = 0

	var/list/things_to_say = alist(
		"Взгляни на часы. Такое время, а ты ещё трезвый." = 20,
		"Трудный день? Хмельной напиток решит проблему!" = 20,
		"Ещё налить, дорогой мой друг?" = 100,
		"Мы в баре, бестолочь! Ой. Это что, твой...первый раз?" = 1,
		"Ох, что-то я утомился. Так о чем это мы?" = 20,
		"А, отличный выбор! Ну для меня." = 20,
		"Давай уже, говори. Я не могу ждать целую вечность!" = 20,
		"Ты слишком трезв, мой дорогой друг." = 20,
		"Вы укрываете в себе трезвость, верно?" = 20,
		"Когда-то и меня вела дорога приключений, а потом мне налили бокал светлого" = 20,
	)

// Добавляем наш "микро-компонент" хамптеру
/obj/item/toy/plushie/beer_demon/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/tts_component, /datum/tts_seed/silero/dandelion)

// Действия при взаимодействии в руке при разных интентах
/obj/item/toy/plushie/beer_demon/activate_self(mob/user)
	. = ..()
	if(. || cooldown >= world.time - 3 SECONDS)
		return

	atom_say(pickweight(things_to_say))
	cooldown = world.time
