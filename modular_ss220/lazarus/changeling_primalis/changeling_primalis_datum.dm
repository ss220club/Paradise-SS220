/datum/game_mode
	var/list/mob/living/simple_animal/changeling_primalis/ling_infestors = list()
	var/list/mob/living/carbon/human/ling_hosts = list()

/datum/antagonist/blood_brother
	name = "Blood Brother"
	roundend_category = "Blood Brothers"
	job_rank = ROLE_BLOOD_BROTHER
	special_role = SPECIAL_ROLE_BLOOD_BROTHER
	antag_hud_name = "hudbloodbrother"
	antag_hud_type = ANTAG_HUD_BLOOD_BROTHER
	clown_gain_text = {"Ты очень много тренировался, чтобы наконец-то вступить в Синдикат, даже твоя клоунская натура не сможет помешать.
Ты уверенно владеешь всем оружием."}
	clown_removal_text = "Все тренировки пошли насмарку - ты как был клоуном, так и остался."
	wiki_page_name = "Blood_Brothers"
