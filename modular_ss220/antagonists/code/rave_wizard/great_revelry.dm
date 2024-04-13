/datum/spell/great_revelry
	name = "Ritual of Great Revelry"
	desc = "Gives everyone a beckoning bottle of alcohol, forcing them to drop an item from their hand."

	school = "transmutation"
	base_cooldown = 300
	clothes_req = TRUE
	invocation = "none"
	invocation_type = "none"
	cooldown_min = 100 //50 deciseconds reduction per rank
	nonabstract_req = TRUE
	var/beverages = list(/obj/item/reagent_containers/drinks/bottle/vodka,
					/obj/item/reagent_containers/drinks/bottle/whiskey,
					/obj/item/reagent_containers/drinks/bottle/tequila,
					/obj/item/reagent_containers/drinks/bottle/absinthe/premium,
					/obj/item/reagent_containers/drinks/bottle/absinthe,
					/obj/item/reagent_containers/drinks/bottle/hcider,
					/obj/item/reagent_containers/drinks/bottle/fernet)
	action_icon_state = "no_state"
	action_background_icon_state = "revelry"
	action_icon = 'modular_ss220/antagonists/icons/rave.dmi'

/datum/spell/great_revelry/create_new_targeting()
	return new /datum/spell_targeting/self

/datum/spell/great_revelry/cast(list/targets, mob/user = usr)
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		var/turf/T = get_turf(H)
		if(T && is_away_level(T.z))
			continue
		if(H.stat == DEAD || !(H.client))
			return
		if(iswizard(H) || H?.mind.offstation_role)
			return
		H.drop_item()
		give_alcohol(H)


/datum/spell/great_revelry/proc/give_alcohol(mob/living/carbon/human/H)
	var/bottle_type = pick(beverages)
	var/obj/item/bottle = new bottle_type(get_turf(H))
	playsound(get_turf(H),'modular_ss220/antagonists/sound/beer_can_open.ogg', 50, TRUE)
	H.put_in_hands(bottle)

/datum/spellbook_entry/great_revelry
	name = "Ritual of Great Revelry"
	spell_type = /datum/spell/great_revelry
	category = "Rave"
