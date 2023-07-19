// =========== statues ===========

/obj/structure/statue/bananium/clown/unique
	name = "статуя великого Хонкера"
	desc = "Искусно слепленная статуя из бананиума, бананового сока и непонятного белого материала. Судя по его выдающейся улыбки, двум золотым гудкам в руках и наряду, он был лучшим стендапером и шутником на станции. Полное имя, к сожалению плохо читаемо и затерто, похоже кто-то явно завидовал его таланту."
	icon = 'modular_ss220/unique_objects/icons/statue.dmi'
	icon_state = "clown_unique"
	oreAmount = 20

/obj/structure/statue/tranquillite/mime/unique
	name = "статуя гордости пантомимы"
	desc = "Искусно слепленная статуя из транквилиума, если приглядеться, то на статую надета старая униформа мима, перекрашенная под текстуру транквилиума, а рот статуи заклеен скотчем. Похоже кто-то полностью отдавал себя искусству пантомимы. На груди виднеется медаль с еле различимой закрашенной надписью \"За Отвагу\", поверх которой написано \"За Военные Преступления\"."
	icon = 'modular_ss220/unique_objects/icons/statue.dmi'
	icon_state = "mime_unique"
	oreAmount = 20

/obj/structure/statue/elwycco
	name = "Camper Hunter"
	desc = "Похоже это какой-то очень важный человек, или очень значимый для многих людей. Вы замечаете огроменный топор в его руках, с выгравированным числом 220. Что это число значит? Каждый понимает по своему, однако по слухам оно означает количество его жертв. \n Надпись на табличке - Мы с тобой, Шустрила! Аве, Легион!"
	icon = 'modular_ss220/unique_objects/icons/statue.dmi'
	icon_state = "elwycco"
	anchored = TRUE
	oreAmount = 0

/obj/structure/statue/ell_good
	name = "Mr.Буум"
	desc = "Загадочный клоун с жёлтым оттенком кожи и выразительными зелёными глазами. Лучший двойной агент синдиката умудрявшийся захватить власть множества объектов. \
			Его имя часто произносят неправильно из-за чего его заслуги по документам принадлежат сразу нескольким Буумам. \
			Так же знаменит тем, что убедил руководство НТ тратить время, силы и средства, на золотой унитаз."
	icon = 'modular_ss220/unique_objects/icons/statuelarge.dmi'
	icon_state = "ell_good"
	pixel_y = 7
	anchored = TRUE
	oreAmount = 0

/obj/structure/statue/furukai
	name = "София Вайт"
	desc = "Загадочная девушка, ныне одна из множества офицеров синдиката. Получившая столь высокую позицию не за связи, а за свои способности. \
			Движимая местью за потерю родной сестры из-за коррупционных верхушек Нанотрейзен, она вступила в Синдикат,  \
			где стала известна и как способный агент и как отличный инженер. Хоть ее позывной и отсылал на пушистых, в душе она их ненавидела... \
			Но по итогу при смене руководства Синдиката, вскрылись множественные проблемы, скрывающиеся доселе в стенах Синдиката. \
			Буквально в стенах Синдиката. Попавшие под её руководство базы имели очень специфичные методы построек, из-за чего \
			нередко служили причиной их краха. "
	icon = 'modular_ss220/unique_objects/icons/statuelarge.dmi'
	icon_state = "furukai"
	pixel_y = 7
	anchored = TRUE
	oreAmount = 0

/obj/structure/statue/mooniverse
	name = "Неизвестный агент"
	desc = "Информация на табличке под статуей исцарапана и нечитабельна... Поверх написана невнятная вселенская смесь из слов \"Furry\" и \"Universe\""
	icon = 'modular_ss220/unique_objects/icons/statuelarge.dmi'
	icon_state = "mooniverse"
	pixel_y = 7
	anchored = TRUE
	oreAmount = 0

// =========== items ===========
/obj/item/clothing/head/helmet/skull/Yorick
	name = "Йорик"
	desc = "Бедный Йорик..."

/obj/item/bikehorn/rubberducky/captain
	name = "уточка-капитан"
	desc = "Капитан всех уточек на этой станции. Крайне важная и престижная уточка. Выпущены в ограниченных экземплярах и только для капитанов. Ценная находка для коллекционеров."
	icon = 'modular_ss220/unique_objects/icons/watercloset.dmi'
	icon_state = "captain_rubberducky"
	item_state = "captain_rubberducky"

// =========== toilets ===========
/obj/structure/toilet
	var/is_final = FALSE

/obj/structure/toilet/material
	name = "Унитаз"
	desc = "Особенный унитаз для особенных особ."
	icon = 'modular_ss220/unique_objects/icons/watercloset.dmi'

