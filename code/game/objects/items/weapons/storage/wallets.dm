/obj/item/storage/wallet
	name = "leather wallet"
	desc = "Made from genuine leather, it is of the highest quality."
	storage_slots = 10
	icon = 'icons/obj/wallets.dmi'
	icon_state = "wallet"
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FLAMMABLE
	can_hold = list(
		/obj/item/stack/spacecash,
		/obj/item/card,
		/obj/item/clothing/mask/cigarette,
		/obj/item/flashlight/pen,
		/obj/item/seeds,
		/obj/item/stack/medical,
		/obj/item/toy/crayon,
		/obj/item/coin,
		/obj/item/dice,
		/obj/item/disk,
		/obj/item/implanter,
		/obj/item/lighter,
		/obj/item/match,
		/obj/item/paper,
		/obj/item/pen,
		/obj/item/photo,
		/obj/item/reagent_containers/dropper,
		/obj/item/screwdriver,
		/obj/item/stamp)
	cant_hold = list(
		/obj/item/screwdriver/power
	)
	slot_flags = SLOT_FLAG_ID

	var/obj/item/card/id/front_id = null

	// allows for clicking of stuff on our person/on the ground to put in the wallet, so easy to stick your ID in your wallet
	use_to_pickup = TRUE
	pickup_all_on_tile = FALSE


/obj/item/storage/wallet/remove_from_storage(obj/item/I, atom/new_location)
	. = ..()
	if(. && istype(I, /obj/item/card/id))
		refresh_ID()

/obj/item/storage/wallet/handle_item_insertion(obj/item/I, prevent_warning = FALSE)
	. = ..()
	if(. && istype(I, /obj/item/card/id))
		refresh_ID()

/obj/item/storage/wallet/orient2hud(mob/user)
	. = ..()
	refresh_ID()

/obj/item/storage/wallet/proc/refresh_ID()
	// Locate the first ID in the wallet
	front_id = (locate(/obj/item/card/id) in contents)

	if(ishuman(loc))
		var/mob/living/carbon/human/wearing_human = loc
		if(wearing_human.wear_id == src)
			wearing_human.sec_hud_set_ID()

	update_appearance(UPDATE_NAME|UPDATE_OVERLAYS)

/obj/item/storage/wallet/update_overlays()
	. = ..()
	if(!front_id)
		return
	. += mutable_appearance(front_id.icon, front_id.icon_state)
	. += front_id.overlays
	. += mutable_appearance(icon, "wallet_overlay")

	// fuck yeah, ass photo in my wallet
	var/obj/item/photo/photo = locate(/obj/item/photo) in contents
	if(!photo)
		return
	var/mutable_appearance/MA = mutable_appearance(photo.appearance)
	MA.pixel_x = 11
	MA.pixel_y = 1
	. += MA
	. += mutable_appearance(icon, "photo_overlay")

/obj/item/storage/wallet/update_name(updates)
	. = ..()
	if(front_id)
		name = "wallet displaying [front_id]"
	else
		name = initial(name)

/obj/item/storage/wallet/GetID()
	return front_id

/obj/item/storage/wallet/GetAccess()
	var/obj/item/I = GetID()
	if(I)
		return I.GetAccess()
	else
		return ..()

/obj/item/storage/wallet/random/populate_contents()
	var/cash = pick(/obj/item/stack/spacecash,
		/obj/item/stack/spacecash/c5,
		/obj/item/stack/spacecash/c10,
		/obj/item/stack/spacecash/c50,
		/obj/item/stack/spacecash/c100)
	var/coin = pickweight(list(/obj/item/coin/iron = 3,
							/obj/item/coin/silver = 2,
							/obj/item/coin/gold = 1))

	new cash(src)
	if(prob(50)) // 50% chance of a second
		new cash(src)
	new coin(src)


// Arcade Wallet
/obj/item/storage/wallet/cheap
	name = "cheap wallet"
	desc = "A cheap and flimsy wallet from the arcade."
	storage_slots = 5		//smaller storage than normal wallets






