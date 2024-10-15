GLOBAL_LIST_INIT(uplink_items, subtypesof(/datum/uplink_item))
// This define is used when we have to spawn in an uplink item in a weird way, like a Surplus crate spawning an actual crate.
// Use this define by setting `uses_special_spawn` to TRUE on the item, and then checking if the parent proc of `spawn_item` returns this define. If it does, implement your special spawn after that.

/proc/get_uplink_items(obj/item/uplink/U, mob/user)
	var/list/uplink_items = list()
	var/list/sales_items = list()
	var/newreference = 1
	if(!length(uplink_items))
		for(var/path in GLOB.uplink_items)
			var/datum/uplink_item/I = new path
			if(!I.item)
				continue
			if(length(I.uplinktypes) && !(U.uplink_type in I.uplinktypes) && U.uplink_type != UPLINK_TYPE_ADMIN)
				continue
			if(length(I.excludefrom) && (U.uplink_type in I.excludefrom))
				continue
			//Add items to discount pool, checking job, species, and hijacker status
			if(I.job && !(user.mind.assigned_role in I.job)) //If your job does not match, no discount
				continue
			if(I.species && !(user.dna?.species.name in I.species)) //If your species does not match, no discount
				continue

			if(!uplink_items[I.category])
				uplink_items[I.category] = list()

			uplink_items[I.category] += I

			if(I.limited_stock < 0 && I.can_discount && I.item && I.cost > 5 && !I.hijack_only)
				sales_items += I

	if(isnull(user)) //Handles surplus
		return uplink_items

	for(var/i in 1 to 3)
		var/datum/uplink_item/sale_item = pick_n_take(sales_items)
		var/datum/uplink_item/A = new sale_item.type
		var/discount = 0.5
		A.limited_stock = 1
		sale_item.refundable = FALSE
		A.refundable = FALSE
		if(A.cost >= 100)
			discount *= 0.5 // If the item costs 100TC or more, it's only 25% off.
		A.cost = max(round(A.cost * (1 - discount)), 1)
		A.category = "Discounted Gear"
		A.name += " ([round(((initial(A.cost) - A.cost) / initial(A.cost)) * 100)]% off!)"
		A.reference = "DIS[newreference]"
		A.desc += " Limit of [A.limited_stock] per uplink. Normally costs [initial(A.cost)] TC."
		A.surplus = 0 //No freebies
		A.item = sale_item.item
		newreference++
		if(!uplink_items[A.category])
			uplink_items[A.category] = list()

		uplink_items[A.category] += A

	return uplink_items

// You can change the order of the list by putting datums before/after one another

/datum/uplink_item
	/// Name of the item in the uplink
	var/name = "item name"
	/// What category is the item listed under
	var/category = "item category"
	/// Description of the item in the uplink
	var/desc = "Item Description"
	/// Used for discounts. Any unique string will do.
	var/reference
	/// What is spawned when we purchase this?
	var/item
	/// How many TC does this cost?
	var/cost = 0
	/// Is what we're spawning abstract?
	var/abstract = 0
	/// Empty list means it is in all the uplink types. Otherwise place the uplink type here.
	var/list/uplinktypes = list()
	/// Empty list does nothing. Place the name of uplink type you don't want this item to be available in here.
	var/list/excludefrom = list()
	/// Is this job locked?
	var/list/job = null
	/// This makes an item on the uplink only show up to the specified species
	var/list/species = null
	/// Chance of being included in the surplus crate (when pick() selects it)
	var/surplus = 100
	/// Can this be sold at a discount?
	var/can_discount = TRUE
	/// Can you only buy so many? -1 allows for infinite purchases
	var/limited_stock = -1
	/// Can this item be purchased only during hijackings? Hijack-only items are by default unable to be on sale.
	var/hijack_only = FALSE
	/// Can you refund this in the uplink?
	var/refundable = FALSE
	/// Alternative path for refunds, in case the item purchased isn't what is actually refunded (ie: holoparasites).
	var/refund_path = null
	/// specified refund amount in case there needs to be a TC penalty for refunds.
	var/refund_amount
	/// Our special little snowflakes that have to be spawned in a different way than normal, like a surplus crate spawning a crate or contractor kits
	var/uses_special_spawn = FALSE

/datum/uplink_item/proc/spawn_item(turf/loc, obj/item/uplink/U)

	if(hijack_only && !(usr.mind.special_role == SPECIAL_ROLE_NUKEOPS))//nukies get items that regular traitors only get with hijack. If a hijack-only item is not for nukies, then exclude it via the gamemode list.
		if(!(locate(/datum/objective/hijack) in usr.mind.get_all_objectives()) && U.uplink_type != UPLINK_TYPE_ADMIN)
			to_chat(usr, "<span class='warning'>Синдикат выдаст это очень опасное оружие только агентам с целью Угон.</span>")
			return

	U.uses -= max(cost, 0)
	U.used_TC += cost
	SSblackbox.record_feedback("nested tally", "traitor_uplink_items_bought", 1, list("[initial(name)]", "[cost]"))
	if(item && !uses_special_spawn)
		return new item(loc)

	if(limited_stock)
		limited_stock -= 1 // In case we are handling discount items differently
	return UPLINK_SPECIAL_SPAWNING

/datum/uplink_item/proc/description()
	if(!desc)
		// Fallback description
		var/obj/temp = src.item
		desc = replacetext(initial(temp.desc), "\n", "<br>")
	return desc

/datum/uplink_item/proc/buy_uplink_item(obj/item/uplink/hidden/U, mob/user, put_in_hands = TRUE)
	if(!istype(U))
		return

	if(user.stat || user.restrained())
		return

	if(!ishuman(user))
		return

	// If the uplink's holder is in the user's contents
	if((U.loc in user.contents || (in_range(U.loc, user) && isturf(U.loc.loc))))
		if(cost > U.uses)
			return


		var/obj/I = spawn_item(get_turf(user), U, user)

		if(!I || I == UPLINK_SPECIAL_SPAWNING)
			return // Failed to spawn, or we handled it with special spawning
		if(limited_stock > 0)
			limited_stock--
			log_game("[key_name(user)] purchased [name]. [name] was discounted to [cost].")
			user.create_log(MISC_LOG, "Uplink purchase: [name] was discounted to [cost]tc")
			if(!user.mind.special_role)
				message_admins("[key_name_admin(user)] purchased [name] (discounted to [cost]), as a non antagonist.")

		else
			log_game("[key_name(user)] purchased [name].")
			user.create_log(MISC_LOG, "Uplink purchase: [name] for [cost]tc")
			if(!user.mind.special_role)
				message_admins("[key_name_admin(user)] purchased [name], as a non antagonist.")

		if(istype(I, /obj/item/storage/box) && length(I.contents))
			for(var/atom/o in I)
				U.purchase_log += "<big>[bicon(o)]</big>"

		else
			U.purchase_log += "<big>[bicon(I)]</big>"

		if(put_in_hands)
			user.put_in_any_hand_if_possible(I)
		return I

