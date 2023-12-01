/datum/job/donor/adjutant
	title = "Adjutant"
	ru_title = "Адъютант"
	outfit = /datum/outfit/job/donor/adjutant

/datum/outfit/job/donor/adjutant
	name = "Адъютант"
	jobtype = /datum/job/donor/adjutant

	uniform = /obj/item/clothing/under/rank/procedure/iaa/blue
	suit = /obj/item/clothing/suit/storage/iaa/bluejacket
	shoes = /obj/item/clothing/shoes/laceup
	l_ear = /obj/item/radio/headset/headset_iaa/alt
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses
	gloves = /obj/item/clothing/gloves/color/white
	l_pocket = /obj/item/laser_pointer
	r_pocket = /obj/item/clothing/accessory/lawyers_badge
	l_hand = /obj/item/storage/briefcase
	id = /obj/item/card/id/internalaffairsagent
	pda = /obj/item/pda/lawyer
	backpack_contents = list(
		/obj/item/folder/blue = 1,
		/obj/item/camera = 1,
		/obj/item/taperecorder = 1,
		/obj/item/storage/box/tapes = 1,
		/obj/item/clipboard = 1,
		/obj/item/clothing/under/rank/procedure/lawyer/blue = 1,
		)
	implants = list(/obj/item/implant/mindshield)
	satchel = /obj/item/storage/backpack/satchel_sec
	dufflebag = /obj/item/storage/backpack/duffel/security


/datum/job/donor/butler
	title = "Butler"
	ru_title = "Дворецкий"
	outfit = /datum/outfit/job/donor/butler

/datum/outfit/job/donor/butler
	name = "Дворецкий"
	jobtype = /datum/job/donor/butler

	uniform = /obj/item/clothing/under/rank/procedure/lawyer/black
	shoes = /obj/item/clothing/shoes/laceup
	head = /obj/item/clothing/head/beaverhat
	glasses = /obj/item/clothing/glasses/monocle
	gloves = /obj/item/clothing/gloves/color/white
	backpack_contents = list(
		/obj/item/reagent_containers/glass/rag = 1,
		/obj/item/folder/blue = 1,
		/obj/item/camera = 1,
		/obj/item/taperecorder = 1,
		/obj/item/storage/box/tapes = 1,
		/obj/item/clipboard = 1,
		/obj/item/clothing/under/rank/procedure/iaa = 1,
		/obj/item/clothing/suit/storage/iaa/blackjacket = 1,
		)


/datum/job/donor/maid
	title = "Maid"
	ru_title = "Горничная"
	outfit = /datum/outfit/job/donor/maid

/datum/outfit/job/donor/maid
	name = "Горничная"
	jobtype = /datum/job/donor/maid

	uniform = /obj/item/clothing/under/costume/janimaid
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/color/white
	backpack_contents = list(
		/obj/item/reagent_containers/glass/rag = 1,
		/obj/item/folder/blue = 1,
		/obj/item/camera = 1,
		/obj/item/taperecorder = 1,
		/obj/item/storage/box/tapes = 1,
		/obj/item/clipboard = 1,
		/obj/item/clothing/suit/chef/classic = 1,
		)


/datum/job/donor/representative_tsf
	title = "Representative TSF"
	ru_title = "Представитель ТСФ"
	outfit = /datum/outfit/job/donor/representative_tsf

/datum/outfit/job/donor/representative_tsf
	name = "Представитель ТСФ"
	jobtype = /datum/job/donor/representative_tsf

	uniform = /obj/item/clothing/under/solgov/rep
	glasses = /obj/item/clothing/glasses/sunglasses
	gloves = /obj/item/clothing/gloves/color/white
	shoes = /obj/item/clothing/shoes/centcom
	l_ear = /obj/item/radio/headset/ert
	l_pocket = /obj/item/melee/classic_baton/telescopic
	id = /obj/item/card/id/silver
	pda = /obj/item/pda
	backpack_contents = list(
		/obj/item/storage/box/responseteam = 1,
		/obj/item/implanter/death_alarm = 1,
		/obj/item/lighter/zippo/blue = 1,
		/obj/item/storage/fancy/cigarettes/cigpack_robustgold = 1,
		/obj/item/clothing/under/pants/shorts/blue  = 1,
	)
	back = /obj/item/storage/backpack/satchel

	implants = list(/obj/item/implant/mindshield,
		/obj/item/implant/death_alarm
	)


/datum/job/donor/representative_ussp
	title = "Representative USSP"
	ru_title = "Представитель ССП"
	outfit = /datum/outfit/job/donor/representative_ussp

/datum/outfit/job/donor/representative_ussp
	name = "Представитель ССП"
	jobtype = /datum/job/donor/representative_ussp

	uniform = /obj/item/clothing/under/new_soviet/sovietofficer
	suit = /obj/item/clothing/suit/sovietcoat/officer
	head = /obj/item/clothing/head/sovietofficerhat
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	glasses = /obj/item/clothing/glasses/sunglasses
	l_pocket = /obj/item/melee/classic_baton/telescopic
	backpack_contents = list(
		/obj/item/storage/box/responseteam = 1,
		/obj/item/implanter/death_alarm = 1,
		/obj/item/lighter/zippo/engraved = 1,
		/obj/item/storage/fancy/cigarettes/cigpack_robustgold = 1,
		/obj/item/clothing/under/pants/shorts/red = 1,
		/obj/item/clothing/head/ushanka = 1,
	)
	back = /obj/item/storage/backpack/satchel


/datum/job/donor/dealer
	title = "Dealer"
	ru_title = "Независимый Торговец"
	outfit = /datum/outfit/job/donor/dealer
	alt_titles = list("Торговец", "Барахольщик", "Меценат")

/datum/outfit/job/donor/dealer
	name = "Независимый Торговец"
	jobtype = /datum/job/donor/dealer

	uniform = /obj/item/clothing/under/suit/black
	suit = /obj/item/clothing/suit/pirate_black
	back = /obj/item/storage/backpack/duffel/engineering
	belt = /obj/item/melee/classic_baton
	head = /obj/item/clothing/head/fedora
	shoes = /obj/item/clothing/shoes/cowboy/black
	l_hand = /obj/item/cane
	glasses = /obj/item/clothing/glasses/sunglasses/big
	gloves = /obj/item/clothing/gloves/color/black
	id = /obj/item/card/id/supply
	pda = /obj/item/pda
	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/hand_labeler = 1,
		/obj/item/hand_labeler_refill = 1
	)

/datum/outfit/job/donor/dealer/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(H.mind && H.mind.role_alt_title)
		switch(H.mind.role_alt_title)
			if("Торговец", "Барахольщик")
				uniform = /obj/item/clothing/under/color/brown
				suit = /obj/item/clothing/suit/pirate_brown
				shoes = /obj/item/clothing/shoes/cowboy
				head = /obj/item/clothing/head/cowboyhat
				gloves = /obj/item/clothing/gloves/color/brown
