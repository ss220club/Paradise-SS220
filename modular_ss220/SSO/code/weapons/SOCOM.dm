//////////////////////////////
// MARK: M26A3 SOCOM
//////////////////////////////
/obj/item/gun/projectile/automatic/ar/sso
	name = "M26A3 SOCOM"
	desc = "Штурмовая винтовка М26, в модификации SOCOM специально разработанная для сил специальных операций ТСФ. На нём стоит связка из колиматорного прицела и магнифера, что позволяет стрелять и на дальние дистанции. Использует патроны калибра 5.56мм."
	icon = 'modular_ss220/SSO/icons/SOCOM_ARG.dmi'
	lefthand_file = 'modular_ss220/SSO/icons/inhands/guns_lefthand.dmi'
	righthand_file = 'modular_ss220/SSO/icons/inhands/guns_righthand.dmi'
	icon_state = "arg"
	inhand_icon_state = "arg"
	mag_type = /obj/item/ammo_box/magazine/m556/arg
	fire_sound = 'sound/weapons/gunshots/gunshot_mg.ogg'
	magin_sound = 'sound/weapons/gun_interactions/batrifle_magin.ogg'
	magout_sound = 'sound/weapons/gun_interactions/batrifle_magout.ogg'
	fire_delay = 1
	execution_speed = 4 SECONDS
	can_suppress = TRUE
	var/zoomable = TRUE

/obj/item/gun/projectile/automatic/ar/sso/Initialize(mapload)
	. = ..()
	if(zoomable)
		AddComponent(/datum/component/scope, range_modifier = 2, flags = SCOPE_TURF_ONLY | SCOPE_NEED_ACTIVE_HAND)

/obj/item/gun/projectile/automatic/ar/sso/process_fire(atom/target, mob/living/user, message = TRUE, params, zone_override, bonus_spread = 0)
	if(istype(chambered.BB, /obj/projectile/bullet/sniper) && !HAS_TRAIT(user, TRAIT_SCOPED))
		var/obj/projectile/bullet/sniper/S = chambered.BB
		if(S.non_zoom_spread)
			to_chat(user, SPAN_WARNING("[src] must be zoomed in to fire this ammunition accurately!"))
			bonus_spread += S.non_zoom_spread
	return ..()

/obj/item/gun/projectile/automatic/ar/sso/update_overlays()
	. = ..()
	switch(select)
		if(0)
			. += "[initial(icon_state)]semi"
		if(1)
			. += "[initial(icon_state)]burst"

//////////////////////////////
// MARK: M26A3 c ГП SOCOM
//////////////////////////////
/obj/item/gun/projectile/automatic/ar/sso/grenade
	name = "M26A3 c ГП SOCOM"
	desc = "Штурмовая винтовка М26, оснащённая подствольным гранотомётом М204, в модификации SOCOM специально разработанная для сил специальных операций ТСФ. На нём стоит связка из колиматорного прицела и магнифера, что позволяет стрелять и на дальние дистанции. Использует патроны калибра 5.56мм."
	icon = 'modular_ss220/SSO/icons/SOCOM_ARG_gren.dmi'
	lefthand_file = 'modular_ss220/SSO/icons/inhands/guns_lefthand.dmi'
	righthand_file = 'modular_ss220/SSO/icons/inhands/guns_righthand.dmi'
	icon_state = "arg"
	inhand_icon_state = "arg"
	mag_type = /obj/item/ammo_box/magazine/m556/arg
	fire_sound = 'sound/weapons/gunshots/gunshot_mg.ogg'
	magin_sound = 'sound/weapons/gun_interactions/batrifle_magin.ogg'
	magout_sound = 'sound/weapons/gun_interactions/batrifle_magout.ogg'
	fire_delay = 1
	execution_speed = 4 SECONDS
	can_suppress = TRUE
	var/obj/item/gun/projectile/revolver/grenadelauncher/underbarrel

/obj/item/gun/projectile/automatic/ar/sso/grenade/Initialize(mapload)
	. = ..()
	underbarrel = new /obj/item/gun/projectile/revolver/grenadelauncher(src)
	update_icon()

/obj/item/gun/projectile/automatic/ar/sso/grenade/Destroy()
	qdel(underbarrel)
	return ..()

/obj/item/gun/projectile/automatic/ar/sso/grenade/afterattack__legacy__attackchain(atom/target, mob/living/user, flag, params)
	if(select == 2)
		underbarrel.afterattack__legacy__attackchain(target, user, flag, params)
	else
		..()
		return

/obj/item/gun/projectile/automatic/ar/sso/grenade/attackby__legacy__attackchain(obj/item/A, mob/user, params)
	if(istype(A, /obj/item/ammo_casing))
		if(istype(A, underbarrel.magazine.ammo_type))
			underbarrel.attack_self__legacy__attackchain(user)
			underbarrel.attackby__legacy__attackchain(A, user, params)
	else
		return ..()

/obj/item/gun/projectile/automatic/ar/sso/grenade/update_overlays()
	. = ..()
	switch(select)
		if(0)
			. += "[initial(icon_state)]semi"
		if(1)
			. += "[initial(icon_state)]burst"
		if(2)
			. += "[initial(icon_state)]gren"


/obj/item/gun/projectile/automatic/ar/sso/grenade/burst_select()
	var/mob/living/carbon/human/user = usr
	switch(select)
		if(0)
			select = 1
			burst_size = initial(burst_size)
			fire_delay = initial(fire_delay)
			to_chat(user, SPAN_NOTICE("You switch to [burst_size] round burst."))
		if(1)
			select = 2
			to_chat(user, SPAN_NOTICE("You switch to grenades."))
		if(2)
			select = 0
			burst_size = 1
			fire_delay = 0
			to_chat(user, SPAN_NOTICE("You switch to semi-auto."))
	playsound(user, 'sound/weapons/gun_interactions/selector.ogg', 100, 1)
	update_icon()

//////////////////////////////
// MARK: M42 EBR
//////////////////////////////
/obj/item/gun/projectile/automatic/sniper_rifle/sso
	name = "M42 EBR"
	desc = "Марксманская винтовка М42, в модификации SOCOM специально разработанная для сил специальных операций ТСФ. Использует патроны 7,62х51"
	icon = 'modular_ss220/SSO/icons/SOCOM_M42.dmi'
	lefthand_file = 'modular_ss220/SSO/icons/inhands/guns_lefthand.dmi'
	righthand_file = 'modular_ss220/SSO/icons/inhands/guns_righthand.dmi'
	icon_state = "m42"
	worn_icon = 'modular_ss220/SSO/icons/inhands/guns_worn.dmi'
	worn_icon_state = "m42"
	inhand_icon_state = "m42"
	recoil = 1.5
	w_class = WEIGHT_CLASS_BULKY
	mag_type = /obj/item/ammo_box/magazine/m42
	fire_sound = 'modular_ss220/SSO/sound/weapons/gunshots/gun_nsg23_new_2.ogg' //подтырено с маринов
	suppressed_sound = 'modular_ss220/SSO/sound/weapons/gunshots/gun_silenced_shot2.ogg' //подтырено с маринов
	magin_sound = 'modular_ss220/SSO/sound/weapons/cylinder/l42_reload.ogg' //подтырено с маринов
	magout_sound = 'modular_ss220/SSO/sound/weapons/cylinder/l42_unload.ogg' //подтырено с маринов
	fire_delay = 1
	burst_size = 1
	//origin_tech = "combat=7"
	slot_flags = ITEM_SLOT_BACK
	actions_types = list()
	execution_speed = 4 SECONDS

