/obj/item/toy/plushie/lizardplushie
	icon = 'modular_ss220/plushiki/code/Lizards.dmi'
	icon_state = "lizard"

	/// Ссылка на надетый предмет
	var/obj/item/equipped_item

	/// Список разрешённых предметов и соответствующих им спрайтов.
	/// istype() проверит и все дочерние типы (subtypes).
	var/static/list/allowed_items = list(
		/obj/item/clothing/suit/hooded/explorer = "lizard_glass",
		/obj/item/clothing/under/rank/engineering = "lizard_al",
		/obj/item/clothing/under/rank/cargo/expedition = "lizard_kisko",
		/obj/item/clothing/under/rank/cargo/expedition_prime = "lizard_kisko",
		/obj/item/clothing/under/rank/cargo/miner = "lizard_dani"
	)

	// Объявляем список как static, чтобы он не создавался заново при каждом клике
	var/static/list/lizard_sounds = list(
		'modular_ss220/emotes/audio/unathi/roar_unathi_1.ogg' = 5,
		'modular_ss220/emotes/audio/unathi/roar_unathi_2.ogg' = 5,
		'modular_ss220/emotes/audio/unathi/roar_unathi_3.ogg' = 5,
		'modular_ss220/emotes/audio/unathi/rumble_unathi_1.ogg' = 40,
		'modular_ss220/emotes/audio/unathi/rumble_unathi_2.ogg' = 40,
		'modular_ss220/emotes/audio/unathi/threat_unathi_1.ogg' = 5,
		'modular_ss220/emotes/audio/unathi/threat_unathi_2.ogg' = 5,
		'sound/effects/unathihiss.ogg' = 20
	)

/obj/item/toy/plushie/lizardplushie/activate_self(mob/user)
	. = ..()
	if(prob(10)) // 10% шанс, что плюш издаст звук
		var/chosen_sound
		if(icon_state == "lizard_al" && prob(5))
			chosen_sound = 'modular_ss220/plushiki/code/chess-battle-advanced.ogg'
		else
			chosen_sound = pickweight(lizard_sounds) // pickweight корректно работает с весами
		playsound(get_turf(src), chosen_sound, 20, TRUE, -1)

/obj/item/toy/plushie/lizardplushie/Destroy()
	QDEL_NULL(equipped_item)
	return ..()

/// Вспомогательный.proc для проверки, подходит ли предмет и какой спрайт он даёт
/obj/item/toy/plushie/lizardplushie/proc/get_equipped_icon_state(obj/item/I)
	for(var/type_path in allowed_items)
		if(istype(I, type_path))
			return allowed_items[type_path]
	return null

/// Надевание предмета (клик предметом по плюшу)
/obj/item/toy/plushie/lizardplushie/attack_by(obj/item/attacking, mob/user, params)
	. = ..() // Вызываем родительский attack_by (чтобы работало потрошение ножом и гранаты)
	if(.)
		return

	// Если уже что-то надето
	if(equipped_item)
		to_chat(user, SPAN_WARNING("[src] already has something equipped!"))
		return FINISH_ATTACK

	// Проверяем, является ли предмет допустимым
	var/new_state = get_equipped_icon_state(attacking)
	if(!new_state)
		return // Если предмет не из списка, просто выходим, не блокируя дальнейшую логику родителя

	// Пытаемся выбить предмет из рук
	if(!user.drop_item())
		to_chat(user, SPAN_WARNING("[attacking] is stuck to your hand!"))
		return FINISH_ATTACK

	// Перемещаем предмет внутрь плюша и сохраняем данные
	attacking.forceMove(src)
	equipped_item = attacking

	icon_state = new_state
	update_icon(UPDATE_ICON_STATE)

	return FINISH_ATTACK

/// Снятие предмета (Alt-Click)
/obj/item/toy/plushie/lizardplushie/AltClick(mob/user)
	if(!equipped_item)
		return

	// Проверки на то, может ли пользователь взаимодействовать
	if(user.stat || HAS_TRAIT(user, TRAIT_HANDS_BLOCKED) || user.restrained())
		to_chat(user, SPAN_WARNING("You can't take anything off [src] right now!"))
		return

	// Если активная рука свободна и мы рядом - кладём в руку, иначе кидаем на пол
	if(!user.get_active_hand() && Adjacent(user))
		user.put_in_hands(equipped_item)
	else
		equipped_item.forceMove(get_turf(user))

	equipped_item = null
	icon_state = "lizard"
	update_icon(UPDATE_ICON_STATE)

/// Обновление спрайта в руке моба
/obj/item/toy/plushie/lizardplushie/update_icon_state()
	. = ..()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_r_hand()
		M.update_inv_l_hand()

/// Подсказки при осмотре
/obj/item/toy/plushie/lizardplushie/examine(mob/user)
	. = ..()
	if(equipped_item)
		. += SPAN_NOTICE("You can <b>Alt-Click</b> to remove the [equipped_item.name].")
	else
		. += SPAN_NOTICE("It looks like you can put some clothes or gear on it.")

