// MARK: Prime sabers

#define LEGENDARY_SWORDS_CKEY_WHITELIST list("mooniverse")

/obj/item/melee/saber/cane_rapier
	name = "трость-рапира"
	desc = "Стилизованная под трость рапира, чье элегантное и обоюдоострое лезвие насажено на роскошно украшенную рукоять. Одни лишь инкрустированные в неё драгоценные камни стоят как целая звездная система."
	icon = 'modular_ss220/prime_only/icons/saber.dmi'
	icon_state = "trrapier"
	item_state = "trrapier"
	force = 25
	lefthand_file = 'modular_ss220/prime_only/icons/saber_left.dmi'
	righthand_file = 'modular_ss220/prime_only/icons/saber_right.dmi'

/obj/item/storage/belt/sheath/saber/cane_rapier
	name = "трость-рапира"
	desc = "Ножны стилизованной под трость рапиры. Их корпус вырезан из черного дерева и щедро украшен позолотой. Их владелец обладает неоспоримым богатством и властью в известной Галактике."
	icon_state = "trsheath"
	item_state = "trsheath"
	icon = 'modular_ss220/prime_only/icons/saber.dmi'
	lefthand_file = 'modular_ss220/prime_only/icons/saber_left.dmi'
	righthand_file = 'modular_ss220/prime_only/icons/saber_right.dmi'
	can_hold = list(/obj/item/melee/saber/cane_rapier)

/obj/item/storage/belt/sheath/saber/cane_rapier/populate_contents()
	new /obj/item/melee/saber/cane_rapier(src)
	update_icon()

/obj/item/dualsaber/legendary_saber
	name = "Злоба"
	desc = "\"Злоба\" - один из легендарных энергетических мечей Галактики. Является олицетворением самой Тьмы, вызывающей трепетный ужас врагов её владельца. По легенде, \"Злоба\" была собрана своим создателем из чистой и всеобъятной ненависти. \nТекущий владелец: Миднайт Блэк."
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
	var/ranged = FALSE
	var/power = 1
	var/refusal_text = "Злоба неподвластна твоей воле, усмирить её сможет лишь сильнейший."
	var/datum/enchantment/enchant = new/datum/enchantment/dash

/obj/item/dualsaber/legendary_saber/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/ckey_and_role_locked_pickup, TRUE, LEGENDARY_SWORDS_CKEY_WHITELIST, pickup_damage = 10, refusal_text = refusal_text)

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

/obj/item/dualsaber/legendary_saber/sorrow_catcher
	name = "Ловец Скорби"
	desc = "\"Ловец  Скорби\"  (Второе название \"Плакса\") - один из легендарных энергетических мечей Галактики. Имеет специфический звук, отдалённо напоминающий плач. По легендам, этот меч впитывает предсмертные вопли своих повержанных врагов. \nТекущий владелец: Билл Громов."
	icon_state = "gr_dualsaber0"
	blade_color = "gromov"
	refusal_text = "Ну, заплачь."
	colormap = LIGHT_COLOR_LIGHT_CYAN
	saber_name = "gr"
	wieldsound = 'modular_ss220/prime_only/sound/weapons/gr_saberon.ogg'
	unwieldsound = 'modular_ss220/prime_only/sound/weapons/gr_saberoff.ogg'
	hit_wield = 'modular_ss220/prime_only/sound/weapons/gr_saberhit.ogg'

/obj/item/dualsaber/legendary_saber/flame
	name = "Пламя"
	desc = "\"Пламя\" - один из легендарных энергетических мечей Галактики. Оружие завоевателей. Был создан одной из знатных семей Эллизиума и долгое время являлся их фамильной реликвией. \nТекущий владелец: Шарлотта Дитерхис."
	icon_state = "sh_dualsaber0"
	blade_color = "sharlotta"
	refusal_text = "Кровь и свет принадлежат лишь одному."
	colormap = LIGHT_COLOR_LAVENDER
	saber_name = "sh"
	wieldsound = 'modular_ss220/prime_only/sound/weapons/sh_saberon.ogg'
	unwieldsound = 'modular_ss220/prime_only/sound/weapons/sh_saberoff.ogg'
	hit_wield = 'modular_ss220/prime_only/sound/weapons/sh_saberhit.ogg'