//////////////////////////////
// MARK: СВД
//////////////////////////////
/obj/item/gun/projectile/automatic/sniper_rifle/sso/svd
	name = "СВД"
	desc = "Снайперская винтовка СВД. Старичек, почти как винтовка Мосина. От неё так и не смогли отказаться в СССП. Из-за простоты обслуживания и того, что она выполняет свои прямые задачи, она до сих пор стоит на вооружении СССП. Использует патроны 7,62х54R"
	icon = 'modular_ss220/SSO/icons/USSP_SVD.dmi'
	icon_state = "arg"
	worn_icon_state = "svd"
	inhand_icon_state = "svd"
	recoil = 1.5
	w_class = WEIGHT_CLASS_BULKY
	mag_type = /obj/item/ammo_box/magazine/svd
	fire_sound = 'modular_ss220/SSO/sound/weapons/gunshots/gun_nsg23_new_1.ogg' //подтырено с маринов
	suppressed_sound = 'modular_ss220/SSO/sound/weapons/gunshots/gun_silenced_shot2.ogg' //подтырено с маринов
	magin_sound = 'modular_ss220/SSO/sound/weapons/cylinder/l42_reload.ogg' //подтырено с маринов
	magout_sound = 'modular_ss220/SSO/sound/weapons/cylinder/l42_unload.ogg' //подтырено с маринов
	fire_delay = 1
	//origin_tech = "combat=7"
	slot_flags = ITEM_SLOT_BACK
	actions_types = list()
	execution_speed = 4 SECONDS

//////////////////////////////
// MARK: СВДК «Взломщик»
//////////////////////////////
/obj/item/gun/projectile/automatic/sniper_rifle/sso/svdk
	name = "СВДК"
	desc = "Снайперская винтовка СВДК «Взломщик». Чуть более новая версия старой доброй СВД. Она ещё и патрон использует побольше! Использует патроны 9,3х64"
	icon = 'modular_ss220/SSO/icons/USSP_SVDK.dmi'
	icon_state = "arg"
	worn_icon_state = "svdk"
	inhand_icon_state = "svdk"
	recoil = 1.7
	mag_type = /obj/item/ammo_box/magazine/svdk
	fire_sound = 'modular_ss220/SSO/sound/weapons/gunshots/gun_vulture_fire.ogg' //подтырено с маринов
	suppressed_sound = 'modular_ss220/SSO/sound/weapons/gunshots/gun_socom_1.ogg' //подтырено с маринов
	magin_sound = 'modular_ss220/SSO/sound/weapons/cylinder/gun_srs99_cocked.ogg' //подтырено с маринов
	magout_sound = 'modular_ss220/SSO/sound/weapons/cylinder/gun_srs99_unload.ogg' //подтырено с маринов
	fire_delay = 20
	//origin_tech = "combat=7"
	slot_flags = ITEM_SLOT_BACK
	actions_types = list()
	execution_speed = 4 SECONDS

//////////////////////////////
// MARK: M210 "Balancer" SOCOM
//////////////////////////////
/obj/item/gun/projectile/automatic/sniper_rifle/sso/heavy
	name = "M210 «Уравниватель» SOCOM"
	desc = "Винтовка M210 «Уравниватель», в модификации SOCOM специально разработанная для сил специальных операций ТСФ. Использует патроны .338 Lapua Magnum. Ходит слух о том, что она, после попадания, не оставляет в живых..."
	icon = 'modular_ss220/SSO/icons/SOCOM_M210.dmi'
	icon_state = "m210"
	inhand_icon_state = "m210"
	worn_icon_state = "m210"
	recoil = 2
	weapon_weight = WEAPON_HEAVY
	mag_type = /obj/item/ammo_box/magazine/m210
	fire_sound = 'modular_ss220/SSO/sound/weapons/gunshots/gun_boltaction.ogg' //подтырено с маринов
	suppressed_sound = 'modular_ss220/SSO/sound/weapons/gunshots/shot_heavy.ogg' //подтырено с маринов
	magin_sound = 'modular_ss220/SSO/sound/weapons/cylinder/gun_vulture_bolt_close.ogg' //подтырено с маринов
	magout_sound = 'modular_ss220/SSO/sound/weapons/cylinder/gun_vulture_bolt_eject.ogg' //подтырено с маринов
	fire_delay = 20
	burst_size = 1
	slot_flags = ITEM_SLOT_BACK

/obj/item/gun/projectile/automatic/sniper_rifle/sso/update_icon_state()
	icon_state = "[initial(icon_state)][magazine ? "-[magazine.max_ammo]" : ""][chambered ? "" : "-e"][suppressed ? "-suppressed" : ""]"

//////////////////////////////
// MARK: КСВ-А "Ключник"
//////////////////////////////
/obj/item/gun/projectile/automatic/sniper_rifle/sso/heavy/ksv
	name = "КСВ-А 'Ключник'"
	desc = "Винтовка КСВ-А 'Ключник'. Крупнокалиберная Снайперская Винтовка Автоматизированая, вскроет любого из тесного пространства. Использует патроны 12,7х108 . Вообще её используют чтобы лёгкобронированную технику уничтожать... но вам видне..."
	icon = 'modular_ss220/SSO/icons/USSP_KSV.dmi'
	icon_state = "arg"
	inhand_icon_state = "ksv"
	worn_icon_state = "ksv"
	recoil = 2
	weapon_weight = WEAPON_HEAVY
	mag_type = /obj/item/ammo_box/magazine/ksv
	fire_sound = 'modular_ss220/SSO/sound/weapons/gunshots/gun_srs99_1.ogg'  // подтырено с маринов
	suppressed_sound = 'modular_ss220/SSO/sound/weapons/gunshots/gun_boltaction.ogg' //ZAMENIT
	magin_sound = 'modular_ss220/SSO/sound/weapons/cylinder/gun_vulture_bolt_close.ogg' //подтырено с маринов
	magout_sound = 'modular_ss220/SSO/sound/weapons/cylinder/gun_vulture_bolt_eject.ogg' //подтырено с маринов
	fire_delay = 50
	burst_size = 1

//////////////////////////////
// MARK: ДПК «Корд»
//////////////////////////////
/obj/item/gun/projectile/automatic/mg
	name = "ДПК «Корд»"
	desc = "Пулемёт Дегтярёв Пехотный Крупнокалиберный «Корд». Один из самых мощных пулемётов используемый СССП. Отрывает члены. Использует патроны 12,7х108мм"
	icon = 'modular_ss220/SSO/icons/USSP_KORD.dmi'
	icon_state = "MGclosed100"
	lefthand_file = 'modular_ss220/SSO/icons/inhands/guns_lefthand.dmi'
	righthand_file = 'modular_ss220/SSO/icons/inhands/guns_righthand.dmi'
	inhand_icon_state = "KORD"
	worn_icon = 'modular_ss220/SSO/icons/inhands/guns_worn.dmi'
	worn_icon_state = "KORD"
	w_class = WEIGHT_CLASS_BULKY
	mag_type = /obj/item/ammo_box/magazine/mg_kord
	weapon_weight = WEAPON_HEAVY
	fire_sound = 'modular_ss220/SSO/sound/weapons/gunshots/autocannon_fire.ogg' // подтырено с маринов
	suppressed_sound = 'modular_ss220/SSO/sound/weapons/gunshots/gun_boltaction.ogg' //ZAMENIT
	magin_sound = 'sound/weapons/gun_interactions/lmg_magin.ogg' //заменить на мариновские МОЩНЫЕ
	magout_sound = 'sound/weapons/gun_interactions/lmg_magout.ogg' //заменить на мариновские МОЩНЫЕ
	actions_types = list()
	can_suppress = TRUE
	burst_size = 1
	spread = 7
	fire_delay = 0
	slot_flags = ITEM_SLOT_BACK
	var/cover_open = FALSE
	var/zoomable = TRUE