/obj/item/storage/wallet_NT   //Кошель НТ, ща насру
	name = "leather wallet NT"    //Название сменил
	desc = "Ваш кошелек настолько шикарен, что с ним вы выглядите просто потрясающе."   //Описание от Муни.
	storage_slots = 10
	icon = 'icons/obj/wallets.dmi'
	icon_state = "wallet_NT"             //Иконка.
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FLAMMABLE
	can_hold = list(
		/obj/item/stack/spacecash,
		/obj/item/card,
		/obj/item/clothing/mask/cigarette,
		/obj/item/flashlight/pen,
		/obj/item/seeds,
		/obj/item/stack/medical,
		/obj/item/toy/crayon,
		/obj/item/coin,
		/obj/item/dice,
		/obj/item/disk,
		/obj/item/implanter,
		/obj/item/lighter,
		/obj/item/match,
		/obj/item/paper,
		/obj/item/pen,
		/obj/item/photo,
		/obj/item/reagent_containers/dropper,
		/obj/item/screwdriver,
		/obj/item/stamp)
	cant_hold = list(
		/obj/item/screwdriver/power
	)
	slot_flags = SLOT_FLAG_ID

	var/obj/item/card/id/front_id = null

	// allows for clicking of stuff on our person/on the ground to put in the wallet, so easy to stick your ID in your wallet
	use_to_pickup = TRUE
	pickup_all_on_tile = FALSE


/obj/item/storage/wallet_NT/remove_from_storage(obj/item/I, atom/new_location)
	. = ..()
	if(. && istype(I, /obj/item/card/id))
		refresh_ID()

/obj/item/storage/wallet_NT/handle_item_insertion(obj/item/I, prevent_warning = FALSE)
	. = ..()
	if(. && istype(I, /obj/item/card/id))
		refresh_ID()

/obj/item/storage/wallet_NT/orient2hud(mob/user)
	. = ..()
	refresh_ID()

/obj/item/storage/wallet_NT/proc/refresh_ID()
	// Locate the first ID in the wallet
	front_id = (locate(/obj/item/card/id) in contents)

	if(ishuman(loc))
		var/mob/living/carbon/human/wearing_human = loc
		if(wearing_human.wear_id == src)
			wearing_human.sec_hud_set_ID()

	update_appearance(UPDATE_NAME|UPDATE_OVERLAYS)

/obj/item/storage/wallet_NT/update_overlays()
	. = ..()
	if(!front_id)
		return
	. += mutable_appearance(front_id.icon, front_id.icon_state)
	. += front_id.overlays
	. += mutable_appearance(icon, "wallet_overlay_NT")

	// fuck yeah, ass photo in my wallet
	var/obj/item/photo/photo = locate(/obj/item/photo) in contents
	if(!photo)
		return
	var/mutable_appearance/MA = mutable_appearance(photo.appearance)
	MA.pixel_x = 11
	MA.pixel_y = 1
	. += MA
	. += mutable_appearance(icon, "photo_overlay_NT")

/obj/item/storage/wallet_NT/update_name(updates)
	. = ..()
	if(front_id)
		name = "wallet displaying [front_id]"
	else
		name = initial(name)

/obj/item/storage/wallet_NT/GetID()
	return front_id

/obj/item/storage/wallet_NT/GetAccess()
	var/obj/item/I = GetID()
	if(I)
		return I.GetAccess()
	else
		return ..()

/obj/item/storage/wallet_NT/random/populate_contents()
	var/cash = pick(/obj/item/stack/spacecash,
		/obj/item/stack/spacecash/c5,
		/obj/item/stack/spacecash/c10,
		/obj/item/stack/spacecash/c50,
		/obj/item/stack/spacecash/c100)
	var/coin = pickweight(list(/obj/item/coin/iron = 3,
							/obj/item/coin/silver = 2,
							/obj/item/coin/gold = 1))

	new cash(src)
	if(prob(50)) // 50% chance of a second
		new cash(src)
	new coin(src)


// Arcade Wallet
//obj/item/storage/wallet_NT/cheap
	//name = "cheap wallet"
	//desc = "A cheap and flimsy wallet from the arcade."
	//storage_slots = 5		//smaller storage than normal wallets






