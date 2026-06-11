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
	name = "Пистолет Стечкина FK-69 10мм"
	reference = "SPI"
	desc = "Небольшой, легко скрываемый пистолет, использующий патроны калибра 10мм в магазинах на 8 патронов. Имеет \
			 резьбу на стволе для глушителя."
	item = /obj/item/gun/projectile/automatic/pistol
	cost = 20

/datum/uplink_item/dangerous/revolver
	name = "Револьвер Синдиката .357"
	reference = "SR"
	desc = "Предельно простой в использование револьвер Синдиката, стреляющий патронами калибра .357 Magnum и имеющий \
			барабан на 7 патрон. Поставляется с одним спидлоадером."
	item = /obj/item/storage/box/syndie_kit/revolver
	cost = 70 // SS220 EDIT PRICE UP/DOWN 65 -> 70
	surplus = 50

/datum/uplink_item/dangerous/rapid
	name = "Перчатки Полярной звезды"
	desc = "Перчатки позволяют пользователю с невероятной скоростью наносить удары, а также толкать, хватать \
			и даже гладить своих жертв. Не увеличивают скорость атаки оружием, но отлично сочетается с боевыми искусствами."
	reference = "RPGD"
	item = /obj/item/clothing/gloves/fingerless/rapid
	cost = 40

/datum/uplink_item/dangerous/sword
	name = "Энергомеч"
	desc = "Холодное оружие с большим уроном и лезвием из чистой энергии. Меч достаточно мал, поэтому его можно положить \
			 в карман в неактивном состоянии. При активации издается громкий и характерный звук."
	reference = "ES"
	item = /obj/item/melee/energy/sword/saber
	cost = 45 // SS220 EDIT PRICE UP/DOWN 40 -> 45

/datum/uplink_item/dangerous/dsword
	name = "Двойной энергомеч"
	desc = "Двухклинковый энергомеч, что может быть лучше? Наносит больший урон, чем обычный энергомеч, \
			отлично парирует удары и автоматически отражает лазерные снаряды."
	reference = "DSRD"
	item = /obj/item/dualsaber
	cost = 70 // SS220 EDIT PRICE UP/DOWN 15 -> 20

/datum/uplink_item/dangerous/snakefang
	name = "Змеиный Клык"
	desc = "Скимитар с раздвоенным вилкообразным наконечником. Меч не поместится в вашу сумку, но к нему прилагаются ножны, \
			 которые можно прикрепить на пояс."
	reference = "SF"
	item = /obj/item/storage/belt/sheath/snakesfang
	cost = 25

/datum/uplink_item/dangerous/powerfist
	name = "Силовой Кулак"
	desc = "Силовой кулак представляет собой металлическую перчатку со встроенным ударным поршнем, работающим от внешнего \
			 источника газа. При попадании в цель поршень выдвигается вперед и наносит серьезный урон, отталкивая цель. \
			 С помощью гаечного ключа вы сможете регулировать количество газа, расходуемого на удар, повышая наносимый \
			 урон и отталкивая цели с большей силой. С помощью отвертки можно снять баллон."
	reference = "PF"
	item = /obj/item/melee/powerfist
	cost = 60 // SS220 EDIT PRICE UP/DOWN 50 -> 60

/datum/uplink_item/dangerous/chainsaw
	name = "Бензопила"
	desc = "Чрезвычайно смертоносное и громкое оружие. Она не может храниться в рюкзаке и издает очень громкий шум, \
			 когда включена. Разрывает тела в клочья, оставляя после себя только жалкие куски мяса. \
			 Заведя пилу, её более никто не сможет отнять у вас из-за очень удобной рукояти."
	reference = "CH"
	item = /obj/item/chainsaw/syndie
	cost = 70 // SS220 EDIT PRICE UP/DOWN 60 -> 70
	surplus = 0 // This has caused major problems with un-needed chainsaw massacres. Bwoink bait.
	excludefrom = list(UPLINK_TYPE_NUCLEAR)
	can_discount = FALSE // Too gamer.

/datum/uplink_item/dangerous/universal_gun_kit
	name = "Универсальный комплект для самостоятельной сборки винтовки"
	desc = "Универсальный комплект, который можно комбинировать \
			с любым другим комплектом оружия из РНД для его создания. \
			Для самостоятельной сборки просто соедините комплекты друг с другом."
	reference = "IKEA"
	item = /obj/item/weaponcrafting/gunkit/universal_gun_kit
	cost = 10 // SS220 EDIT PRICE UP/DOWN 20 -> 10

/datum/uplink_item/dangerous/batterer
	name ="Подавитель разума"
	desc = "Опасное устройство Синдиката, предназначенное для контроля толпы или организации беспорядков. Вызывает повреждение \
			 мозга, замешательство и другие неприятные эффекты у окружающих пользователя. \
			 Имеет 5 зарядов, перезарядка одной активации занимает 20 секунд."
	reference = "BTR"
	item = /obj/item/batterer
	cost = 25

/datum/uplink_item/dangerous/porta_turret
	name = "Портативная турель"
	desc = "Быстроразвёртывемая турель Синдиката, которая расстреляет любого кроме установившего её. После установки турель \
			 нельзя передвинуть."
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
	desc = "Дополнительный магазин на 8 патронов калибра 10 мм для пистолета Стечкина FK-69 10мм, заряженный дешевыми патронами."
	reference = "10MM"
	item = /obj/item/ammo_box/magazine/m10mm
	cost = 2 // SS220 EDIT PRICE UP/DOWN 3 -> 2