/obj/item/gun/projectile/automatic/mg/attack_self__legacy__attackchain(mob/user)
	cover_open = !cover_open
	to_chat(user, SPAN_NOTICE("You [cover_open ? "open" : "close"] [src]'s cover."))
	//заменить на мариновские МОЩНЫЕ
	playsound(src, cover_open ? 'sound/weapons/gun_interactions/sawopen.ogg' : 'sound/weapons/gun_interactions/sawclose.ogg', 50, 1)
	update_icon()

/obj/item/gun/projectile/automatic/mg/update_icon_state()
	icon_state = "MG[cover_open ? "open" : "closed"][magazine ? CEILING(get_ammo(FALSE) / 12.5, 1) * 25 : "-empty"][suppressed ? "-suppressed" : ""]"
	inhand_icon_state = "KORD[cover_open ? "open" : "closed"][magazine ? "mag" : ""]"

/obj/item/gun/projectile/automatic/mg/afterattack__legacy__attackchain(atom/target as mob|obj|turf, mob/living/user as mob|obj, flag, params) //what I tried to do here is just add a check to see if the cover is open or not and add an icon_state change because I can't figure out how c-20rs do it with overlays
	if(cover_open)
		to_chat(user, SPAN_NOTICE("[src]'s cover is open! Close it before firing!"))
	else
		..()
		update_icon()

/obj/item/gun/projectile/automatic/mg/attack_hand(mob/user)
	if(loc != user)
		..()
		return	//let them pick it up
	if(!cover_open || (cover_open && !magazine))
		..()
	else if(cover_open && magazine)
		//drop the mag
		magazine.update_icon()
		magazine.loc = get_turf(loc)
		user.put_in_hands(magazine)
		magazine = null
		playsound(src, magout_sound, 50, 1)
		update_icon()
		if(user.hand)
			user.update_inv_r_hand()
		else
			user.update_inv_l_hand()
		to_chat(user, SPAN_NOTICE("You remove the magazine from [src]."))

/obj/item/gun/projectile/automatic/mg/attackby__legacy__attackchain(obj/item/A, mob/user, params)
	if(istype(A, /obj/item/ammo_box/magazine))
		var/obj/item/ammo_box/magazine/AM = A
		if(istype(AM, mag_type))
			if(!cover_open)
				to_chat(user, SPAN_WARNING("[src]'s cover is closed! You can't insert a new mag."))
				return
	return ..()


/obj/item/gun/projectile/automatic/mg/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.2 SECONDS)
	if(zoomable)
		AddComponent(/datum/component/scope, range_modifier = 2, flags = SCOPE_TURF_ONLY | SCOPE_NEED_ACTIVE_HAND)

/obj/item/gun/projectile/automatic/mg/process_fire(atom/target, mob/living/user, message = TRUE, params, zone_override, bonus_spread = 0)
	if(istype(chambered.BB, /obj/projectile/bullet/sniper) && !HAS_TRAIT(user, TRAIT_SCOPED))
		var/obj/projectile/bullet/sniper/S = chambered.BB
		if(S.non_zoom_spread)
			to_chat(user, SPAN_WARNING("[src] must be zoomed in to fire this ammunition accurately!"))
			bonus_spread += S.non_zoom_spread
	return ..()

//////////////////////////////
// MARK: ПКП «Печенег»
//////////////////////////////
/obj/item/gun/projectile/automatic/mg/pkp
	name = "ПКП «Печенег»"
	desc = "Пулемёт ПКП «Печенег». Один из лучших пулемётов, сочетает надёжность, прочность и лёгкость (относительно других пулемётов). Такой же лёгкий в обращении как и автомат Калашникова! Использует патроны 7,62х54R."
	icon = 'modular_ss220/SSO/icons/USSP_PKP.dmi'
	icon_state = "MGclosed100"
	lefthand_file = 'modular_ss220/SSO/icons/inhands/guns_lefthand.dmi'
	righthand_file = 'modular_ss220/SSO/icons/inhands/guns_righthand.dmi'
	inhand_icon_state = "pkp"
	worn_icon_state = "pkp"
	slot_flags = 0
	mag_type = /obj/item/ammo_box/magazine/mg_pkp
	weapon_weight = WEAPON_HEAVY
	fire_sound = 'modular_ss220/SSO/sound/weapons/gunshots/shot_heavy.ogg' //заменить на мариновские МОЩНЫЕ
	suppressed_sound = 'modular_ss220/SSO/sound/weapons/gunshots/gun_silenced_shot1.ogg' //ZAMENIT
	magin_sound = 'modular_ss220/SSO/sound/weapons/cylinder/l42_reload.ogg' //заменить на мариновские МОЩНЫЕ
	magout_sound = 'modular_ss220/SSO/sound/weapons/cylinder/gun_br55_unload.ogg' //заменить на мариновские МОЩНЫЕ
	actions_types = list()
	can_suppress = TRUE
	slot_flags = ITEM_SLOT_BACK

/obj/item/gun/projectile/automatic/mg/pkp/update_icon_state()
	icon_state = "MG[cover_open ? "open" : "closed"][magazine ? CEILING(get_ammo(FALSE) / 25, 1) * 25 : "-empty"][suppressed ? "-suppressed" : ""]"
	inhand_icon_state = "pkp[cover_open ? "open" : "closed"][magazine ? "mag" : ""]"

/obj/item/gun/projectile/automatic/mg/pkp/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.1 SECONDS)

//////////////////////////////
// MARK: MMG338 «Stormbreaker»
//////////////////////////////
/obj/item/gun/projectile/automatic/mg/sso
	name = "MMG338 «Stormbreaker»"
	desc = "Пулемёт MMG338 «Stormbreaker» (Medium Machine Gun). Создан для сил специальных операций ТСФ. Не особо понятно, почему он назван «СРЕДНИМ» пулемётом, когда использует очень даже антиматериальный патрон... Врагу точно придётся не сладко. Использует патрон .338 Lapua Magnum"
	icon = 'modular_ss220/SSO/icons/SOCOM_MMG338.dmi'
	icon_state = "MGclosed100"
	lefthand_file = 'modular_ss220/SSO/icons/inhands/guns_lefthand.dmi'
	righthand_file = 'modular_ss220/SSO/icons/inhands/guns_righthand.dmi'
	inhand_icon_state = "MMG338"
	worn_icon_state = "MMG338"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = 0
	mag_type = /obj/item/ammo_box/magazine/mg_sso
	weapon_weight = WEAPON_HEAVY
	fire_sound = 'modular_ss220/SSO/sound/weapons/gunshots/gun_m56d_auto.ogg' //заменить на мариновские МОЩНЫЕ
	suppressed_sound = 'modular_ss220/SSO/sound/weapons/gunshots/shot_heavy.ogg' //ZAMENIT
	magin_sound = 'sound/weapons/gun_interactions/lmg_magin.ogg' //заменить на мариновские МОЩНЫЕ
	magout_sound = 'sound/weapons/gun_interactions/lmg_magout.ogg' //заменить на мариновские МОЩНЫЕ
	actions_types = list()
	can_suppress = TRUE
	slot_flags = ITEM_SLOT_BACK

