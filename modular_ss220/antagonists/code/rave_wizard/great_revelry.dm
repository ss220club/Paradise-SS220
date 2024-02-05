/obj/effect/proc_holder/spell/great_revelry
	name = "Ritual of Great Revelry"
	desc = "Gives everyone a beckoning bottle of alcohol, forcing them to drop an item from their hand."

	school = "transmutation"
	base_cooldown = 300
	clothes_req = TRUE
	invocation = "none"
	invocation_type = "none"
	cooldown_min = 100 //50 deciseconds reduction per rank
	nonabstract_req = TRUE
	var/beverages = list(/obj/item/reagent_containers/food/drinks/bottle/vodka,
					/obj/item/reagent_containers/food/drinks/bottle/whiskey,
					/obj/item/reagent_containers/food/drinks/bottle/tequila,
					/obj/item/reagent_containers/food/drinks/bottle/absinthe/premium,
					/obj/item/reagent_containers/food/drinks/bottle/absinthe,
					/obj/item/reagent_containers/food/drinks/bottle/hcider,
					/obj/item/reagent_containers/food/drinks/bottle/fernet)
	action_icon_state = "no_state"
	action_background_icon_state = "magic_beer"
	action_icon = 'modular_ss220/antagonists/icons/rave.dmi'

/obj/effect/proc_holder/spell/great_revelry/create_new_targeting()
	return new /datum/spell_targeting/self

/obj/effect/proc_holder/spell/great_revelry/cast(list/targets, mob/user = usr)
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		var/turf/T = get_turf(H)
		if(T && is_away_level(T.z))
			return
		if(H.stat == DEAD || H?.client)
			return
		if(iswizard(H) || H?.mind.offstation_role)
			return
		var/alcohol_type = pick(beverages)
		var/obj/item/reagent_containers/food/drinks/bottle/B = new alcohol_type(get_turf(H))
		playsound(get_turf(H),'modular_ss220/antagonists/sound/beer_can_open.mp3', 50, TRUE)
		H.drop_item() //drops item in active hand
		var/in_hand = H.put_in_hands(B)
		to_chat(H, "<span class='warning'>\A [B] appears [in_hand ? "in your hand" : "at your feet"]!</span>")

/datum/spellbook_entry/great_revelry
	name = "Ritual of Great Revelry"
	spell_type = /obj/effect/proc_holder/spell/great_revelry
	category = "Rave"