/datum/uplink_item/ammo/pistolap
	name = "Пистолетный магазин (Бронебойные 10мм)"
	desc = "Дополнительный магазин на 8 патронов калибра 10 мм для пистолета Стечкина FK-69 10мм, заряженный менее эффективными \
			 для ранения цели патронами, но более пробивающими защитную экипировку."
	reference = "10MMAP"
	item = /obj/item/ammo_box/magazine/m10mm/ap
	cost = 5 // SS220 EDIT PRICE UP/DOWN 6 -> 5

/datum/uplink_item/ammo/pistolfire
	name = "Пистолетный магазин (Зажигательные 10мм)"
	desc = "Дополнительный магазин на 8 патронов калибра 10 мм для пистолета Стечкина FK-69 10мм, заряженный зажигательными \
			 патронами, которые поджигают цель."
	reference = "10MMFIRE"
	item = /obj/item/ammo_box/magazine/m10mm/fire
	cost = 10 // SS220 EDIT PRICE UP/DOWN 9 -> 10

/datum/uplink_item/ammo/pistolhp
	name = "Пистолетный магазин (10мм с полым наконечником)"
	desc = "Дополнительный магазин на 8 патронов калибра 10 мм для пистолета Стечкина FK-69 10мм, заряженный патронами, \
			 которые наносят больший урон, но неэффективны против брони."
	reference = "10MMHP"
	item = /obj/item/ammo_box/magazine/m10mm/hp
	cost = 5 // SS220 EDIT PRICE UP/DOWN 7 -> 5

/datum/uplink_item/ammo/revolver
	name = "Револьверный быстрозарядник (.357)"
	desc = "быстрозарядник, содержащий семь дополнительных патронов калибра .357 Magnum для револьвера Синдиката. \
			 На тот случай, когда нужно больше, чем одна смерть..."
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
	desc = "Отрезок волокнистой проволоки, зажатый между двумя деревянными рукоятками - идеальное оружие в руках \
			 осторожного убийцы. При использовании со спины, мгновенно захватывает цель и заставляет замолчать, \
			 а также вызывает быстрое удушение. Не работает на тех, кому не нужно дышать."
	item = /obj/item/garrote
	reference = "GAR"
	cost = 15 // SS220 EDIT PRICE UP/DOWN 30 -> 15

/datum/uplink_item/stealthy_weapons/cameraflash
	name = "Фотовспышка"
	desc = "Вспышка, замаскированная под фотоаппарат, с необычайно яркой вспышкой. Имеет автоперезарядку \
			до 5 активных зарядов. Бесполезна против боргов и лиц с индивидуальной защитой глаз."
	reference = "CF"
	item = /obj/item/flash/cameraflash
	cost = 5

/datum/uplink_item/stealthy_weapons/throwingweapons
	name = "Коробка метательного оружия"
	desc = "Коробка с сюрикенами и усиленными болами. Очень эффективное метательное оружие: болы могут запутывать ноги \
			 жертвы, а сюрикены вонзаются в конечности."
	reference = "STK"
	item = /obj/item/storage/box/syndie_kit/throwing_weapons
	cost = 15

/datum/uplink_item/stealthy_weapons/edagger
	name = "Энергокинжал"
	desc = "Энергетический кинжал, неотличимый от обычной ручки, пока не будет активирован."
	reference = "EDP"
	item = /obj/item/pen/edagger
	cost = 10

/datum/uplink_item/stealthy_weapons/foampistol
	name = "Игрушечный пистолет (с оглушающими дротиками)"
	desc = "Безобидный на вид игрушечный пистолет, предназначенный для стрельбы пенопластовыми дротиками. Поставляется \
			 с дротиками класса Riot, которые истощают выносливость цели."
	reference = "FSPI"
	item = /obj/item/gun/projectile/automatic/toy/pistol/riot
	cost = 10 // SS220 EDIT PRICE UP/DOWN 15 -> 10
	surplus = 10

/datum/uplink_item/stealthy_weapons/false_briefcase
	name = "Портфель с фальшивым дном"
	desc = "Портфель со скрытым дном позволяющий хранить вещи среднего размера или меньше. Внутрь можно спрятать любое \
			 оружие, что позволит стрелять прямо из портфеля, не вытаскивая оружие. \
			 Открутите дно отверткой, вставьте оружие, и закрутите отверткой снова."
	reference = "FBBC"
	item = /obj/item/storage/briefcase/false_bottomed
	cost = 5 // SS220 EDIT PRICE UP/DOWN 10 -> 5

/datum/uplink_item/stealthy_weapons/soap
	name = "Мыло Синдиката"
	desc = "Кусок мыла подозрительного вида который очищает буквально всё за секунду. Окровавленное место убийства или \
			 отпечатки на оружии с этим мылом больше не страшны!"
	reference = "SOAP"
	item = /obj/item/soap/syndie
	cost = 5
	surplus = 50

/datum/uplink_item/stealthy_weapons/rsg
	name = "Скорострельный шприцемёт"
	desc = "Скорострельный шприцемёт Синдиката, способный автоматически наполнять шприцы из внутреннего резервуара для \
			 реагентов и выстреливать ими. В комплекте идут 7 пустых шприцев, максимальная вместимость оружия - 14 шприцев и 300 юнитов реагентов."
	reference = "RSG"
	item = /obj/item/gun/syringe/rapidsyringe/preloaded/half
	cost = 50 // SS220 EDIT PRICE UP/DOWN 60 -> 50