/obj/item/gun/projectile/automatic/mg/sso/update_icon_state()
	icon_state = "MG[cover_open ? "open" : "closed"][magazine ? CEILING(get_ammo(FALSE) / 12.5, 1) * 25 : "-empty"][suppressed ? "-suppressed" : ""]"
	inhand_icon_state = "MMG338[cover_open ? "open" : "closed"][magazine ? "mag" : ""]"

//////////////////////////////
// MARK: Mk 43 SOCOM
//////////////////////////////
/obj/item/gun/projectile/automatic/pistol/sso
	name = "Mk43 SOCOM"
	desc = "Пистолет Mk43 «Миротворец» в модификации SOCOM, специально разработанная для сил специальных операций ТСФ, использует патрон .45. Обычно постовляется вместе с глушителем и тактическим фонарём."
	icon = 'modular_ss220/SSO/icons/SOCOM_MK43.dmi'
	icon_state = "mk43"
	lefthand_file = 'modular_ss220/SSO/icons/inhands/guns_lefthand.dmi'
	righthand_file = 'modular_ss220/SSO/icons/inhands/guns_righthand.dmi'
	inhand_icon_state = "pistol"
	// fire_sound = 'modular_ss220/SSO/sound/weapons/gunshots/gun_m56d_auto.ogg' //заменить на мариновские МОЩНЫЕ
	// suppressed_sound = 'modular_ss220/SSO/sound/weapons/gunshots/shot_heavy.ogg' //ZAMENIT
	w_class = WEIGHT_CLASS_NORMAL
	mag_type = /obj/item/ammo_box/magazine/mk43
	can_suppress = TRUE
	can_flashlight = TRUE

/obj/item/gun/projectile/automatic/pistol/sso/update_icon_state()
	icon_state = "[initial(icon_state)][magazine ? "-[magazine.max_ammo]" : ""][chambered ? "" : "-e"][suppressed ? "-suppressed" : ""]"

/obj/item/gun/projectile/automatic/pistol/sso/update_overlays()
	. = list()
	if(gun_light)
		var/flashlight = "mk43_light"
		if(gun_light.on)
			flashlight = "mk43_light-on"
		. += image(icon = icon, icon_state = flashlight, pixel_x = 0)

/obj/item/gun/projectile/automatic/pistol/sso/ui_action_click()
	toggle_gunlight()

//////////////////////////////
// MARK: АПС
//////////////////////////////
/obj/item/gun/projectile/automatic/pistol/sso/aps
	name = "АПС"
	desc = "Автоматический Пистолет АПС. Классика на все года, ещё и автоматический! Использует стандартные патроны 10мм"
	icon = 'modular_ss220/SSO/icons/ussp_APS.dmi'
	icon_state = "aps"
	lefthand_file = 'modular_ss220/SSO/icons/inhands/guns_lefthand.dmi'
	righthand_file = 'modular_ss220/SSO/icons/inhands/guns_righthand.dmi'
	inhand_icon_state = "pistol"
	// fire_sound = 'modular_ss220/SSO/sound/weapons/gunshots/gun_m56d_auto.ogg' //заменить на мариновские МОЩНЫЕ
	// suppressed_sound = 'modular_ss220/SSO/sound/weapons/gunshots/shot_heavy.ogg' //ZAMENIT
	w_class = WEIGHT_CLASS_NORMAL
	mag_type = /obj/item/ammo_box/magazine/aps
	can_suppress = TRUE
	can_flashlight = FALSE
	actions_types = list(/datum/action/item_action/toggle_firemode)
	burst_size = 3
	fire_delay = 1

//////////////////////////////
// MARK: MP7A4
//////////////////////////////
/obj/item/gun/projectile/automatic/pistol/sso/mp7
	name = "MP7A4"
	desc = "Пистолет Пулемёт MP7A4. Не слабая вещь в умелый руках, патрон хоть и маленький, но на мное способный. Использует патроны 4.6x30мм"
	icon = 'modular_ss220/SSO/icons/SOCOM_MP7.dmi'
	icon_state = "mp7"
	lefthand_file = 'modular_ss220/SSO/icons/inhands/guns_lefthand.dmi'
	righthand_file = 'modular_ss220/SSO/icons/inhands/guns_righthand.dmi'
	inhand_icon_state = "mp7"
	fire_sound = 'modular_ss220/SSO/sound/weapons/gunshots/gun_m39.ogg' // подтырено с маринов
	suppressed_sound = 'modular_ss220/SSO/sound/weapons/gunshots/gun_socom_1.ogg' //подтырено с маринов
	w_class = WEIGHT_CLASS_NORMAL
	mag_type = /obj/item/ammo_box/magazine/mp7
	can_suppress = TRUE
	can_flashlight = FALSE
	actions_types = list(/datum/action/item_action/toggle_firemode)
	burst_size = 3
	fire_delay = 1

//////////////////////////////
// MARK: АШ-12
//////////////////////////////
/obj/item/gun/projectile/automatic/ar/sso/ash12
	name = "АШ-12"
	desc = "Автомат Штурмовой АШ-12, оснащён оптическим прицелом, что позволяет стрелять и на дальние дистанции. Использует патроны калибра 12,7х55мм. Злая вещь..."
	icon = 'modular_ss220/SSO/icons/USSP_ASH-12.dmi'
	lefthand_file = 'modular_ss220/SSO/icons/inhands/guns_lefthand.dmi'
	righthand_file = 'modular_ss220/SSO/icons/inhands/guns_righthand.dmi'
	icon_state = "arg"
	inhand_icon_state = "ash12"
	mag_type = /obj/item/ammo_box/magazine/ash12
	fire_sound = 'modular_ss220/SSO/sound/weapons/gunshots/gun_olympia.ogg' // подтырено с маринов
	suppressed_sound = 'modular_ss220/SSO/sound/weapons/gunshots/gun_silenced_shot1.ogg'  // подтырено с маринов
	magin_sound = 'sound/weapons/gun_interactions/batrifle_magin.ogg'
	magout_sound = 'sound/weapons/gun_interactions/batrifle_magout.ogg'
	burst_size = 2
	fire_delay = 1
	execution_speed = 4 SECONDS
	can_suppress = TRUE

