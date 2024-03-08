/obj/item/seeds/soya/peas_shooter
	name = "pack of peas shooter seeds"
	desc = "Эти семена прорастают в горохострела"
	icon = 'modular_ss220/peas_shooter/icons/seeds/seed_soybean.dmi'
	icon_state = "seed-soybean"
	species = "peas shooter"
	plantname = "Peas Shooter Plants"
	growthstages = 4
	growing_icon = 'modular_ss220/peas_shooter/icons/plant/growing.dmi'
	icon_harvest = "peas_shooter-grow4"
	icon_grow = "peas_shooter-grow"
	icon_dead = "peas_shooter-dead"
	product = /obj/item/gun/projectile/revolver/peas_shooter
	rarity = 20
	reagents_add = list("plantmatter" = 0.2, "vitamin" = 0.4)
	mutatelist = list()
	potency = 20
	yield = 1
	production = 10
	genes = list()

/obj/item/seeds/soya/Initialize(mapload)
	. = ..()
	mutatelist |= list(/obj/item/seeds/soya/peas_shooter)

/obj/item/food/snacks/grown/soybeans/Initialize(mapload)
	. = ..()
	trash += /obj/item/ammo_casing/peas_shooter

/obj/item/food/snacks/grown/soybeans/attack_self(mob/user)
	. = ..()
	if(!do_after(user, 1.5 SECONDS, target = user))
		return
	user.unEquip(src)
	if(trash)
		var/obj/item/T = generate_trash()
		user.put_in_hands(T)
		to_chat(user, "<span class='notice'>You open [src]\'s shell, revealing \a [T].</span>")
	qdel(src)
