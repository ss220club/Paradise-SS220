////////////////////////////////////////////////////////////////////////////////
/// Drinks.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_containers/drinks
	name = "drink"
	desc = "yummy!"
	icon = 'icons/obj/drinks.dmi'
	icon_state = null
	container_type = OPENCONTAINER
	possible_transfer_amounts = list(5,10,15,20,25,30,50)
	visible_transfer_rate = TRUE
	volume = 50
	resistance_flags = NONE
	var/consume_sound = 'sound/items/drink.ogg'
	var/chugging = FALSE

/obj/item/reagent_containers/drinks/attack_self(mob/user)
	return

/obj/item/reagent_containers/drinks/attack(mob/M, mob/user, def_zone)
	if(!reagents || !reagents.total_volume)
		to_chat(user, "<span class='warning'>В [declent_ru(PREPOSITIONAL)] ничего не осталось, о нет!</span>")
		return FALSE

	if(!is_drainable())
		to_chat(user, "<span class='warning'>Вам нужно сначала открыть [declent_ru(ACCUSATIVE)]!</span>")
		return FALSE

	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if(C.drink(src, user))
			return TRUE
	return FALSE

/obj/item/reagent_containers/drinks/MouseDrop(atom/over_object) //CHUG! CHUG! CHUG!
	if(!iscarbon(over_object))
		return
	var/mob/living/carbon/chugger = over_object
	if(!(container_type & DRAINABLE))
		to_chat(chugger, "<span class='notice'>Вам нужно сначала открыть [declent_ru(ACCUSATIVE)]!</span>")
		return
	if(reagents.total_volume && loc == chugger && src == chugger.get_active_hand())
		chugger.visible_message("<span class='notice'>[capitalize(chugger.declent_ru(NOMINATIVE))] подносит [declent_ru(ACCUSATIVE)] к рту и начинает [pick("жадно пить","пить залпом")], будто [pick("дикарь","бешеное животное","безумец","завтра не наступит")]!</span>",
			"<span class='notice'>Вы начинаете пить залпом [declent_ru(ACCUSATIVE)].</span>",
			"<span class='notice'>Вы слышите звук, похожий на глотание.</span>")
		chugging = TRUE
		while(do_after_once(chugger, 4 SECONDS, TRUE, chugger, null, "Вы прекращаете пить залпом [declent_ru(ACCUSATIVE)]."))
			chugger.drink(src, chugger, 25) //Half of a glass, quarter of a bottle.
			if(!reagents.total_volume) //Finish in style.
				chugger.emote("gasp")
				chugger.visible_message("<span class='notice'>[capitalize(chugger.declent_ru(NOMINATIVE))] [pick("осушает до последней капли","поглощает полностью","употребляет до конца","выпивает до дна")] [declent_ru(ACCUSATIVE)], будто  [pick("зверь","монстр","дикарь","животное")]!</span>",
					"<span class='notice'>Вы заканчиваете пить залпом [declent_ru(ACCUSATIVE)]![prob(50) ? " Может быть, это была не такая уж хорошая идея..." : ""]</span>",
					"<span class='notice'>Вы слышите вздох и звон.</span>")
				break
		chugging = FALSE

/obj/item/reagent_containers/drinks/afterattack(obj/target, mob/user, proximity)
	if(!proximity)
		return
	if(chugging)
		return

	if(target.is_refillable() && is_drainable()) //Something like a glass. Player probably wants to transfer TO it.
		if(!reagents.total_volume)
			to_chat(user, "<span class='warning'>[capitalize(declent_ru(NOMINATIVE))] [genderize_ru(src, "пустой", "пустая", "пустое", "пустые")].</span>")
			return FALSE

		if(target.reagents.holder_full())
			to_chat(user, "<span class='warning'>[capitalize(declent_ru(NOMINATIVE))] [genderize_ru(src, "полный", "полная", "полное", "полные")].</span>")
			return FALSE

		var/trans = reagents.trans_to(target, amount_per_transfer_from_this)
		to_chat(user, "<span class='notice'>Вы переливаете [trans] единиц[declension_ru(trans, "у", "ы", "")] содержимого в [target.declent_ru(ACCUSATIVE)].</span>")

	else if(target.is_drainable()) //A dispenser. Transfer FROM it TO us.
		if(!is_refillable())
			to_chat(user, "<span class='warning'>Крышка [declent_ru(GENITIVE)] закрыта!</span>")
			return FALSE
		if(!target.reagents.total_volume)
			to_chat(user, "<span class='warning'>[capitalize(declent_ru(NOMINATIVE))] [genderize_ru(src, "пустой", "пустая", "пустое", "пустые")].</span>")
			return FALSE

		if(reagents.holder_full())
			to_chat(user, "<span class='warning'>[capitalize(declent_ru(NOMINATIVE))] [genderize_ru(src, "полный", "полная", "полное", "полные")].</span>")
			return FALSE

		var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this)
		to_chat(user, "<span class='notice'>Вы наполняете [declent_ru(ACCUSATIVE)] [trans] единиц[declension_ru(trans, "ей", "ами", "ами")] содержимого [target.declent_ru(GENITIVE)].</span>")

	return FALSE

