/datum/outfit/job/chef/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(H.mind && H.mind.role_alt_title)
		switch(H.mind.role_alt_title)
			if("Culinary Artist")
				head = /obj/item/clothing/head/chefhat/red
				uniform = /obj/item/clothing/under/rank/civilian/chef/red
				suit = /obj/item/clothing/suit/chef/red
				belt = /obj/item/storage/belt/chef/apron/red

/datum/job/bartender
	alt_titles = list("Barista", "Barkeeper")

/datum/job/hydro/New()
	. = ..()
	alt_titles |= list("Florist", "Gardener", "Herbalist")

/datum/job/clown
	alt_titles = list("Joker", "Comedian", "Jester")

/datum/job/mime
	alt_titles = list("Pantomimist")

/datum/job/explorer
	alt_titles = list("Expeditor", "Exploration Member", "Exploration Engineer", "Exploration Medic")

/datum/job/mining/New()
	. = ..()
	alt_titles |= list("Prospector", "Geologist")
