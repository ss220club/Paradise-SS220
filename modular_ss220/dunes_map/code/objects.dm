/obj/item/reagent_containers/food/condiment/milk/empty
	list_reagents = null

/obj/item/reagent_containers/food/condiment/flour/empty
	list_reagents = null

/obj/item/reagent_containers/food/condiment/soymilk/empty
	list_reagents = null

/obj/item/reagent_containers/food/condiment/rice/empty
	list_reagents = null

/obj/item/reagent_containers/glass/bottle/nutrient/fuel
	name = "\improper канистра с топливом"
	desc = "Содержит в себе топливо. Пить не рекомендуется."
	possible_transfer_amounts = list(1,2,5,10,20,40,80,100)
	list_reagents = list("fuel" = 100)

/obj/structure/decorative_structures/corpse
	name = "\improper кровавое тело"
	icon = 'modular_ss220/dunes_map/icons/dead.dmi'
	icon_state = "deadbody"
	density = 0
	max_integrity = 5
	var/bloodtiles = 8  // number of tiles with blood while pulling

/obj/structure/decorative_structures/corpse/Initialize()
	START_PROCESSING(SSobj, src)
	..()

/obj/structure/decorative_structures/corpse/Destroy()
	playsound(src, 'sound/goonstation/effects/gib.ogg', 30, 0)
	var/turf/T = get_turf(src)
	new /obj/effect/decal/cleanable/blood/gibs(T)
	new /obj/effect/decal/cleanable/blood(T)
	STOP_PROCESSING(SSobj, src)
	..()

