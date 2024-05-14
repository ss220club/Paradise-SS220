/obj/item/melee/rapier/genri_rapier
	name = "Трость-рапира"
	desc = "ыа"
	icon = 'modular_ss220/prime_only/icons/saber.dmi'
	icon_state = "trrapier"
	item_state = "trrapier"
	force = 25
	lefthand_file = 'modular_ss220/prime_only/icons/saber_left.dmi'
	righthand_file = 'modular_ss220/prime_only/icons/saber_right.dmi'

/obj/item/storage/belt/rapier/genri_rapier
	name = "Трость-рапира"
	desc = "ыа"
	icon_state = "trsheath"
	item_state = "trsheath"
	icon = 'modular_ss220/prime_only/icons/saber.dmi'
	lefthand_file = 'modular_ss220/prime_only/icons/saber_left.dmi'
	righthand_file = 'modular_ss220/prime_only/icons/saber_right.dmi'
	can_hold = list(/obj/item/melee/rapier/genri_rapier)

/obj/item/storage/belt/rapier/genri_rapier/populate_contents()
	new /obj/item/melee/rapier/genri_rapier(src)
	update_icon()

/obj/item/dualsaber/legendary_saber
	name = "Злоба"
	desc = "''Злоба'' - Один из легендарных мечей в галактике, был создан мастером Согда К'Тримом. Обладающий мистической энергией, он вызывает трепет у тех, кто стоит перед его обладателем.  Злоба - олицетворяет самую темную сторону силы,   рукоять меча  гладкая, не имеющая массивных узоров и рун.  При вспышке света он излучает рванный кроваво-красный свет, словно крича о непокорности и ярости своего владельца.  По мифам в мече ''Злоба'' пребыает сама темная сущность могущества и бесконечного гнева, готовая исполнить волю своего хозяина даже за пределами пространства и времени. Текущий владелец: Миднайт Блэк.."
	icon = 'modular_ss220/prime_only/icons/saber.dmi'
	lefthand_file = 'modular_ss220/prime_only/icons/saber_left.dmi'
	righthand_file = 'modular_ss220/prime_only/icons/saber_right.dmi'
	icon_state = "mid_dualsaber0"
	blade_color = "midnight"
	colormap = LIGHT_COLOR_RED
	wieldsound = 'modular_ss220/prime_only/sound/weapons/mid_saberon.ogg'
	unwieldsound = 'modular_ss220/prime_only/sound/weapons/mid_saberoff.ogg'
	var/saber_name = "mid"
	var/hit_wield = 'modular_ss220/prime_only/sound/weapons/mid_saberhit.ogg'
	var/hit_unwield = "swing_hit"

	var/datum/enchantment/enchant = null
	var/ranged = FALSE
	var/power = 1

