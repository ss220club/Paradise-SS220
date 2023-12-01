/datum/job/donor/barber
	title = "Barber"
	ru_title = "Парикмахер"
	outfit = /datum/outfit/job/donor/barber

/datum/outfit/job/donor/barber
	name = "Парикмахер"
	jobtype = /datum/job/donor/barber

	uniform = /obj/item/clothing/under/rank/civilian/barber
	shoes = /obj/item/clothing/shoes/laceup
	head = /obj/item/clothing/head/boaterhat
	backpack_contents = list(
		/obj/item/storage/box/barber = 1,
	)


/datum/job/donor/bath
	title = "Bath"
	ru_title = "Банщик"
	outfit = /datum/outfit/job/donor/bath

/datum/outfit/job/donor/bath
	name = "Банщик"
	jobtype = /datum/job/donor/bath

	uniform = /obj/item/clothing/under/costume/pirate_rags
	suit = /obj/item/clothing/suit/mantle
	shoes = /obj/item/clothing/shoes/sandal
	glasses = /obj/item/clothing/glasses/goggles
	backpack_contents = list(
		/obj/item/clothing/under/pants/white = 5,
		/obj/item/clothing/head/beanie = 1,
		/obj/item/clothing/head/beanie/black = 1,
		/obj/item/clothing/head/beanie/red = 1,
		/obj/item/clothing/head/beanie/green = 1,
		/obj/item/clothing/head/beanie/darkblue = 1,
		/obj/item/clothing/head/beanie/purple = 1,
		/obj/item/clothing/head/beanie/yellow = 1,
		/obj/item/clothing/head/beanie/cyan = 1,
		/obj/item/clothing/head/beanie/orange = 5,
	)


/datum/job/donor/casino
	title = "Casino"
	ru_title = "Крупье"
	outfit = /datum/outfit/job/donor/casino

/datum/outfit/job/donor/casino
	name = "Крупье"
	jobtype = /datum/job/donor/casino

	uniform = /obj/item/clothing/under/rank/procedure/iaa/purple
	suit = /obj/item/clothing/suit/storage/iaa/purplejacket
	shoes = /obj/item/clothing/shoes/laceup
	belt = /obj/item/storage/belt/fannypack/purple
	backpack_contents = list(
		/obj/item/storage/bag/money = 1,
		/obj/item/coin/twoheaded = 1,
		/obj/item/coin/gold = 2,
		/obj/item/coin/silver = 4,
		/obj/item/coin/iron = 8,
		/obj/item/eftpos = 1,
	)

/datum/job/donor/waiter
	title = "Waiter"
	ru_title = "Официант"
	outfit = /datum/outfit/job/donor/waiter
	relate_job = "Chef"

/datum/outfit/job/donor/waiter
	name = "Официант"
	jobtype = /datum/job/donor/waiter

	uniform = /obj/item/clothing/under/misc/waiter
	suit = /obj/item/clothing/suit/storage/iaa/blackjacket
	shoes = /obj/item/clothing/shoes/laceup
	head = /obj/item/clothing/head/fez
	belt = /obj/item/storage/belt/fannypack/blue
	backpack_contents = list(
		/obj/item/eftpos = 1,
		/obj/item/clipboard = 1,
		/obj/item/reagent_containers/glass/rag = 1,
	)


/datum/job/donor/acolyte
	title = "Acolyte"
	ru_title = "Послушник"
	outfit = /datum/outfit/job/donor/acolyte
	relate_job = "Chaplain"

/datum/outfit/job/donor/acolyte
	name = "Послушник"
	jobtype = /datum/job/donor/acolyte

	uniform = /obj/item/clothing/under/suit/victsuit
	suit = /obj/item/clothing/suit/hooded/monk
	shoes = /obj/item/clothing/shoes/black
	r_hand = /obj/item/storage/bag/garment/chaplain


/datum/job/donor/courier
	title = "Courier"
	ru_title = "Курьер"
	alt_titles = list("Почтальон", "Доставщик")
	outfit = /datum/outfit/job/donor/courier

/datum/outfit/job/donor/courier
	name = "Курьер"
	jobtype = /datum/job/donor/courier

	uniform = /obj/item/clothing/under/misc/overalls
	shoes = /obj/item/clothing/shoes/workboots
	head = /obj/item/clothing/head/soft
	r_hand = /obj/item/mail_scanner
	belt = /obj/item/storage/belt/fannypack/orange
	r_pocket = /obj/item/storage/bag/mail
	backpack_contents = list(
		/obj/item/eftpos = 1,
		/obj/item/clipboard = 1,
	)



/datum/outfit/job/donor/courier/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(H.mind && H.mind.role_alt_title)
		switch(H.mind.role_alt_title)
			if("Почтальон")
				uniform = /obj/item/clothing/under/misc/mailman
				shoes = /obj/item/clothing/shoes/laceup
				head = /obj/item/clothing/head/mailman
			if("Доставщик")
				uniform = /obj/item/clothing/under/rank/cargo/deliveryboy
				head = /obj/item/clothing/head/soft/deliverysoft


/datum/job/donor/wrestler
	title = "Wrestler"
	ru_title = "Борец"
	outfit = /datum/outfit/job/donor/wrestler
	alt_titles = list("Рефери", "Тренер", "Боксёр")