/obj/item/storage/wallet_USSP_1
	name = "leather wallet USSP"
	desc = "Говорят, такие кошельки в СССП носят исключительно для зажигалок."
	storage_slots = 10
	icon = 'icons/obj/wallets.dmi'
	icon_state = "wallet_USSP_1"
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FLAMMABLE
	can_hold = list(
		/obj/item/stack/spacecash,
		/obj/item/card,
		/obj/item/clothing/mask/cigarette,
		/obj/item/flashlight/pen,
		/obj/item/seeds,
		/obj/item/stack/medical,
		/obj/item/toy/crayon,
		/obj/item/coin,
		/obj/item/dice,
		/obj/item/disk,
		/obj/item/implanter,
		/obj/item/lighter,
		/obj/item/match,
		/obj/item/paper,
		/obj/item/pen,
		/obj/item/photo,
		/obj/item/reagent_containers/dropper,
		/obj/item/screwdriver,
		/obj/item/stamp)
	cant_hold = list(
		/obj/item/screwdriver/power
	)
	slot_flags = SLOT_FLAG_ID

	var/obj/item/card/id/front_id = null

	// allows for clicking of stuff on our person/on the ground to put in the wallet, so easy to stick your ID in your wallet
	use_to_pickup = TRUE
	pickup_all_on_tile = FALSE


/obj/item/storage/wallet_USSP_1/remove_from_storage(obj/item/I, atom/new_location)
	. = ..()
	if(. && istype(I, /obj/item/card/id))
		refresh_ID()

/obj/item/storage/wallet_USSP_1/handle_item_insertion(obj/item/I, prevent_warning = FALSE)
	. = ..()
	if(. && istype(I, /obj/item/card/id))
		refresh_ID()

/obj/item/storage/wallet_USSP_1/orient2hud(mob/user)
	. = ..()
	refresh_ID()

/obj/item/storage/wallet_USSP_1/proc/refresh_ID()
	// Locate the first ID in the wallet
	front_id = (locate(/obj/item/card/id) in contents)

	if(ishuman(loc))
		var/mob/living/carbon/human/wearing_human = loc
		if(wearing_human.wear_id == src)
			wearing_human.sec_hud_set_ID()

	update_appearance(UPDATE_NAME|UPDATE_OVERLAYS)

/obj/item/storage/wallet_USSP_1/update_overlays()
	. = ..()
	if(!front_id)
		return
	. += mutable_appearance(front_id.icon, front_id.icon_state)
	. += front_id.overlays
	. += mutable_appearance(icon, "wallet_overlay_USSP")

	// fuck yeah, ass photo in my wallet
	var/obj/item/photo/photo = locate(/obj/item/photo) in contents
	if(!photo)
		return
	var/mutable_appearance/MA = mutable_appearance(photo.appearance)
	MA.pixel_x = 11
	MA.pixel_y = 1
	. += MA
	. += mutable_appearance(icon, "photo_overlay_USSP")

/obj/item/storage/wallet_USSP_1/update_name(updates)
	. = ..()
	if(front_id)
		name = "wallet displaying [front_id]"
	else
		name = initial(name)

/obj/item/storage/wallet_USSP_1/GetID()
	return front_id

/obj/item/storage/wallet_USSP_1/GetAccess()
	var/obj/item/I = GetID()
	if(I)
		return I.GetAccess()
	else
		return ..()

/obj/item/storage/wallet_USSP_1/random/populate_contents()
	var/cash = pick(/obj/item/stack/spacecash,
		/obj/item/stack/spacecash/c5,
		/obj/item/stack/spacecash/c10,
		/obj/item/stack/spacecash/c50,
		/obj/item/stack/spacecash/c100)
	var/coin = pickweight(list(/obj/item/coin/iron = 3,
							/obj/item/coin/silver = 2,
							/obj/item/coin/gold = 1))

	new cash(src)
	if(prob(50)) // 50% chance of a second
		new cash(src)
	new coin(src)


// Arcade Wallet
//obj/item/storage/wallet_USSP_1/cheap
	//name = "cheap wallet"
	//desc = "A cheap and flimsy wallet from the arcade."
	//storage_slots = 5		//smaller storage than normal wallets