//////////////////////////////
// MARK: АН-94 «Абакан»
//////////////////////////////
/obj/item/gun/projectile/automatic/ar/sso/an94
	name = "АН-94"
	desc = "Автомат АН-94 «Абакан», оснащён оптическим прицелом, что позволяет стрелять и на дальние дистанции. Использует патроны калибра 5,45х39мм."
	icon = 'modular_ss220/SSO/icons/USSP_AN94.dmi'
	lefthand_file = 'modular_ss220/SSO/icons/inhands/guns_lefthand.dmi'
	righthand_file = 'modular_ss220/SSO/icons/inhands/guns_righthand.dmi'
	icon_state = "arg"
	inhand_icon_state = "an94"
	mag_type = /obj/item/ammo_box/magazine/ak814
	fire_sound = 'modular_ss220/SSO/sound/weapons/gunshots/gun_ar10.ogg' // переделать
	suppressed_sound = 'modular_ss220/SSO/sound/weapons/gunshots/gun_silenced_shot1.ogg'  // подтырено с маринов
	magin_sound = 'sound/weapons/gun_interactions/batrifle_magin.ogg'
	magout_sound = 'sound/weapons/gun_interactions/batrifle_magout.ogg'
	burst_size = 2
	fire_delay = 1
	execution_speed = 4 SECONDS
	can_suppress = TRUE

//////////////////////////////
// MARK: АН-94 с ГП
//////////////////////////////
/obj/item/gun/projectile/automatic/ar/sso/an94/grenade
	name = "АН-94 c ГП"
	desc = "Автомат АН-94 «Абакан»,оснащённая подствольным гранотомётом ГП-30, а также оптическим прицелом, что позволяет стрелять и на дальние дистанции. Использует патроны калибра 5,45х39мм."
	icon = 'modular_ss220/SSO/icons/USSP_AN94_gren.dmi'
	var/obj/item/gun/projectile/revolver/grenadelauncher/underbarrel

/obj/item/gun/projectile/automatic/ar/sso/an94/grenade/Initialize(mapload)
	. = ..()
	underbarrel = new /obj/item/gun/projectile/revolver/grenadelauncher(src)
	update_icon()

/obj/item/gun/projectile/automatic/ar/sso/an94/grenade/Destroy()
	qdel(underbarrel)
	return ..()

/obj/item/gun/projectile/automatic/ar/sso/an94/grenade/afterattack__legacy__attackchain(atom/target, mob/living/user, flag, params)
	if(select == 2)
		underbarrel.afterattack__legacy__attackchain(target, user, flag, params)
	else
		..()
		return

/obj/item/gun/projectile/automatic/ar/sso/an94/grenade/attackby__legacy__attackchain(obj/item/A, mob/user, params)
	if(istype(A, /obj/item/ammo_casing))
		if(istype(A, underbarrel.magazine.ammo_type))
			underbarrel.attack_self__legacy__attackchain(user)
			underbarrel.attackby__legacy__attackchain(A, user, params)
	else
		return ..()

/obj/item/gun/projectile/automatic/ar/sso/an94/grenade/update_overlays()
	. = ..()
	switch(select)
		if(0)
			. += "[initial(icon_state)]semi"
		if(1)
			. += "[initial(icon_state)]burst"
		if(2)
			. += "[initial(icon_state)]gren"


/obj/item/gun/projectile/automatic/ar/sso/an94/grenade/burst_select()
	var/mob/living/carbon/human/user = usr
	switch(select)
		if(0)
			select = 1
			burst_size = initial(burst_size)
			fire_delay = initial(fire_delay)
			to_chat(user, SPAN_NOTICE("You switch to [burst_size] round burst."))
		if(1)
			select = 2
			to_chat(user, SPAN_NOTICE("You switch to grenades."))
		if(2)
			select = 0
			burst_size = 1
			fire_delay = 0
			to_chat(user, SPAN_NOTICE("You switch to semi-auto."))
	playsound(user, 'sound/weapons/gun_interactions/selector.ogg', 100, 1)
	update_icon()

//////////////////////////////
// MARK: ВСС «Винторез»
//////////////////////////////
/obj/item/gun/projectile/automatic/ar/sso/vss
	name = "ВСС «Винторез»"
	desc = "Знаменитая снайперская винтовка ВСС «Винторез», оснащена оптическим прицелом, что позволяет стрелять на средние дистанции. На дальние хер постреляешь - пуля медленная... Использует патроны калибра 9х39мм."
	icon = 'modular_ss220/SSO/icons/USSP_VSS_VAL.dmi'
	icon_state = "vss"
	inhand_icon_state = "vss"
	mag_type = /obj/item/ammo_box/magazine/vss
	fire_sound = 'modular_ss220/SSO/sound/weapons/gunshots/gun_silenced_shot1.ogg' // переделать
	burst_size = 2
	can_suppress = FALSE
	worn_icon_state = "shotgun"

//////////////////////////////
// MARK: AC ВАЛ
//////////////////////////////
/obj/item/gun/projectile/automatic/ar/sso/vss/val
	name = "АС ВАЛ"
	desc = "Автомат АС ВАЛ, оснащена оптическим прицелом, что позволяет стрелять на средние дистанции. На дальние хер постреляешь - пуля медленная...Использует патроны калибра 9х39мм. И помни про боезапас... он у тебя закончится быстрее, чем ты о нём подумаешь."
	icon = 'modular_ss220/SSO/icons/USSP_VSS_VAL.dmi'
	icon_state = "val"
	inhand_icon_state = "val"
	worn_icon_state = "shotgun_combat"
	burst_size = 3
	can_flashlight = TRUE

/obj/item/gun/projectile/automatic/ar/sso/vss/val/update_overlays()
	. = list()
	if(gun_light)
		var/flashlight = "val_light"
		if(gun_light.on)
			flashlight = "val_light-on"
		. += image(icon = icon, icon_state = flashlight, pixel_x = 0)

/obj/item/gun/projectile/automatic/ar/sso/vss/val/ui_action_click()
	burst_select()
	toggle_gunlight()

//////////////////////////////
// MARK: Magazines
//////////////////////////////

/obj/item/ammo_box/magazine/m42
	name = "магазин M42"
	desc = "Магазин патронов калибра 7,62х51mm."
	icon = 'modular_ss220/SSO/icons/ammo.dmi'
	icon_state = "m42"
	multi_sprite_step = 2
	ammo_type = /obj/item/ammo_casing/mm762x51
	multi_sprite_step = AMMO_BOX_MULTI_SPRITE_STEP_ON_OFF
	max_ammo = 15
	multiload = 0
	caliber = "mm762x51"

/obj/item/ammo_box/magazine/m42/ap
	name = "магазин M42 AP"
	desc = "Магазин бронебойных патронов калибра 7,62х51mm."
	icon_state = "m42AP"
	ammo_type = /obj/item/ammo_casing/mm762x51/ap

/obj/item/ammo_box/magazine/m42/sr
	name = "магазин M42 SR"
	desc = "Магазин сонных патронов калибра 7,62х51mm."
	icon_state = "m42SR"
	ammo_type = /obj/item/ammo_casing/mm762x51/soporific

/obj/item/ammo_box/magazine/svd
	name = "магазин СВД"
	desc = "Магазин винтовки СВД"
	icon = 'modular_ss220/SSO/icons/ammo.dmi'
	icon_state = "svd"
	multi_sprite_step = 2
	ammo_type = /obj/item/ammo_casing/a762
	multi_sprite_step = AMMO_BOX_MULTI_SPRITE_STEP_ON_OFF
	max_ammo = 10
	multiload = 0
	caliber = "a762"

/obj/item/ammo_box/magazine/svd/ap
	name = "магазин СВД БП"
	desc = "Магазин бронебойных патронов для винтовки СВД"
	icon_state = "svdAP"
	ammo_type = /obj/item/ammo_casing/a762/ap

