/datum/job/donor/administrator
	title = "Administrator"
	ru_title = "Сервис-Администратор"
	outfit = /datum/outfit/job/donor/administrator

/datum/outfit/job/donor/administrator
	name = "Сервис-Администратор"
	jobtype = /datum/job/donor/administrator

	uniform = /obj/item/clothing/under/rank/procedure/iaa
	suit = /obj/item/clothing/suit/storage/iaa/blackjacket
	shoes = /obj/item/clothing/shoes/laceup
	head = /obj/item/clothing/head/fez
	gloves = /obj/item/clothing/gloves/color/white
	belt = /obj/item/storage/belt/fannypack/black
	glasses = /obj/item/clothing/glasses/regular
	backpack_contents = list(
		/obj/item/clothing/under/rank/procedure/lawyer/black = 1,
		/obj/item/clothing/under/misc/waiter = 1,
		/obj/item/eftpos = 1,
		/obj/item/clipboard = 1,
		/obj/item/reagent_containers/glass/rag = 1,
	)


/datum/job/donor/tourist_tsf
	title = "Tourist TSF"
	ru_title = "Турист ТСФ"
	outfit = /datum/outfit/job/donor/tourist_tsf

/datum/outfit/job/donor/tourist_tsf
	name = "Турист ТСФ"
	jobtype = /datum/job/donor/tourist_tsf

	uniform = /obj/item/clothing/under/solgov
	suit = /obj/item/clothing/suit/hooded/hoodie/blue
	shoes = /obj/item/clothing/shoes/combat
	head = /obj/item/clothing/head/soft/solgov/marines
	belt = /obj/item/storage/belt/fannypack/black
	gloves = /obj/item/clothing/gloves/fingerless
	backpack_contents = list(
		/obj/item/clothing/under/pants/shorts/blue  = 1,
	)
	///obj/item/radio/headset/ert/alt/solgov


/datum/job/donor/tourist_ussp
	title = "Tourist USSP"
	ru_title = "Турист ССП"
	outfit = /datum/outfit/job/donor/tourist_ussp

/datum/outfit/job/donor/tourist_ussp
	name = "Турист ССП"
	jobtype = /datum/job/donor/tourist_ussp

	uniform = /obj/item/clothing/under/new_soviet
	suit = /obj/item/clothing/suit/sovietcoat
	shoes = /obj/item/clothing/shoes/combat
	head = /obj/item/clothing/head/sovietsidecap
	gloves = /obj/item/clothing/gloves/fingerless
	glasses = /obj/item/clothing/glasses/sunglasses/big
	backpack_contents = list(
		/obj/item/clothing/under/pants/shorts/red = 1,
		/obj/item/clothing/head/ushanka = 1,
	)
	///obj/item/radio/headset/soviet


/datum/job/donor/manager_janitor
	title = "Manager Janitor"
	ru_title = "Менеджер по Клинингу"
	access = list(ACCESS_JANITOR, ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_JANITOR, ACCESS_MAINT_TUNNELS)
	alt_titles = list("Ловец Крыс")
	outfit = /datum/outfit/job/donor/manager_janitor

/datum/outfit/job/donor/manager_janitor
	name = "Менеджер по Клинингу"
	jobtype = /datum/job/donor/manager_janitor

	uniform = /obj/item/clothing/under/rank/civilian/janitor
	suit = /obj/item/clothing/suit/apron/overalls
	shoes = /obj/item/clothing/shoes/galoshes/dry/lightweight
	gloves = /obj/item/clothing/gloves/color/purple
	mask = /obj/item/clothing/mask/bandana/purple
	head = /obj/item/clothing/head/soft/purple
	belt = /obj/item/storage/belt/janitor/full
	l_ear = /obj/item/radio/headset/headset_service
	id = /obj/item/card/id/janitor
	pda = /obj/item/pda/janitor
	r_pocket = /obj/item/door_remote/janikeyring
	backpack_contents = list(
		/obj/item/clothing/head/beret/purple_normal = 1,
		/obj/item/clothing/suit/storage/iaa/purplejacket = 1,
		/obj/item/clipboard = 1,
	)


/datum/job/donor/apprentice
	title = "Apprentice"
	ru_title = "Подмастерье"
	outfit = /datum/outfit/job/donor/apprentice