/obj/item/reagent_containers/drinks/examine(mob/user)
	. = ..()
	if(in_range(user, src))
		if(!reagents || reagents.total_volume == 0)
			. += "<span class='notice'>[capitalize(declent_ru(NOMINATIVE))] [genderize_ru(src, "пустой", "пустая", "пустое", "пустые")]!</span>"
		else if(reagents.total_volume <= volume/4)
			. += "<span class='notice'>[capitalize(declent_ru(NOMINATIVE))] почти [genderize_ru(src, "полный", "полная", "полное", "полные")]!</span>"
		else if(reagents.total_volume <= volume*0.66)
			. += "<span class='notice'>[capitalize(declent_ru(NOMINATIVE))] наполовину [genderize_ru(src, "полный", "полная", "полное", "полные")]!</span>"// We're all optimistic, right?!

		else if(reagents.total_volume <= volume*0.90)
			. += "<span class='notice'>[capitalize(declent_ru(NOMINATIVE))] почти [genderize_ru(src, "полный", "полная", "полное", "полные")]!</span>"
		else
			. += "<span class='notice'>[capitalize(declent_ru(NOMINATIVE))] [genderize_ru(src, "полный", "полная", "полное", "полные")]!</span>"

////////////////////////////////////////////////////////////////////////////////
/// Drinks. END
////////////////////////////////////////////////////////////////////////////////

/obj/item/reagent_containers/drinks/trophy
	name = "pewter cup"
	desc = "Каждый получит трофей."
	icon_state = "pewter_cup"
	w_class = WEIGHT_CLASS_TINY
	force = 1
	throwforce = 1
	amount_per_transfer_from_this = 5
	materials = list(MAT_METAL=100)
	possible_transfer_amounts = null
	volume = 5
	flags = CONDUCT
	container_type = OPENCONTAINER
	resistance_flags = FIRE_PROOF

/obj/item/reagent_containers/drinks/trophy/gold_cup
	name = "gold cup"
	desc = "Вы победитель!!"
	icon_state = "golden_cup"
	w_class = WEIGHT_CLASS_BULKY
	force = 14
	throwforce = 10
	amount_per_transfer_from_this = 20
	materials = list(MAT_GOLD=1000)
	volume = 150

/obj/item/reagent_containers/drinks/trophy/silver_cup
	name = "silver cup"
	desc = "Лучший неудачник!"
	icon_state = "silver_cup"
	w_class = WEIGHT_CLASS_NORMAL
	force = 10
	throwforce = 8
	amount_per_transfer_from_this = 15
	materials = list(MAT_SILVER=800)
	volume = 100

/obj/item/reagent_containers/drinks/trophy/bronze_cup
	name = "bronze cup"
	desc = "Первое место с конца!"
	icon_state = "bronze_cup"
	w_class = WEIGHT_CLASS_SMALL
	force = 5
	throwforce = 4
	amount_per_transfer_from_this = 10
	materials = list(MAT_METAL=400)
	volume = 25

/// 2023 toolbox tournament 3rd place went to paradise station.
/obj/item/reagent_containers/drinks/trophy/bronze_cup/toolbox_win
	name = "3rd place toolbox tournament 2567"
	desc = "Награда для элитных бойцов Центкома, собравших средства для института исследования ГБС."
	icon_state = "reward_cup"
	force = 10.3
	throwforce = 10.3

///////////////////////////////////////////////Drinks
//Notes by Darem: Drinks are simply containers that start preloaded. Unlike condiments, the contents can be ingested directly
//	rather then having to add it to something else first. They should only contain liquids. They have a default container size of 50.
//	Formatting is the same as food.


/obj/item/reagent_containers/drinks/coffee
	name = "Robust Coffee"
	desc = "Осторожно, очень горячее содержимое для вашего наслаждения!"
	icon_state = "coffee"
	list_reagents = list("coffee" = 30)
	resistance_flags = FREEZE_PROOF

