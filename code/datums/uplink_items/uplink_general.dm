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
	var/desc = "Item Description."
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
	/// Can this item be purchased only during hijackings or nukings? Hijack-only items are by default unable to be on sale.
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
		if(!(locate(/datum/objective/hijack) in usr.mind.get_all_objectives() || locate(/datum/objective/nuke) in usr.mind.get_all_objectives()) && U.uplink_type != UPLINK_TYPE_ADMIN)
			to_chat(usr, SPAN_WARNING("Синдикат выдаст этот крайне опасный предмет только агентам, которым поручено захватить шаттл или взорвать ядерное устройство станции."))
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
	if(((U.loc in user.contents) || (in_range(U.loc, user) && isturf(U.loc.loc))))
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
	category = "Крайне заметное и мощное вооружение"

/datum/uplink_item/dangerous/pistol
	name = "Пистолет Стечкина ФК-69 10мм"
	reference = "SPI"
	desc = "Небольшой, легко скрываемый пистолет, использующий патроны калибра 10мм в магазинах на 8 патронов. Имеет насечку на стволе для глушителя."
	item = /obj/item/gun/projectile/automatic/pistol
	cost = 20

/datum/uplink_item/dangerous/revolver
	name = "Револьвер синдиката .357"
	reference = "SR"
	desc = "Предельно простой в использование револьвер Синдиката, стреляющий патронами калибра .357 Magnum и имеющий барабан на 7 патрон. Поставляется с одним спидлоадером."
	item = /obj/item/storage/box/syndie_kit/revolver
	cost = 70 // SS220 EDIT PRICE UP/DOWN 65 -> 70
	surplus = 50

/datum/uplink_item/dangerous/rapid
	name = "Перчатки Полярной звезды"
	desc = "Перчатки позволяют с невероятной скоростью совершать обычные действия вроде толкания и избивания жертвы, но так же работают и на поглаживания. Работают только на безоружные атаки. Могут использоваться в сочетании с боевыми искусствами для непобедимой комбинации."
	reference = "RPGD"
	item = /obj/item/clothing/gloves/fingerless/rapid
	cost = 40

/datum/uplink_item/dangerous/sword
	name = "Световой меч"
	desc = "Холодное оружие с большим уроном и лезвием из чистой энергии. Меч настолько мал, поэтому его можно положить в карман в неактивном состояние. При активации издается громкий и характерный звук. С большой вероятностью отражает лазерные снаряды."
	reference = "ES"
	item = /obj/item/melee/energy/sword/saber
	cost = 45 // SS220 EDIT PRICE UP/DOWN 40 -> 45

/datum/uplink_item/dangerous/dsword
	name = "Двухклинковый световой меч"
	desc = "Световой меч с двойным лезвием, что может быть ещё лучше? Наносит чуть больший урон, чем обычный энергетический меч. Автоматически отражает все виды лазерных снарядов. Ударяет нападавшего в ответ при ударе пользователя в режиме парирования."
	reference = "DSRD"
	item = /obj/item/dualsaber
	cost = 70 // SS220 EDIT PRICE UP/DOWN 15 -> 20

/datum/uplink_item/dangerous/snakefang
	name = "Змеиный Клык"
	desc = "Скимитар с раздвоенным вилкообразным наконечником. Меч не поместится в вашу сумку, но к нему прилагаются ножны, которые можно прикрепить на пояс."
	reference = "SF"
	item = /obj/item/storage/belt/sheath/snakesfang
	cost = 25

/datum/uplink_item/dangerous/powerfist
	name = "Силовой Кулак"
	desc = "Силовой кулак представляет собой металлическую перчатку со встроенным ударным поршнем, работающим от внешнего источника газа. При попадании в цель поршень выдвигается вперед и наносит серьезный урон, отталкивая цель. С помощью гаечного ключа вы сможете регулировать количество газа, расходуемого на удар, повышая наносимый урон и отталкивая цели с большей силой. С помощью отвертки можно снять баллон."
	reference = "PF"
	item = /obj/item/melee/powerfist
	cost = 60 // SS220 EDIT PRICE UP/DOWN 50 -> 60

/datum/uplink_item/dangerous/chainsaw
	name = "Бензопила"
	desc = "Чрезвычайно смертоносное и громкое оружие. Она не может храниться в рюкзаке и издает очень громкий шум, когда включена. Разрывает трупы на куски мяса, не оставляя ничего для клонирования. Заведя пилу, её более никто не сможет отнять у вас из-за очень удобной рукояти."
	reference = "CH"
	item = /obj/item/chainsaw/syndie
	cost = 70 // SS220 EDIT PRICE UP/DOWN 60 -> 70
	surplus = 0 // This has caused major problems with un-needed chainsaw massacres. Bwoink bait.
	excludefrom = list(UPLINK_TYPE_NUCLEAR)
	can_discount = FALSE // Too gamer.

/datum/uplink_item/dangerous/universal_gun_kit
	name = "Универсальный комплект для самостоятельной сборки винтовки"
	desc = "Универсальный набор сборки оружия, который можно комбинировать с любым набором для создания оружия. Для самостоятельной сборки используются встроенные шестигранные ключи, просто соедините наборы, нажав одним по другому."
	reference = "IKEA"
	item = /obj/item/weaponcrafting/gunkit/universal_gun_kit
	cost = 10 // SS220 EDIT PRICE UP/DOWN 20 -> 10

/datum/uplink_item/dangerous/batterer
	name ="Подавитель разума"
	desc = "Опасное устройство Синдиката, предназначенное для контроля толпы или организации беспорядков. Вызывает повреждение мозга, замешательство и другие неприятные эффекты у окружающих пользователя. Имеет 5 зарядов, перезарядка одной активации занимает 20 секунд."
	reference = "BTR"
	item = /obj/item/batterer
	cost = 25