/*
//
//	UPLINK ITEMS
//
*/

//Discounts (dynamically filled above)
/datum/uplink_item/discounts
	category = "Снаряжение со скидкой"

////////////////////////////////////////
// MARK: DANGEROUS WEAPONS
////////////////////////////////////////

/datum/uplink_item/dangerous
	category = "Легкозаметные и опасные виды оружия"

/datum/uplink_item/dangerous/pistol
	name = "FK-69 Stechkin Pistol"
	reference = "SPI"
	desc = "Маленький, легкоскрываемый пистолет, использующий патроны 10мм в магазине ёмкостью 8 патронов. Совместим с глушителями."
	item = /obj/item/gun/projectile/automatic/pistol
	cost = 20

/datum/uplink_item/dangerous/revolver
	name = "Syndicate .357 Revolver"
	reference = "SR"
	desc = "Предельно простой револьвер Синдиката, стреляющий патронами калибра .357 Magnum и имеющий 7-зарядный. Поставляется с дополнительным спидлоадером."
	item = /obj/item/storage/box/syndie_kit/revolver
	cost = 65
	surplus = 50

/datum/uplink_item/dangerous/rapid
	name = "Gloves of the North Star"
	desc = "Эти перчатки позволяют очень быстро помогать, толкать, хватать и бить людей. Не увеличивает скорость атаки оружием. Может быть совмещено с боевыми искусствами для ещё большей смертоносности."
	reference = "RPGD"
	item = /obj/item/clothing/gloves/fingerless/rapid
	cost = 40

/datum/uplink_item/dangerous/sword
	name = "Energy Sword"
	desc = "Энергетический меч - это меч с клинком из чистой энергии. В неактивном состоянии меч можно спрятать в кармане. Активация производит характерный громкий звук."
	reference = "ES"
	item = /obj/item/melee/energy/sword/saber
	cost = 40

/datum/uplink_item/dangerous/dsword
	name = "Double Energy Sword"
	desc = "A double-bladed energy sword. More damaging than a standard energy sword, and automatically parries incoming energy weapons fire. Bulk discount applied."
	reference = "DSRD"
	item = /obj/item/dualsaber
	cost = 60

/datum/uplink_item/dangerous/snakefang
	name = "Snakesfang"
	desc = "The snakesfang is a fork-tipped scimitar with a sharp edge and sharper bite. This sword cannot fit in your bag, but it does come with a scabbard you can attach to your belt."
	reference = "SF"
	item = /obj/item/storage/belt/sheath/snakesfang
	cost = 25

/datum/uplink_item/dangerous/powerfist
	name = "Power Fist"
	desc = "Силовая перчатка - металлическая перчатся со встроенным гидравлическим поршнем , приводящимся в движение внешним источником газа. \
		При ударе цели поршень выдвинется вперед, увеличивая урон от контакта. \
		Использование гаечного ключа на клапане поршня позволит регулировать количество газа на удар, \
		используемое для нанесения увеличенного урона и отталкивания целей на большие расстояния. Использование отвёртки снимает баллон."
	reference = "PF"
	item = /obj/item/melee/powerfist
	cost = 50

/datum/uplink_item/dangerous/chainsaw
	name = "Chainsaw"
	desc = "Высокомощная бензопила для разрезания... ну вы понимаете..."
	reference = "CH"
	item = /obj/item/butcher_chainsaw
	cost = 65
	surplus = 0 // This has caused major problems with un-needed chainsaw massacres. Bwoink bait.
	excludefrom = list(UPLINK_TYPE_NUCLEAR)

/datum/uplink_item/dangerous/universal_gun_kit
	name = "Universal Self Assembling Gun Kit"
	desc = "Универсальный оружейный набор, который можно совместить с любым набором оружейных деталей, получая таким образом функционирующее оружие из РнД. Использует встроенные шестигранники для сборки. Просто совместите наборы, ударив один об другой."
	reference = "IKEA"
	item = /obj/item/weaponcrafting/gunkit/universal_gun_kit
	cost = 20

/datum/uplink_item/dangerous/batterer
	name = "Mind Batterer"
	desc = "Опасное устройство синдиката, ориентированное на контроль толпы и побеги. Вызывает урон мозгу, головокружение, а также другие неприятные эффекты на всех, кто находится рядом. Имеет 5 зарядов."
	reference = "BTR"
	item = /obj/item/batterer
	cost = 25

/datum/uplink_item/dangerous/porta_turret
	name = "Portable Turret"
	desc = "Саморазвёртывающаяся турель Синдиката, которая атакует любого, кто не взвёл эту гранату. Турель нельзя передвинуть после развёртывания."
	reference = "MIS"
	item = /obj/item/grenade/turret
	cost = 20

////////////////////////////////////////
// MARK: AMMUNITION
////////////////////////////////////////

/datum/uplink_item/ammo
	category = "Ammunition"
	surplus = 0 // Getting these in a discount or surplus is not a good time.
	can_discount = FALSE

/datum/uplink_item/ammo/pistol
	name = "Stechkin - 10mm Magazine"
	desc = "Дополнительный 8-зарядный 10мм магазин для пистолета Синдиката, заряженный дешевыми патронами, в половину уступающими калибру .357"
	reference = "10MM"
	item = /obj/item/ammo_box/magazine/m10mm
	cost = 3

/datum/uplink_item/ammo/pistolap
	name = "Stechkin - 10mm Armour Piercing Magazine"
	desc = "Дополнительный 8-зарядный 10мм магазин для пистолета Синдиката, заряженный патронами, которые менее эффективны в ранении цели, но пробивающие защитное снаряжение."
	reference = "10MMAP"
	item = /obj/item/ammo_box/magazine/m10mm/ap
	cost = 6