/obj/item/dualsaber/legendary_saber/pickup(mob/living/user)
	. = ..()
	if(!(user.mind.offstation_role) && !(user.client.ckey == "mooniverse"))
		user.Weaken(10 SECONDS)
		user.unEquip(src, force, silent = FALSE)
		to_chat(user, span_userdanger("Вы недостойны."))
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.apply_damage(rand(force/2, force), BRUTE, pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
		else
			user.adjustBruteLoss(rand(force/2, force))


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
	desc = "''Ловец  Скорби''  (Второе название ''Плакса'') -  один из легендарных световых мечей.   Он сиволизизирует не только силу власти и могущества, но и является предметом гордости своего обладателя.  Искусно выполненый клинок излучает мягкий голубой свет,   словно призывая к миру и согласию, но при этом скрывает в себе силу и решимость защитить своего хозяина любой ценой.  Рукоять меча состоит из матового металлического материала,  так же на рукояти красуется  фреска с логотипом NT.   Ловец Скорби имеет специфический звук,  отдалённо напоминающий плач, от чего некоторые прозвали меч ''Плаксой'' \n Создатель:  Гаскон-Валлен-Деламот.    Текущий владелец: Билл Громов"
	icon_state = "gr_dualsaber0"
	blade_color = "gromov"
	colormap = LIGHT_COLOR_LIGHT_CYAN
	saber_name = "gr"
	wieldsound = 'modular_ss220/prime_only/sound/weapons/gr_saberon.ogg'
	unwieldsound = 'modular_ss220/prime_only/sound/weapons/gr_saberoff.ogg'
	hit_wield = 'modular_ss220/prime_only/sound/weapons/gr_saberhit.ogg'
	enchant = new/datum/enchantment/dash

/obj/item/dualsaber/legendary_saber/sharlotta_saber
	name = "Пламя"
	desc = "''Пламя'' - один из легендарных световых мечей. Он отражает неумолимую справедливость и рьяность характера своего хозяина. В противоречие грозному названию, эфес меча представляет собой аккуратное и ''нежное'' произведение искусства - отполированная нарезная титановая основа завершается золотым навершием, а декоративная гарда выполнен в виде раскрывшегося бутона. Энергетический клинок источает яркий фиолетовый свет, несущий очищение и упокоение своим врагам. Рукоять меча крайне хорошо сбалансирована и отдает дань аристократическим традициям человеческого прошлого. Создатель: Гаскон-Валлен-Деламот. Текущий владелец: Шарлотта Дитерхис."
	icon_state = "sh_dualsaber0"
	blade_color = "sharlotta"
	colormap = LIGHT_COLOR_LAVENDER
	saber_name = "sh"
	wieldsound = 'modular_ss220/prime_only/sound/weapons/sh_saberon.ogg'
	unwieldsound = 'modular_ss220/prime_only/sound/weapons/sh_saberoff.ogg'
	hit_wield = 'modular_ss220/prime_only/sound/weapons/sh_saberhit.ogg'
	enchant = new/datum/enchantment/dash

/obj/item/dualsaber/legendary_saber/kirien_saber
	name = "Верность клятве"
	desc = "''Верность Клятве'' - легендарный световой меч с впечатляющим изумрудно-зеленым свечением.   Сияющий осколок зеленого света, словно призывает к доблести и чести.  Владение данным  оружием говорит о преданности и силе духа.  Этот меч служит, как напоминание о обязательствах и клятвах, данным владельцем при его получении.  Согласно мифам,  в свечении отражается сама душа создателя   Арканона, который проводил долгие годы в изоляции в попытках создать воистину  уникальное творение.  Рукоять хромированный сатин, украшенный древними иероглифами людской расы. Создатель: Арканон.  Текущий владелец: Хель Кириэн."
	icon_state = "kir_dualsaber0"
	blade_color = "kirien"
	colormap = LIGHT_COLOR_PURE_GREEN
	saber_name = "kir"
	wieldsound = 'modular_ss220/prime_only/sound/weapons/kir_saberon.ogg'
	unwieldsound = 'modular_ss220/prime_only/sound/weapons/kir_saberoff.ogg'
	hit_wield = 'modular_ss220/prime_only/sound/weapons/kir_saberhit.ogg'
	enchant = new/datum/enchantment/dash

/obj/item/dualsaber/legendary_saber/normandy_saber
	name = "Сестра"
	desc = "''Сестра'' - легендарный световой меч, представляет собой удивительное оружие с мистической историей и неповторимыми свойствами.  Его лезвие излучает мягкий  золотой свет, символизирующий  мудрость, мощь и защиту. Сестра - это не просто меч, а источник силы и опоры для своего владельца.  Его форма напоминает древние мечи рыцарей, но в тоже время он обладает строгим стилем, который дополняет своего владельца. Этот меч стал объектом поклонения и уважения во всей галактике, имя его символ доблести, чести и справедливости.  По мифам считается, что только тот, кто искренне верит в силу справедлиовсти и защиты, способен раскрывать скрытые возможности Сестры. Этот меч служит не просто как инструмент борьбы, но как символ верности высшим идеалам. Создатель: Коникс`Хеллькикс.  Текущий Владелец: Мунивёрс Нормандия"
	icon_state = "norm_dualsaber0"
	blade_color = "normandy"
	colormap = LIGHT_COLOR_HOLY_MAGIC
	saber_name = "norm"
	wieldsound = 'modular_ss220/prime_only/sound/weapons/norm_saberon.ogg'
	unwieldsound = 'modular_ss220/prime_only/sound/weapons/norm_saberoff.ogg'
	hit_wield = 'modular_ss220/prime_only/sound/weapons/norm_saberhit.ogg'
	enchant = new/datum/enchantment/dash

/obj/item/dualsaber/legendary_saber/kelly_saber
	name = "Ловец Бегущих"
	desc = "''Ловец Бегущих'' - легендарный световой меч который является младшей частью меча ''Сестра''. Первый взгляд на корпус даёт понять, что он служит уже продолжительное время. Вся поверхность изобилует царапинами, сколами и потёртостями. Под кнопкой включения, вдоль рукояти, нарисованы семь белых, перечёркнутых жетонов - счёт владельцев, через которых прошло это оружие. Рядом с самым первым жетоном выгравировано ''2361. А.М.'' Рукоять меча удлинена для комфортного боя как одной, так и двумя руками, навершие Типа P покрыто золотом и обладает специальным разъёмом для подключения второго меча, а гарда представляет собой два закруглённых отростка. Обладатели этого меча используют хаотичный, адаптивный под врага стиль боя. Создатель: Коникс`Хеллькикс. Текущий Владелец: Мунивёрс Нормандия, в последствии был передан Рицу Келли."
	icon_state = "kel_dualsaber0"
	blade_color = "kelly"
	colormap = LIGHT_COLOR_HOLY_MAGIC
	saber_name = "kel"
	wieldsound = 'modular_ss220/prime_only/sound/weapons/kel_saberon.ogg'
	unwieldsound = 'modular_ss220/prime_only/sound/weapons/kel_saberoff.ogg'
	hit_wield = 'modular_ss220/prime_only/sound/weapons/kel_saberhit.ogg'
	enchant = new/datum/enchantment/dash

/obj/item/dualsaber/legendary_saber/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	enchant?.on_legendary_hit(target, user, proximity_flag, src)

/obj/item/dualsaber/legendary_saber/proc/add_enchantment(new_enchant, mob/living/user, intentional = TRUE)
	var/datum/enchantment/E = new new_enchant
	enchant = E
	E.on_gain(src, user)
	E.power *= power
	if(intentional)
		SSblackbox.record_feedback("nested tally", "saber_enchants", 1, list("[E.name]"))


/datum/enchantment/dash/proc/charge(mob/living/user, atom/chargeat, obj/item/dualsaber/legendary_saber/S)
	if(on_leap_cooldown)
		return
	if(!chargeat)
		return
	var/turf/T = get_turf(chargeat)

	if(!T)
		return
	var/list/targets = list()
	for(var/atom/target in T.contents)
		targets += target
	charging = TRUE

	var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(user.loc, user)
	animate(D, alpha = 0, color = "#271e77", transform = matrix()*1, time = anim_time, loop = anim_loop)

	var/i
	for(i=0, i<5, i++)
		spawn(i * 9 MILLISECONDS)
			step_to(user, T, 1, movespeed)
			var/obj/effect/temp_visual/decoy/D2 = new /obj/effect/temp_visual/decoy(user.loc, user)
			animate(D2, alpha = 0, color = "#271e77", transform = matrix()*1, time = anim_time, loop = anim_loop)

	spawn(45 MILLISECONDS)
		if(get_dist(user, T) > 1)
			return
		charge_end(targets, user, S)


/datum/enchantment/dash/proc/charge_end(var/list/targets = list(), mob/living/user, obj/item/dualsaber/legendary_saber/S)
	charging = FALSE

	for(var/mob/living/L in targets)
		if(!(L == user))
			user.apply_damage(-40, STAMINA)
			S.melee_attack_chain(user, L)

/datum/enchantment/dash
	name = "Рывок"
	desc = "Этот клинок несёт владельца прямо к цели. Никто не уйдёт."
	ranged = TRUE
	var/movespeed = 0.8
	var/on_leap_cooldown = FALSE
	var/charging = FALSE
	var/anim_time = 3 DECISECONDS
	var/anim_loop = 3 DECISECONDS


/datum/enchantment/proc/on_legendary_hit(mob/living/target, mob/living/user, proximity, obj/item/dualsaber/legendary_saber/S)
	if(world.time < cooldown)
		return FALSE
	if(!istype(target))
		return FALSE
	if(target.stat == DEAD)
		return FALSE
	if(!ranged && !proximity)
		return FALSE
	cooldown = world.time + initial(cooldown)
	return TRUE

/datum/enchantment/dash/on_legendary_hit(mob/living/target, mob/living/user, proximity, obj/item/dualsaber/legendary_saber/S)
	if(proximity) // don't put it on cooldown if adjacent
		return
	. = ..()
	if(!.)
		return

	if(HAS_TRAIT(S, TRAIT_WIELDED))
		charge(user, target, S)