/datum/uplink_item/dangerous/porta_turret
	name = "Портативная турель"
	desc = "Быстроразвёртывемая турель Синдиката, которая расстреляет любого кроме установившего её. После установки турель нельзя передвинуть."
	reference = "MIS"
	item = /obj/item/grenade/turret
	cost = 10 // SS220 EDIT PRICE UP/DOWN 20 -> 10

////////////////////////////////////////
// MARK: AMMUNITION
////////////////////////////////////////

/datum/uplink_item/ammo
	category = "Боеприпасы"
	surplus = 0 // Getting these in a discount or surplus is not a good time.
	can_discount = FALSE

/datum/uplink_item/ammo/pistol
	name = "Пистолетный магазин (10мм)"
	desc = "Дополнительный магазин на 8 патронов калибра 10 мм для пистолета Стечкина ФК-69 10мм, заряженный дешевыми патронами."
	reference = "10MM"
	item = /obj/item/ammo_box/magazine/m10mm
	cost = 2 // SS220 EDIT PRICE UP/DOWN 3 -> 2

/datum/uplink_item/ammo/pistolap
	name = "Пистолетный магазин (Бронебойные 10мм)"
	desc = "Дополнительный магазин на 8 патронов калибра 10 мм для пистолета Стечкина ФК-69 10мм, заряженный менее эффективными для ранения цели патронами, но более пробивающими защитную экипировку."
	reference = "10MMAP"
	item = /obj/item/ammo_box/magazine/m10mm/ap
	cost = 5 // SS220 EDIT PRICE UP/DOWN 6 -> 5

/datum/uplink_item/ammo/pistolfire
	name = "Пистолетный магазин (Зажигательные 10мм)"
	desc = "Дополнительный магазин на 8 патронов калибра 10 мм для пистолета Стечкина ФК-69 10мм, заряженный зажигательными патронами, которые поджигают цель."
	reference = "10MMFIRE"
	item = /obj/item/ammo_box/magazine/m10mm/fire
	cost = 10 // SS220 EDIT PRICE UP/DOWN 9 -> 10

/datum/uplink_item/ammo/pistolhp
	name = "Пистолетный магазин (10мм с полым наконечником)"
	desc = "Дополнительный магазин на 8 патронов калибра 10 мм для пистолета Стечкина ФК-69 10мм, заряженный патронами, которые наносят больший урон, но неэффективны против брони."
	reference = "10MMHP"
	item = /obj/item/ammo_box/magazine/m10mm/hp
	cost = 5 // SS220 EDIT PRICE UP/DOWN 7 -> 5

/datum/uplink_item/ammo/revolver
	name = "Револьверный быстрозарядник (.357)"
	desc = "быстрозарядник, содержащий семь дополнительных патронов калибра .357 Magnum для револьвера Синдиката. На тот случай, когда нужно больше, чем одна смерть..."
	reference = "357"
	item = /obj/item/ammo_box/a357
	cost = 15

////////////////////////////////////////
// MARK: STEALTHY WEAPONS
////////////////////////////////////////

/datum/uplink_item/stealthy_weapons
	category = "Скрытое и незаметное вооружение"

/datum/uplink_item/stealthy_weapons/garrote
	name = "Волоконная удавка"
	desc = "Отрезок волокнистой проволоки, зажатый между двумя деревянными рукоятками - идеальное оружие в руках осторожного убийцы. При использовании со спины, мгновенно захватывает цель и заставляет замолчать, а также вызывает быстрое удушение. Не работает на тех, кому не нужно дышать."
	item = /obj/item/garrote
	reference = "GAR"
	cost = 15 // SS220 EDIT PRICE UP/DOWN 30 -> 15

/datum/uplink_item/stealthy_weapons/cameraflash
	name = "Фотовспышка"
	desc = "Вспышка, замаскированная под фотоаппарат, с системой предотвращения перегорания. Имеет автоперезарядку до 5 активных зарядов. Вспышка полезна для того, чтобы ослепить и ошеломить окружающих или отдельных людей, не имеющих средств защиты глаз."
	reference = "CF"
	item = /obj/item/flash/cameraflash
	cost = 5

/datum/uplink_item/stealthy_weapons/throwingweapons
	name = "Коробка метательного оружия"
	desc = "Коробка с сюрикенами и усиленными болами. Очень эффективное метательное оружие: болы могут запутывать ноги жертвы, а сюрикены вонзаются в конечности."
	reference = "STK"
	item = /obj/item/storage/box/syndie_kit/throwing_weapons
	cost = 15

/datum/uplink_item/stealthy_weapons/edagger
	name = "Световой кинжал"
	desc = "Энергетический кинжал, который в выключенном состоянии выглядит и функционирует как ручка."
	reference = "EDP"
	item = /obj/item/pen/edagger
	cost = 10

/datum/uplink_item/stealthy_weapons/foampistol
	name = "Игрушечный пистолет (с оглушающими дротиками)"
	desc = "Безобидный на вид игрушечный пистолет, предназначенный для стрельбы пенопластовыми дротиками. Поставляется с дротиками класса Riot, которые истощают выносливость цели."
	reference = "FSPI"
	item = /obj/item/gun/projectile/automatic/toy/pistol/riot
	cost = 10 // SS220 EDIT PRICE UP/DOWN 15 -> 10
	surplus = 10