/datum/uplink_item/ammo/pistolfire
	name = "Stechkin - 10mm Incendiary Magazine"
	desc = "Дополнительный 8-зарядный 10мм магазин для пистолета Синдиката, заряженный зажигательными патронами поджигающими цель."
	reference = "10MMFIRE"
	item = /obj/item/ammo_box/magazine/m10mm/fire
	cost = 9

/datum/uplink_item/ammo/pistolhp
	name = "Stechkin - 10mm Hollow Point Magazine"
	desc = "Дополнительный 8-зарядный 10мм магазин для пистолета Синдиката, заряженный патронами, которые наносят больше урона, но  неэффективны против брони."
	reference = "10MMHP"
	item = /obj/item/ammo_box/magazine/m10mm/hp
	cost = 7

/datum/uplink_item/ammo/revolver
	name = ".357 Revolver - Speedloader"
	desc = "Спидлоудер, содержащий 7 патронов для револьвера .357 Синдиката. Когда вам нужно реально много трупов."
	reference = "357"
	item = /obj/item/ammo_box/a357
	cost = 15

////////////////////////////////////////
// MARK: STEALTHY WEAPONS
////////////////////////////////////////

/datum/uplink_item/stealthy_weapons
	category = "Скрытное и незаметное оружие"

/datum/uplink_item/stealthy_weapons/garrote
	name = "Fiber Wire Garrote"
	desc = "отрезон волоконного шнура с двумя деревянными рукоятками, идеально для убийцы-одиночки. Это оружие, будучи использовано на цели со спины, \
			моментально захватит и лишит её возможности говорить, а также вызовет быстрое удушье. Не сработает на тех, кому не требуется дыхание."
	item = /obj/item/garrote
	reference = "GAR"
	cost = 30

/datum/uplink_item/stealthy_weapons/cameraflash
	name = "Camera Flash"
	desc = "Вспышка, замаскированная под камеру с самозарядной системой защиты от перегорания. \
			Из-за своего устройства, данная вспышка не может быть перегружена как обычные вспышки. \
			Полезна для оглушения киборгов и людей без защиты глаз или ослепления толпы для побега."
	reference = "CF"
	item = /obj/item/flash/cameraflash
	cost = 5

/datum/uplink_item/stealthy_weapons/throwingweapons
	name = "Box of Throwing Weapons"
	desc = "Коробка сюрекенов и усиленных бол из древнего Земного боевого искусства. Это очень эффективное \
			метательное оружие. Болы могут сбить цель с ног, а сюрикены гарантированно застрянут в конечностях."
	reference = "STK"
	item = /obj/item/storage/box/syndie_kit/throwing_weapons
	cost = 15

/datum/uplink_item/stealthy_weapons/edagger
	name = "Energy Dagger"
	desc = "Кинжал из энергии, который выглядит и функционирует как ручка в выключенном состоянии."
	reference = "EDP"
	item = /obj/item/pen/edagger
	cost = 10

/datum/uplink_item/stealthy_weapons/foampistol
	name = "Toy Gun (with Stun Darts)"
	desc = "Безобидно выглядящий игрушечный пистолет, предназначенный для стрельбы вспененными зарядами. Поставляется заряженным резиновыми патронами для оглушения цели."
	reference = "FSPI"
	item = /obj/item/gun/projectile/automatic/toy/pistol/riot
	cost = 15
	surplus = 10

/datum/uplink_item/stealthy_weapons/false_briefcase
	name = "False Bottomed Briefcase"
	desc = "Модифицированный чемодан, способный хранить и стрелять из оружия под ложным дном. Используйте отвёртку для открытия дна и модификации. Отличим при ближайшем рассмотрении из-за дополнительного веса."
	reference = "FBBC"
	item = /obj/item/storage/briefcase/false_bottomed
	cost = 10

/datum/uplink_item/stealthy_weapons/soap
	name = "Syndicate Soap"
	desc = "Зловеще выглядящий сурфактант, используемый для очистки кровавых следов на месте убийства и предотвращения ДНК-анализа. Вы также можете бросать его под ноги людям."
	reference = "SOAP"
	item = /obj/item/soap/syndie
	cost = 5
	surplus = 50

/datum/uplink_item/stealthy_weapons/RSG
	name = "Rapid Syringe Gun"
	desc = "Скоростной шприцемет Синдиката, способный заправлять шприцы и стрелять ими автоматически из внутреннего хранилища реагентов. Поставляется заряженным  7 пустыми шприцами, максимальная ёмкость - 14 шприцов и 300 юнитов реагентов."
	reference = "RSG"
	item = /obj/item/gun/syringe/rapidsyringe/preloaded/half
	cost = 60

/datum/uplink_item/stealthy_weapons/poisonbottle
	name = "Poison Bottle"
	desc = "Синдикат поставит вам один пузырёк с 40 юнитами случайного яда. Яд варьируется от очень раздражающего до невероятно смертельного."
	reference = "TPB"
	item = /obj/item/reagent_containers/glass/bottle/traitor
	cost = 10
	surplus = 0 // Requires another item to function.

/datum/uplink_item/stealthy_weapons/silencer
	name = "Universal Suppressor"
	desc = "Подходящий для любого оружия малого калибра с нарезным стволом, этот глушитель способен заглушить звуки выстрелов для большей скрытности и преимущества в засадах."
	reference = "US"
	item = /obj/item/suppressor
	cost = 5
	surplus = 10

/datum/uplink_item/stealthy_weapons/dehy_carp
	name = "Dehydrated Space Carp"
	desc = "Просто добавьте воды для создания ручного карпа, враждебного ко всему. Выглядит как плюшевая игрушка. Первый человек, сжавший игрушку, будет считаться владельцем, на которого карп не будет нападать. Если владельца нет, он будет атаковать вообще всех."
	reference = "DSC"
	item = /obj/item/toy/plushie/carpplushie/dehy_carp
	cost = 4

/datum/uplink_item/stealthy_weapons/knuckleduster
	name = "Syndicate Knuckleduster"
	desc = "Прямолинейное и достаточно легко скрываемое оружие ближнего боя для избиения кого-либо в брутальном стиле. Конкретно это оружие спроектировано специально для нанесения большого урон внутренним органам жертвы."
	reference = "SKD"
	item = /obj/item/melee/knuckleduster/syndie
	cost = 10