/obj/structure/decorative_structures/corpse/attack_hand(mob/living/user)
	take_damage(pick(2,3), BRUTE, "melee")
	playsound(src, (pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg')), 20, 0)

/obj/structure/decorative_structures/corpse/play_attack_sound()
	return

/obj/structure/decorative_structures/corpse/do_climb()
	return

/obj/structure/decorative_structures/corpse/Move()
	. = ..()
	bloodtiles -= 1
	if(bloodtiles >= 0 && prob(40))
		new /obj/effect/decal/cleanable/blood(get_turf(src))

/obj/structure/decorative_structures/corpse/process()
	for(var/mob/living/carbon/human/H in range(4, src))
		if(prob(15))
			var/obj/item/clothing/mask/M = H.wear_mask
			if(M && (M.flags_cover & MASKCOVERSMOUTH))
				continue
			if(TRAIT_NOBREATH in H.dna.species.species_traits)
				continue
			to_chat(H, "<span class='warning'>Как же воняет...</span>")
			H.fakevomit()

/obj/structure/sink/kolodec
	name = "\improper колодец"
	desc = "Главное не упасть..."
	icon = 'modular_ss220/dunes_map/icons/kolodec.dmi'
	icon_state = "kolodec"
	density = TRUE
	layer = ABOVE_ALL_MOB_LAYER
	var/drop_x = 1
	var/drop_y = 1
	var/drop_z = -1

/obj/structure/sink/kolodec/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/largetransparency)

/obj/structure/sink/kolodec/MouseDrop_T(atom/movable/AM)
	. = 0
	if(!do_after(AM, 1 SECONDS, target = src))
		return
	AM.forceMove(src.loc)
	var/thing_to_check = src
	if(AM)
		thing_to_check = list(AM)
	for(var/thing in thing_to_check)
		. = 1
		INVOKE_ASYNC(src, PROC_REF(drop), thing)

/obj/structure/sink/kolodec/proc/drop(atom/movable/AM)
	if(iscarbon(AM))
		playsound(AM.loc, 'modular_ss220/aesthetics_sounds/sound/wilhelm_scream.ogg', 50)

	if(!AM || QDELETED(AM))
		return
	AM.visible_message("<span class='boldwarning'>[AM] falls into [src]!</span>", "<span class='userdanger'>You stumble and stare into an abyss before you. It stares back, and you fall \
	into the enveloping dark.</span>")
	if(isliving(AM))
		var/mob/living/L = AM
		L.notransform = TRUE
		L.Weaken(20 SECONDS)
	animate(AM, transform = matrix() - matrix(), alpha = 0, color = rgb(0, 0, 0), time = 10)
	for(var/i in 1 to 5)
		//Make sure the item is still there after our sleep
		if(!AM || QDELETED(AM))
			return
		AM.pixel_y--
		sleep(2)

	//Make sure the item is still there after our sleep
	if(!AM || QDELETED(AM))
		return

	if(isliving(AM))
		var/mob/living/fallen_mob = AM
		fallen_mob.notransform = FALSE
		if(fallen_mob.stat != DEAD)
			fallen_mob.adjustBruteLoss(500) //crunch from long fall, want it to be like legion in damage
		return
	for(var/mob/M in AM.contents)
		M.forceMove(src)
	qdel(AM)

/obj/machinery/power/port_gen/pacman/wood
	sheet_path = /obj/item/stack/sheet/wood
	sheet_name = "Wooden Planks"
	time_per_sheet = 25 // same power output, but a 50 sheet stack will last 2 hours at max safe power
	max_sheets = 50
	power_gen = 5000
	max_power_output = 1
	max_safe_output = 1


//car wreck

/obj/structure/decorative_structures/car_wreck
	name = "\improper остов машины"
	desc = "Заржавевший и выпотрошенный наземный транспорт, который активно использовался несколько веков назад."
	icon = 'modular_ss220/dunes_map/icons/wrecks_1.dmi'
	icon_state = "helper"
	anchored = TRUE
	layer = ABOVE_ALL_MOB_LAYER
	max_integrity = 50

/obj/structure/decorative_structures/car_wreck/Initialize(mapload)
	. = ..()
	var/list/car_types = list("coupe", "muscle", "sport", "van")
	icon_state = "[pick(car_types)]-[rand(1,5)]"
	AddComponent(/datum/component/largetransparency)

//statues and stuff

/obj/structure/fluff/desert_construction
	name = "окаменелые останки"
	desc = "Останки какой-то огромной допотопной твари."
	icon = 'modular_ss220/dunes_map/icons/statuelarge.dmi'
	icon_state = "rib"
	density = TRUE
	deconstructible = FALSE
	layer = ABOVE_ALL_MOB_LAYER

/obj/structure/fluff/desert_construction/skull1
	name = "окаменелый череп"
	desc = "Череп какой-то огромной допотопной твари."
	icon_state = "skull"

/obj/structure/fluff/desert_construction/skull2
	name = "окаменелые череп"
	desc = "Череп какой-то огромной допотопной твари."
	icon_state = "skull-half"

/obj/structure/fluff/desert_construction/ribs
	name = "останки"
	desc = "Белеющие на солнце кости местной фауны."
	icon_state = "rib_white"

/obj/structure/fluff/desert_construction/stone1
	name = "скала"
	desc = "Массивный каменный обломок."
	icon_state = "stone1"

/obj/structure/fluff/desert_construction/stone2
	name = "скала"
	desc = "Массивный каменный обломок."
	icon_state = "stone2"

/obj/structure/fluff/desert_construction/obelisk1
	name = "обелиск"
	desc = "Древний обелиск из песчанника, обтесанный и расписаный неизвестными иероглифами."
	icon_state = "obelisk"

/obj/structure/fluff/desert_construction/altar
	name = "кубический алтарь"
	desc = "Геометрически правильное сооружение из черного камня, испускающее тусклый красный свет."
	icon_state = "cube"

/obj/structure/fluff/desert_construction/head1
	name = "массивный каменный бюст"
	desc = "Голова отвратительной твари, выбитая в камне."
	icon_state = "head1"

/obj/structure/fluff/desert_construction/crushedhead
	name = "разрушенный бюст"
	desc = "Останки некогда массивной статуи, поддашвейся неумолимой стихии."
	icon_state = "crushedhead"

/obj/structure/fluff/desert_construction/column1
	name = "колонна"
	desc = "Колонна из песчаника."
	icon_state = "column4"

/obj/structure/fluff/desert_construction/column2
	name = "обломок колонны"
	desc = "Разрушенная колонна из песчаника."
	icon_state = "column5"

/obj/structure/fluff/desert_construction/red_rocks
	name = "камень"
	desc = "Небольшой обломок красного песчаника."
	icon_state = "rock"
	density = FALSE
	layer = BELOW_MOB_LAYER

/obj/structure/fluff/desert_construction/red_rocks/Initialize(mapload)
	. = ..()
	icon_state = "[pick("rock")]-[rand(1,4)]"

/obj/structure/fluff/desert_construction/black_obelisk1
	name = "поврежденный чёрный обелиск"
	desc = "Разрушенный ужасающий черный обелиск, несущий запретные знания в своих письменах"
	icon_state = "black_obelisk"

/obj/structure/fluff/desert_construction/huge_columns
	name = "колонна"
	desc = "Колонна из песчаника."
	icon = 'modular_ss220/dunes_map/icons/columns.dmi'
	icon_state = "column1"

/obj/structure/fluff/desert_construction/huge_columns/column3
	name = "колонна"
	desc = "Полуразрушенная колонна из песчаника."
	icon_state = "column3"

/obj/structure/fluff/desert_construction/huge_columns/column4
	name = "колонна"
	desc = "Каменная колонна."
	icon_state = "column2"

/obj/structure/fluff/desert_construction/huge_columns/black_obelisk2
	name = "чёрный обелиск"
	desc = "Ужасающий черный обелиск, несущий запретные знания в своих письменах"
	icon_state = "black_obelisk2"

/obj/structure/fluff/desert_construction/huge_columns/statue1
	name = "монструозная статуя"
	desc = "Статуя отвратительной твари выполненная из черного камня."
	icon_state = "ugly_statue1"

/obj/structure/fluff/desert_construction/huge_head
	name = "огромный каменный бюст"
	desc = "Вы никогда не видели чего-то более устрашающего и омерзительного."
	icon = 'modular_ss220/dunes_map/icons/hugehead.dmi'
	icon_state = "head2"
	pixel_x = -16

/obj/structure/fluff/desert_construction/huge_head/statue2
	name = "монструозная статуя"
	desc = "Статуя отвратительной твари выполненная из черного камня."
	icon_state = "ugly_statue2"


//legendary sabers
/obj/item/melee/rapier/genri_rapier
	name = "Трость-рапира"
	desc = "ыа"
	icon = 'modular_ss220/dunes_map/icons/saber.dmi'
	icon_state = "trrapier"
	item_state = "trrapier"
	force = 25
	lefthand_file = 'modular_ss220/dunes_map/icons/saber_left.dmi'
	righthand_file = 'modular_ss220/dunes_map/icons/saber_right.dmi'

/obj/item/storage/belt/rapier/genri_rapier
	name = "Трость-рапира"
	desc = "ыа"
	icon_state = "trsheath"
	item_state = "trsheath"
	icon = 'modular_ss220/dunes_map/icons/saber.dmi'
	lefthand_file = 'modular_ss220/dunes_map/icons/saber_left.dmi'
	righthand_file = 'modular_ss220/dunes_map/icons/saber_right.dmi'
	can_hold = list(/obj/item/melee/rapier/genri_rapier)

/obj/item/storage/belt/rapier/genri_rapier/populate_contents()
	new /obj/item/melee/rapier/genri_rapier(src)
	update_icon()

/obj/item/dualsaber/legendary_saber
	name = "Злоба"
	desc = "''Злоба'' - Один из легендарных мечей в галактике, был создан мастером Согда К'Тримом. Обладающий мистической энергией, он вызывает трепет у тех, кто стоит перед его обладателем.  Злоба - олицетворяет самую темную сторону силы,   рукоять меча  гладкая, не имеющая массивных узоров и рун.  При вспышке света он излучает рванный кроваво-красный свет, словно крича о непокорности и ярости своего владельца.  По мифам в мече ''Злоба'' пребыает сама темная сущность могущества и бесконечного гнева, готовая исполнить волю своего хозяина даже за пределами пространства и времени. Текущий владелец: Миднайт Блэк.."
	icon = 'modular_ss220/dunes_map/icons/saber.dmi'
	lefthand_file = 'modular_ss220/dunes_map/icons/saber_left.dmi'
	righthand_file = 'modular_ss220/dunes_map/icons/saber_right.dmi'
	icon_state = "mid_dualsaber0"
	blade_color = "midnight"
	colormap = LIGHT_COLOR_RED
	wieldsound = 'modular_ss220/dunes_map/sound/weapons/mid_saberon.ogg'
	unwieldsound = 'modular_ss220/dunes_map/sound/weapons/mid_saberoff.ogg'
	var/saber_name = "mid"
	var/hit_wield = 'modular_ss220/dunes_map/sound/weapons/mid_saberhit.ogg'
	var/hit_unwield = "swing_hit"

/obj/item/dualsaber/legendary_saber/update_icon_state()
	if(HAS_TRAIT(src, TRAIT_WIELDED))
		icon_state = "[saber_name]_dualsaber[blade_color]1"
		set_light(brightness_on, l_color=colormap)
	else
		icon_state = "[saber_name]_dualsaber0"
		set_light(0)

/obj/item/dualsaber/legendary_saber/on_wield(obj/item/source, mob/living/carbon/user)
	if(user && HAS_TRAIT(user, TRAIT_HULK))
		to_chat(user, "<span class='warning'>You lack the grace to wield this!</span>")
		return COMPONENT_TWOHANDED_BLOCK_WIELD

	hitsound = hit_wield
	w_class = w_class_on

/obj/item/dualsaber/legendary_saber/on_unwield()
	hitsound = hit_unwield
	w_class = initial(w_class)

/obj/item/dualsaber/legendary_saber/gromov_saber
	name = "Ловец Скорби"
	desc = "''Ловец  Скорби''  (Второе название ''Плакса'') -  Один из легендарных световых мечей.   Он сиволизизирует не только силу власти и могущества, но и является предметом гордости своего обладателя.  Искусно выполненый клинок излучает мягкий голубой свет,   словно призывая к миру и согласию, но при этом скрывает в себе силу и решимость защитить своего хозяина любой ценой.  Рукоять меча состоит из матового металлического материала,  так же на рукояти красуется  фреска с логотипом NT.   Ловец Скорби имеет специфический звук,  отдалённо напоминающий плач, от чего некоторые прозвали меч ''Плаксой'' \n Создатель:  Гаскон-Валлен-Деламот    Текущий владелец: Билл Громов"
	icon_state = "gr_dualsaber0"
	blade_color = "gromov"
	colormap = LIGHT_COLOR_LIGHT_CYAN
	saber_name = "gr"
	wieldsound = 'modular_ss220/dunes_map/sound/weapons/gr_saberon.ogg'
	unwieldsound = 'modular_ss220/dunes_map/sound/weapons/gr_saberoff.ogg'
	hit_wield = 'modular_ss220/dunes_map/sound/weapons/gr_saberhit.ogg'

/obj/item/dualsaber/legendary_saber/sharlotta_saber
	name = "Пламя"
	desc = "''Пламя'' - один из легендарных световых мечей. Он отражает неумолимую справедливость и рьяность характера своего хозяина. В противоречие грозному названию, эфес меча представляет собой аккуратное и ''нежное'' произведение искусства - отполированная нарезная титановая основа завершается золотым навершием, а декоративная гарда выполнен в виде раскрывшегося бутона. Энергетический клинок источает яркий фиолетовый свет, несущий очищение и упокоение своим врагам. Рукоять меча крайне хорошо сбалансирована и отдает дань аристократическим традициям человеческого прошлого. Создатель: Гаскон-Валлен-Деламот. Текущий владелец: Шарлотта Дитерхис."
	icon_state = "sh_dualsaber0"
	blade_color = "sharlotta"
	colormap = LIGHT_COLOR_LAVENDER
	saber_name = "sh"
	wieldsound = 'modular_ss220/dunes_map/sound/weapons/sh_saberon.ogg'
	unwieldsound = 'modular_ss220/dunes_map/sound/weapons/sh_saberoff.ogg'
	hit_wield = 'modular_ss220/dunes_map/sound/weapons/sh_saberhit.ogg'

/obj/item/dualsaber/legendary_saber/kirien_katana
	name = "Верность клятве"
	desc = "''Верность Клятве'' - Легендарный световой меч с впечатляющим изумрудно-зеленым свечением.   Сияющий осколок зеленого света, словно призывает к доблести и чести.  Владение данным  оружием говорит о преданности и силе духа.  Этот меч служит, как напоминание о обязательствах и клятвах, данным владельцем при его получении.  Согласно мифам,  в свечении отражается сама душа создателя   Арканона, который проводил долгие годы в изоляции в попытках создать воистину  уникальное творение.  Рукоять хромированный сатин, украшенный древними иероглифами людской расы. Создатель: Арканон  Текущий владелец: Хель Кириэн."
	icon_state = "kir_dualsaber0"
	blade_color = "kirien"
	colormap = LIGHT_COLOR_PURE_GREEN
	force_unwielded = 18
	saber_name = "kir"
	wieldsound = 'modular_ss220/dunes_map/sound/weapons/sh_saberon.ogg'
	unwieldsound = 'modular_ss220/dunes_map/sound/weapons/sh_saberoff.ogg'
	hit_wield = 'sound/weapons/blade1.ogg'
	hit_unwield = 'sound/weapons/slash.ogg'