/datum/uplink_item/stealthy_weapons/false_briefcase
	name = "Портфель с фальшивым дном"
	desc = "Портфель со скрытым дном позволяющий хранить вещи среднего размера или меньше. Внутрь можно спрятать любое оружие, что позволит стрелять прямо из портфеля, не вытаскивая оружие. Открутите дно отверткой, вставьте оружие, и закрутите отверткой снова."
	reference = "FBBC"
	item = /obj/item/storage/briefcase/false_bottomed
	cost = 5 // SS220 EDIT PRICE UP/DOWN 10 -> 5

/datum/uplink_item/stealthy_weapons/soap
	name = "Мыло Синдиката"
	desc = "Кусок мыла подозрительного вида который очищает буквально всё за секунду. Окровавленное место убийства или отпечатки на оружие с этим мылом больше не страшны!"
	reference = "SOAP"
	item = /obj/item/soap/syndie
	cost = 5
	surplus = 50

/datum/uplink_item/stealthy_weapons/rsg
	name = "Скорострельный шприцемёт"
	desc = "Скорострельный шприцемёт Синдиката, способный автоматически наполнять шприцы из внутреннего резервуара для реагентов и выстреливать ими. В комплекте идут 7 пустых шприцев, максимальная вместимость оружия - 14 шприцев и 300 юнитов реагентов."
	reference = "RSG"
	item = /obj/item/gun/syringe/rapidsyringe/preloaded/half
	cost = 50 // SS220 EDIT PRICE UP/DOWN 60 -> 50

/datum/uplink_item/stealthy_weapons/poisonbottle
	name = "Бутылка с ядом"
	desc = "Синдикат поставит вам флакон с 40 юнитами случайно выбранного яда. Яд может быть как очень раздражительным для жертвы, так и невероятно смертельным."
	reference = "TPB"
	item = /obj/item/reagent_containers/glass/bottle/traitor
	cost = 10
	surplus = 0 // Requires another item to function.

/datum/uplink_item/stealthy_weapons/silencer
	name = "Универсальный глушитель"
	desc = "Глушитель для использования с любым малокалиберным оружием с нарезным стволом. Заглушает выстрелы, обеспечивая повышенную скрытность и превосходные возможности для засады. Слегка увеличивает размер оружия."
	reference = "US"
	item = /obj/item/suppressor
	cost = 5
	surplus = 10

/datum/uplink_item/stealthy_weapons/dehy_carp
	name = "Обезвоженный космический карп"
	desc = "Просто добавьте воды, и у вас получится свой собственный космический карп, враждебный ко всему на свете. Он выглядит как плюшевая игрушка. Первый, кто его сожмет, будет его папой, на которого он не нападет."
	reference = "DSC"
	item = /obj/item/toy/plushie/carpplushie/dehy_carp
	cost = 2 // SS220 EDIT PRICE UP/DOWN 4 -> 2

/datum/uplink_item/stealthy_weapons/knuckleduster
	name = "Синдикастет"
	desc = "Простое в использование и хорошо скрываемое оружие ближнего боя, предназначенное для забивания цели до смерти жестоким способом. Это оружие разработано специально для нанесения жертве серьезных повреждений органов."
	reference = "SKD"
	item = /obj/item/melee/knuckleduster/syndie
	cost = 5 // SS220 EDIT PRICE UP/DOWN 10 -> 5

////////////////////////////////////////
// MARK: GRENADES AND EXPLOSIVES
////////////////////////////////////////

/datum/uplink_item/explosives
	category = "Гранаты и взрывчатка"

/datum/uplink_item/explosives/plastic_explosives
	name = "Композитная взрывчатка"
	desc = "Одна из самых распространнёных пластичных композитных взрывчаток. Гарантированно уничтожает объект, на котором размещенна, в том числе и пол. Имеет настраиваемый таймер с минимальной задержкой до взрыва в 10 секунд. Отлично подходит для избавления от трупов..."
	reference = "C4"
	item = /obj/item/grenade/plastic/c4
	cost = 5

/datum/uplink_item/explosives/plastic_explosives_pack
	name = "Набор взрывчатки С4"
	desc = "Набор из 5 взрывчаток типа C-4 по более низкой цене. Самое то для саботажа."
	reference = "C4P"
	item = /obj/item/storage/box/syndie_kit/c4
	cost = 20

/datum/uplink_item/explosives/syndicate_minibomb
	name = "Минибомба Синдиката"
	desc = "Граната с пятисекундной задержкой перед взрывом. Кратно мощнее композитной взрывчатки."
	reference = "SMB"
	item = /obj/item/grenade/syndieminibomb
	cost = 20 // SS220 EDIT PRICE UP/DOWN 30 -> 20

/datum/uplink_item/explosives/frag_grenade
	name = "Осколочная граната"
	desc = "При взрыве разлетается бесчисленное множество осколков, которые поражают всех вокруг."
	reference = "FG"
	item = /obj/item/grenade/frag
	cost = 10

/datum/uplink_item/explosives/frag_grenade_pack
	name = "Набор осколочных гранат"
	desc = "Коробка с пятью осколочными гранатами. При взрыве разлетаются осколки, которые могут застрять в телах ближайших жертв. А жертв будет больше, чем МНОГО."
	reference = "FGP"
	item = /obj/item/storage/box/syndie_kit/frag_grenades
	cost = 40

/datum/uplink_item/explosives/pizza_bomb
	name = "Пицца-бомба"
	desc = "Коробка из-под пиццы, в которую вклеена бомба. Чтобы установить таймер, нужно открыть коробку. Если открыть ее еще раз, произойдет взрыв."
	reference = "PB"
	item = /obj/item/pizzabox/pizza_bomb
	cost = 15 // SS220 EDIT PRICE UP/DOWN 30 -> 15
	surplus = 80