////////////////////////////////////////
// MARK: GRENADES AND EXPLOSIVES
////////////////////////////////////////

/datum/uplink_item/explosives
	category = "Гранаты и взрывчатка"

/datum/uplink_item/explosives/plastic_explosives
	name = "Composition C-4"
	desc = "С-4 это пластичная взрывчатка, распространённая вариация композита C. Надёжно уничтожает объект, на который установлена, за исключением взрывоустойчивых. Не липнет к членам экипажа. Уничтожит только напольные покрытия в случае установки на них. Есть настраиваемый таймер с минимумом в 10 секунд."
	reference = "C4"
	item = /obj/item/grenade/plastic/c4
	cost = 5

/datum/uplink_item/explosives/plastic_explosives_pack
	name = "Pack of 5 C-4 Explosives"
	desc = "Упаковка, содержащая 5 взрывчаток C-4 по скидочной цене. Для тех случаев, когда для ваших саботажей требуется слегка больше."
	reference = "C4P"
	item = /obj/item/storage/box/syndie_kit/c4
	cost = 20

/datum/uplink_item/explosives/syndicate_minibomb
	name = "Syndicate Minibomb"
	desc = "Минибомба, граната с пятисекундным взрывателем"
	reference = "SMB"
	item = /obj/item/grenade/syndieminibomb
	cost = 30

/datum/uplink_item/explosives/frag_grenade
	name = "Fragmentation Grenade"
	desc = "Осколочная граната. При детонации выпускает шрапнель, застревающую в ближайших жертв."
	reference = "FG"
	item = /obj/item/grenade/frag
	cost = 10

/datum/uplink_item/explosives/frag_grenade_pack
	name = "Набор из 5 осколочных гранат"
	desc = "Коробка с пятью осколочными гранатами. При детонации выпускает шрапнель, застревающую в ближайших жертвах. И похоже будет МНОГО жертв."
	reference = "FGP"
	item = /obj/item/storage/box/syndie_kit/frag_grenades
	cost = 40

/datum/uplink_item/explosives/pizza_bomb
	name = "Pizza Bomb"
	desc = "Коробка из под пиццы с бомбой, приклеенной внутри. Сначала таймер надо настроить, открыв коробку. Повторное открытие провоцирует детонацию."
	reference = "PB"
	item = /obj/item/pizzabox/pizza_bomb
	cost = 30
	surplus = 80

/datum/uplink_item/explosives/atmosn2ogrenades
	name = "Knockout Gas Grenades"
	desc = "Коробка с двумя (2) гранатами, распространяющими усыпляющий газ на большой территории. Экипируйте баллон с воздухом перед их использованием."
	reference = "ANG"
	item = /obj/item/storage/box/syndie_kit/atmosn2ogrenades
	cost = 40

/datum/uplink_item/explosives/emp
	name = "EMP Grenades and bio-chip implanter Kit"
	desc = "Коробка, содержащая две ЭМИ гранаты и ЭМИ имплант на два использования. Полезно для отключения коммуникаций, \
			энергетического оружия СБ и синтетических форм жизни, когда вас прижмут."
	reference = "EMPK"
	item = /obj/item/storage/box/syndie_kit/emp
	cost = 10

/datum/uplink_item/explosives/emp/New()
	..()
	if(HAS_TRAIT(SSstation, STATION_TRAIT_CYBERNETIC_REVOLUTION))
		cost *= 3

/datum/uplink_item/explosives/targrenade
	name = "Sticky Tar Grenade"
	desc = "A grenade filled with aerosols and sticky tar. \
			Will release a plume of smoke that applies tar to a wide area, severely slowing down movement. Makes for the ultimate getaway!"
	reference = "TARG"
	item = /obj/item/grenade/chem_grenade/tar
	cost = 7

////////////////////////////////////////
// MARK: STEALTHY TOOLS
////////////////////////////////////////

/datum/uplink_item/stealthy_tools
	category = "Скрытные и камуфляжные предметы"

/datum/uplink_item/stealthy_tools/chameleon_stamp
	name = "Chameleon Stamp"
	desc = "Штамп, который может быть активирован для имитации официального штампа НаноТрэйзен. Замаскированный штамп будет работать точно также как настоящий, позволяя вам подделывать документы для получения дополнительных доступов и оборудования. \
	Также может быть использовано в стиральной машине для подделывания одежды."
	reference = "CHST"
	item = /obj/item/stamp/chameleon
	cost = 1
	surplus = 35

/datum/uplink_item/stealthy_tools/chameleonflag
	name = "Chameleon Flag"
	desc = "Флаг, который может быть замаскирован под любой известный флаг. Есть скрытое место в флагштоке для минирования гранатой или минибомбой, которая подорвётся через некоторое время после поджога флага."
	reference = "CHFLAG"
	item = /obj/item/flag/chameleon
	cost = 1
	surplus = 35

/datum/uplink_item/stealthy_tools/chamsechud
	name = "Chameleon Security HUD"
	desc = "Сворованный ХУД СБ со встроенной хамелеон технологией Синдиката. Сходно комбинезону хамелеон, ХУД может превратиться в любые очки, сохраняя свой функционал когда они надеты."
	reference = "CHHUD"
	item = /obj/item/clothing/glasses/hud/security/chameleon
	cost = 10

/datum/uplink_item/stealthy_tools/thermal
	name = "Thermal Chameleon Glasses"
	desc = "Это термальные очки со встроенной хамелеон технологией Синдиката. Они позволят вам видеть организмы через стены, улавливая верхнюю часть инфракрасного спектра, излучаемую в виде тепла и света от объектов. Горячие объекты, вроде теплых тел, кибернетических организмов и ядер ИИ излучают больше этого света, чем более холодные объекты, такие как стены и шлюзы."
	reference = "THIG"
	item = /obj/item/clothing/glasses/chameleon/thermal
	cost = 15

/datum/uplink_item/stealthy_tools/night
	name = "Nightvision Chameleon Glasses"
	desc = "These glasses are nightvision with Syndicate chameleon technology built into them. Lets you see clearer in the dark."
	reference = "TNIG"
	item = /obj/item/clothing/glasses/chameleon/night
	cost = 5

/datum/uplink_item/stealthy_tools/agent_card
	name = "Agent ID Card"
	desc = "Карта агента предотвращает отслеживание носителя со стороны ИИ, а также позволяет копировать доступы с других идентификационных карт. Эффект суммируется, поэтому сканирование одних карт не стирает доступы, полученные от других."
	reference = "AIDC"
	item = /obj/item/card/id/syndicate
	cost = 10

