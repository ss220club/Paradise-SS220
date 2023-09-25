/* Stuff & misc */

//Trees
/obj/structure/flora/tree/great_tree
	name = "great tree"
	desc = "A colossal tree with the carved face of some deity."
	icon = 'modular_ss220/maps220/icons/trees.dmi'
	icon_state = "great_tree"

//Crates
//Wooden crates
/obj/structure/closet/crate/wooden
	icon = 'modular_ss220/maps220/icons/crates.dmi'
	open_sound = 'sound/machines/wooden_closet_open.ogg'
	close_sound = 'sound/machines/wooden_closet_close.ogg'

/obj/structure/closet/crate/wooden/wooden_crate
	name = "wooden crate"
	desc = "A wooden crate."
	icon_state = "wooden"
	icon_opened = "wooden_open"
	icon_closed = "wooden"

/obj/structure/closet/crate/wooden/barrel
	name = "wooden barrel"
	desc = "A wooden barrel."
	icon_state = "crate_barrel"
	icon_opened = "crate_barrel_open"
	icon_closed = "crate_barrel"

/* Syndicate Base - Mothership */
// Machinery
/obj/machinery/photocopier/syndie
	name = "Syndicate photocopier"
	desc = "They don't even try to hide it's theirs..."
	icon = 'modular_ss220/maps220/icons/machinery.dmi'
	icon_state = "syndiebigscanner"
	insert_anim = "syndiebigscanner1"

// Structure
/obj/structure/chair/comfy/shuttle/dark
	icon = 'modular_ss220/maps220/icons/chairs.dmi'
	icon_state = "shuttle_chair_dark"

/obj/structure/chair/comfy/shuttle/dark/GetArmrest()
	return mutable_appearance('modular_ss220/maps220/icons/chairs.dmi', "shuttle_chair_dark_armrest")

// Mecha
/obj/mecha/combat/durand/rover
	desc = "Combat exosuit, developed by syndicate from the Durand Mk. II by scraping unnecessary things, and adding some of their tech. Much more protected from any Nanotrasen hazards."
	name = "Rover"
	icon = 'modular_ss220/maps220/icons/mecha.dmi'
	icon_state = "darkdurand"
	initial_icon = "darkdurand"
	armor = list(melee = 30, bullet = 40, laser = 50, energy = 50, bomb = 20, rad = 50, fire = 100, acid = 100)
	operation_req_access = list(ACCESS_SYNDICATE)
	wreckage = /obj/structure/mecha_wreckage/durand/rover
	max_equip = 4
	internal_damage_threshold = 35
	starting_voice = /obj/item/mecha_modkit/voice/syndicate
	destruction_sleep_duration = 1

/obj/mecha/combat/durand/rover/GrantActions(mob/living/user, human_occupant = 0)
	..()
	thrusters_action.Grant(user, src)
	energywall_action.Grant(user, src)

/obj/mecha/combat/durand/rover/RemoveActions(mob/living/user, human_occupant = 0)
	..()
	thrusters_action.Remove(user)
	energywall_action.Remove(user)

/obj/mecha/combat/durand/rover/loaded/Initialize(mapload)
	. = ..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg/syndi
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/repair_droid
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/antiproj_armor_booster
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/ionshotgun
	ME.attach(src)

/obj/mecha/combat/durand/rover/loaded/add_cell()
	cell = new /obj/item/stock_parts/cell/bluespace(src)
