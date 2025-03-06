/obj/machinery/economy/vending/nta
	name = "NT Ammunition"
	desc = "A special equipment vendor."
	ads_list = list("Возьми патрон!","Не забывай, снаряжаться - полезно!","Бжж-Бзз-з!.","Обезопасить, удержать, сохранить!","Стоять, снарядись на задание!")
	icon = 'modular_ss220/vending/icons/vending.dmi'
	icon_state = "nta"
	icon_deny = "nta_deny"
	icon_vend = "nta_vend"
	req_access = list(ACCESS_CENT_SECURITY)
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	refill_canister = /obj/item/vending_refill/nta
	products = list(
		/obj/item/grenade/barrier/dropwall = 10,
		/obj/item/flashlight/seclite = 10,
		/obj/item/restraints/legcuffs/bola/energy = 10,
		/obj/item/ammo_box/magazine/laser = 10,
		/obj/item/ammo_box/magazine/beretta/mm919 = 10,
		/obj/item/ammo_box/magazine/beretta/mmap919 = 10,
		/obj/item/ammo_box/magazine/beretta/mmbsp919 = 10,
		/obj/item/ammo_box/magazine/wt550m9/wtap = 10,
		/obj/item/ammo_box/magazine/wt550m9/wtic = 10,
		/obj/item/ammo_box/magazine/wt550m9/wttx = 10,
		/obj/item/ammo_box/magazine/enforcer = 10,
		/obj/item/ammo_box/magazine/smgm9mm/ap = 10,
		/obj/item/ammo_box/magazine/smgm9mm/fire = 10,
		/obj/item/ammo_box/magazine/smgm9mm/toxin = 10,
		/obj/item/ammo_box/magazine/m556/arg = 10,
		/obj/item/ammo_box/magazine/m556 = 10,
		/obj/item/ammo_box/a40mm = 5,
	)

/obj/machinery/economy/vending/nta/admin/Initialize(mapload)
	products = list()
	var/list/new_products = list() + subtypesof(/obj/item/ammo_box) + /obj/item/storage/fancy/shell/rubbershot +\
	/obj/item/storage/fancy/shell/buck + /obj/item/storage/fancy/shell/dragonsbreath + /obj/item/storage/fancy/shell/holy +\
	/obj/item/storage/fancy/shell/rubbershot + /obj/item/storage/fancy/shell/slug + /obj/item/storage/fancy/shell/stun +\
	/obj/item/storage/fancy/shell/tranquilizer - /obj/item/ammo_box/magazine - typesof(/obj/item/ammo_box/magazine/internal)
	for(var/ammo_type in new_products)
		products[ammo_type] = 999
	. = ..()

/obj/machinery/economy/vending/nta/blue
	name = "NT ERT Medium Gear & Ammunition"
	desc = "A ERT Medium equipment vendor."
	ads_list = list("Круши черепа синдиката!","Не забывай, спасать - полезно!","Бжж-Бзз-з!.","Обезопасить, удержать, сохранить!","Стоять, снарядись на задание!")
	products = list(
		/obj/item/gun/energy/gun/blueshield/pdw9 = 5,
		/obj/item/gun/energy/arc_revolver = 5,
		/obj/item/gun/energy/plasma_pistol = 5,
		/obj/item/gun/energy/sparker = 5,
		/obj/item/gun/projectile/automatic/pistol/beretta = 5,
		/obj/item/ammo_box/magazine/beretta = 10,
		/obj/item/gun/energy/temperature = 5,
		/obj/item/gun/energy/ionrifle/carbine = 5,
		/obj/item/gun/energy/immolator = 5,
		/obj/item/gun/projectile/automatic/lasercarbine = 5,
		/obj/item/ammo_box/magazine/laser/ert = 10,
		/obj/item/gun/projectile/automatic/wt550 = 5,
		/obj/item/ammo_box/magazine/wt550m9 = 10,
		/obj/item/gun/projectile/shotgun/automatic/combat = 5,
		/obj/item/storage/fancy/shell/holy = 5,
		/obj/item/storage/fancy/shell/dragonsbreath = 5,
		/obj/item/grenade/plastic/c4/x4 = 5,
	)