/datum/uplink_item/stealthy_tools/chameleon_proj
	name = "Chameleon-Projector"
	desc = "Проецирует картинку на пользователя, маскируя его как отсканированный объект пока проектор находится в руке. Замаскированный пользователь не может бегать, и снаряды будут пролетать мимо него."
	reference = "CP"
	item = /obj/item/chameleon
	cost = 25

/datum/uplink_item/stealthy_tools/chameleon_counter
	name = "Chameleon Counterfeiter"
	desc = "Это устройство маскирует себя как любой отсканированный объект. Маскировка - не идеальная реплика и может быть распознана при осмотре наблюдателем."
	reference = "CC"
	item = /obj/item/chameleon_counterfeiter
	cost = 10

/datum/uplink_item/stealthy_tools/camera_bug
	name = "Camera Bug"
	desc = "Позволяет вам просматривать все камеры в сети для отслеживания цели. Также даёт 5 скрытых камер, позволяя вам удалённо смотреть за объектом, на который вы прицепили камеру."
	reference = "CB"
	item = /obj/item/storage/box/syndie_kit/camera_bug
	cost = 5
	surplus = 90

/datum/uplink_item/stealthy_tools/dnascrambler
	name = "DNA Scrambler"
	desc = "Шприц с одной инъекцией, меняющей имя и внешность на случайные. Более дешевая, но менее универсальная альтернатива карте агента и модулятору голоса."
	reference = "DNAS"
	item = /obj/item/dnascrambler
	cost = 7

/datum/uplink_item/stealthy_tools/smugglersatchel
	name = "Smuggler's Satchel"
	desc = "Эта сумка достаточно тонкая для укладки между обшивкой и полом, отлично подходит для прятанья ворованных вещей. Поставляется с ломом и напольной плиткой внутри."
	reference = "SMSA"
	item = /obj/item/storage/backpack/satchel_flat
	cost = 10
	surplus = 30

/datum/uplink_item/stealthy_tools/emplight
	name = "EMP Flashlight"
	desc = "Маленькое, самозарядное устройство ЭМИ, замаскированное под фонарик. Работает на короткой дистанции. \
		Полезно для отключения наушников, камер, и боргов во время скрытных операций."
	reference = "EMPL"
	item = /obj/item/flashlight/emp
	cost = 20
	surplus = 30

/datum/uplink_item/stealthy_tools/emplight/New()
	..()
	if(HAS_TRAIT(SSstation, STATION_TRAIT_CYBERNETIC_REVOLUTION))
		cost *= 2.5

/datum/uplink_item/stealthy_tools/cutouts
	name = "Adaptive Cardboard Cutouts"
	desc = "Эти картонные аппликации покрыты тонким материалом, предотвращающим выцветание и делающим изображения более похожими на реальные. В наборе их 3, а также \
	баллончик с краской для смены их вида."
	reference = "ADCC"
	item = /obj/item/storage/box/syndie_kit/cutouts
	cost = 1
	surplus = 20

/datum/uplink_item/stealthy_tools/safecracking
	name = "Safe-cracking Kit"
	desc = "Всё что вам требуется для тихого открытия механического сейфа."
	reference = "SCK"
	item = /obj/item/storage/box/syndie_kit/safecracking
	cost = 5
	surplus = 0 // Far too objective specific.

/datum/uplink_item/stealthy_tools/handheld_mirror
	name = "Hand Held Mirror"
	desc = "Карманное зеркало. Позволяет вам мгновенно менять причёску и особенности лица, от цвета до стиля, моментально, пока зеркало находится в руке."
	reference = "HM"
	item = /obj/item/handheld_mirror
	cost = 5

////////////////////////////////////////
// MARK: DEVICES AND TOOLS
////////////////////////////////////////

/datum/uplink_item/device_tools
	category = "Устройства и инструменты"
	abstract = 1

/datum/uplink_item/device_tools/emag
	name = "Cryptographic Sequencer"
	desc = "Криптографический сиквенсер, также известный как емаг, это маленькая карта, открывающая скрытые функции элнетронных устройств, искажает изначальные функции и характерно ломает системы безопасности."
	reference = "EMAG"
	item = /obj/item/card/emag
	cost = 30

/datum/uplink_item/device_tools/access_tuner
	name = "Access Tuner"
	desc = "Настройщик доступа - это маленькое устройство, взаимодействующее со шлюзами на расстоянии. Этот процесс занимает несколько секунд и позволяет болтировать, открывать шлюзы и переключать экстренный доступ."
	reference = "HACK"
	item = /obj/item/door_remote/omni/access_tuner
	cost = 30

/datum/uplink_item/device_tools/toolbox
	name = "Fully Loaded Toolbox"
	desc = "Подозрительный красно-чёрный ящик с инструментами Синдиката. Помимо инструментов, поставляется с изолированными перчатками и мультитулом."
	reference = "FLTB"
	item = /obj/item/storage/toolbox/syndicate
	cost = 5

/datum/uplink_item/device_tools/surgerybag
	name = "Syndicate Surgery Duffelbag"
	desc = "Хирургическая сумка Синдиката поставляется с полным набором хирургических инструментов, смирительной рубашкой и кляпом. Сама сумка сделана из очень лёгких материалов, поэтому не будет замедлять вас, пока экипирована"
	reference = "SSDB"
	item = /obj/item/storage/backpack/duffel/syndie/med/surgery
	cost = 10

/datum/uplink_item/device_tools/bonerepair
	name = "Prototype Nanite Autoinjector"
	desc = "Украденный прототип с нанитами, лечащими всё тело. При инъекции выключает системы в теле, пока наниты оживляют органы и конечности."
	reference = "NCAI"
	item = /obj/item/reagent_containers/hypospray/autoinjector/nanocalcium
	cost = 10

/datum/uplink_item/device_tools/syndicate_teleporter
	name = "Experimental Syndicate Teleporter"
	desc = "Телепортатор Синдиката это переносное устройство, переносящее пользователя на 4-8 метров вперед. \
			Осторожно, телепортация в стену заставит телепортатор сделать экстренный параллельный телепорт, \
			но если экстренный телепорт даст сбой, он вас убьет. \
			Имеет четыре заряда, перезаряжается, гарантия недействительна при воздействии ЭМИ. \
			Поставляется мезонными очками хамелеон, чтобы вы оставались стильным, имея возможность видеть сквозь стены."
	reference = "TELE"
	item = /obj/item/storage/box/syndie_kit/teleporter
	cost = 40