/obj/item/ammo_box/magazine/svd/big
	max_ammo = 20
	icon_state = "svd20"

/obj/item/ammo_box/magazine/svd/big/ap
	name = "магазин СВД БП"
	desc = "Магазин бронебойных патронов для винтовки СВД"
	icon_state = "svd20AP"
	ammo_type = /obj/item/ammo_casing/a762/ap

/obj/item/ammo_box/magazine/m210
	name = "Магазин M210"
	desc = "Магазин патронов калибра .338 Lapua Magnum."
	icon = 'modular_ss220/SSO/icons/ammo.dmi'
	icon_state = "m210"
	multi_sprite_step = 2
	ammo_type = /obj/item/ammo_casing/a338
	multi_sprite_step = AMMO_BOX_MULTI_SPRITE_STEP_ON_OFF
	max_ammo = 10
	slow_loading = TRUE
	caliber = ".338"

/obj/item/ammo_box/magazine/m210/ap
	name = "Магазин M210 - бронебойные"
	desc = "Магазин бронебойных патронов калибра .338 Lapua Magnum."
	icon_state = "m210AP"
	ammo_type = /obj/item/ammo_casing/a338/ap
	caliber = ".338"

/obj/item/ammo_box/magazine/m210/antimatter
	name = "Магазин M210 - антиматериальные"
	desc = "Магазин антиматериальных патронов калибра .338 Lapua Magnum."
	icon_state = "m210AM"
	ammo_type = /obj/item/ammo_casing/a338/antimatter
	caliber = ".338"

/obj/item/ammo_box/magazine/mg_kord
	name = "Пулемётная лента (12,7x108mm)"
	desc = "Пулемётная лента для ДПК КОРД"
	icon = 'modular_ss220/SSO/icons/ammo.dmi'
	icon_state = "KORD"
	w_class = WEIGHT_CLASS_NORMAL
	multi_sprite_step = AMMO_BOX_MULTI_SPRITE_STEP_ON_OFF
	ammo_type = /obj/item/ammo_casing/mm127x108
	caliber = "mm12.7x108"
	max_ammo = 50

/obj/item/ammo_box/magazine/mg_kord/ap
	name = "Пулемётная лента (12,7x108mm БП)"
	desc = "Бронебойная пулемётная лента для ДПК КОРД"
	icon_state = "KORDAP"
	ammo_type = /obj/item/ammo_casing/mm127x108/ap

/obj/item/ammo_box/magazine/mg_sso
	name = "Пулемётная лента (.338LM)"
	desc = "Пулемётная лента для MMG 338"
	icon = 'modular_ss220/SSO/icons/ammo.dmi'
	icon_state = "MMG338"
	w_class = WEIGHT_CLASS_NORMAL
	multi_sprite_step = AMMO_BOX_MULTI_SPRITE_STEP_ON_OFF
	ammo_type = /obj/item/ammo_casing/a338
	caliber = ".338"
	max_ammo = 50

/obj/item/ammo_box/magazine/mg_sso/ap
	name = "Пулемётная лента (.338LM AP)"
	desc = "Пулемётная лента для MMG 338, заряженная бронебойными патронами"
	icon_state = "MMG338AP"
	ammo_type = /obj/item/ammo_casing/a338/ap
	caliber = ".338"
	max_ammo = 50

/obj/item/ammo_box/magazine/mg_sso/antimatter
	name = "Пулемётная лента (.338LM AM)"
	desc = "Пулемётная лента для MMG 338, заряженная антиматериальными патронами... если враг проснулся... то зря он это сделал..."
	icon_state = "MMG338AM"
	ammo_type = /obj/item/ammo_casing/a338/antimatter
	caliber = ".338"
	max_ammo = 50

/obj/item/ammo_box/magazine/mk43
	name = "магазин Mk43"
	desc = "Магазин для пистолета Mk43"
	icon = 'modular_ss220/SSO/icons/ammo.dmi'
	icon_state = "mk43"
	multi_sprite_step = 2
	ammo_type = /obj/item/ammo_casing/c45
	multi_sprite_step = AMMO_BOX_MULTI_SPRITE_STEP_ON_OFF
	multiload = 0
	max_ammo = 15
	caliber = ".45"

/obj/item/ammo_box/magazine/aps
	name = "Магазин АПС (10mm)"
	desc = "Магазин для пистолета АПС"
	icon = 'modular_ss220/SSO/icons/ammo.dmi'
	icon_state = "aps"
	ammo_type = /obj/item/ammo_casing/c10mm
	caliber = "10mm"
	max_ammo = 20
	multi_sprite_step = AMMO_BOX_MULTI_SPRITE_STEP_ON_OFF

/obj/item/ammo_box/magazine/aps/fire
	name = "Магазин АПС (10mm ПЗ)"
	desc = "Магазин для пистолета АПС, заряженный зажигательными"
	icon_state = "aps"
	ammo_type = /obj/item/ammo_casing/c10mm/fire

/obj/item/ammo_box/magazine/aps/hp
	name = "Магазин АПС (10mm ПЭ)"
	desc = "Магазин для пистолета АПС, заряженный экспансивными"
	icon_state = "apsHP"
	ammo_type = /obj/item/ammo_casing/c10mm/hp

/obj/item/ammo_box/magazine/aps/ap
	name = "Магазин АПС (10mm БП)"
	desc = "Магазин для пистолета АПС, заряженный бронебойными"
	icon_state = "apsAP"
	ammo_type = /obj/item/ammo_casing/c10mm/ap

/obj/item/ammo_box/magazine/mp7
	name = "Магазин MP7"
	desc = "Магазин для ПП MP7A4"
	icon = 'modular_ss220/SSO/icons/ammo.dmi'
	icon_state = "mp7"
	ammo_type = /obj/item/ammo_casing/c46x30mm
	caliber = "4.6x30mm"
	max_ammo = 20
	multi_sprite_step = AMMO_BOX_MULTI_SPRITE_STEP_ON_OFF

/obj/item/ammo_box/magazine/mp7/ap
	name = "Магазин MP7 AP"
	desc = "Магазин для ПП MP7A4, заряженный бронебойными."
	icon_state = "mp7AP"
	ammo_type = /obj/item/ammo_casing/c46x30mm/ap

/obj/item/ammo_box/magazine/mp7/big
	icon_state = "mp7-40"
	max_ammo = 40

/obj/item/ammo_box/magazine/mp7/big/ap
	name = "Магазин MP7 AP"
	desc = "Магазин для ПП MP7A4, заряженный бронебойными."
	icon_state = "mp7-40AP"
	ammo_type = /obj/item/ammo_casing/c46x30mm/ap

/obj/item/ammo_box/magazine/ash12
	name = "магазин АШ-12"
	desc = "Магазин для автомата АШ-12."
	icon = 'modular_ss220/SSO/icons/ammo.dmi'
	icon_state = "ash12-20"
	ammo_type = /obj/item/ammo_casing/mm127
	multi_sprite_step = AMMO_BOX_MULTI_SPRITE_STEP_ON_OFF
	max_ammo = 20
	slow_loading = TRUE
	caliber = "127mm"

/obj/item/ammo_box/magazine/ash12/ten
	max_ammo = 10
	icon_state = "ash12-10"