/obj/item/reagent_containers/drinks/ice
	name = "ice cup"
	desc = "Осторожно, холодный лёд, не жуйте!"
	icon_state = "icecup"
	list_reagents = list("ice" = 30)

/obj/item/reagent_containers/drinks/tea
	name = "Duke Purple tea"
	desc = "Оскорбление Дюка Пурпурного — это оскорбление Космической Королевы! Любой настоящий джентльмен вызовет вас на дуэль, если вы оскверните этот чай."
	icon_state = "teacup"
	item_state = "coffee"
	list_reagents = list("tea" = 30)

/obj/item/reagent_containers/drinks/tea/Initialize(mapload)
	. = ..()
	if(prob(20))
		reagents.add_reagent("mugwort", 3)

/obj/item/reagent_containers/drinks/mugwort
	name = "mugwort tea"
	desc = "Горький травяной чай."
	icon_state = "manlydorfglass"
	item_state = "coffee"
	list_reagents = list("mugwort" = 30)

/obj/item/reagent_containers/drinks/h_chocolate
	name = "Dutch hot coco"
	desc = "Прекрасно подходит для посиделок у камина!"
	icon_state = "hot_coco"
	item_state = "coffee"
	list_reagents = list("hot_coco" = 30, "sugar" = 5)
	resistance_flags = FREEZE_PROOF

/obj/item/reagent_containers/drinks/chocolate
	name = "hot chocolate"
	desc = "Горячий шоколад, идеально подходящий для того, чтобы смотреть в иллюминатор, укутавшись в плед."
	icon_state = "hot_coco"
	item_state = "coffee"
	list_reagents = list("hot_coco" = 15, "chocolate" = 6, "water" = 9)
	resistance_flags = FREEZE_PROOF

/obj/item/reagent_containers/drinks/weightloss
	name = "weight-loss shake"
	desc = "Шейк, разработанный для похудения, теперь в ягодном вкусе. Упаковка гордо заявляет, что он «без глистов»."
	icon_state = "weightshake"
	list_reagents = list("lipolicide" = 30, "berryjuice" = 5)

/obj/item/reagent_containers/drinks/dry_ramen
	name = "cup ramen"
	desc = "Для приготовления просто добавьте 10 юнитов воды. Вкус, который напоминает о школьных годах."
	icon_state = "ramen"
	item_state = "ramen"
	list_reagents = list("dry_ramen" = 30)

/obj/item/reagent_containers/drinks/dry_ramen/Initialize(mapload)
	. = ..()
	if(prob(20))
		reagents.add_reagent("enzyme", 3)

/obj/item/reagent_containers/drinks/chicken_soup
	name = "canned chicken soup"
	desc = "Банка вкусного и нежного куринного супа с лапшой. Вкус домашнего супа прямиком из микроволновки."
	icon_state = "soupcan"
	item_state = "soupcan"
	list_reagents = list("chicken_soup" = 30)

/obj/item/reagent_containers/drinks/sillycup
	name = "paper cup"
	desc = "Бумажный стаканчик для воды."
	icon_state = "water_cup_e"
	item_state = "coffee"
	possible_transfer_amounts = null
	volume = 10

/obj/item/reagent_containers/drinks/sillycup/on_reagent_change()
	if(reagents.total_volume)
		icon_state = "water_cup"
	else
		icon_state = "water_cup_e"

//////////////////////////drinkingglass and shaker//
//Note by Darem: This code handles the mixing of drinks. New drinks go in three places: In Chemistry-Reagents.dm (for the drink
//	itself), in Chemistry-Recipes.dm (for the reaction that changes the components into the drink), and here (for the drinking glass
//	icon states.

/obj/item/reagent_containers/drinks/shaker
	name = "shaker"
	desc = "Металлический шейкер для смешивания напитков."
	icon_state = "shaker"
	materials = list(MAT_METAL=1500)
	amount_per_transfer_from_this = 10
	volume = 100
	var/shaking = FALSE

	COOLDOWN_DECLARE(shaking_cooldown)

/obj/item/reagent_containers/drinks/shaker/Initialize(mapload)
	. = ..()
	reagents.set_reacting(FALSE)