/datum/uplink_item/device_tools/organ_extractor
	name = "Organ Extractor"
	desc = "Устройство, используемое для извлечения и хранения органов и кибернетических имплантов жертвы. \
	Хранящиеся органы можно имплантиовать в пользователя или в другие цели. Синтезирует химикаты для сохранения органов свежими."
	reference = "OREX"
	item = /obj/item/organ_extractor
	cost = 20

/datum/uplink_item/device_tools/c_foam_launcher
	name = "C-Foam Launcher"
	desc = "A gun that shoots blobs of foam. Will block airlocks, and slow down humanoids. Not rated for xenomorph usage."
	reference = "CFOAM"
	item = /obj/item/gun/projectile/c_foam_launcher
	cost = 25

/datum/uplink_item/device_tools/tar_spray
	name = "Sticky Tar Applicator"
	desc = "A spray bottle containing an extremely viscous fluid that will leave behind tar whenever it is sprayed, greatly slowing down anyone who tries to walk over it. \
	Comes with 10 uses worth of fluid and cannot be refilled."
	reference = "TAR"
	item = /obj/item/reagent_containers/spray/sticky_tar
	cost = 10

/datum/uplink_item/device_tools/binary
	name = "Binary Translator Key"
	desc = "A key, that when inserted into a radio headset, allows you to listen to and talk with artificial intelligences and cybernetic organisms in binary. To talk on the binary channel, type :+ before your radio message."
	reference = "BITK"
	item = /obj/item/encryptionkey/binary
	cost = 25
	surplus = 75

/datum/uplink_item/device_tools/cipherkey
	name = "Syndicate Encryption Key"
	desc = "A key, that when inserted into a radio headset, allows you to listen to all station department channels as well as talk on an encrypted Syndicate channel."
	reference = "SEK"
	item = /obj/item/encryptionkey/syndicate
	cost = 10 //Nowhere near as useful as the Binary Key!
	surplus = 75

/datum/uplink_item/device_tools/hacked_module
	name = "Hacked AI Upload Module"
	desc = "When used with an upload console, this module allows you to upload priority laws to an artificial intelligence. Be careful with their wording, as artificial intelligences may look for loopholes to exploit."
	reference = "HAI"
	item = /obj/item/aiModule/syndicate
	cost = 15

/datum/uplink_item/device_tools/powersink
	name = "Power Sink"
	desc = "When screwed to wiring attached to an electric grid, then activated, this large device places excessive load on the grid, causing a stationwide blackout. The sink cannot be carried because of its excessive size. Ordering this sends you a small beacon that will teleport the power sink to your location on activation."
	reference = "PS"
	item = /obj/item/beacon/syndicate/power_sink
	cost = 50

/datum/uplink_item/device_tools/singularity_beacon
	name = "Power Beacon"
	desc = "When screwed to wiring attached to an electric grid and activated, this large device pulls any \
			active gravitational singularities. This will not work when the engine is still \
			in containment. Because of its size, it cannot be carried. Ordering this \
			sends you a small beacon that will teleport the larger beacon to your location upon activation."
	reference = "SNGB"
	item = /obj/item/beacon/syndicate
	cost = 10
	surplus = 0
	hijack_only = TRUE //This is an item only useful for a hijack traitor, as such, it should only be available in those scenarios.

/datum/uplink_item/device_tools/advpinpointer
	name = "Advanced Pinpointer"
	desc = "A pinpointer that tracks any specified coordinates, DNA string, high value item or the nuclear authentication disk."
	reference = "ADVP"
	item = /obj/item/pinpointer/advpinpointer
	cost = 10
	can_discount = FALSE

/datum/uplink_item/device_tools/ai_detector
	name = "Artificial Intelligence Detector" // changed name in case newfriends thought it detected disguised ai's
	desc = "A functional multitool that turns red when it detects an artificial intelligence watching it or its holder. Knowing when an artificial intelligence is watching you is useful for knowing when to maintain cover."
	reference = "AID"
	item = /obj/item/multitool/ai_detect
	cost = 5

/datum/uplink_item/device_tools/jammer
	name = "Radio Jammer"
	desc = "When turned on this device will scramble any outgoing radio communications near you, making them hard to understand."
	reference = "RJ"
	item = /obj/item/jammer
	cost = 20

/datum/uplink_item/device_tools/decoy_nade
	name = "Decoy Grenade Kit"
	desc = "A box of five grenades that can be configured to reproduce many suspicious sounds at varying rates."
	reference = "DCY"
	item = /obj/item/storage/box/syndie_kit/decoy
	cost = 20

////////////////////////////////////////
// MARK: SPACE SUITS AND HARDSUITS
////////////////////////////////////////

/datum/uplink_item/suits
	category = "Скафандры и MODsuit'ы"
	surplus = 10 //I am setting this to 10 as there are a bunch of modsuit parts in here that should be weighted to 10. Suits and modsuits adjusted below.

/datum/uplink_item/suits/space_suit
	name = "Syndicate Space Suit"
	desc = "Этот красно-черный скафандр Синдиката менее загруженный, чем варианты Нанотрэйзен, \
	помещается в рюкзак, а также имеет оружейный слот. Поставляется с баллоном воздуха. Но всё же, члены команды Нанотрейзен научены докладывать о \
	красно-черных скафандрах."
	reference = "SS"
	item = /obj/item/storage/box/syndie_kit/space
	cost = 20

/datum/uplink_item/suits/thermal
	name = "MODsuit Thermal Visor Module"
	desc = "Визор для MODsuit'а. Позволяет вам видеть живых существ через стены. Также даёт ночное зрение."
	reference = "MSTV"
	item = /obj/item/mod/module/visor/thermal
	cost = 15 // Don't forget, you need to get a modsuit to go with this
	surplus = 10 //You don't need more than

/datum/uplink_item/suits/night
	name = "MODsuit Night Visor Module"
	desc = "Визор для MODsuit'а. Позволяет вам лучше видеть в темноте."
	reference = "MSNV"
	item = /obj/item/mod/module/visor/night
	cost = 5 // It's night vision, rnd pumps out those goggles for anyone man.
	surplus = 10 //You don't need more than one