/datum/uplink_item/explosives/atmosn2ogrenades
	name = "Усыпляющие газовые гранаты"
	desc = "Коробка с двумя гранатами, которые распыляют сонный газ на большой площади."
	reference = "ANG"
	item = /obj/item/storage/box/syndie_kit/atmosn2ogrenades
	cost = 40

/datum/uplink_item/explosives/emp
	name = "Набор Эми гранат с ЭМИ-имплантом"
	desc = "Коробка с двумя ЭМИ-гранатами и ЭМИ-имплантом на два применения. Пригодится, чтобы нарушить связь, вывести из строя энергетическое оружие и перегрузить боргов."
	reference = "EMPK"
	item = /obj/item/storage/box/syndie_kit/emp
	cost = 15 // SS220 EDIT PRICE UP/DOWN 10 -> 15

/datum/uplink_item/explosives/emp/New()
	..()
	if(HAS_TRAIT(SSstation, STATION_TRAIT_CYBERNETIC_REVOLUTION))
		cost *= 3

/datum/uplink_item/explosives/targrenade
	name = "Граната с липкой смолой"
	desc = "Граната, наполненная липкой смолой. При взрыве образуется облако дыма, которое покрывает смолой большую площадь, сильно замедляя движение преследователей. Идеальный вариант для побега."
	reference = "TARG"
	item = /obj/item/grenade/chem_grenade/tar
	cost = 5 // SS220 EDIT PRICE UP/DOWN 7 -> 5

////////////////////////////////////////
// MARK: STEALTHY TOOLS
////////////////////////////////////////

/datum/uplink_item/stealthy_tools
	category = "Предметы для скрытности и маскировки"

/datum/uplink_item/stealthy_tools/forgers_kit
	name = "Набор фальсификатора"
	desc = "Набор, состоящий из штампа и специальной ручки. Штамп может имитировать любую печать, в том числе и официальный штамп Nanotrasen, с помощью которого можно подделывать документы, а также использовать его в стиральной машине для создания радужной одежды. Входящая в набор ручка позволяет создавать поддельные подписи, что еще больше расширяет возможности."
	reference = "FGK"
	item = /obj/item/storage/box/syndie_kit/forgers_kit
	cost = 10
	surplus = 35

/datum/uplink_item/stealthy_tools/chameleonflag
	name = "Маскировочный флаг"
	desc = "Флаг, который можно замаскировать под любой другой. В древке есть потайное место, куда можно спрятать гранату или мини-бомбу, которая взорвется через некоторое время после поджёга флага."
	reference = "CHFLAG"
	item = /obj/item/flag/chameleon
	cost = 1
	surplus = 35

/datum/uplink_item/stealthy_tools/chamsechud
	name = "Маскировочный ИЛС СБ"
	desc = "Украденный ИЛС СБ с внедренной в него технологией маскировки «хамелеон» Синдиката. Подобно маскировочному комбинезону, ИЛС может превращаться в различные очки, сохраняя при этом свои функции."
	reference = "CHHUD"
	item = /obj/item/clothing/glasses/hud/security/chameleon
	cost = 5 // SS220 EDIT PRICE UP/DOWN 10 -> 5

/datum/uplink_item/stealthy_tools/thermal
	name = "Маскировочные термо-очки"
	desc = "Очки-тепловизоры со встроенной технологией «хамелеон» Синдиката. Они позволяют видеть организмы сквозь стены, улавливая верхнюю часть инфракрасного спектра, которую объекты излучают в виде тепла и света."
	reference = "THIG"
	item = /obj/item/clothing/glasses/chameleon/thermal
	cost = 15

/datum/uplink_item/stealthy_tools/night
	name = "Маскировочный ПНВ"
	desc = "Эти очки оснащены функцией ночного видения и технологией «хамелеон» Синдиката. Позволяют кратно лучше видеть в темноте."
	reference = "TNIG"
	item = /obj/item/clothing/glasses/chameleon/night
	cost = 5

/datum/uplink_item/stealthy_tools/agent_card
	name = "Идентификационная карта агента"
	desc = "Карта агента могжет копировать доступ с других идентификационных карт, суммируя его с уже полученными. По умолчанию, карта блокирует отслеживание носителя Искусстевенным интелектом через камеры, но не скрывает его."
	reference = "AIDC"
	item = /obj/item/card/id/syndicate
	cost = 5 // SS220 EDIT PRICE UP/DOWN 10 -> 5

/datum/uplink_item/stealthy_tools/chameleon_proj
	name = "Маскировочный проектор"
	desc = "Проецирует изображение на пользователя, маскируя его под отсканированный объект, пока он не выпустит проектор из рук или маскировки не коснуться. Пользователь в маскировке не может бежать, а снаряды пролетают сквозь него."
	reference = "CP"
	item = /obj/item/chameleon
	cost = 15 // SS220 EDIT PRICE UP/DOWN 25 -> 15

/datum/uplink_item/stealthy_tools/chameleon_counter
	name = "Маскировочный подделыватель"
	desc = "Это устройство маскируется под любой объект, который оно сканирует. Маскировка не идеальна, и наблюдатель может ее заметить."
	reference = "CC"
	item = /obj/item/chameleon_counterfeiter
	cost = 5 // SS220 EDIT PRICE UP/DOWN 10 -> 5

/datum/uplink_item/stealthy_tools/camera_bug
	name = "Камерный жучок"
	desc = "Позволяет просматривать изображение со всех камер в сети. Также в комплект входят 5 скрытых камер, которые можно закрепить на любом объекте и использовать для удаленного наблюдения."
	reference = "CB"
	item = /obj/item/storage/box/syndie_kit/camera_bug
	cost = 5
	surplus = 90

