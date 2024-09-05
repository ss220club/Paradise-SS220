/obj/item/circuitboard/vendor
	var/static/list/ss220_vendors = list("MacVulpix Deluxe Food" = /obj/machinery/economy/vending/vulpix)

/obj/machinery/economy/vending/vulpix
	name = "\improper MacVulpix Deluxe Food"
	desc = "Торговый автомат сети ресторанов быстрого питания МакВульпикс, с забавным лисом на логотипе."
	icon = 'modular_ss220/vending/icons/vending.dmi'
	icon_state = "McVulpix"
	icon_lightmask = "McVulpix"
	category = VENDOR_TYPE_FOOD
	refill_canister = /obj/item/vending_refill/vulpix
	slogan_list = list(
		"Taste 5000 years of culture!",
		"Mr. Chang, approved for safe consumption in over 10 sectors!",
		"Chinese food is great for a date night, or a lonely night!",
		"You can't go wrong with Mr. Chang's authentic Chinese food!"
	)
	products = list(
		/obj/item/reagent_containers/drinks/bottle/vulpix_milk/berry = 3,
		/obj/item/reagent_containers/drinks/bottle/vulpix_milk/banana = 3,
		/obj/item/reagent_containers/drinks/bottle/vulpix_milk/choco = 3,
		/obj/item/food/fancy/macvulpix_original = 3,
		/obj/item/food/fancy/macvulpix_cheese = 3,
	)
	prices = list(
		/obj/item/reagent_containers/drinks/bottle/vulpix_milk/berry = 50,
		/obj/item/reagent_containers/drinks/bottle/vulpix_milk/banana = 50,
		/obj/item/reagent_containers/drinks/bottle/vulpix_milk/choco = 50,
		/obj/item/food/fancy/macvulpix_original = 100,
		/obj/item/food/fancy/macvulpix_cheese = 100,
	)
	contraband = list(
		/obj/item/poster/mac_vulpix = 3,
	)