/datum/outfit/job/donor/wrestler
	name = "Борец"
	jobtype = /datum/job/donor/wrestler

	uniform = /obj/item/clothing/under/pants/classicjeans
	suit = /obj/item/clothing/suit/hooded/hoodie/blue
	shoes = /obj/item/clothing/shoes/sandal
	belt = /obj/item/storage/belt/fannypack/blue
	gloves = /obj/item/clothing/gloves/fingerless

	backpack_contents = list(
		/obj/item/clothing/gloves/boxing = 1,
		/obj/item/clothing/gloves/boxing/green = 1,
		/obj/item/clothing/gloves/boxing/blue = 1,
		/obj/item/clothing/gloves/boxing/yellow = 1,
		/obj/item/clothing/mask/luchador = 1,
		/obj/item/clothing/mask/luchador/tecnicos = 1,
		/obj/item/clothing/mask/luchador/rudos = 1,
		/obj/item/clothing/under/pants/shorts/red = 1,
		/obj/item/clothing/under/pants/shorts/green = 1,
		/obj/item/clothing/under/pants/shorts/blue = 1,
		/obj/item/clothing/under/pants/shorts/black = 1,
		/obj/item/clothing/under/pants/shorts/grey = 1,
		/obj/item/storage/belt/fannypack/blue = 1,
		/obj/item/storage/belt/fannypack/red = 1,
	)



/datum/job/donor/painter
	title = "Painter"
	ru_title = "Художник"
	outfit = /datum/outfit/job/donor/painter
	alt_titles = list("Художник", "Творец", "Искуствовед", "Пейзажист", "Фотореалист")

/datum/outfit/job/donor/painter
	name = "Художник"
	jobtype = /datum/job/donor/painter

	uniform = /obj/item/clothing/under/misc/sl_suit
	suit = /obj/item/clothing/suit/apron
	shoes = /obj/item/clothing/shoes/white
	head = /obj/item/clothing/head/beret/white
	glasses = /obj/item/clothing/glasses/regular/hipster
	backpack_contents = list(
		/obj/item/stack/cable_coil/random = 1,
		/obj/item/camera = 1,
		/obj/item/camera_film = 2,
		/obj/item/storage/photo_album = 1,
		/obj/item/hand_labeler = 1,
		/obj/item/stack/tape_roll = 1,
		/obj/item/paper = 4,
		/obj/item/storage/fancy/crayons = 1,
		/obj/item/pen/fancy = 1,
		/obj/item/toy/crayon/rainbow = 1
	)

/datum/job/donor/musican
	title = "Musician"
	ru_title = "Музыкант"
	outfit = /datum/outfit/job/donor/musican

/datum/outfit/job/donor/musican
	name = "Музыкант"
	jobtype = /datum/job/donor/musican

	uniform = /obj/item/clothing/under/costume/singerb
	shoes = /obj/item/clothing/shoes/singerb
	gloves = /obj/item/clothing/gloves/color/white
	r_ear = /obj/item/clothing/ears/headphones
	glasses = /obj/item/clothing/glasses/regular/hipster
	pda = /obj/item/pda
	id = /obj/item/card/id
	backpack_contents = list(
		/obj/item/flashlight = 1,
		/obj/item/instrument/violin = 1,
		/obj/item/instrument/piano_synth = 1,
		/obj/item/instrument/guitar = 1,
		/obj/item/instrument/eguitar = 1,
		/obj/item/instrument/accordion = 1,
		/obj/item/instrument/saxophone = 1,
		/obj/item/instrument/trombone = 1,
		/obj/item/instrument/harmonica = 1
	)


/datum/job/donor/actor
	title = "Actor"
	ru_title = "Актер"
	alt_titles = list("Артист", "Стендапер", "Комедиант", "Эстрадный Актер")
	outfit = /datum/outfit/job/donor/actor

/datum/outfit/job/donor/actor
	name = "Актер"
	jobtype = /datum/job/donor/actor

	uniform = /obj/item/clothing/under/rank/procedure/lawyer/red
	shoes = /obj/item/clothing/shoes/laceup
	head = /obj/item/clothing/head/bowlerhat
	gloves = /obj/item/clothing/gloves/color/white
	glasses = /obj/item/clothing/glasses/regular
	backpack_contents = list(
		/obj/item/clothing/under/rank/procedure/iaa/purple = 1,
		/obj/item/clothing/suit/storage/iaa/purplejacket = 1,
		/obj/item/clothing/under/suit/really_black = 1,
		/obj/item/clothing/under/costume/cuban_suit = 1,
		/obj/item/clothing/head/cuban_hat = 1,
	)

/datum/outfit/job/donor/courier/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/rank/procedure/lawyer/red/skirt

	if(H.mind && H.mind.role_alt_title)
		switch(H.mind.role_alt_title)
			if("Артист")
				uniform = /obj/item/clothing/under/suit/victsuit/red
				if(H.gender == FEMALE)
					uniform = /obj/item/clothing/under/dress/victdress/red
					suit = /obj/item/clothing/suit/victcoat/red
			if("Комедиант")
				uniform = /obj/item/clothing/under/costume/jester
				head = /obj/item/clothing/head/jester
			if("Эстрадный Актер")
				uniform = /obj/item/clothing/under/suit/victsuit/redblk
				suit = /obj/item/clothing/suit/draculacoat
				if(H.gender == FEMALE)
					uniform = /obj/item/clothing/under/dress/redeveninggown