/datum/uplink_item/stealthy_tools/dnascrambler
	name = "Шифратор ДНК"
	desc = "Шприц с одной инъекцией, которая при использовании случайным образом полностью меняет внешний вид и имя."
	reference = "DNAS"
	item = /obj/item/dnascrambler
	cost = 5 // SS220 EDIT PRICE UP/DOWN 7 -> 5

/datum/uplink_item/stealthy_tools/smugglersatchel
	name = "Сумка контрабандиста"
	desc = "Эта сумка достаточно тонкая, чтобы ее можно было спрятать между полом и плиткой. В ней удобно прятать награбленное. В комплекте лом и напольная плитка."
	reference = "SMSA"
	item = /obj/item/storage/backpack/satchel_flat
	cost = 10
	surplus = 30

/datum/uplink_item/stealthy_tools/emplight
	name = "EMP Flashlight"
	desc = "Небольшой самозаряжающийся генератор ЭМИ излучения ближнего действия, замаскированный под фонарик. Пригодится для выведения из строя гарнитур, камер, КПБ и боргов во время скрытных операций."
	reference = "EMPL"
	item = /obj/item/flashlight/emp
	cost = 10 // SS220 EDIT PRICE UP/DOWN 20 -> 10
	surplus = 30

/datum/uplink_item/stealthy_tools/emplight/New()
	..()
	if(HAS_TRAIT(SSstation, STATION_TRAIT_CYBERNETIC_REVOLUTION))
		cost *= 2.5

/datum/uplink_item/stealthy_tools/cutouts
	name = "Адаптивные картонные фигуры"
	desc = "Эти адаптивные фигурки покрыты тонким слоем материала, который предотвращает выцветание и делает изображения более реалистичными. В наборе три таких фигурки и баллончик краски для изменения их внешнего вида."
	reference = "ADCC"
	item = /obj/item/storage/box/syndie_kit/cutouts
	cost = 1
	surplus = 20

/datum/uplink_item/stealthy_tools/safecracking
	name = "Набор для вскрытия сейфа"
	desc = "Все, что нужно, чтобы незаметно открыть механический сейф с кодовым замком."
	reference = "SCK"
	item = /obj/item/storage/box/syndie_kit/safecracking
	cost = 5
	surplus = 0 // Far too objective specific.

/datum/uplink_item/stealthy_tools/handheld_mirror
	name = "Ручное зеркало"
	desc = "Зеркало карманного размера. Позволяет мгновенно изменить цвет волос и черты лица, а также прическу."
	reference = "HM"
	item = /obj/item/handheld_mirror
	cost = 5

////////////////////////////////////////
// MARK: DEVICES AND TOOLS
////////////////////////////////////////

/datum/uplink_item/device_tools
	category = "Devices and Tools"
	abstract = 1

/datum/uplink_item/device_tools/emag
	name = "Cryptographic Sequencer"
	desc = "The cryptographic sequencer, also known as an emag, is a small card that unlocks hidden functions in electronic devices, subverts intended functions and characteristically breaks security mechanisms."
	reference = "EMAG"
	item = /obj/item/card/emag
	cost = 30

/datum/uplink_item/device_tools/access_tuner
	name = "Access Tuner"
	desc = "The access tuner is a small device that can interface with airlocks from range. It takes a few seconds to connect and can change the bolt state, open the door, or toggle emergency access."
	reference = "HACK"
	item = /obj/item/door_remote/omni/access_tuner
	cost = 20 // SS220 EDIT PRICE UP/DOWN 30 -> 20

/datum/uplink_item/device_tools/toolbox
	name = "Fully Loaded Toolbox"
	desc = "The syndicate toolbox is a suspicious black and red. Aside from tools, it comes with insulated gloves and a multitool."
	reference = "FLTB"
	item = /obj/item/storage/toolbox/syndicate
	cost = 5

/datum/uplink_item/device_tools/surgerybag
	name = "Syndicate Surgery Duffel Bag"
	desc = "The Syndicate surgery duffel bag comes with a full set of surgery tools, a straightjacket and a muzzle. The bag itself is also made of very light materials and won't slow you down while it is equipped."
	reference = "SSDB"
	item = /obj/item/storage/backpack/duffel/syndie/med/surgery
	cost = 5 // SS220 EDIT PRICE UP/DOWN 10 -> 5

/datum/uplink_item/device_tools/bonerepair
	name = "Prototype Nanite Autoinjector"
	desc = "Stolen prototype full body repair nanites. On injection it will shut down body systems as it revitilizes limbs and organs. Heals organics organs, cybernetic organs, and limbs to fully operational conditions."
	reference = "NCAI"
	item = /obj/item/reagent_containers/hypospray/autoinjector/nanocalcium
	cost = 5 // SS220 EDIT PRICE UP/DOWN 10 -> 5

/datum/uplink_item/device_tools/syndicate_teleporter
	name = "Experimental Syndicate Teleporter"
	desc = "The Syndicate teleporter is a handheld device that teleports the user 4-8 meters forward. \
			Beware, teleporting into a wall will make the teleporter do a parallel emergency teleport, \
			but if that emergency teleport fails, it will kill you. \
			Has 4 charges, recharges, warranty voided if exposed to EMP. \
			Comes with free chameleon mesons, to help you stay stylish while seeing through walls."
	reference = "TELE"
	item = /obj/item/storage/box/syndie_kit/teleporter
	cost = 50 // SS220 EDIT PRICE UP/DOWN 40 -> 50