/datum/uplink_item/stealthy_weapons/poisonbottle
	name = "Бутылка с ядом"
	desc = "Синдикат поставит вам флакон с 40 юнитами случайно выбранного яда. Яд может быть как очень раздражительным для \
			 жертвы, так и невероятно смертельным."
	reference = "TPB"
	item = /obj/item/reagent_containers/glass/bottle/traitor
	cost = 10
	surplus = 0 // Requires another item to function.

/datum/uplink_item/stealthy_weapons/silencer
	name = "Универсальный глушитель"
	desc = "Глушитель для использования с любым малокалиберным оружием с нарезным стволом. Заглушает выстрелы, обеспечивая \
			 повышенную скрытность и превосходные возможности для засады. Слегка увеличивает размер оружия."
	reference = "US"
	item = /obj/item/suppressor
	cost = 5
	surplus = 10

/datum/uplink_item/stealthy_weapons/dehy_carp
	name = "Обезвоженный космический карп"
	desc = "Просто добавьте воды, и у вас получится свой собственный космический карп, враждебный ко всему на свете. Он \
			 выглядит как плюшевая игрушка. Первый, кто его сожмет, будет его папой, на которого он не нападет."
	reference = "DSC"
	item = /obj/item/toy/plushie/carpplushie/dehy_carp
	cost = 2 // SS220 EDIT PRICE UP/DOWN 4 -> 2

/datum/uplink_item/stealthy_weapons/knuckleduster
	name = "Синдикастет"
	desc = "Простое в использование и хорошо скрываемое оружие ближнего боя, предназначенное для забивания цели до \
			 смерти жестоким способом. Это оружие разработано специально для нанесения жертве серьезных повреждений органов."
	reference = "SKD"
	item = /obj/item/melee/knuckleduster/syndie
	cost = 5 // SS220 EDIT PRICE UP/DOWN 10 -> 5

////////////////////////////////////////
// MARK: GRENADES AND EXPLOSIVES
////////////////////////////////////////

/datum/uplink_item/explosives
	category = "Гранаты и взрывчатка"

/datum/uplink_item/explosives/plastic_explosives
	name = "Композит С-4"
	desc = "Одна из самых распространнёных пластичных композитных взрывчаток. Гарантированно уничтожает объект, на \
			 котором размещенна, в том числе и пол. Имеет настраиваемый таймер с минимальной задержкой до взрыва в 10 секунд. \
			 Отлично подходит для уничтожения преград и ненужных тел с места преступления"
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
	desc = "Граната с пятисекундной задержкой. Кратно мощнее композитной взрывчатки."
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
	desc = "Коробка с пятью осколочными гранатами. При взрыве разлетаются осколки, которые могут застрять в телах ближайших \
			 жертв. А жертв будет больше, чем МНОГО."
	reference = "FGP"
	item = /obj/item/storage/box/syndie_kit/frag_grenades
	cost = 40

/datum/uplink_item/explosives/pizza_bomb
	name = "Пицца-бомба"
	desc = "Коробка из-под пиццы, в которую вклеена бомба. Чтобы установить таймер, нужно открыть коробку. Если открыть \
			 ее еще раз, произойдет взрыв."
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
	desc = "Коробка с двумя ЭМИ-гранатами и ЭМИ-имплантом на два применения. Пригодится, чтобы нарушить связь, вывести из строя \
			 энергетическое оружие и перегрузить боргов."
	reference = "EMPK"
	item = /obj/item/storage/box/syndie_kit/emp
	cost = 15 // SS220 EDIT PRICE UP/DOWN 10 -> 15

/datum/uplink_item/explosives/emp/New()
	..()
	if(HAS_TRAIT(SSstation, STATION_TRAIT_CYBERNETIC_REVOLUTION))
		cost *= 3

/datum/uplink_item/explosives/targrenade
	name = "Граната с липкой смолой"
	desc = "Граната, наполненная липкой смолой. При взрыве образуется облако дыма, которое покрывает смолой большую площадь, \
			 сильно замедляя движение преследователей. Идеальный вариант для побега."
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
	desc = "Набор, состоящий из штампа и специальной ручки. Штамп может имитировать любую печать, в том числе и официальный \
			 штамп Nanotrasen, с помощью которого можно подделывать документы. \
			 Входящая в набор ручка позволяет создавать поддельные подписи, что еще больше расширяет \
			  возможности. Предупреждение: Не забудьте выложить печать из кармана своего комбинезона перед стиркой!"
	reference = "FGK"
	item = /obj/item/storage/box/syndie_kit/forgers_kit
	cost = 10
	surplus = 35

/datum/uplink_item/stealthy_tools/chameleonflag
	name = "Флаг-хамелион"
	desc = "Флаг, который можно замаскировать под любой другой. В древке есть потайное место, куда можно спрятать гранату \
			 или мини-бомбу, которая взорвется через некоторое время, если поджечь флаг."
	reference = "CHFLAG"
	item = /obj/item/flag/chameleon
	cost = 1
	surplus = 35

/datum/uplink_item/stealthy_tools/chamsechud
	name = "HUD-хамелеон Службы Безопасности"
	desc = "Похищенная у Нанотрейзен и модернизированная Синдикатом технология системы головного интерфейса Службы Безопасности. \
			Как и комбинезон-хамелеон, может изменить свой внешний вид под любую пару очков, но при этом сохраняя свои функции."
	reference = "CHHUD"
	item = /obj/item/clothing/glasses/hud/security/chameleon
	cost = 5 // SS220 EDIT PRICE UP/DOWN 10 -> 5