/obj/item/reagent_containers/drinks/shaker/attack_self(mob/user)
	if(!reagents.total_volume)
		to_chat(user, "<span class='warning'>Вы ведь не будете трясти пустой шейкер, правда?</span>")
		return

	if(COOLDOWN_FINISHED(src, shaking_cooldown))
		shaking = TRUE
		var/adjective = pick("яросно", "страсно", "энергично", "решительно", "с полной отдачей", "с заботой и любовью", "стильно")
		user.visible_message("<span class='notice'>[capitalize(user.declent_ru(NOMINATIVE))] [adjective] трясёт [declent_ru(ACCUSATIVE)]!</span>", "<span class='notice'>Вы [adjective] трясёте [declent_ru(ACCUSATIVE)]!</span>")
		icon_state = "shaker-shake"
		if(iscarbon(loc))
			var/mob/living/carbon/M = loc
			M.update_inv_r_hand()
			M.update_inv_l_hand()
		playsound(user, 'sound/items/boston_shaker.ogg', 80, TRUE)
		COOLDOWN_START(src, shaking_cooldown, 3 SECONDS)

	if(shaking)
		if(do_after_once(user, 3 SECONDS, target = src, allow_moving = TRUE, attempt_cancel_message = "Вы прекращаете трясти [declent_ru(ACCUSATIVE)] до того, как содержимое смешается."))
			reagents.set_reacting(TRUE)
			reagents.handle_reactions()
	icon_state = "shaker"
	if(iscarbon(loc))
		var/mob/living/carbon/M = loc
		M.update_inv_r_hand()
		M.update_inv_l_hand()

	shaking = FALSE
	reagents.set_reacting(FALSE)

/obj/item/reagent_containers/drinks/shaker/dropped(mob/user)
	. = ..()
	icon_state = "shaker"

/obj/item/reagent_containers/drinks/flask
	name = "flask"
	desc = "Каждый уважающий себя космонавт знает, что всегда стоит взять с собой пару пинт виски, куда бы ты ни отправился."
	icon_state = "flask"
	materials = list(MAT_METAL=250)
	volume = 60

/obj/item/reagent_containers/drinks/flask/barflask
	name = "flask"
	desc = "Для тех, кто не хочет тратить время на посиделки в баре за напитками."
	icon_state = "barflask"

/obj/item/reagent_containers/drinks/flask/gold
	name = "captain's flask"
	desc = "Драгоценная фляга, принадлежащая капитану, с логотипом Nanotrasen, инкрустированным перламутром."
	icon_state = "flask_gold"
	materials = list(MAT_GOLD=500)

/obj/item/reagent_containers/drinks/flask/detflask
	name = "detective's flask"
	desc = "Единственный настоящий друг детектива."
	icon_state = "detflask"
	list_reagents = list("whiskey" = 30)

/obj/item/reagent_containers/drinks/flask/hand_made
	name = "handmade flask"
	desc = "Деревянная фляга с серебряной крышкой и дном. Она покрыта матовой тёмно-синей краской, на которой черным цветом выгравированы инициалы \"W.H.\"."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "williamhackett"
	materials = list()

/obj/item/reagent_containers/drinks/flask/thermos
	name = "vintage thermos"
	desc = "Старый потёртый термос с тусклым отблеском.."
	icon_state = "thermos"
	volume = 50

/obj/item/reagent_containers/drinks/flask/shiny
	name = "shiny flask"
	desc = "Блестящая металлическая фляга. На ней выгравирован греческий символ."
	icon_state = "shinyflask"
	volume = 50

/obj/item/reagent_containers/drinks/flask/lithium
	name = "lithium flask"
	desc = "Фляга с изображением атома лития."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "lithiumflask"
	volume = 50


/obj/item/reagent_containers/drinks/britcup
	name = "cup"
	desc = "A cup with the british flag emblazoned on it."
	icon_state = "britcup"
	volume = 30

/obj/item/reagent_containers/drinks/bag
	name = "drink bag"
	desc = "Обычно содержит вино. Легко спрятать в штанах."
	icon_state = "goonbag"
	volume = 70

/obj/item/reagent_containers/drinks/bag/goonbag
	name = "goon from a Blue Toolbox special edition"
	desc = "Вино из страны на краю света, где бродят динго и странствуют кенгуру."
	icon_state = "goonbag"
	list_reagents = list("wine" = 70)

/obj/item/reagent_containers/drinks/oilcan
	name = "oil can"
	desc = "Содержит масло, предназначеное для киборгов, роботов и других синтетиков."
	icon = 'icons/goonstation/objects/oil.dmi'
	icon_state = "oilcan"
	volume = 100

/obj/item/reagent_containers/drinks/oilcan/full
	list_reagents = list("oil" = 100)