/datum/uplink_item/device_tools/organ_extractor
	name = "Organ Extractor"
	desc = "A device that can remove organs or cybernetic implants from a target, and stores them inside. \
	Stored organs can be implanted into the user, or into other targets. Synthesizes chemicals to keep the organs fresh."
	reference = "OREX"
	item = /obj/item/organ_extractor
	cost = 10 // SS220 EDIT PRICE UP/DOWN 20 -> 10

/datum/uplink_item/device_tools/c_foam_launcher
	name = "C-Foam Launcher"
	desc = "A gun that shoots blobs of foam. Will block airlocks, and slow down humanoids. Not rated for xenomorph usage."
	reference = "CFOAM"
	item = /obj/item/gun/projectile/c_foam_launcher
	cost = 15 // SS220 EDIT PRICE UP/DOWN 25 -> 15

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
	cost = 10 // SS220 EDIT PRICE UP/DOWN 25 -> 10
	surplus = 75

/datum/uplink_item/device_tools/cipherkey
	name = "Syndicate Encryption Key"
	desc = "A key, that when inserted into a radio headset, allows you to listen to all station department channels as well as talk on an encrypted Syndicate channel."
	reference = "SEK"
	item = /obj/item/encryptionkey/syndicate
	cost = 5 //Nowhere near as useful as the Binary Key! // SS220 EDIT PRICE UP/DOWN 10 -> 5
	surplus = 75

/datum/uplink_item/device_tools/hacked_module
	name = "Hacked AI Upload Module"
	desc = "When used with an upload console, this module allows you to upload priority laws to an artificial intelligence. Be careful with their wording, as artificial intelligences may look for loopholes to exploit."
	reference = "HAI"
	item = /obj/item/ai_module/syndicate
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
	cost = 15 // SS220 EDIT PRICE UP/DOWN 20 -> 15

/datum/uplink_item/device_tools/decoy_nade
	name = "Decoy Grenade Kit"
	desc = "A box of five grenades that can be configured to reproduce many suspicious sounds at varying rates."
	reference = "DCY"
	item = /obj/item/storage/box/syndie_kit/decoy
	cost = 5 // SS220 EDIT PRICE UP/DOWN 20 -> 5

////////////////////////////////////////
// MARK: SPACE SUITS AND HARDSUITS
////////////////////////////////////////

/datum/uplink_item/suits
	category = "Space Suits and MODsuits"
	surplus = 10 //I am setting this to 10 as there are a bunch of modsuit parts in here that should be weighted to 10. Suits and modsuits adjusted below.

/datum/uplink_item/suits/space_suit
	name = "Syndicate Space Suit"
	desc = "This armoured red and black Syndicate space suit is less encumbering than Nanotrasen variants, \
			fits inside bags, and has a weapon slot. Comes packaged with internals. Nanotrasen crewmembers are trained to report red space suit \
			sightings, however. "
	reference = "SS"
	item = /obj/item/storage/box/syndie_kit/space
	cost = 15 // SS220 EDIT PRICE UP/DOWN 20 -> 15

/datum/uplink_item/suits/thermal
	name = "MODsuit Thermal Visor Module"
	desc = "A visor for a MODsuit. Lets you see living beings through walls. Also provides night vision."
	reference = "MSTV"
	item = /obj/item/mod/module/visor/thermal
	cost = 10 // Don't forget, you need to get a modsuit to go with this // SS220 EDIT PRICE UP/DOWN 15 -> 10

/datum/uplink_item/suits/night
	name = "MODsuit Night Visor Module"
	desc = "A visor for a MODsuit. Lets you see clearer in the dark."
	reference = "MSNV"
	item = /obj/item/mod/module/visor/night
	cost = 5 // It's night vision, rnd pumps out those goggles for anyone man.

/datum/uplink_item/suits/plate_compression
	name = "MODsuit Plate Compression Module"
	desc = "A MODsuit module that lets the suit compress into a smaller size. Not compatible with storage modules, \
	you will have to take that module out first."
	reference = "MSPC"
	item = /obj/item/mod/module/plate_compression
	cost = 5 // SS220 EDIT PRICE UP/DOWN 10 -> 5

/datum/uplink_item/suits/chameleon_module
	name = "MODsuit Chameleon Module"
	desc = "A module using chameleon technology to disguise an undeployed MODsuit as another object. Note: the disguise will not work once the MODsuit is deployed, but can be toggled again when retracted."
	reference = "MSCM"
	item = /obj/item/mod/module/chameleon
	cost = 5 // SS220 EDIT PRICE UP/DOWN 10 -> 5

/datum/uplink_item/suits/noslip
	name = "MODsuit Anti-Slip Module"
	desc = "A MODsuit module preventing the user from slipping on water. Already installed in the uplink MODsuits."
	reference = "MSNS"
	item = /obj/item/mod/module/noslip
	cost = 5

/datum/uplink_item/suits/springlock_module
	name = "Heavily Modified Springlock MODsuit Module"
	desc = "A module that spans the entire size of the MOD unit, sitting under the outer shell. \
		This mechanical exoskeleton pushes out of the way when the user enters and it helps in booting \
		up. While springlocks in older models were prone to \"snapping\" due to environmental humidity, \
		this version reacts solely to specific chemical triggers, such as smoke from grenades. \
		You know what it's like to have an entire exoskeleton enter you? \
		This version of the module has been modified to allow for near instant activation of the MODsuit. \
		Useful for quickly getting your MODsuit on/off, or for taking care of a target via a tragic accident. \
		It is hidden as a DNA lock module. It will block retraction for 10 seconds by default to allow you to follow \
		up with smoke, but you can multitool the module to disable that."
	reference = "FNAF"
	item = /obj/item/mod/module/springlock/bite_of_87
	cost = 5