/datum/outfit/job/donor/apprentice
	name = "Подмастерье"
	jobtype = /datum/job/donor/apprentice

	uniform = /obj/item/clothing/under/color/grey
	suit = /obj/item/clothing/suit/apron/overalls
	back = /obj/item/storage/backpack
	shoes = /obj/item/clothing/shoes/workboots
	mask = /obj/item/clothing/mask/gas
	head = /obj/item/clothing/head/soft/grey
	belt = /obj/item/storage/belt/fannypack/white
	gloves = /obj/item/clothing/gloves/color/grey
	l_hand = /obj/item/storage/toolbox/mechanical
	r_hand = /obj/item/flag/grey

	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/clothing/head/welding = 1,
		/obj/item/flashlight = 1,
		/obj/item/clothing/under/pants/shorts/grey = 1,
	)


/datum/job/donor/guard
	title = "Guard"
	ru_title = "Охранник Шестерочки"
	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_BAR, ACCESS_MAINT_TUNNELS, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM)
	outfit = /datum/outfit/job/donor/guard

/datum/outfit/job/donor/guard
	name = "Охранник Шестерочки"
	jobtype = /datum/job/donor/guard

	uniform = /obj/item/clothing/under/rank/civilian/bartender
	suit = /obj/item/clothing/suit/armor/vest/old	// с замедлением
	belt = /obj/item/melee/classic_baton
	shoes = /obj/item/clothing/shoes/jackboots/noisy
	head = /obj/item/clothing/head/bowlerhat
	l_ear = /obj/item/radio/headset/headset_service
	glasses = /obj/item/clothing/glasses/sunglasses/reagent
	id = /obj/item/card/id/bartender
	pda = /obj/item/pda/bar
	backpack_contents = list(
		/obj/item/clothing/suit/jacket/leather = 1,
		)


/datum/job/donor/migrant
	title = "Migrant"
	ru_title = "Мигрант"
	outfit = /datum/outfit/job/donor/migrant

/datum/outfit/job/donor/migrant
	name = "Мигрант"
	jobtype = /datum/job/donor/migrant

	uniform = /obj/item/clothing/under/costume/pirate_rags
	suit = /obj/item/clothing/suit/poncho
	shoes = /obj/item/clothing/shoes/sandal
	head = /obj/item/clothing/head/sombrero
	mask = /obj/item/clothing/mask/fakemoustache
	belt = /obj/item/storage/belt/fannypack/orange
	backpack_contents = list(
		/obj/item/reagent_containers/food/drinks/bottle/tequila = 1,
		/obj/item/reagent_containers/food/snacks/taco = 6,
		/obj/item/reagent_containers/food/snacks/nachos = 3,
		/obj/item/reagent_containers/food/snacks/cheesenachos = 3,
		/obj/item/reagent_containers/food/snacks/cubannachos = 3,
		/obj/item/clothing/suit/poncho/red = 1,
		/obj/item/clothing/suit/poncho/green = 1,
		)


/datum/job/donor/uncertain
	title = "Uncertain"
	ru_title = "Забытый Ассистент"
	outfit = /datum/outfit/job/donor/uncertain

/datum/outfit/job/donor/uncertain
	name = "Забытый Ассистент"
	jobtype = /datum/job/donor/uncertain

	uniform = /obj/item/clothing/under/costume/kilt
	suit = /obj/item/clothing/suit/mantle/old
	shoes = /obj/item/clothing/shoes/sandal
	head = /obj/item/clothing/head/beanie/yellow
	glasses = /obj/item/clothing/glasses/eyepatch
	mask = /obj/item/clothing/mask/cigarette/pipe/cobpipe
	backpack_contents = list(
		/obj/item/reagent_containers/food/drinks/bottle/vodka = 1,
		/obj/item/storage/fancy/cigarettes/cigpack_random = 2,
		/obj/item/reagent_containers/food/snacks/doshik = 3,
		/obj/item/reagent_containers/food/snacks/doshik_spicy = 3,
		/obj/item/clothing/head/flatcap = 1,
		/obj/item/clothing/suit/browntrenchcoat = 1,
		/obj/item/clothing/accessory/horrible = 1,
		/obj/item/clothing/under/costume/pirate_rags = 1,
		/obj/item/clothing/head/cowboyhat = 1,
		)