/obj/item/storage/wallet_USSP_2
	name = "leather wallet USSP"
	desc = "Говорят, такие кошельки в СССП носят исключительно для зажигалок."
	storage_slots = 10
	icon = 'icons/obj/wallets.dmi'
	icon_state = "wallet_USSP_2"
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FLAMMABLE
	can_hold = list(
		/obj/item/stack/spacecash,
		/obj/item/card,
		/obj/item/clothing/mask/cigarette,
		/obj/item/flashlight/pen,
		/obj/item/seeds,
		/obj/item/stack/medical,
		/obj/item/toy/crayon,
		/obj/item/coin,
		/obj/item/dice,
		/obj/item/disk,
		/obj/item/implanter,
		/obj/item/lighter,
		/obj/item/match,
		/obj/item/paper,
		/obj/item/pen,
		/obj/item/photo,
		/obj/item/reagent_containers/dropper,
		/obj/item/screwdriver,
		/obj/item/stamp)
	cant_hold = list(
		/obj/item/screwdriver/power
	)
	slot_flags = SLOT_FLAG_ID

	var/obj/item/card/id/front_id = null

	// allows for clicking of stuff on our person/on the ground to put in the wallet, so easy to stick your ID in your wallet
	use_to_pickup = TRUE
	pickup_all_on_tile = FALSE


/obj/item/storage/wallet_USSP_2/remove_from_storage(obj/item/I, atom/new_location)
	. = ..()
	if(. && istype(I, /obj/item/card/id))
		refresh_ID()

/obj/item/storage/wallet_USSP_2/handle_item_insertion(obj/item/I, prevent_warning = FALSE)
	. = ..()
	if(. && istype(I, /obj/item/card/id))
		refresh_ID()

/obj/item/storage/wallet_USSP_2/orient2hud(mob/user)
	. = ..()
	refresh_ID()

/obj/item/storage/wallet_USSP_2/proc/refresh_ID()
	// Locate the first ID in the wallet
	front_id = (locate(/obj/item/card/id) in contents)

	if(ishuman(loc))
		var/mob/living/carbon/human/wearing_human = loc
		if(wearing_human.wear_id == src)
			wearing_human.sec_hud_set_ID()

	update_appearance(UPDATE_NAME|UPDATE_OVERLAYS)

/obj/item/storage/wallet_USSP_2/update_overlays()
	. = ..()
	if(!front_id)
		return
	. += mutable_appearance(front_id.icon, front_id.icon_state)
	. += front_id.overlays
	. += mutable_appearance(icon, "wallet_overlay_USSP")

	// fuck yeah, ass photo in my wallet
	var/obj/item/photo/photo = locate(/obj/item/photo) in contents
	if(!photo)
		return
	var/mutable_appearance/MA = mutable_appearance(photo.appearance)
	MA.pixel_x = 11
	MA.pixel_y = 1
	. += MA
	. += mutable_appearance(icon, "photo_overlay_USSP")

/obj/item/storage/wallet_USSP_2/update_name(updates)
	. = ..()
	if(front_id)
		name = "wallet displaying [front_id]"
	else
		name = initial(name)

/obj/item/storage/wallet_USSP_2/GetID()
	return front_id

/obj/item/storage/wallet_USSP_2/GetAccess()
	var/obj/item/I = GetID()
	if(I)
		return I.GetAccess()
	else
		return ..()

/obj/item/storage/wallet_USSP_2/random/populate_contents()
	var/cash = pick(/obj/item/stack/spacecash,
		/obj/item/stack/spacecash/c5,
		/obj/item/stack/spacecash/c10,
		/obj/item/stack/spacecash/c50,
		/obj/item/stack/spacecash/c100)
	var/coin = pickweight(list(/obj/item/coin/iron = 3,
							/obj/item/coin/silver = 2,
							/obj/item/coin/gold = 1))

	new cash(src)
	if(prob(50)) // 50% chance of a second
		new cash(src)
	new coin(src)


// Arcade Wallet
//obj/item/storage/wallet_USSP_2/cheap
	//name = "cheap wallet"
	//desc = "A cheap and flimsy wallet from the arcade."
	//storage_slots = 5		//smaller storage than normal wallets