/datum/uplink_item/suits/plate_compression
	name = "MODsuit Plate Compression Module"
	desc = "Модуль на MODsuit, позволяющий ему сжаться до меньших размеров. Несовместим с модулями хранилища, \
	сначала вам придётся извлечь такой модуль."
	reference = "MSPC"
	item = /obj/item/mod/module/plate_compression
	cost = 10

/datum/uplink_item/suits/chameleon_module
	name = "MODsuit Chameleon Module"
	desc = "Модуль, использующий технологию хамелеон для маскировки сложенного MODsuit'а под другой предмет. Примечание: маскировка выключится при развертывании MODsuit'а, но может быть активирована повторно после складывания."
	reference = "MSCM"
	item = /obj/item/mod/module/chameleon
	cost = 10

/datum/uplink_item/suits/noslip
	name = "MODsuit Anti-Slip Module"
	desc = "Модуль на MODsuit, предотвращающий поскальзывание на воде. Предустановлен в MODsuit'ы из аплинка."
	reference = "MSNS"
	item = /obj/item/mod/module/noslip
	cost = 5

/datum/uplink_item/suits/springlock_module
	name = "Heavily Modified Springlock MODsuit Module"
	desc = "Модуль, простирающийся на всю длину MODsuit, находящийся под внешней оболочкой. \
		Этот механический экзоскелет отодвигается при входе пользователя и ускоряет запуск, \
		но он был изъят из современных костюмов из-за тенденции \"срываться\" в \
		исходное положение при попадании влаги. Вы знаете, каково это — чувствовать вхождение в себя экзоскелета? \
		Эта версия модуля была улучшена таким образом, что позволяет практически моментально активировать MODsuit. \
		Полезен для быстрого снятия MODsuit или для убийства цели при помощи трагичного несчастного случая. \
		Этот модуль спрятан как ДНК-замок. Он заблокирует складывание модуля на 5 секунд по умолчанию, позволяя вам \
		использовать дым, но вы можете отключить данный функционал модуля, используя мультитул."
	reference = "FNAF"
	item = /obj/item/mod/module/springlock/bite_of_87
	cost = 5
	surplus = 10

/datum/uplink_item/suits/hidden_holster
	name = "Hidden Holster Module"
	desc = "Модуль кобуры, замаскированный под крюк-кошку. Требует MODsuit для установки, естественно. Ствол приобретается отдельно."
	reference = "HHM"
	item = /obj/item/mod/module/holster/hidden
	cost = 5
	surplus = 10

/datum/uplink_item/suits/smoke_grenade
	name = "Smoke Grenade Module"
	desc = "Модуль на MODsuit, который выпускает взведенные дымовые гранаты для разгона толпы."
	reference = "SGM"
	item = /obj/item/mod/module/dispenser/smoke
	cost = 10
	surplus = 10

////////////////////////////////////////
// MARK: IMPLANTS
////////////////////////////////////////

/datum/uplink_item/bio_chips
	category = "Био-чипы"

/datum/uplink_item/bio_chips/freedom
	name = "Freedom Bio-chip"
	desc = "Био-чип, вживляемый в тело и позже активируемый для того, чтобы вырваться из любых оков. Может быть активирован до 4 раз."
	reference = "FI"
	item = /obj/item/bio_chip_implanter/freedom
	cost = 25

/datum/uplink_item/bio_chips/protofreedom
	name = "Prototype Freedom Bio-chip"
	desc = "Прототип био-чипа, вживляемый в тело и позже активируемый для того, чтобы вырваться из любых оков. Может быть активирован лишь единожды."
	reference = "PFI"
	item = /obj/item/bio_chip_implanter/freedom/prototype
	cost = 10

/datum/uplink_item/bio_chips/storage
	name = "Storage Bio-chip"
	desc = "Био-чип, вживляемый в тело и активируемый по воле владельца. Открывает маленький субпространственный карман, способный вместить 2 предмета."
	reference = "ESI"
	item = /obj/item/bio_chip_implanter/storage
	cost = 40

/datum/uplink_item/bio_chips/mindslave
	name = "Mindslave Bio-chip"
	desc = "Коробка с имплантером с био-чипом подчинения, который при вживлении в другого человека делает их верным вам и вашему делу, кроме случаев, если они уже проимплантированы кем-то другим. Лояльность кончается при извлечении импланта из тела."
	reference = "MI"
	item = /obj/item/bio_chip_implanter/traitor
	cost = 50

/datum/uplink_item/bio_chips/adrenal
	name = "Adrenal Bio-chip"
	desc = "Био-чип, вводимый в тело и позже активируемый в ручную для впрыскивания химического коктейля, имеющего средние исцеляющие способности, а также убирает текущие ослабления и уменьшает время всех последующих, дополнительно увеличивая скорость передвижения. Может быть активирован до 3 раз."
	reference = "AI"
	item = /obj/item/bio_chip_implanter/adrenalin
	cost = 40

/datum/uplink_item/bio_chips/basic_adrenal
	name = "Basic-Adrenal Bio-chip"
	desc = "Одноразовый био-чип, вводимый в тело и активируемый для впрыска химического коктейля. У данной версии лечащее действие хуже обычного адреналина. Его можно активировать единожды для полученния эффекта как от 3/4 оригинала."
	reference = "BAI"
	item = /obj/item/bio_chip_implanter/basic_adrenalin
	cost = 20
	can_discount = FALSE

/datum/uplink_item/bio_chips/proto_adrenal
	name = "Proto-Adrenal Bio-chip"
	desc = "Старый прототип био-чипа Адреналин, дающий пользователю 4 секунды антистана, единожды поднимая его на ноги, но ничего более. Скорость и лечение продаются отдельно."
	reference = "PAI"
	item = /obj/item/bio_chip_implanter/proto_adrenalin
	cost = 10

/datum/uplink_item/bio_chips/stealthimplant
	name = "Stealth Bio-chip"
	desc = "Этот уникальный имплант делает вас практически невидимым, если вы правильно разыграете карты. \
			При активации, он спрячет вас внутри картонной коробки, которую можно обнаружить, только если кто-то врежется в вас."
	reference = "SI"
	item = /obj/item/bio_chip_implanter/stealth
	cost = 45

////////////////////////////////////////
// MARK: CYBERNETICS
////////////////////////////////////////

