/datum/job/officer/cadet
	title = "Security Cadet"
	flag = JOB_CADET
	total_positions = 0	// miss add slots
	spawn_positions = 2
	//selection_color = "#efe6e6"
	alt_titles = list("Security Assistant", "Security Graduate")
	exp_map = list(EXP_TYPE_CREW = NOVICE_CADET_JOB_MINUTES)
	outfit = /datum/outfit/job/officer/cadet
	important_information = "Космический закон это необходимость, а не рекомендация. Ваша должность ограничена во всех взаимодействиях с рабочим имуществом отдела и экипажем станции, при отсутствии приставленного к нему квалифицированного сотрудника или полученного разрешения от вышестоящего начальства."

/datum/outfit/job/officer/cadet
	name = "Security Cadet"
	jobtype = /datum/job/officer/cadet
	uniform = /obj/item/clothing/under/rank/security/officer/cadet
	suit = /obj/item/clothing/suit/armor/vest/security
	gloves = /obj/item/clothing/gloves/color/black
	shoes = /obj/item/clothing/shoes/jackboots
	head = /obj/item/clothing/head/soft/sec
	l_ear = /obj/item/radio/headset/headset_sec/alt
	id = /obj/item/card/id/security/cadet
	l_pocket = /obj/item/reagent_containers/spray/pepper
	suit_store = /obj/item/gun/energy/disabler
	pda = /obj/item/pda/security
	backpack_contents = list(
		/obj/item/restraints/handcuffs = 1
	)
	//box = /obj/item/storage/box/survival_security/cadet


/datum/outfit/job/officer/cadet/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()

	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/rank/security/officer/cadet/skirt

	switch(H.mind.role_alt_title)
		if("Security Assistant")
			uniform = /obj/item/clothing/under/rank/security/officer/cadet/assistant
			if(H.gender == FEMALE)
				uniform = /obj/item/clothing/under/rank/security/officer/cadet/assistant/skirt
		if("Security Graduate")
			head = /obj/item/clothing/head/beret/sec

/datum/job/officer
	alt_titles = list("Security Trainer", "Junior Security Officer")

/datum/outfit/job/officer/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/rank/security/officer/skirt

/datum/job/officer
	exp_map = list(EXP_TYPE_SECURITY = (600 + NOVICE_CADET_JOB_MINUTES))

/datum/job/brigphysic
	exp_map = list(EXP_TYPE_SECURITY = (900 + NOVICE_CADET_JOB_MINUTES))

/datum/job/detective
	exp_map = list(EXP_TYPE_SECURITY = (900 + NOVICE_CADET_JOB_MINUTES))

/datum/job/warden
	exp_map = list(EXP_TYPE_SECURITY = (900 + NOVICE_CADET_JOB_MINUTES))

/datum/job/hos
	exp_map = list(EXP_TYPE_SECURITY = (1200 + NOVICE_CADET_JOB_MINUTES))

/datum/job/brigphysic
	title = "Security Medic"
	flag = JOB_BRIGPHYSICIAN
	department_flag = JOBCAT_ENGSEC
	total_positions = 1
	spawn_positions = 1
	alt_titles = list("Brig Physician", "Security Doctor", "Security Paramedic")
	supervisors = "the head of security"
	department_head = list("Head of Security")
	selection_color = "#ffeeee"
	job_department_flags = DEP_FLAG_SECURITY
	access = list(ACCESS_BRIG, ACCESS_COURT, ACCESS_MAINT_TUNNELS, ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SEC_DOORS, ACCESS_SECURITY, ACCESS_SURGERY, ACCESS_WEAPONS, ACCESS_CREMATORIUM, ACCESS_EVA)
	minimal_player_age = 21
	exp_map = list(EXP_TYPE_SECURITY = 900)
	blacklisted_disabilities = list(DISABILITY_FLAG_BLIND, DISABILITY_FLAG_DEAF, DISABILITY_FLAG_MUTE, DISABILITY_FLAG_DIZZY)
	missing_limbs_allowed = FALSE
	outfit = /datum/outfit/job/brigphysic
	important_information = "Вы медик службы безопасности. \
	Лечите своих коллег и заключённых. Следите за стерильностью своей комнаты. \
	Помните о том что вы не офицер службы безопаности, а их медик и вместо войны должны заниматся лечением."

/datum/outfit/job/brigphysic
	name = "Security Medic"
	jobtype = /datum/job/brigphysic
	uniform = /obj/item/clothing/under/rank/security/brigphysic
	suit = /obj/item/clothing/suit/storage/labcoat
	gloves = /obj/item/clothing/gloves/color/black
	shoes = /obj/item/clothing/shoes/laceup
	head = /obj/item/clothing/head/beret/sec
	l_ear = /obj/item/radio/headset/headset_secmedical/alt
	id = /obj/item/card/id/brigphysician
	l_pocket = /obj/item/reagent_containers/spray/pepper
	r_pocket = /obj/item/flash
	l_hand = /obj/item/storage/firstaid/doctor
	pda = /obj/item/pda/brigphysic
	backpack_contents = list(
		/obj/item/melee/classic_baton/telescopic = 1
	)

	bio_chips = list(/obj/item/bio_chip/mindshield)

	backpack = /obj/item/storage/backpack/security
	satchel = /obj/item/storage/backpack/satchel_sec
	dufflebag = /obj/item/storage/backpack/duffel/security

/datum/outfit/job/brigphysic/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()

	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/rank/security/brigphysic/skirt

var/list/blacklisted_partial = list(
	/datum/job/brigphysic
)