/obj/item/ammo_box/magazine/ak814
	name = "Автоматный магазин АК"
	desc = "Магазин для автоматов типа АК."
	icon = 'modular_ss220/SSO/icons/ammo.dmi'
	icon_state = "AK"

/obj/item/ammo_box/magazine/vss
	name = "магазин ВСС"
	desc = "Магазин для ВСС"
	icon = 'modular_ss220/SSO/icons/ammo.dmi'
	icon_state = "vss"
	ammo_type = /obj/item/ammo_casing/mm9x39
	multi_sprite_step = AMMO_BOX_MULTI_SPRITE_STEP_ON_OFF
	multiload = 0
	max_ammo = 10
	caliber = "mm9x39"

/obj/item/ammo_box/magazine/vss/val
	name = "магазин АС ВАЛ"
	desc = "Магазин для АС ВАЛ"
	icon = 'modular_ss220/SSO/icons/ammo.dmi'
	icon_state = "val"
	ammo_type = /obj/item/ammo_casing/mm9x39
	max_ammo = 20

/obj/item/ammo_box/magazine/ksv
	name = "Магазин КСВ-А"
	desc = "Магазин для винтовки КСВ-А"
	icon = 'modular_ss220/SSO/icons/ammo.dmi'
	icon_state = "ksv"
	multi_sprite_step = AMMO_BOX_MULTI_SPRITE_STEP_ON_OFF
	ammo_type = /obj/item/ammo_casing/mm127x108
	caliber = "mm12.7x108"
	slow_loading = TRUE
	max_ammo = 5

/obj/item/ammo_box/magazine/ksv/ap
	name = "Магазин КСВ-А БП"
	desc = "Магазин бронебойных патронов для винтовки КСВ-А"
	icon_state = "ksvAP"
	ammo_type = /obj/item/ammo_casing/mm127x108/ap

/obj/item/ammo_box/magazine/svdk
	name = "Магазин СВДК"
	desc = "Магазин для винтовки СВДК"
	icon = 'modular_ss220/SSO/icons/ammo.dmi'
	icon_state = "svdk"
	multi_sprite_step = AMMO_BOX_MULTI_SPRITE_STEP_ON_OFF
	ammo_type = /obj/item/ammo_casing/mm93x64
	caliber = "mm9.3x64"
	slow_loading = TRUE
	max_ammo = 10

/obj/item/ammo_box/magazine/svdk/ap
	name = "Магазин БП СВДК "
	desc = "Магазин бронебойных патронов для винтовки СВДК"
	icon_state = "svdkAP"
	ammo_type = /obj/item/ammo_casing/mm93x64/ap

/obj/item/ammo_box/magazine/mg_pkp
	name = "Пулемётная лента (7.62x54mm)"
	desc = "Пулемётная лента для ПКП «Печенег»"
	icon = 'modular_ss220/SSO/icons/ammo.dmi'
	icon_state = "pkp"
	w_class = WEIGHT_CLASS_NORMAL
	multi_sprite_step = AMMO_BOX_MULTI_SPRITE_STEP_ON_OFF
	ammo_type = /obj/item/ammo_casing/a762
	caliber = "a762"
	max_ammo = 100

/obj/item/ammo_box/magazine/mg_pkp/ap
	name = "Пулемётная лента (7.62x54mm БП)"
	desc = "Бронебойная пулемётная лента для ПКП «Печенег»"
	icon_state = "pkpAP"
	multi_sprite_step = AMMO_BOX_MULTI_SPRITE_STEP_ON_OFF
	ammo_type = /obj/item/ammo_casing/a762/ap
//////////////////////////////
// MARK: Ammo BOX
//////////////////////////////

/obj/item/ammo_box/box_mm762
	name = "ammo box (7.62x51)"
	desc = "Contains up to 100 7.62x51mm cartridges."
	w_class = WEIGHT_CLASS_BULKY
	ammo_type = /obj/item/ammo_casing/mm762x51
	max_ammo = 100
	icon = 'modular_ss220/SSO/icons/ammo.dmi'
	icon_state = "mm762_box"

/obj/item/ammo_box/box_mm762/ap
	ammo_type = /obj/item/ammo_casing/mm762x51/ap
	name = "ammo box (7.62x51AP)"
	desc = "Contains up to 100 7.62x51mm AP cartridges."
	icon_state = "mm762AP_box"

/obj/item/ammo_box/box_a338
	name = "ammo box (.338LM)"
	desc = "Contains up to 100 .338 cartridges."
	w_class = WEIGHT_CLASS_BULKY
	ammo_type = /obj/item/ammo_casing/a338
	max_ammo = 100
	icon = 'modular_ss220/SSO/icons/ammo.dmi'
	icon_state = "338LM_box"

/obj/item/ammo_box/box_a338/ap
	name = "ammo box (.338LM AP)"
	desc = "Contains up to 100 .338 AP cartridges."
	ammo_type = /obj/item/ammo_casing/a338/ap
	icon_state = "338LM-AP_box"

/obj/item/ammo_box/box_a338/antimatter
	name = "ammo box (.338LM Antimatter)"
	desc = "Contains up to 100 .338 Antimatter cartridges."
	ammo_type = /obj/item/ammo_casing/a338/antimatter
	icon_state = "338LM-AM_box"

/obj/item/ammo_box/box_mm127x108
	name = "ammo box (12,7x108mm)"
	desc = "Contains up to 100 12,7x108mm  cartridges."
	w_class = WEIGHT_CLASS_BULKY
	ammo_type = /obj/item/ammo_casing/mm127x108
	icon = 'modular_ss220/SSO/icons/ammo.dmi'
	icon_state = "127x108_box"

/obj/item/ammo_box/box_mm127x108/ap
	name = "ammo box (12,7x108mm БП)"
	desc = "Contains up to 100 12,7x108mm БП cartridges."
	ammo_type = /obj/item/ammo_casing/mm127x108/ap
	icon_state = "127x108AP_box"

/obj/item/ammo_box/box_mm9x39
	name = "ammo box (9x39)"
	desc = "Contains up to 100 9x39mm cartridges."
	w_class = WEIGHT_CLASS_BULKY
	ammo_type = /obj/item/ammo_casing/mm9x39
	max_ammo = 100
	icon = 'modular_ss220/SSO/icons/ammo.dmi'
	icon_state = "mm9x39_box"

/obj/item/ammo_box/box_mm93x64
	name = "ammo box (9.3x64)"
	desc = "Contains up to 100 9.3x64mm cartridges."
	w_class = WEIGHT_CLASS_BULKY
	ammo_type = /obj/item/ammo_casing/mm93x64
	max_ammo = 100
	icon = 'modular_ss220/SSO/icons/ammo.dmi'
	icon_state = "mm9.3x64_box"

/obj/item/ammo_box/box_mm93x64/ap
	name = "ammo box (9.3x64 БП)"
	desc = "Содержит в себе 100 БП патронов калибра 9,3x64."
	ammo_type = /obj/item/ammo_casing/mm93x64/ap
	icon_state = "mm9.3x64AP_box"

/obj/item/ammo_box/box_a762
	name = "ammo box (7.62x54)"
	desc = "Contains up to 100 7.62x54mm cartridges."
	w_class = WEIGHT_CLASS_BULKY
	ammo_type = /obj/item/ammo_casing/a762
	max_ammo = 100
	icon = 'modular_ss220/SSO/icons/ammo.dmi'
	icon_state = "a762_box"