/obj/machinery/economy/vending/nta/red
	name = "NT ERT Heavy Gear & Ammunition"
	desc = "A ERT Heavy equipment vendor."
	ads_list = list("Круши черепа синдиката!","Не забывай, спасать - полезно!","Бжж-Бзз-з!.","Обезопасить, удержать, сохранить!","Стоять, снарядись на задание!")
	products = list(
		/obj/item/gun/energy/disabler/silencer = 5,
		/obj/item/gun/projectile/automatic/pistol/enforcer = 5,
		/obj/item/ammo_box/magazine/enforcer/lethal = 10,
		/obj/item/gun/energy/gun/nuclear = 5,
		/obj/item/gun/energy/xray = 5,
		/obj/item/gun/energy/lwap = 5,
		/obj/item/gun/energy/lasercannon = 5,
		/obj/item/gun/energy/immolator/multi = 5,
		/obj/item/gun/projectile/automatic/proto = 5,
		/obj/item/ammo_box/magazine/smgm9mm = 10,
		/obj/item/gun/projectile/automatic/shotgun/bulldog = 5,
		/obj/item/ammo_box/magazine/m12g = 5,
		/obj/item/storage/firstaid/tactical = 5,
		/obj/item/storage/lockbox/t4 = 5,
		/obj/item/grenade/frag = 5,
		/obj/item/suppressor = 5,
	)

/obj/machinery/economy/vending/nta/green
	name = "NT ERT Light Gear & Ammunition"
	desc = "A ERT Light equipment vendor."
	ads_list = list("Круши черепа синдиката!","Не забывай, спасать - полезно!","Бжж-Бзз-з!.","Обезопасить, удержать, сохранить!","Стоять, снарядись на задание!")
	products = list(
		/obj/item/gun/energy/disabler/smg = 5,
		/obj/item/gun/energy/disabler = 5,
		/obj/item/gun/energy/gun/mini = 5,
		/obj/item/gun/energy/gun = 5,
		/obj/item/gun/energy/laser = 5,
		/obj/item/gun/projectile/shotgun/riot = 5,
		/obj/item/storage/fancy/shell/rubbershot = 5,
		/obj/item/storage/fancy/shell/beanbag = 5,
		/obj/item/storage/fancy/shell/tranquilizer = 5,
		/obj/item/ammo_box/magazine/sslr = 10,
	)

/obj/machinery/economy/vending/nta/yellow
	name = "NT ERT Death Wish Gear & Ammunition"
	desc = "A ERT Death Wish equipment vendor."
	ads_list = list("Круши черепа ВСЕХ!","Не забывай, УБИВАТЬ - полезно!","УБИВАТЬ УБИВАТЬ УБИВАТЬ УБИВАТЬ!.","УБИВАТЬ, удержать, УБИВАТЬ!","Стоять, снарядись на УБИВАТЬ!")
	products = list(
		/obj/item/gun/projectile/automatic/gyropistol = 10,
		/obj/item/ammo_box/magazine/m75 = 20,
		/obj/item/gun/projectile/automatic/l6_saw = 10,
		/obj/item/ammo_box/magazine/mm762x51 = 20,
		/obj/item/ammo_box/magazine/mm762x51/incen = 20,
		/obj/item/ammo_box/magazine/mm762x51/ap = 20,
		/obj/item/ammo_box/magazine/mm762x51/hollow = 20,
		/obj/item/ammo_box/magazine/mm762x51/bleeding = 20,
		/obj/item/gun/projectile/automatic/sniper_rifle = 10,
		/obj/item/ammo_box/magazine/sniper_rounds = 20,
		/obj/item/ammo_box/magazine/sniper_rounds/antimatter = 20,
		/obj/item/ammo_box/magazine/sniper_rounds/soporific = 20,
		/obj/item/ammo_box/magazine/sniper_rounds/haemorrhage = 20,
		/obj/item/ammo_box/magazine/sniper_rounds/penetrator = 20,
		/obj/item/gun/energy/pulse/destroyer/annihilator = 10,
		/obj/item/gun/energy/bsg/prebuilt/admin = 10,
		/obj/item/grenade/clusterbuster/inferno = 10,
		/obj/item/grenade/clusterbuster/emp = 10,
	)

/obj/machinery/economy/vending/nta/medical
	name = "NT ERT Medical Gear"
	desc = "A ERT medical equipment vendor."
	ads_list = list("Лечи раненых от рук синдиката!","Не забывай, лечить - полезно!","Бжж-Бзз-з!.","Перевязать, оперировать, выписать!","Стоять, снарядись медикаментами на задание!")
	products = list(
		/obj/item/storage/firstaid/regular/doctor = 5,
		/obj/item/storage/firstaid/adv = 5,
		/obj/item/healthanalyzer/advanced = 5,
		/obj/item/storage/pill_bottle/patch_pack = 5,
		/obj/item/reagent_containers/patch/silver_sulf = 10,
		/obj/item/reagent_containers/patch/styptic = 10,
		/obj/item/reagent_containers/iv_bag/salglu = 5,
		/obj/item/storage/pill_bottle = 5,
		/obj/item/reagent_containers/pill/mannitol = 10,
		/obj/item/reagent_containers/pill/salbutamol = 10,
		/obj/item/reagent_containers/pill/charcoal = 10,
		/obj/item/reagent_containers/pill/mutadone = 10,
		/obj/item/reagent_containers/pill/hydrocodone = 10,
		/obj/item/storage/firstaid/surgery = 5,
		/obj/item/scalpel/laser = 5,
		/obj/item/roller/holo = 5,
		/obj/item/reagent_containers/iv_bag/blood/o_minus = 10,
		/obj/item/reagent_containers/iv_bag/blood/vox = 3,
		/obj/item/reagent_containers/iv_bag/slime = 3,
	)

