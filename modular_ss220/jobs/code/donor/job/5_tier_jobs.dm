/datum/job/donor/vip_guest
	title = "VIP Guest"
	ru_title = "VIP гость"
	alt_titles = list("")
	outfit = /datum/outfit/job/donor/vip_guest

/datum/outfit/job/donor/vip_guest
	name = "VIP гость"
	jobtype = /datum/job/donor/vip_guest

	uniform = /obj/item/clothing/under/suit/really_black
	glasses = /obj/item/clothing/glasses/monocle
	gloves = /obj/item/clothing/gloves/color/black
	shoes = /obj/item/clothing/shoes/centcom
	head = /obj/item/clothing/head/that
	l_hand = /obj/item/cane
	l_pocket = /obj/item/melee/classic_baton/telescopic
	//l_ear = /obj/item/radio/headset/ert
	//id = /obj/item/card/id/centcom
	//pda = /obj/item/pda
	back = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/storage/box/engineer = 1,
		/obj/item/stack/spacecash/c10000 = 1,
		/obj/item/implanter/death_alarm = 1,
		/obj/item/lighter/zippo/engraved = 1,
	)


/datum/job/donor/banker
	title = "Banker"
	ru_title = "Банкир"
	outfit = /datum/outfit/job/donor/banker

/datum/outfit/job/donor/banker
	name = "Банкир"
	jobtype = /datum/job/donor/banker

	uniform = /obj/item/clothing/under/suit/really_black
	suit = /obj/item/clothing/suit/victcoat
	glasses = /obj/item/clothing/glasses/monocle
	gloves = /obj/item/clothing/gloves/color/white
	shoes = /obj/item/clothing/shoes/centcom
	head = /obj/item/clothing/head/fedora
	l_hand = /obj/item/cane
	l_pocket = /obj/item/melee/classic_baton/telescopic
	back = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/storage/box/engineer = 1,
		//15k
		/obj/item/stack/spacecash/c10000 = 1,
		/obj/item/stack/spacecash/c1000 = 5,

		/obj/item/implanter/death_alarm = 1,
		/obj/item/lighter/zippo/engraved = 1,
		/obj/item/clothing/under/rank/procedure/lawyer/black = 1,
	)


/datum/job/donor/seclown
	title = "Security Clown"
	//ru_title = "Клоун Службы Безопасности" // чтобы скрываться среди СБ-ух при поиске
	alt_titles = list("Clown Warden", "Clown Detective", "Honkective", "Honkden", "Clown Cadet", "Клоун Службы Безопасности", "Клоун-Детектив", "Клоун-Смотритель", "Хонкектив", "Клоун Кадет")
	supervisors = "the head of security"
	department_head = list("Head of Security")
	job_department_flags = DEP_FLAG_SECURITY
	access = list(ACCESS_CLOWN, ACCESS_THEATRE, ACCESS_MAINT_TUNNELS, ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT)
	minimal_access = list(ACCESS_CLOWN, ACCESS_THEATRE, ACCESS_MAINT_TUNNELS, ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT)
	outfit = /datum/outfit/job/donor/seclown
	relate_job = "Security Officer"

/datum/outfit/job/donor/seclown
	name = "Security Clown"
	jobtype = /datum/job/donor/seclown

	uniform = /obj/item/clothing/under/rank/civilian/clown
	suit = /obj/item/clothing/suit/armor/vest/warden
	shoes = /obj/item/clothing/shoes/clown_shoes
	head = /obj/item/clothing/head/officer
	mask = /obj/item/clothing/mask/gas/clown_hat
	gloves = /obj/item/clothing/gloves/color/red
	l_pocket = /obj/item/bikehorn
	suit_store = /obj/item/gun/energy/clown
	l_ear = /obj/item/radio/headset/headset_service
	r_ear = /obj/item/radio/headset/headset_sec/alt
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses
	id = /obj/item/card/id/clown
	pda = /obj/item/pda/clown
	backpack_contents = list(
		/obj/item/reagent_containers/food/snacks/grown/banana = 1,
		/obj/item/stamp/clown = 1,
		/obj/item/toy/crayon/rainbow = 1,
		/obj/item/storage/fancy/crayons = 1,
		/obj/item/reagent_containers/spray/waterflower = 1,
		/obj/item/reagent_containers/food/drinks/bottle/bottleofbanana = 1,
		/obj/item/instrument/bikehorn = 1,
		/obj/item/flash = 1,
		/obj/item/restraints/handcuffs/twimsts = 1,
	)

	implants = list(/obj/item/implant/sad_trombone, /obj/item/implant/mindshield)

	backpack = /obj/item/storage/backpack/clown
	satchel = /obj/item/storage/backpack/clown
	dufflebag = /obj/item/storage/backpack/duffel/clown