/obj/structure/toilet/attacked_by(obj/item/I, mob/living/user)
	if(!istype(I, /obj/item/stack) && !is_final)
		. = ..()

	var/obj/item/stack/M = I

	var/is_rare = istype(M, /obj/item/stack/ore/bluespace_crystal)
	var/need_amount = is_rare ? 2 : 10
	if(M.get_amount() < need_amount)
		visible_message("Недостаточно материала, нужно хотя бы [need_amount] шт.")
		. = ..()

	switch(type)
		if(/obj/structure/toilet)
			switch(M.type)
				if(/obj/item/stack/sheet/mineral/gold)
					construct(/obj/structure/toilet/material/gold, user, M, need_amount)
				if(/obj/item/stack/sheet/mineral/silver)
					construct(/obj/structure/toilet/material/captain, user, M, need_amount)
				if(/obj/item/stack/ore/bluespace_crystal)
					construct(/obj/structure/toilet/material/bluespace, user, M, need_amount)
				else visible_message("Неподходящий материал для улучшения.")
		if(/obj/structure/toilet/material/gold)
			construct(/obj/structure/toilet/material/gold/nt, user, M, need_amount)
		if(/obj/structure/toilet/material/captain)
			construct(/obj/structure/toilet/material/gold/nt, user, M, need_amount)
		if(/obj/structure/toilet/material/bluespace)
			construct(/obj/structure/toilet/material/bluespace/nt, user, M, need_amount)
		else
			visible_message("Неподходящая цель для гравировки.")

/obj/structure/toilet/proc/construct(var/build_type, mob/living/user, var/obj/item/stack/M, var/amount)
	if(do_after(user, 20, target = src))
		M.use(amount)
		new build_type(loc)
		qdel(src)

/obj/structure/toilet/material/gold
	name = "Золотой унитаз"
	desc = "Особенный унитаз для особенных особ."
	icon_state = "gold_toilet00"

/obj/structure/toilet/material/gold/nt
	name = "Королевский Унитаз"
	desc = "Только самые снобные снобы и люди не имеющие вкуса будут восседать на этом троне."
	icon_state = "gold_toilet00-NT"
	is_final = TRUE

/obj/structure/toilet/material/gold/update_icon()
	. = ..()
	icon_state = "gold_toilet[open][cistern]"

/obj/structure/toilet/material/gold/nt/update_icon()
	. = ..()
	icon_state = "gold_toilet[open][cistern]-NT"

/obj/structure/toilet/material/captain
	name = "Унитаз Капитана"
	desc = "Престижное седалище для престижной персоны. Судя по форме, был идеально подготовлен под седальное место Капитана."
	icon_state = "captain_toilet00"

/obj/structure/toilet/material/captain/update_icon()
	. = ..()
	icon_state = "captain_toilet[open][cistern]"

//Bluspace Tolkan
/obj/structure/toilet/material/bluespace
	name = "Научный унитаз"
	desc = "Загадка современной науки о возникновении данного научного экземпляра."
	icon_state = "bluespace_toilet00"
	var/singulo_layer = "bluespace_toilet_singularity"
	var/teleport_sound = 'sound/magic/lightning_chargeup.ogg'
	var/tp_range = 1
	emagged = FALSE

/obj/structure/toilet/material/bluespace/nt
	name = "Воронка Бездны Синего Космоса"
	desc = "То, ради чего наука и была создана и первый гуманоид ударил палку о камень. Главное не смотреть в бездну."
	icon_state = "bluespace_toilet00-NT"
	tp_range = 3
	is_final = TRUE

/obj/structure/toilet/material/bluespace/emag_act(mob/user)
	if(!emagged)
		visible_message("Блюспейс начал переливаться красными краплениями.")
		if(do_after(user, 20, target = src))
			emagged = TRUE
			tp_range = initial(tp_range) * 3
			singulo_layer = "bluespace_toilet_singularity-emagged"
			update_icon()
			playsound(src, "sparks", 100, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)

/obj/structure/toilet/material/bluespace/update_icon()
	. = ..()
	icon_state = "bluespace_toilet[open][cistern]"

/obj/structure/toilet/material/bluespace/nt/update_icon()
	. = ..()
	icon_state = "bluespace_toilet[open][cistern]-NT"

/obj/structure/toilet/material/bluespace/attack_hand(mob/living/user)
	. = ..()
	overlays.Cut()
	if(open)
		overlays += image(icon, singulo_layer)

		if(do_after(user, 100, target = src))
			teleport(tp_range)

/obj/structure/toilet/material/bluespace/proc/teleport(var/range_dist = 1)
	playsound(loc, teleport_sound, 100, 1)

	var/list/objects = range(range_dist, src)

	var/turf/simulated/floor/F = find_safe_turf(zlevels = src.z)
	for(var/mob/living/H in objects)
		do_teleport(H, F, range_dist * 3)
		investigate_log("teleported [key_name_log(H)] to [COORD(F)]")
	for(var/obj/O in objects)
		if(!O.anchored && O.invisibility == 0 && prob(50))
			do_teleport(O, F, range_dist * 3)

	do_teleport(src, F)

/obj/structure/toilet/material/bluespace/Destroy()
	teleport(tp_range*3)
	. = ..()