/obj/machinery/economy/vending/nta/engineer
	name = "NT ERT Engineer Gear"
	desc = "A ERT engineering equipment vendor."
	ads_list = list("Чини станцию от рук синдиката!","Не забывай, чинить - полезно!","Бжж-Бзз-з!.","Починить, заварить, трубить!","Стоять, снарядись на починку труб!")
	products = list(
		/obj/item/storage/belt/utility/chief/full = 2,
		/obj/item/clothing/mask/gas/welding = 3,
		/obj/item/weldingtool/experimental = 3,
		/obj/item/crowbar/power = 3,
		/obj/item/screwdriver/power  = 3,
		/obj/item/extinguisher/mini = 3,
		/obj/item/multitool = 3,
		/obj/item/rcd/preloaded = 2,
		/obj/item/rcd_ammo/large = 6,
		/obj/item/stack/cable_coil = 5,
	)

/obj/machinery/economy/vending/nta/janitor
	name = "NT ERT Janitor Gear"
	desc = "A ERT cleaning equipment vendor."
	ads_list = list("Чисть станцию от рук синдиката!","Не забывай, чистить - полезно!","Вилкой чисти!.","Помыть, постирать, оттереть!","Стоять, снарядись клинерами!")
	products = list(
		/obj/item/storage/belt/janitor/full = 5,
		/obj/item/mop/advanced = 5,
		/obj/item/clothing/shoes/galoshes = 5,
		/obj/item/grenade/chem_grenade/antiweed = 5,
		/obj/item/reagent_containers/spray/cleaner/advanced = 5,
		/obj/item/melee/flyswatter = 5,
		/obj/item/clothing/mask/gas = 5,
		/obj/item/watertank/janitor  = 5,
		/obj/item/lightreplacer/bluespace = 5,
		/obj/item/storage/box/lights/mixed = 5,
	)

/obj/machinery/economy/vending/cola/red
	name = "\improper Автомат с космической колой"
	desc = "Тут можно купить колу, в космосе."
	icon = 'modular_ss220/vending/icons/vending.dmi'
	icon_state = "Cola_Machine_Red"
	icon_lightmask = "Cola_Machine_Red"
	slogan_list = list("Кола в космосе!")

/obj/machinery/economy/vending/suitdispenser/free
	prices = list()

/obj/machinery/economy/vending/wallmed/emergency_ntmed
	name = "\improper Advanced Nanomed"
	desc = "Продвинутая экстренная аптечка на все случаи жизни."
	products = list(
		/obj/item/reagent_containers/applicator/dual = 1,
		/obj/item/reagent_containers/syringe/charcoal = 4,
		/obj/item/reagent_containers/hypospray/autoinjector/nt_emergency = 4,
		/obj/item/healthanalyzer/advanced = 1
		)
	refill_canister = /obj/item/vending_refill/adv_ntmed

/obj/item/reagent_containers/hypospray/autoinjector/nt_emergency
	name = "advanced emergency autoinjector"
	desc = "Компания всегда ставит жизни и здоровье своих сотрудников превыше всего."
	list_reagents = list("nanites" = 10)

/obj/machinery/economy/vending/shoedispenser/Initialize(mapload)
	contraband |= list(/obj/item/clothing/shoes/clown_shoes/moffers = 1)
	prices |= list(/obj/item/clothing/shoes/clown_shoes/moffers = 80)
	. = ..()

/obj/machinery/economy/vending/shoedispenser/free
	prices = list()

/obj/machinery/economy/vending/engidrobe/Initialize(mapload)
	contraband |= list(/obj/item/clothing/gloves/color/yellow/vox = 1)
	prices |= list(/obj/item/clothing/gloves/color/yellow/vox = 300)
	. = ..()

/obj/machinery/economy/vending/engidrobe/free
	prices = list()

/obj/machinery/economy/vending/traindrobe/Initialize(mapload)
	products |= list(
		/obj/item/clothing/under/rank/procedure/nct/black = 2,
		/obj/item/clothing/under/rank/procedure/nct/black/skirt = 2
		)
	. = ..()