/datum/uplink_item/stealthy_tools/thermal
	name = "Термальные хамелеон-очки"
	desc = "Очки-тепловизоры со встроенной технологией «хамелеон» Синдиката. Они позволяют видеть организмы сквозь стены, \
			 улавливая верхнюю часть инфракрасного спектра, которую объекты излучают в виде тепла и света."
	reference = "THIG"
	item = /obj/item/clothing/glasses/chameleon/thermal
	cost = 15

/datum/uplink_item/stealthy_tools/night
	name = "ПНВ-хамелеон"
	desc = "Эти очки оснащены функцией ночного видения и технологией «хамелеон» Синдиката. Позволяют кратно лучше видеть \
			 в темноте."
	reference = "TNIG"
	item = /obj/item/clothing/glasses/chameleon/night
	cost = 5

/datum/uplink_item/stealthy_tools/agent_card
	name = "Идентификационная карта агента"
	desc = "Идентификационная карта, блокирующая отслеживание пользователя посредством ИИ, а так же копирующая доступ \
			с других карт. Доступы накапливаются, поэтому при сканировании последующих карт, имеющиеся доступы не сотрутся."
	reference = "AIDC"
	item = /obj/item/card/id/syndicate
	cost = 5 // SS220 EDIT PRICE UP/DOWN 10 -> 5

/datum/uplink_item/stealthy_tools/chameleon_proj
	name = "Хамелеон-проектор"
	desc = "Проецирует изображение на пользователя, маскируя его под отсканированный объект, пока он не выпустит проектор \
			 из рук или маскировки не коснутся. Пользователь в маскировке не может бежать, а снаряды пролетают сквозь него."
	reference = "CP"
	item = /obj/item/chameleon
	cost = 15 // SS220 EDIT PRICE UP/DOWN 25 -> 15

/datum/uplink_item/stealthy_tools/chameleon_counter
	name = "Хамелеон-фальсификатор"
	desc = "Маскируется под любой отсканированный предмет. Копия не идеальна и может быть раскрыта при детальном осмотре."
	reference = "CC"
	item = /obj/item/chameleon_counterfeiter
	cost = 5 // SS220 EDIT PRICE UP/DOWN 10 -> 5

/datum/uplink_item/stealthy_tools/camera_bug
	name = "Камерный жучок"
	desc = "Позволяет просматривать изображение со всех камер в сети. Также в комплект входят 5 скрытых камер, которые \
			 можно закрепить на любом объекте и использовать для удаленного наблюдения."
	reference = "CB"
	item = /obj/item/storage/box/syndie_kit/camera_bug
	cost = 5
	surplus = 90

/datum/uplink_item/stealthy_tools/dnascrambler
	name = "Шифратор ДНК"
	desc = "Шприц с одной инъекцией, при использовании случайным образом полностью меняет внешний вид и имя."
	reference = "DNAS"
	item = /obj/item/dnascrambler
	cost = 5 // SS220 EDIT PRICE UP/DOWN 7 -> 5

/datum/uplink_item/stealthy_tools/smugglersatchel
	name = "Сумка контрабандиста"
	desc = "Эта сумка достаточно тонкая, чтобы ее можно было спрятать между полом и плиткой. В ней удобно прятать \
			 награбленное. В комплекте лом и напольная плитка."
	reference = "SMSA"
	item = /obj/item/storage/backpack/satchel_flat
	cost = 10
	surplus = 30

/datum/uplink_item/stealthy_tools/emplight
	name = "ЭМИ-вспышка"
	desc = "Небольшой самозаряжающийся электромагнитный излучатель излучения ближнего действия, замаскированный под фонарик. \
			 Пригодится для выведения из строя гарнитур, камер, КПБ и боргов во время скрытных операций."
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
	desc = "Эти адаптивные фигурки покрыты тонким слоем материала, который предотвращает выцветание. В наборе три таких \
			 фигурки и баллончик краски для изменения их внешнего вида."
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
	desc = "Карманное зеркальце, позволяющее мгновенно изменить цвет волос и черты лица, а также прическу."
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
	name = "Криптографический секвенсор"
	desc = "Криптографический секвенсор, также известный как «Emag», представляет собой небольшую карту, \
			 которая открывает доступ к скрытым функциям устройств, позволяет обойти предустановленные ограничения \
			  функций и взломать механизмы защиты."
	reference = "EMAG"
	item = /obj/item/card/emag
	cost = 30

/datum/uplink_item/device_tools/access_tuner
	name = "Настройщик доступа"
	desc = "Настройщик доступа — это небольшое устройство, которое может взаимодействовать с \
			 шлюзами на расстоянии. Подключение займёт несколько секунд, после чего можно будет \
			 управлять болтированием, открытием и аварийным доступом шлюза."
	reference = "HACK"
	item = /obj/item/door_remote/omni/access_tuner
	cost = 20 // SS220 EDIT PRICE UP/DOWN 30 -> 20

/datum/uplink_item/device_tools/toolbox
	name = "Подозрительный ящик для инструментов"
	desc = "Набор инструментов Синдиката черно-красного цвета. Помимо инструментов, в него входят стильные \
			 изоляционные перчатки и мультитул."
	reference = "FLTB"
	item = /obj/item/storage/toolbox/syndicate
	cost = 5