/datum/uplink_item/cyber_implants
	category = "Кибернетические имланты"

/datum/uplink_item/cyber_implants/hackerman_deck
	name = "Binyat Wireless Hacking System Autoimplanter"
	desc = "Этот имплант позволит вам взламывать устройства на расстоянии. Однако, он слегка обжигает \
	при использовании, и процесс взлома сопровождается заметным эффектом. \
	Нельзя увидеть на неулучшенных сканерах тела. Несовместим с Qani-Laaca Sensory Computer."
	reference = "HKR"
	item = /obj/item/autosurgeon/organ/syndicate/oneuse/hackerman_deck
	cost = 30 // Probably slightly less useful than an emag with heat / cooldown, but I am not going to make it cheaper or everyone picks it over emag

/datum/uplink_item/cyber_implants/razorwire
	name = "Razorwire Spool Arm Implant Autoimplanter"
	desc = "Длинная мономолекулярная нить, встроенная прямо в тыльную сторону ладони. \
		Невероятно тонкая и безупречно острая, она без проблем прорежет любую органику \
		даже на расстоянии нескольких шагов. Однако, против чего-либо более стойкого результаты могут варьироваться."
	reference = "RZR"
	item = /obj/item/autosurgeon/organ/syndicate/oneuse/razorwire
	cost = 20

/datum/uplink_item/cyber_implants/scope_eyes
	name = "Hardened Kaleido Optics Eyes Autoimplanter"
	desc = "Эти кибернетические импланты на глаза позволят вам приближать изображение на удаленные объекты\
	Дизориентирующий для многих пользователей и им сложно взаимодействовать с предметами возле себя, пока данный имплант активен. \
	Эта пара была усилена для персонала специальных операций."
	reference = "KOE"
	item = /obj/item/autosurgeon/organ/syndicate/oneuse/scope_eyes
	cost = 10


////////////////////////////////////////
// MARK: POINTLESS BADASSERY
////////////////////////////////////////

/datum/uplink_item/badass
	category = "(Бесполезно) Понты"
	surplus = 0

/datum/uplink_item/badass/pen
	name = "Syndicate Fountain Pen"
	desc = "Изящная ручка с логотипом Синдиката, чтобы показать всем на встрече, что вы настроены серьёзно."
	reference = "PEN"
	item = /obj/item/pen/multi/syndicate
	cost = 1

/datum/uplink_item/badass/syndiecigs
	name = "Syndicate Smokes"
	desc = "Сильный вкус, плотный дым, пропитаны омнизином."
	reference = "SYSM"
	item = /obj/item/storage/fancy/cigarettes/cigpack_syndicate
	cost = 7

/datum/uplink_item/badass/syndiecash
	name = "Syndicate Briefcase Full of Cash"
	desc = "Чемодан с паролем, содержащий в себе 600 космокредитов. Полезно для подкупа персонала или покупки товаров и услуг по заманчивым ценам. \
	Чемодан также кажется слегка тяжелее; он был спроектирован, чтобы от него было чуть больше пользы в случае, если клиенту требуется немного \"убеждения\"."
	reference = "CASH"
	item = /obj/item/storage/secure/briefcase/syndie
	cost = 5

/datum/uplink_item/badass/balloon
	name = "For showing that you are The Boss"
	desc = "Бесполезный красный шарик с логотипом Синдиката на нём. Подрывает даже глубочайшее прикрытие."
	reference = "BABA"
	item = /obj/item/toy/syndicateballoon
	cost = 100
	can_discount = FALSE

/datum/uplink_item/badass/bomber
	name = "Syndicate Bomber Jacket"
	desc = "Крутая куртка, чтоб выделываться перед НаноТрэйзен. Подкладка сделана из тонкого полимера для защиты. Не даёт дополнительное место для хранения вещей."
	reference = "JCKT"
	item = /obj/item/clothing/suit/jacket/bomber/syndicate
	cost = 3

/datum/uplink_item/badass/tpsuit
	name = "Syndicate Two-Piece Suit"
	desc = "Чёткий костюм-двойка, который должен носить каждый уважающий cебя агент Синдиката. Идеален для профессионалов, действующих скрытно, но также несколько бронирован экспериментальной нанотканью на случай, если всё пойдёт не по плану. Поставляется с двумя карманами на кашемировой подкладке для максимального стиля и комфорта."
	reference = "SUIT"
	item = /obj/item/clothing/suit/storage/iaa/blackjacket/armored
	cost = 3

////////////////////////////////////////
// MARK: BUNDLES AND TELECRYSTALS
////////////////////////////////////////

/datum/uplink_item/bundles_TC
	category = "Наборы и телекристаллы"
	surplus = 0
	can_discount = FALSE

/datum/uplink_item/bundles_TC/telecrystal
	name = "Raw Telecrystal"
	desc = "Телекристалл в своей чистейшей форме, может быть использован для увеличения счета телекристаллов на активных аплинках."
	reference = "RTC"
	item = /obj/item/stack/telecrystal
	cost = 1

/datum/uplink_item/bundles_TC/telecrystal/five
	name = "5 Raw Telecrystals"
	desc = "Пять телекристаллов в своей чистейшей форме, может быть использован для увеличения счета телекристаллов на активных аплинках."
	reference = "RTCF"
	item = /obj/item/stack/telecrystal/five
	cost = 5

/datum/uplink_item/bundles_TC/telecrystal/twenty
	name = "20 Raw Telecrystals"
	desc = "Двадцать телекристаллов в своей чистейшей форме, могут быть использованы для увеличения счета телекристаллов на активных аплинках."
	reference = "RTCT"
	item = /obj/item/stack/telecrystal/twenty
	cost = 20

/datum/uplink_item/bundles_TC/telecrystal/fifty
	name = "50 Raw Telecrystals"
	desc = "Пятьдесят телекристаллов в своей чистейшей форме, могут быть использованы для увеличения счета телекристаллов на активных аплинках."
	reference = "RTCB"
	item = /obj/item/stack/telecrystal/fifty
	cost = 50

/datum/uplink_item/bundles_TC/telecrystal/hundred
	name = "100 Raw Telecrystals"
	desc = "Одна сотня телекристаллов в своей чистейшей форме, могут быть использованы для увеличения счета телекристаллов на активных аплинках."
	reference = "RTCH"
	item = /obj/item/stack/telecrystal/hundred
	cost = 100