/datum/uplink_item/suits/hidden_holster
	name = "Hidden Holster Module"
	desc = "A holster module disguised to look like a tether module. Requires a MODsuit to put it in of course. Gun not included."
	reference = "HHM"
	item = /obj/item/mod/module/holster/hidden
	cost = 5

/datum/uplink_item/suits/smoke_grenade
	name = "Smoke Grenade Module"
	desc = "A module that dispenses primed smoke grenades to disperse crowds."
	reference = "SGM"
	item = /obj/item/mod/module/dispenser/smoke
	cost = 5 // SS220 EDIT PRICE UP/DOWN 10 -> 5

////////////////////////////////////////
// MARK: IMPLANTS
////////////////////////////////////////

/datum/uplink_item/bio_chips
	category = "Bio-chips"

/datum/uplink_item/bio_chips/freedom
	name = "Freedom Bio-chip"
	desc = "A bio-chip injected into the body and later activated manually to break out of any restraints or grabs. Can be activated up to 4 times."
	reference = "FI"
	item = /obj/item/bio_chip_implanter/freedom
	cost = 20 // SS220 EDIT PRICE UP/DOWN 25 -> 20

/datum/uplink_item/bio_chips/protofreedom
	name = "Prototype Freedom Bio-chip"
	desc = "A prototype bio-chip injected into the body and later activated manually to break out of any restraints or grabs. Can only be activated a singular time."
	reference = "PFI"
	item = /obj/item/bio_chip_implanter/freedom/prototype
	cost = 5 // SS220 EDIT PRICE UP/DOWN 10 -> 5

/datum/uplink_item/bio_chips/storage
	name = "Storage Bio-chip"
	desc = "A bio-chip injected into the body, and later activated at the user's will. It will open a small subspace pocket capable of storing two items."
	reference = "ESI"
	item = /obj/item/bio_chip_implanter/storage
	cost = 30 // SS220 EDIT PRICE UP/DOWN 40 -> 30

/datum/uplink_item/bio_chips/mindslave
	name = "Mindslave Bio-chip"
	desc = "A box containing a bio-chip implanter filled with a mindslave bio-chip that when injected into another person makes them loyal to you and your cause, unless of course they're already implanted by someone else. Loyalty ends if the implant is no longer in their system."
	reference = "MI"
	item = /obj/item/bio_chip_implanter/traitor
	cost = 40 // SS220 EDIT PRICE UP/DOWN 50 -> 40

/datum/uplink_item/bio_chips/adrenal
	name = "Adrenal Bio-chip"
	desc = "A bio-chip injected into the body, and later activated manually to inject a chemical cocktail, which has a mild healing effect along with removing and reducing the time of all stuns and increasing movement speed. Can be activated up to 3 times."
	reference = "AI"
	item = /obj/item/bio_chip_implanter/adrenalin
	cost = 40

/datum/uplink_item/bio_chips/basic_adrenal
	name = "Basic-Adrenal Bio-chip"
	desc = "A single-use bio-chip injected into the body and later activated manually to inject a chemical cocktail. This one has a worse healing effect than regular adrenaline. It can be activated once for 3/4 of the effect of the original."
	reference = "BAI"
	item = /obj/item/bio_chip_implanter/basic_adrenalin
	cost = 15 // SS220 EDIT PRICE UP/DOWN 20 -> 15
	can_discount = FALSE

/datum/uplink_item/bio_chips/proto_adrenal
	name = "Proto-Adrenal Bio-chip"
	desc = "A old prototype of the Adrenalin implant, that grants the user 4 seconds of antistun, getting them back on their feet instantly once, but nothing more. Speed and healing sold separately."
	reference = "PAI"
	item = /obj/item/bio_chip_implanter/proto_adrenalin
	cost = 5 // SS220 EDIT PRICE UP/DOWN 10 -> 5

/datum/uplink_item/bio_chips/stealthimplant
	name = "Stealth Bio-chip"
	desc = "This one-of-a-kind implant will make you almost invisible if you play your cards right. \
			On activation, it will conceal you inside a chameleon cardboard box that is only revealed once someone bumps into it."
	reference = "SI"
	item = /obj/item/bio_chip_implanter/stealth
	cost = 45

////////////////////////////////////////
// MARK: CYBERNETICS
////////////////////////////////////////

/datum/uplink_item/cyber_implants
	category = "Cybernetic Implants"

/datum/uplink_item/cyber_implants/hackerman_deck
	name = "Binyat Wireless Hacking System Autoimplanter"
	desc = "This implant will allow you to wirelessly emag from a distance. However, it will slightly burn you \
	on use, and will be quite visual as you are emaging the object. \
	Will not show on unupgraded body scanners. Incompatible with the Qani-Laaca Sensory Computer."
	reference = "HKR"
	item = /obj/item/autosurgeon/organ/syndicate/oneuse/hackerman_deck
	cost = 15 // SS220 EDIT PRICE UP/DOWN 30 -> 15 // Probably slightly less useful than an emag with heat / cooldown, but I am not going to make it cheaper or everyone picks it over emag

/datum/uplink_item/cyber_implants/razorwire
	name = "Razorwire Spool Arm Implant Autoimplanter"
	desc = "A long length of monomolecular filament, built into the back of your hand. \
		Impossibly thin and flawlessly sharp, it should slice through organic materials with no trouble; \
		even from a few steps away. However, results against anything more durable will heavily vary."
	reference = "RZR"
	item = /obj/item/autosurgeon/organ/syndicate/oneuse/razorwire
	cost = 15 // SS220 EDIT PRICE UP/DOWN 20 -> 15