/datum/uplink_item/device_tools/surgerybag
	name = "Синди-мешок хирургических инструментов"
	desc = "В сумке находится полный набор хирургических инструментов, смирительная рубашка и намордник. \
			 Сама сумка также изготовлена из очень легких материалов и не будет мешать вам передвигаться, \
			 пока вы носите её на спине."
	reference = "SSDB"
	item = /obj/item/storage/backpack/duffel/syndie/med/surgery
	cost = 5 // SS220 EDIT PRICE UP/DOWN 10 -> 5

/datum/uplink_item/device_tools/bonerepair
	name = "Экспериментальный наноинъектор"
	desc = "Похищенный прототип нанитов тотального восстановления. После введения жизненные функции \
			организма будут приостановлены ради регенерации тканей. Полностью восстанавливает \
			работоспособность биологических и кибернетических органов, а также конечностей."
	reference = "NCAI"
	item = /obj/item/reagent_containers/hypospray/autoinjector/nanocalcium
	cost = 5 // SS220 EDIT PRICE UP/DOWN 10 -> 5

/datum/uplink_item/device_tools/syndicate_teleporter
	name = "Экспериментальный телепортер Синдиката"
	desc = "Телепортер Синдиката - это портативное устройство, которое переносит пользователя на 4-8 метров вперед. \
			 Будьте осторожны, телепортация в стену заставит телепортер выполнить экстренную телепортацию в сторону, \
			  но если эта экстренная телепортация не поможет, это разорвёт вас на куски. Имеет 4 заряда, самозарядный. \
			   Синдикат аннулирует гарантию при воздействии электромагнитного излучения! В комплект входят бесплатные \
			    мезонные очки с технологией «хамелеон» Синдиката, которые помогут вам оставаться стильным, видя сквозь стены."
	reference = "TELE"
	item = /obj/item/storage/box/syndie_kit/teleporter
	cost = 50 // SS220 EDIT PRICE UP/DOWN 40 -> 50

/datum/uplink_item/device_tools/organ_extractor
	name = "Система извлечения органов"
	desc = "Устройство, которое может извлекать органы или имплантаты из тела жертвы и хранить их внутри \
			 неограниченно долго, предотвращая гниение. Сохраненные органы могут быть имплантированы пользователю или другим жертвам."
	reference = "OREX"
	item = /obj/item/organ_extractor
	cost = 10 // SS220 EDIT PRICE UP/DOWN 20 -> 10

/datum/uplink_item/device_tools/c_foam_launcher
	name = "Распылитель вязкой пены"
	desc = "Оружие, стреляющий пеной. Блокирует воздушные шлюзы и замедляет врагов при попадание."
	reference = "CFOAM"
	item = /obj/item/gun/projectile/c_foam_launcher
	cost = 15 // SS220 EDIT PRICE UP/DOWN 25 -> 15

/datum/uplink_item/device_tools/tar_spray
	name = "Баллончик с липкой смолой"
	desc = "Флакон, который распыляет чрезвычайно вязкую смолу, что значительно замедляет движение любого проходящего \
			 по ней. Жидкости хватает на 10 распылений, и ее нельзя доливать повторно."
	reference = "TAR"
	item = /obj/item/reagent_containers/spray/sticky_tar
	cost = 10

/datum/uplink_item/device_tools/binary
	name = "Ключ бинарного перевода"
	desc = "Ключ шифрования для подключения к гарнитуре. Позволяет вам получить доступ к частоте передачи данных \
			 синтетическими формами жизни в двоичном формате. Чтобы разговаривать по двоичному каналу, введите :+ \
			  перед сообщением или хоткей И(B)."
	reference = "BITK"
	item = /obj/item/encryptionkey/binary
	cost = 10 // SS220 EDIT PRICE UP/DOWN 25 -> 10
	surplus = 75

/datum/uplink_item/device_tools/cipherkey
	name = "Ключ-Шифратор Синдиката"
	desc = "Ключ шифрования для подключения к гарнитуре. Позволяет вам прослушивать все каналы отделов станции, \
			 а также разговаривать по зашифрованному каналу Синдиката."
	reference = "SEK"
	item = /obj/item/encryptionkey/syndicate
	cost = 5 //Nowhere near as useful as the Binary Key! // SS220 EDIT PRICE UP/DOWN 10 -> 5
	surplus = 75

/datum/uplink_item/device_tools/hacked_module
	name = "Взломанный Модуль загрузки для ИИ"
	desc = "При использовании на консоли загрузки позволяет внедрить в ИИ приоритетные законы. \
			Будьте осторожны с формулировками: искусственный интеллект твёрдо следует букве законов, а не логике."
	reference = "HAI"
	item = /obj/item/ai_module/syndicate
	cost = 15

/datum/uplink_item/device_tools/powersink
	name = "Силовой модуль-поглотитель «Блэкаут»"
	desc = "При подключении к электросети и последующем включении это огромное устройство создает чрезмерную нагрузку \
			 на сеть, что приводит к отключению электроэнергии по всей станции. Устройство невозможно переносить \
			  из-за его больших размеров, но вы получите небольшой маячок, который при активации телепортирует \
			   Носить поглотитель с собой не получится"
	reference = "PS"
	item = /obj/item/beacon/syndicate/power_sink
	cost = 50

/datum/uplink_item/device_tools/singularity_beacon
	name = "Силовой Маяк"
	desc = "Будучи прикрученным к проводам с питанием от электросети и приведенным в действие, это большое \
			 устройство притягивает все действующие сингулярности к себе. Силовой Маяк не сможет притянуть сингулярность, \
			  если её удерживает защитный барьер . Из-за своих размеров его нельзя переносить. После оплаты, вы получите \
			   небольшой маячок, который при активации телепортирует Силовой Маяк в ваше местоположение."
	reference = "SNGB"
	item = /obj/item/beacon/syndicate
	cost = 10
	surplus = 0
	hijack_only = TRUE //This is an item only useful for a hijack traitor, as such, it should only be available in those scenarios.

