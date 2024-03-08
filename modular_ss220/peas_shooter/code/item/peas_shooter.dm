/obj/item/gun/projectile/revolver/peas_shooter
	name = "Peas shooter"
	desc = "Живой горох! Может стрелять горошинами, которые наносят слабый стамина урон и вызывают брейнрот"
	icon = 'modular_ss220/peas_shooter/icons/items/peas_shooter.dmi'
	icon_state = "peas_shooter"
	lefthand_file = 'modular_ss220/peas_shooter/icons/inhands/peasshooter_lefthand.dmi'
	righthand_file = 'modular_ss220/peas_shooter/icons/inhands/peasshooter_righthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	mag_type = /obj/item/ammo_box/magazine/peas_shooter

/obj/item/ammo_box/magazine/peas_shooter
	name = "peacock shooter magazine"
	desc = "peacocker's mags for cockers"
	ammo_type = /obj/item/ammo_casing/peas_shooter
	max_ammo = 6

/obj/item/ammo_casing/peas_shooter
	name = "pea bullet"
	desc = "Пуля из гороха, не может нанести какого-либо ощутимого урона, вызывает брейнрот"
	projectile_type = /obj/item/projectile/bullet/midbullet_r/peas_shooter
	icon_state = "peashooter_bullet"

/obj/item/projectile/bullet/midbullet_r/peas_shooter
	icon = 'modular_ss220/peas_shooter/icons/items/peas_shooter.dmi'
	item_state = "peashooter_bullet"
	stamina = 5
	damage_type = STAMINA

/obj/item/projectile/bullet/midbullet_r/peas_shooter/on_hit(mob/H)
	. = ..()
	if(prob(5))
		var/peas_talk = pick("Горошину поймал!",)
		H.say(peas_talk)
	if(prob(30))
		H.emote("scream")