/datum/uplink_item/cyber_implants/scope_eyes
	name = "Hardened Kaleido Optics Eyes Autoimplanter"
	desc = "These cybernetic eye implants will let you zoom in on far away objects. \
	Many users find it disorienting, and find it hard to interact with things near them when active. \
	This pair has been hardened for special operations personnel."
	reference = "KOE"
	item = /obj/item/autosurgeon/organ/syndicate/oneuse/scope_eyes
	cost = 10

/datum/uplink_item/cyber_implants/mantis_kit
	name = "'Naginata' Mantis Blades Kit"
	desc = "A pair of devastating 'Naginata' concealable mantis blades, which retract into the arms of the user. \
	Their monomolecular edges will easily tear through flesh and armor alike, and can even pry open airlocks when used together. \
	When both blades are equipped, they enable the user to perform double attacks. \
	Can be used to parry incoming melee attacks."
	reference = "MBK"
	item = /obj/item/storage/box/syndie_kit/syndie_mantis
	cost = 35 // SS220 EDIT PRICE UP/DOWN 50 -> 35
	surplus = 0
	can_discount = FALSE
	excludefrom = list(UPLINK_TYPE_NUCLEAR)

////////////////////////////////////////
// MARK: POINTLESS BADASSERY
////////////////////////////////////////

/datum/uplink_item/badass
	category = "(Pointless) Badassery"
	surplus = 0

/datum/uplink_item/badass/pen
	name = "Syndicate Fountain Pen"
	desc = "A slick Syndicate-branded pen, to show everyone at the meeting that you mean business."
	reference = "PEN"
	item = /obj/item/pen/multi/syndicate
	cost = 1

/datum/uplink_item/badass/syndiecigs
	name = "Syndicate Smokes"
	desc = "Strong flavor, dense smoke, infused with omnizine."
	reference = "SYSM"
	item = /obj/item/storage/fancy/cigarettes/cigpack_syndicate
	cost = 7

/datum/uplink_item/badass/syndiecash
	name = "Syndicate Briefcase Full of Cash"
	desc = "A secure briefcase containing 600 space credits. Useful for bribing personnel, or purchasing goods and services at lucrative prices. \
	The briefcase also feels a little heavier to hold; it has been manufactured to pack a little bit more of a punch if your client needs some convincing."
	reference = "CASH"
	item = /obj/item/storage/secure/briefcase/syndie
	cost = 5

/datum/uplink_item/badass/balloon
	name = "For showing that you are The Boss"
	desc = "A useless red balloon with the syndicate logo on it, which can blow the deepest of covers."
	reference = "BABA"
	item = /obj/item/toy/syndicateballoon
	cost = 100
	can_discount = FALSE

/datum/uplink_item/badass/bomber
	name = "Syndicate Bomber Jacket"
	desc = "An awesome jacket to help you style on Nanotrasen with. The lining is made of a thin polymer to provide a small amount of armor. Does not provide any extra storage space."
	reference = "JCKT"
	item = /obj/item/clothing/suit/jacket/bomber/syndicate
	cost = 3

/datum/uplink_item/badass/tpsuit
	name = "Syndicate Two-Piece Suit"
	desc = "A snappy two-piece suit that any self-respecting Syndicate agent should wear. Perfect for professionals trying to go undetected, but moderately armored with experimental nanoweave in case things do get loud. Comes with two cashmere-lined pockets for maximum style and comfort."
	reference = "SUIT"
	item = /obj/item/clothing/suit/storage/iaa/blackjacket/armored
	cost = 3

/datum/uplink_item/badass/syndie_garments
	name = "Syndicate Garment Bag"
	desc = "A customised garment bag filled with all kinds of Syndicate attire, for the fashionable agent's needs. Proclaim your allegiance with style!"
	reference = "GRMT"
	item = /obj/item/storage/bag/garment/syndie
	cost = 5

////////////////////////////////////////
// MARK: BUNDLES AND TELECRYSTALS
////////////////////////////////////////

/datum/uplink_item/bundles_tc
	category = "Bundles and Telecrystals"
	surplus = 0
	can_discount = FALSE

/datum/uplink_item/bundles_tc/telecrystal
	name = "Raw Telecrystal"
	desc = "Telecrystal in its rawest and purest form; can be utilized on active uplinks to increase their telecrystal count."
	reference = "RTC"
	item = /obj/item/stack/telecrystal
	cost = 1

/datum/uplink_item/bundles_tc/telecrystal/five
	name = "5 Raw Telecrystals"
	desc = "Five telecrystals in their rawest and purest form; can be utilized on active uplinks to increase their telecrystal count."
	reference = "RTCF"
	item = /obj/item/stack/telecrystal/five
	cost = 5

/datum/uplink_item/bundles_tc/telecrystal/twenty
	name = "20 Raw Telecrystals"
	desc = "Twenty telecrystals in their rawest and purest form; can be utilized on active uplinks to increase their telecrystal count."
	reference = "RTCT"
	item = /obj/item/stack/telecrystal/twenty
	cost = 20

/datum/uplink_item/bundles_tc/telecrystal/fifty
	name = "50 Raw Telecrystals"
	desc = "Fifty telecrystals in their rawest and purest form; can be utilized on active uplinks to increase their telecrystal count."
	reference = "RTCB"
	item = /obj/item/stack/telecrystal/fifty
	cost = 50

/datum/uplink_item/bundles_tc/telecrystal/hundred
	name = "100 Raw Telecrystals"
	desc = "One-hundred telecrystals in their rawest and purest form; can be utilized on active uplinks to increase their telecrystal count."
	reference = "RTCH"
	item = /obj/item/stack/telecrystal/hundred
	cost = 100