/datum/uplink_item/device_tools/advpinpointer
	name = "Продвинутый целеуказатель"
	desc = "Пинпоинтер, который отслеживает любые заданные координаты, ДНК след, особо ценный предмет или диск \
			 ядерной аутентификации."
	reference = "ADVP"
	item = /obj/item/pinpointer/advpinpointer
	cost = 10
	can_discount = FALSE

/datum/uplink_item/device_tools/ai_detector
	name = "Детектор Искусственного Интеллекта" // changed name in case newfriends thought it detected disguised ai's
	desc = "Функциональный мультитул, который загорается красным при обнаружении наблюдения за владельцем со стороны ИИ станции."
	reference = "AID"
	item = /obj/item/multitool/ai_detect
	cost = 5

/datum/uplink_item/device_tools/jammer
	name = "Источник радиопомех"
	desc = "При включении будет блокировать все исходящие радиосообщения поблизости от вас, что затруднит их понимание."
	reference = "RJ"
	item = /obj/item/jammer
	cost = 15 // SS220 EDIT PRICE UP/DOWN 20 -> 15

/datum/uplink_item/device_tools/decoy_nade
	name = "Набор ложных гранат"
	desc = "Коробка из пяти гранат, каждая из которых может воспроизводить множество подозрительных звуков."
	reference = "DCY"
	item = /obj/item/storage/box/syndie_kit/decoy
	cost = 5 // SS220 EDIT PRICE UP/DOWN 20 -> 5

////////////////////////////////////////
// MARK: SPACE SUITS AND HARDSUITS
////////////////////////////////////////

/datum/uplink_item/suits
	category = "Космические и модульные скафандры"
	surplus = 10 //I am setting this to 10 as there are a bunch of modsuit parts in here that should be weighted to 10. Suits and modsuits adjusted below.

/datum/uplink_item/suits/space_suit
	name = "Космический скафандр Синдиката"
	desc = "Бронированный черно-красный скафандр. Легче аналогов НТ, складывается в рюкзаки, оснащен креплением \
			под оружие и встроенной системой дыхания. Внимание: корпоратские крысы обязаны сообщать СБ о появлении \
			фигур в красных скафандрах."
	reference = "SS"
	item = /obj/item/storage/box/syndie_kit/space
	cost = 15 // SS220 EDIT PRICE UP/DOWN 20 -> 15

/datum/uplink_item/suits/thermal
	name = "Термальный визор"
	desc = "Модифицированный визор для модульного скафандра, позволяющий видеть организмы сквозь стены, улавливая \
			верхнюю часть инфракрасного спектра, которую объекты излучают в виде тепла и света. Так же оснащен \
			технологией ночного видения."
	reference = "MSTV"
	item = /obj/item/mod/module/visor/thermal
	cost = 10 // Don't forget, you need to get a modsuit to go with this // SS220 EDIT PRICE UP/DOWN 15 -> 10

/datum/uplink_item/suits/night
	name = "Визор ночного видения"
	desc = "Модифицированный визор для модульного скафандра, позволяющий лучше видеть в темноте."
	reference = "MSNV"
	item = /obj/item/mod/module/visor/night
	cost = 5 // It's night vision, rnd pumps out those goggles for anyone man.

/datum/uplink_item/suits/plate_compression
	name = "Компрессор костюма"
	desc = "Модификация механизма модульного скафандра, позволяющая ему сжиматься до меньшего размера, \
			 несовместимо с модулями для хранения, поэтому сначала вам придется извлечь этот модуль."
	reference = "MSPC"
	item = /obj/item/mod/module/plate_compression
	cost = 5 // SS220 EDIT PRICE UP/DOWN 10 -> 5

/datum/uplink_item/suits/chameleon_module
	name = "Модуль-хамелеон"
	desc = "Модуль, использующий технологию «хамелеон» Синдиката для маскировки неактивированного \
			модульного скафандра под любые сумки и рюкзаки. Внимание: маскировка спадает при активации \
			скафандра, но может быть восстановлена после его сворачивания."
	reference = "MSCM"
	item = /obj/item/mod/module/chameleon
	cost = 5 // SS220 EDIT PRICE UP/DOWN 10 -> 5

/datum/uplink_item/suits/noslip
	name = "Противоскользящие подошвы"
	desc = "Модификация механизма модульного скафандра, дающее лучшее сцепление подошв на мокрых поверхностях. \
			По умолчанию установлены в мод-скафандры из аплинка."
	reference = "MSNS"
	item = /obj/item/mod/module/noslip
	cost = 5

/datum/uplink_item/suits/springlock_module
	name = "Экспериментальный модуль экстренного развёртывания"
	desc = "Модификация механизма модульного скафандра, которая занимает всё пространство под внешней оболочкой. \
			 Этот механический экзоскелет отодвигается в сторону, когда пользователь входит, и помогает при раскрытие. \
			 В старых прототипах была критическая неисправность, которую в новых моделях удалось сделать контролируемой. \
			 Вы знаете, каково это, быть пронизаным экзоскелетом? Эта версия модуля была изменена таким образом, чтобы обеспечить \
			 практически мгновенную активацию МОДсьюта. Он скрыт под модулем блокировки ДНК. По умолчанию он блокирует \
			 сворачивание на 10 секунд и почти моментально схлопыватеся при контакте с дымом. Вы можете перенастроить \
			 модуль мультитулом, отключив блокировку и уязвимость к дыму."
	reference = "FNAF"
	item = /obj/item/mod/module/springlock/bite_of_87
	cost = 5