/obj/item/dualsaber/legendary_saber/devotion
	name = "Верность клятве"
	desc = "\"Верность Клятве\" - один из легендарных энергетических мечей Галактики. Это оружие является сакральным символом, обязующим чтить и исполнять данные клятвы. По легендам, в изумрудном свечении клинка отражается душа его создателя. \nДлительное время был утерян."
	icon_state = "kir_dualsaber0"
	blade_color = "kirien"
	refusal_text = "Только достойный узрит свет."
	colormap = LIGHT_COLOR_PURE_GREEN
	saber_name = "kir"
	wieldsound = 'modular_ss220/prime_only/sound/weapons/kir_saberon.ogg'
	unwieldsound = 'modular_ss220/prime_only/sound/weapons/kir_saberoff.ogg'
	hit_wield = 'modular_ss220/prime_only/sound/weapons/kir_saberhit.ogg'

/obj/item/dualsaber/legendary_saber/sister
	name = "Светлая Сестра"
	desc = "\"Светлая Сестра\" - один из легендарных энергетических мечей Галактики. Имеет крайне редкий кристалл с ярко-белым, \"светлым\" свечением. Меч явно создавался под женскую руку и имеет прекрасный баланс. По легендам, в свое время этим мечом был сражен один из лидеров Синдиката - \"Красавка\". \nТекущий Владелец: Мунивёрс Нормандия."
	icon_state = "norm_dualsaber0"
	blade_color = "normandy"
	refusal_text = "Ты не принадлежишь Сестре, верни её законному владельцу."
	colormap = LIGHT_COLOR_HALOGEN
	brightness_on = 3
	saber_name = "norm"
	wieldsound = 'modular_ss220/prime_only/sound/weapons/norm_saberon.ogg'
	unwieldsound = 'modular_ss220/prime_only/sound/weapons/norm_saberoff.ogg'
	hit_wield = 'modular_ss220/prime_only/sound/weapons/norm_saberhit.ogg'

/obj/item/dualsaber/legendary_saber/flee_catcher
	name = "Ловец Бегущих"
	desc = "\"Ловец Бегущих\" - один из легендарных энергетических мечей Галактики. Имеет крайне потрёпанный временем и боями вид. По легендам, своё название клинок заработал на славе известного охотника за головами, отлавливающего беглецов и предателей. \nТекущий Владелец: Рицу Келли."
	icon_state = "kel_dualsaber0"
	blade_color = "kelly"
	refusal_text = "Ловец бегущих не слушается тебя, кажется он хочет вернуться к хозяину."
	colormap = LIGHT_COLOR_HOLY_MAGIC
	saber_name = "kel"
	wieldsound = 'modular_ss220/prime_only/sound/weapons/kel_saberon.ogg'
	unwieldsound = 'modular_ss220/prime_only/sound/weapons/kel_saberoff.ogg'
	hit_wield = 'modular_ss220/prime_only/sound/weapons/kel_saberhit.ogg'

/obj/item/dualsaber/legendary_saber/eris_star
	name = "Звезда Эриды"
	desc = "\"Звезда Эриды\" - один из легендарных энергетических мечей Галактики, самый могущественный по признанию многих мастеров. По легендам, этот меч был создан могучей воительницей, которая вложила в него частичку своей души. \nТекущий Владелец: Аарон Кандрос. "
	icon_state = "aar_dualsaber0"
	blade_color = "aaron"
	refusal_text = "Свет неистовой звезды опаляет тебя."
	colormap = LIGHT_COLOR_FIRE
	saber_name = "aar"
	wieldsound = 'modular_ss220/prime_only/sound/weapons/aar_saberon.ogg'
	unwieldsound = 'modular_ss220/prime_only/sound/weapons/aar_saberoff.ogg'
	hit_wield = 'modular_ss220/prime_only/sound/weapons/aar_saberhit.ogg'

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
	var/turf/destination_turf  = get_turf(chargeat)

	if(!destination_turf)
		return
	var/list/targets = list()
	for(var/atom/target in destination_turf.contents)
		targets += target
	charging = TRUE

	var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(user.loc, user)
	animate(D, alpha = 0, color = "#271e77", transform = matrix()*1, time = anim_time, loop = anim_loop)

	var/i
	for(i=0, i<5, i++)
		spawn(i * 9 MILLISECONDS)
			step_to(user, destination_turf , 1, movespeed)
			var/obj/effect/temp_visual/decoy/D2 = new /obj/effect/temp_visual/decoy(user.loc, user)
			animate(D2, alpha = 0, color = "#271e77", transform = matrix()*1, time = anim_time, loop = anim_loop)

	spawn(45 MILLISECONDS)
		if(get_dist(user, destination_turf) > 1)
			return
		charge_end(targets, user, S)

/datum/enchantment/dash/proc/charge_end(list/targets = list(), mob/living/user, obj/item/dualsaber/legendary_saber/S)
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
