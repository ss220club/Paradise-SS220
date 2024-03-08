/obj/item/gun/projectile/revolver/peas_shooter
	name = "Peas shooter"
	desc = "A living pea! Can shoot peas, does minor stamina damage and forces brainrotting!"
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
	desc = "A bullet from pea, can't do any coherent damage and forces some brainrotting"
	projectile_type = /obj/item/projectile/bullet/midbullet_r/peas_shooter
	icon_state = "peashooter_bullet"

/obj/item/projectile/bullet/midbullet_r/peas_shooter
	icon = 'modular_ss220/peas_shooter/icons/items/peas_shooter.dmi'
	item_state = "peashooter_bullet"
	stamina = 5
	damage_type = STAMINA

/obj/item/projectile/bullet/midbullet_r/peas_shooter/on_hit(mob/H)
	. = ..()
	if(prob(30))
		var/peas_talk = pick("Только не туда", "пацаны, я горошину ловлю", "хлоп-хлоп", "Это не суп", "МАГИСТРААААТ", "Я тучка-тучка", "Только не мартышки!")
		H.say(peas_talk)
	if(prob(30))
		H.emote("scream")

/datum/chemical_reaction/peas_bullet
	name = "Peas bullet creation"
	id = "pea_bullet_create"
	result = null
	required_reagents = list("soybeanoil" = 5, "ammonia" = 5, "aluminum" = 5)
	result_amount = 3

/datum/chemical_reaction/peas_bullet/on_reaction(datum/reagents/holder, created_volume)
	. = ..()
	var/loc = get_turf(holder.my_atom)
	for(var/i in 1 to created_volume)
		new /obj/item/ammo_casing/peas_shooter(loc)