/obj/item/ammo_box/box_a762/ap
	name = "ammo box (7.62x54 БП)"
	desc = "Contains up to 100 7.62x54 БП cartridges."
	ammo_type = /obj/item/ammo_casing/a762/ap
	icon_state = "a762AP_box"

//////////////////////////////
// MARK: ammo_casing
//////////////////////////////

//переспрайт
/obj/item/ammo_casing/mm762x51
	name = "7,62x51 round"
	desc = "Патрон 7,62х51, используемый в марксманских винтовках и пулемётах."
	icon = 'modular_ss220/SSO/icons/ammo.dmi'
	icon_state = "casing762mm"

/obj/item/ammo_casing/mm762x51/ap
	icon_state = "casing762mmAP"

/obj/item/ammo_casing/mm762x51/bleeding
	icon_state = "casing762mm"

/obj/item/ammo_casing/mm762x51/hollow
	icon_state = "casing762mm"

/obj/item/ammo_casing/mm762x51/incen
	icon_state = "casing762mm"
///////
/obj/item/ammo_casing/mm762x51/soporific
	name = "7,62x51 Сонный патрон"
	desc = "Патрон 7,62х51, используемый для усыпления цели."
	icon_state = "casing762mmSR"
	projectile_type = /obj/projectile/bullet/sniper/soporific
	harmful = FALSE

/obj/item/ammo_casing/a762/ap
	name = "7,62 БП"
	desc = "Бронебойный патрон 7,62."
	caliber = "a762"
	icon = 'modular_ss220/SSO/icons/ammo.dmi'
	icon_state = "casinga762AP"
	projectile_type = /obj/projectile/bullet/a762/ap

/obj/item/ammo_casing/a338
	name = ".338 LM round"
	desc = "A .338 Lapua Magnum bullet casing."
	caliber = ".338"
	icon = 'modular_ss220/SSO/icons/ammo.dmi'
	icon_state = "casing338LM"
	projectile_type = /obj/projectile/bullet/a338
	muzzle_flash_strength = MUZZLE_FLASH_RANGE_STRONG
	muzzle_flash_range = MUZZLE_FLASH_RANGE_STRONG

/obj/item/ammo_casing/a338/ap
	name = ".338 LM AP round"
	desc = "A .338 Lapua Magnum AP bullet casing."
	caliber = ".338"
	icon_state = "casing338LMAP"
	projectile_type = /obj/projectile/bullet/a338/ap

/obj/item/ammo_casing/a338/antimatter
	name = ".338 LM Antimatter round"
	desc = "A .338 Lapua Magnum AP bullet casing."
	caliber = ".338"
	icon_state = "casing338LMAM"
	projectile_type = /obj/projectile/bullet/a338/antimatter

/obj/item/ammo_casing/mm127x108
	name = "127x108 round"
	desc = "Патрон 12,7х108мм"
	caliber = "mm12.7x108"
	icon = 'modular_ss220/SSO/icons/ammo.dmi'
	icon_state = "casing127x108"
	projectile_type = /obj/projectile/bullet/mm127x108

/obj/item/ammo_casing/mm127x108/ap
	name = "127x108 БП round"
	desc = "Бронебойный патрон 12,7х108мм"
	icon_state = "casing127x108AP"
	projectile_type = /obj/projectile/bullet/mm127x108/ap

/obj/item/ammo_casing/mm9x39
	name = "9х39 round"
	desc = "A 9х39 bullet casing."
	caliber = "mm9x39"
	icon = 'modular_ss220/SSO/icons/ammo.dmi'
	icon_state = "casingmm9x39"
	projectile_type = /obj/projectile/bullet/mm9x39
	muzzle_flash_strength = MUZZLE_FLASH_RANGE_STRONG
	muzzle_flash_range = MUZZLE_FLASH_RANGE_STRONG

/obj/item/ammo_casing/mm93x64
	name = "9.3x64 round"
	desc = "A 9.3x64 bullet casing."
	caliber = "mm9.3x64"
	icon = 'modular_ss220/SSO/icons/ammo.dmi'
	icon_state = "casingmm9.3x64"
	projectile_type = /obj/projectile/bullet/mm93x64
	muzzle_flash_strength = MUZZLE_FLASH_RANGE_STRONG
	muzzle_flash_range = MUZZLE_FLASH_RANGE_STRONG

/obj/item/ammo_casing/mm93x64/ap
	name = "9.3x64 БП round"
	desc = "A 9.3x64 БП bullet casing."
	icon_state = "casingmm9.3x64AP"
	projectile_type = /obj/projectile/bullet/mm93x64/ap

//////////////////////////////
//  MARK: bullet
//////////////////////////////

//obj/projectile/bullet/mm762
	//name = "7.62mm bullet"
	//icon_state = "bullet"
	//damage = 60
	//damage_type = BRUTE
	//flag = "bullet"
	//hitsound_wall = "ricochet"
	//impact_effect_type = /obj/effect/temp_visual/impact_effect

/obj/projectile/bullet/a338
	name = "338LM bullet"
	icon_state = "bullet"
	damage = 100
	armor_penetration_flat = 70
	weaken = 10 SECONDS
	damage_type = BRUTE
	flag = "bullet"
	hitsound_wall = "ricochet"
	impact_effect_type = /obj/effect/temp_visual/impact_effect

/obj/projectile/bullet/a338/ap
	name = "338LM AP bullet"
	damage = 100
	armor_penetration_flat = 100
	weaken = 0
	forcedodge = -1
	damage_type = BRUTE
	pass_flags = PASSTABLE //damage glass

/obj/projectile/bullet/a338/antimatter
	name = "338LM antimatter bullet"
	dismemberment = 100

/obj/projectile/bullet/mm127x108
	name = "12.7 bullet"
	icon_state = "bullet"
	damage = 110
	dismemberment = 70
	armor_penetration_flat = 100
	weaken = 10 SECONDS
	damage_type = BRUTE
	flag = "bullet"
	hitsound_wall = "ricochet"
	impact_effect_type = /obj/effect/temp_visual/impact_effect

/obj/projectile/bullet/mm127x108/ap
	name = "12.7 AP bullet"
	weaken = 10 SECONDS
	forcedodge = -1
	pass_flags = PASSTABLE

/obj/projectile/bullet/mm9x39
	name = "9mm bullet"
	icon_state = "bullet"
	damage = 60
	armor_penetration_flat = 30
	weaken = 1 SECONDS
	damage_type = BRUTE
	flag = "bullet"
	hitsound_wall = "ricochet"
	impact_effect_type = /obj/effect/temp_visual/impact_effect

/obj/projectile/bullet/mm93x64
	name = "9.3mm bullet"
	icon_state = "bullet"
	damage = 80
	armor_penetration_flat = 60
	damage_type = BRUTE
	flag = "bullet"
	hitsound_wall = "ricochet"
	impact_effect_type = /obj/effect/temp_visual/impact_effect

/obj/projectile/bullet/mm93x64/ap
	armor_penetration_flat = 100
	damage = 80

/obj/projectile/bullet/a762/ap
	name = "7.62mm AP bullet"
	icon_state = "bullet"
	damage = 50
	armor_penetration_flat = 40
	damage_type = BRUTE
	flag = "bullet"
	hitsound_wall = "ricochet"
	impact_effect_type = /obj/effect/temp_visual/impact_effect