/datum/uplink_item/suits/hidden_holster
	name = "Потайная кобура"
	desc = "Модификация механизма модульного скафандра, добавляющая в костюм потайную кобуру, замаскированную под \
			страховочный трос. Пистолет в сделку не входит."
	reference = "HHM"
	item = /obj/item/mod/module/holster/hidden
	cost = 5

/datum/uplink_item/suits/smoke_grenade
	name = "Модуль дымовых гранат"
	desc = "Модификация механизма модульного скафандра, оснащающая костюм дымовыми гранатами."
	reference = "SGM"
	item = /obj/item/mod/module/dispenser/smoke
	cost = 5 // SS220 EDIT PRICE UP/DOWN 10 -> 5

////////////////////////////////////////
// MARK: IMPLANTS
////////////////////////////////////////

/datum/uplink_item/bio_chips
	category = "Био-чип"

/datum/uplink_item/bio_chips/freedom
	name = "Био-чип свободы"
	desc = "Био-чип, вводимый инъекцией под кожу. Освобождает от любых оков и захватов при срабатывании. Имеет 4 заряда."
	reference = "FI"
	item = /obj/item/bio_chip_implanter/freedom
	cost = 20 // SS220 EDIT PRICE UP/DOWN 25 -> 20

/datum/uplink_item/bio_chips/protofreedom
	name = "Прототип био-чипа свободы"
	desc = "Прототип био-чипа, вводимый инъекцией под кожу. Освобождает от любых оков и захватов при срабатывании. \
			Имеет лишь один заряд - потратьте его с умом."
	reference = "PFI"
	item = /obj/item/bio_chip_implanter/freedom/prototype
	cost = 5 // SS220 EDIT PRICE UP/DOWN 10 -> 5

/datum/uplink_item/bio_chips/storage
	name = "Биочип хранилища"
	desc = "Био-чип, вводимый инъекцией под кожу. При активации откроет карманное хранилище, сжатое с помощью технологии \
			Редспейса до размеров био-чипа. Может хранить только два предмета."
	reference = "ESI"
	item = /obj/item/bio_chip_implanter/storage
	cost = 30 // SS220 EDIT PRICE UP/DOWN 40 -> 30

/datum/uplink_item/bio_chips/mindslave
	name = "Био-чип подчинения"
	desc = "Био-чип, вводимый инъекцией под кожу. При успешном введение, воля цели будет подавленна, а разум будет \
			подчиняться только вашим приказам, выполняя даже самые жестокие поручения."
	reference = "MI"
	item = /obj/item/bio_chip_implanter/traitor
	cost = 40 // SS220 EDIT PRICE UP/DOWN 50 -> 40

/datum/uplink_item/bio_chips/adrenal
	name = "Адреналиновый био-чип"
	desc = "Био-чип, вводимый инъекцией под кожу. Вводит смесь химических веществ, которые заживляют слабые раны, \
			избавляют организм от переутопления и оглушения, а так же увеличивают скорость передвижения. Доступно 3 стимуляции организма."
	reference = "AI"
	item = /obj/item/bio_chip_implanter/adrenalin
	cost = 40

/datum/uplink_item/bio_chips/basic_adrenal
	name = "Стандартный адреналиновый био-чип"
	desc = "Био-чип, вводимый инъекцией под кожу. Устаревшая вариация адреналинового био-чипа, вводящая лишь 3/4 \
			стимулирующей смеси и лишь 1 раз."
	reference = "BAI"
	item = /obj/item/bio_chip_implanter/basic_adrenalin
	cost = 15 // SS220 EDIT PRICE UP/DOWN 20 -> 15
	can_discount = FALSE

/datum/uplink_item/bio_chips/proto_adrenal
	name = "Прототип адреналинового био-чипа"
	desc = "Прототип био-чипа, вводимый инъекцией под кожу. Является самой слабой версией из доступной линейки \
			адреналиновых биочипов. Вещество внутри действует крайне ограниченное время и способно лишь облегчить страдания от переутомления на 1 раз."
	reference = "PAI"
	item = /obj/item/bio_chip_implanter/proto_adrenalin
	cost = 5 // SS220 EDIT PRICE UP/DOWN 10 -> 5

/datum/uplink_item/bio_chips/stealthimplant
	name = "Био-чип скрытности"
	desc = "Био-чип, вводимый инъекцией под кожу. Единственный в своём роде био-чип, который способен укрыть \
			пользователя в невидимой, но осязаемой и очень хрупкой картонной коробке."
	reference = "SI"
	item = /obj/item/bio_chip_implanter/stealth
	cost = 45

////////////////////////////////////////
// MARK: CYBERNETICS
////////////////////////////////////////

/datum/uplink_item/cyber_implants
	category = "Кибернетические импланты"

/datum/uplink_item/cyber_implants/hackerman_deck
	name = "Беспроводная хакерская система Binyat"
	desc = "Автоимплантер, содержащий хакерскую систему Binyat. Позволяет выполнять в злом как «Emag», но на расстояние. \
			При взломе, Система сильно греется, незначительно обжигая ваш мозг. Несовместим с любыми модификациями мозга."
	reference = "HKR"
	item = /obj/item/autosurgeon/organ/syndicate/oneuse/hackerman_deck
	cost = 15 // SS220 EDIT PRICE UP/DOWN 30 -> 15 // Probably slightly less useful than an emag with heat / cooldown, but I am not going to make it cheaper or everyone picks it over emag

/datum/uplink_item/cyber_implants/razorwire
	name = "Катушка с моноструной"
	desc = "Автоимплантер, содержащий катушку с моноструной. Двухметровая моноструна, вживляемая в тыльную сторону ладони. \
			Тонкая, острая и очень длинная, что позволяет ей резать цели на расстояние. С прорезанием прочной брони будут \
			серьёзные проблемы."
	reference = "RZR"
	item = /obj/item/autosurgeon/organ/syndicate/oneuse/razorwire
	cost = 15 // SS220 EDIT PRICE UP/DOWN 20 -> 15

/datum/uplink_item/cyber_implants/scope_eyes
	name = "Экранированные глаза Kaleido Optics"
	desc = "Автоимплантер, содержащий экранированные глаза Kaleido Optics. Позволяют приближать дальние объекты. \
			Использование их для рассмотрения ближайших объектов может вызывать дезориентацию"
	reference = "KOE"
	item = /obj/item/autosurgeon/organ/syndicate/oneuse/scope_eyes
	cost = 10

/datum/uplink_item/cyber_implants/mantis_kit
	name = "Набор клинков Богомола Naginata"
	desc = "Два автоимплантера, содержащие клинки Богомола Naginata. Их тонкие лезвия легко пробивают плоть и броню, \
			а при использовании одновременно обоих лезвий могут даже раздвигать шлюзы или выполнять двойные удары. \
			Позволяют парировать атаки в ближнем бою."
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
	category = "(Бесполезные) Крутые вещи"
	surplus = 0

/datum/uplink_item/badass/pen
	name = "Авторучка Синдиката"
	desc = "Изящная ручка с логотипом Синдиката. Показатель статуса."
	reference = "PEN"
	item = /obj/item/pen/multi/syndicate
	cost = 1

/datum/uplink_item/badass/syndiecigs
	name = "Сигареты Синдиката"
	desc = "Пафосные чёрно-красные сигареты с привкусом Омнизина."
	reference = "SYSM"
	item = /obj/item/storage/fancy/cigarettes/cigpack_syndicate
	cost = 7

/datum/uplink_item/badass/syndiecash
	name = "Чемодан полный налички"
	desc = "Надёжный и модный кейс, в котором есть 600 кредитов для подкупа разного рода персонала. \
			Кейс довольно увесистый, поэтому подходит и для альтернативного аргумента кредитам."
	reference = "CASH"
	item = /obj/item/storage/secure/briefcase/syndie
	cost = 5

/datum/uplink_item/badass/balloon
	name = "Показать, кто здесь Папочка"
	desc = "Не самый полезный красный воздушный шарик с логотипом Синдиката"
	reference = "BABA"
	item = /obj/item/toy/syndicateballoon
	cost = 100
	can_discount = FALSE

/datum/uplink_item/badass/bomber
	name = "Куртка Синдиката"
	desc = "Стильная куртка с прокладкой из полимера, защищающая от небольших повреждений."
	reference = "JCKT"
	item = /obj/item/clothing/suit/jacket/bomber/syndicate
	cost = 3

/datum/uplink_item/badass/tpsuit
	name = "Костюм-двойка Синдиката"
	desc = "Не менее стильный костюм, который обязателен к ношению всеми агентами Синдиката. В него вшиты два кармана для малых вещей."
	reference = "SUIT"
	item = /obj/item/clothing/suit/storage/iaa/blackjacket/armored
	cost = 3

/datum/uplink_item/badass/syndie_garments
	name = "Чехол для одежды"
	desc = "Продемонстрируйте свою приверженность стилю с помощью этого комплекта всевозможной одежды Синдиката!"
	reference = "GRMT"
	item = /obj/item/storage/bag/garment/syndie
	cost = 5

////////////////////////////////////////
// MARK: BUNDLES AND TELECRYSTALS
////////////////////////////////////////

/datum/uplink_item/bundles_tc
	category = "Комплекты и телекристаллы"
	surplus = 0
	can_discount = FALSE

/datum/uplink_item/bundles_tc/telecrystal
	name = "Очищенный телекристалл"
	desc = "Телекристалл в его чистом виде."
	reference = "RTC"
	item = /obj/item/stack/telecrystal
	cost = 1

/datum/uplink_item/bundles_tc/telecrystal/five
	name = "5 очищенных телекристаллов"
	desc = "Пять чистых телекристаллов."
	reference = "RTCF"
	item = /obj/item/stack/telecrystal/five
	cost = 5

/datum/uplink_item/bundles_tc/telecrystal/twenty
	name = "20 очищенных телекристаллов"
	desc = "Двадцать чистых телекристаллов."
	reference = "RTCT"
	item = /obj/item/stack/telecrystal/twenty
	cost = 20

/datum/uplink_item/bundles_tc/telecrystal/fifty
	name = "50 очищенных телекристаллов"
	desc = "Пятьдесят чистых телекристаллов."
	reference = "RTCB"
	item = /obj/item/stack/telecrystal/fifty
	cost = 50

/datum/uplink_item/bundles_tc/telecrystal/hundred
	name = "100 очищенных телекристаллов"
	desc = "Сто чистых телекристаллов."
	reference = "RTCH"
	item = /obj/item/stack/telecrystal/hundred
	cost = 100
