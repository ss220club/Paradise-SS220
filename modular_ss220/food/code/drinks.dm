/obj/item/reagent_containers/food/drinks/drinkingglass/on_reagent_change()
	. = ..()
	if(!reagents.reagent_list.len)
		icon = initial(icon)
		return
	var/datum/reagent/reagent = reagents.get_master_reagent()
	if(!istype(reagent, /datum/reagent/consumable/ethanol))
		icon = initial(icon)
		return
	var/datum/reagent/consumable/ethanol/booze = reagent
	icon = booze.drinking_glass_icon

/datum/reagent/consumable/ethanol
	var/drinking_glass_icon = 'icons/obj/drinks.dmi'

/obj/machinery/chem_dispenser/beer/Initialize(mapload)
	dispensable_reagents |= "sambuka"
	dispensable_reagents |= "champagne"
	dispensable_reagents |= "aperol"
	dispensable_reagents |= "jagermeister"
	dispensable_reagents |= "schnaps"
	dispensable_reagents |= "bitter"
	dispensable_reagents |= "sheridan"
	dispensable_reagents |= "bluecuracao"
	. = ..()

/obj/item/handheld_chem_dispenser/booze/Initialize(mapload)
	dispensable_reagents |= "sambuka"
	dispensable_reagents |= "champagne"
	dispensable_reagents |= "aperol"
	dispensable_reagents |= "jagermeister"
	dispensable_reagents |= "schnaps"
	dispensable_reagents |= "bitter"
	dispensable_reagents |= "sheridan"
	dispensable_reagents |= "bluecuracao"
	. = ..()

/datum/reagent/consumable/ethanol/sambuka
	name = "Sambuka"
	id = "sambuka"
	description = "Flying into space, many thought that they had grasped fate."
	color = "#e0e0e0"
	alcohol_perc = 0.45
	dizzy_adj = 1
	drink_icon = "sambukaglass"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Glass of Sambuka"
	drink_desc = "Flying into space, many thought that they had grasped fate."
	taste_description = "twirly fire"

/datum/reagent/consumable/ethanol/innocent_erp
	name = "Innocent ERP"
	id = "innocent_erp"
	description = "Remember that big brother sees everything."
	color = "#746463"
	alcohol_perc = 0.5
	drink_icon = "innocent_erp"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Innocent ERP"
	drink_desc = "Remember that big brother sees everything."
	taste_description = "loss of flirtatiousness"

/datum/chemical_reaction/innocent_erp
	name = "Innocent ERP"
	id = "innocent_erp"
	result = "innocent_erp"
	required_reagents = list("sambuka" = 3, "triple_citrus" = 1, "irishcream" = 1)
	result_amount = 5
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/soundhand
	name = "soundhand"
	id = "soundhand"
	description = "Коктейль из нескольких алкогольных напитков с запахом ягод и легким слоем перца на стакане."
	color = "#C18A7B"
	alcohol_perc = 0.5
	drink_icon = "soundhand"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Саундхэнд"
	drink_desc = "Коктейль из нескольких алкогольных напитков с запахом ягод и легким слоем перца на стакане."
	taste_description = "дребезжащие в ритме металлические струны."

/datum/reagent/consumable/ethanol/soundhand/on_mob_life(mob/living/M)
	. = ..()
	if(prob(10))
		M.emote("airguitar")

/datum/chemical_reaction/soundhand
	name = "Soundhand"
	id = "soundhand"
	result = "soundhand"
	required_reagents = list("vodka" = 2, "whiskey" = 1, "berryjuice" = 1, "blackpepper" = 1)
	result_amount = 5
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/champagne
	name = "Champagne"
	id = "champagne"
	description = "Excellent sparkling champagne. For those who want to stand out among vinokurs."
	color = "#d0d312"
	alcohol_perc = 0.2
	drink_icon = "champagneglass"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Glass of Champagne"
	drink_desc = "Excellent sparkling champagne. For those who want to stand out among vinokurs."
	taste_description = "sparkling sunshine"

/datum/reagent/consumable/ethanol/aperol
	name = "Aperol"
	id = "aperol"
	description = "Oh-oh-oh... It looks like it's an ambush for the liver"
	color = "#b9000a"
	alcohol_perc = 0.2
	drink_icon = "aperolglass"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Glass of Aperol"
	drink_desc = "Oh-oh-oh... It looks like it's an ambush for the liver"
	taste_description = "herbaceous sweetness"

/datum/chemical_reaction/aperol
	name = "Aperol"
	id = "aperol"
	result = "aperol"
	required_reagents = list("grapejuice" = 5, "limejuice" = 5, "wine" = 5)
	required_catalysts = list("enzyme" = 5)
	result_amount = 20
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/jagermeister
	name = "Jagermeister"
	id = "jagermeister"
	description = "The drunkard hunter came from deep space, and it looks like he found a victim."
	color = "#200b0b"
	alcohol_perc = 0.4
	dizzy_adj = 6 SECONDS
	drink_icon = "jagermeisterglass"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Glass of Jagermeister"
	drink_desc = "The drunkard hunter came from deep space, and it looks like he found a victim."
	taste_description = "btterness of hunting"

/datum/reagent/consumable/ethanol/schnaps
	name = "Schnaps"
	id = "schnaps"
	description = "From such a schnapps it's not a sin to start yodeling."
	color = "#e0e0e0"
	alcohol_perc = 0.4
	dizzy_adj = 2 SECONDS
	drink_icon = "schnapsglass"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Glass of Schnaps"
	drink_desc = "From such a schnapps it's not a sin to start yodeling."
	taste_description = "wheat mint"

/datum/chemical_reaction/schnaps
	name = "Schnaps"
	id = "schnaps"
	result = "schnaps"
	required_reagents = list("ethanol" = 5, "flour" = 5)
	required_catalysts = list("enzyme" = 5)
	result_amount = 15
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/bluecuracao
	name = "Blue Curacao"
	id = "bluecuracao"
	description = "The fuse is ready, the blue has already lit up."
	color = "#16c9ff"
	alcohol_perc = 0.35
	drink_icon = "bluecuracaoglass"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Glass of Blue Curacao"
	drink_desc = "The fuse is ready, the blue has already lit up."
	taste_description = "explosive blue"

/datum/reagent/consumable/ethanol/bitter
	name = "Bitter"
	id = "bitter"
	description = "Don't mix up the label sizes, because I won't change anything."
	color = "#d44071"
	alcohol_perc = 0.45
	dizzy_adj = 4 SECONDS
	drink_icon = "bitterglass"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Glass of bitter"
	drink_desc = "Don't mix up the label sizes, because I won't change anything."
	taste_description = "vacuum bitterness"

/datum/chemical_reaction/bitter
	name = "Bitter"
	id = "bitter"
	result = "bitter"
	required_reagents = list("ethanol" = 5, "berryjuice" = 5)
	required_catalysts = list("enzyme" = 5)
	result_amount = 15
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/sheridan
	name = "Sheridan's"
	id = "sheridan"
	description = "Refrigerate, pour at an angle of 45, do not mix, enjoy."
	color = "#3a3d2e"
	alcohol_perc = 0.35
	drink_icon = "sheridanglass"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Glass of Sheridan's"
	drink_desc = "Refrigerate, pour at an angle of 45, do not mix, enjoy."
	taste_description = "creamy coffee"

/datum/reagent/consumable/ethanol/black_blood
	name = "Black Blood"
	id = "black_blood"
	description = "Need to drink faster before it starts to curdle."
	color = "#252521"
	alcohol_perc = 0.45
	drink_icon = "black_blood"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Black Blood"
	drink_desc = "Need to drink faster before it starts to curdle."
	taste_description = "bloody darkness"

/datum/reagent/consumable/ethanol/black_blood/reaction_mob(mob/living/M, method, volume)
	. = ..()
	if(prob(50))
		M.say(pick("Fuu ma'jin!", "Sas'so c'arta forbici!", "Ta'gh fara'qha fel d'amar det!", "Kla'atu barada nikt'o!", "Fel'th Dol Ab'orod!", "In'totum Lig'abis!", "Ethra p'ni dedol!", "Ditans Gut'ura Inpulsa!", "O bidai nabora se'sma!"))

/datum/chemical_reaction/black_blood
	name = "Black Blood"
	id = "black_blood"
	result = "black_blood"
	required_reagents = list("bluecuracao" = 2, "jagermeister" = 1, "sodawater" = 1, "ice" = 1)
	result_amount = 5
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/light_storm
	name = "Light Storm"
	id = "light_storm"
	description = "Even away from the ocean, you can feel this shaking."
	color = "#4b4b44"
	alcohol_perc = 0.6
	drink_icon = "light_storm"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Light Storm"
	drink_desc = "Even away from the ocean, you can feel this shaking."
	taste_description = "sea excitement"

/datum/chemical_reaction/light_storm
	name = "Light Storm"
	id = "light_storm"
	result = "light_storm"
	required_reagents = list("sheridan" = 2, "vodka" = 1, "sambuka" = 1, "cream" = 1)
	result_amount = 5
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/cream_heaven
	name = "Cream Heaven"
	id = "cream_heaven"
	description = "This is a touch of cream and coffee, a real creation of heaven."
	color = "#4b4b44"
	alcohol_perc = 0.25
	drink_icon = "cream_heaven"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Cream Heaven"
	drink_desc = "This is a touch of cream and coffee, a real creation of heaven."
	taste_description = "coffee cloud"

/datum/chemical_reaction/cream_heaven
	name = "Cream Heaven"
	id = "cream_heaven"
	result = "cream_heaven"
	required_reagents = list("sheridan" = 2, "milk" = 2, "gin" = 1, "ice" = 1)
	result_amount = 6
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/negroni
	name = "Negroni"
	id = "negroni"
	description = "Bitters are very good for the liver, and gin has a bad effect on you. Here they balance each other."
	color = "#ad3948"
	alcohol_perc = 0.4
	drink_icon = "negroni"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Negroni"
	drink_desc = "Bitters are very good for the liver, and gin has a bad effect on you. Here they balance each other."
	taste_description = "sweet parade"

/datum/chemical_reaction/negroni
	name = "Negroni"
	id = "negroni"
	result = "negroni"
	required_reagents = list("martini" = 2, "bitter" = 1, "orangejuice" = 2)
	result_amount = 5
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/hirosima
	name = "Hirosima"
	id = "hirosima"
	description = "My hands are up to the elbows in blood... Oh, wait, it's alcohol."
	color = "#598317"
	alcohol_perc = 0.3
	drink_icon = "hirosima"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Hirosima"
	drink_desc = "My hands are up to the elbows in blood... Oh, wait, it's alcohol."
	taste_description = "alcoholic ashes"

/datum/chemical_reaction/hirosima
	name = "Hirosima"
	id = "hirosima"
	result = "hirosima"
	required_reagents = list("grapejuice" = 1, "sambuka" = 2, "absinthe" = 1, "irishcream" = 1)
	result_amount = 5
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/nagasaki
	name = "nagasaki"
	id = "nagasaki"
	description = "At first, no one knew what would happen next. The intoxication was terrible. There is no doubt that this is the strongest intoxication that a person has ever seen."
	color = "#18c212"
	alcohol_perc = 0.7
	drink_icon = "nagasaki"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Nagasaki"
	drink_desc = "At first, no one knew what would happen next. The intoxication was terrible. There is no doubt that this is the strongest intoxication that a person has ever seen."
	taste_description = "radioactive ash"

/datum/chemical_reaction/nagasaki
	name = "Nagasaki"
	id = "nagasaki"
	result = "nagasaki"
	required_reagents = list("hirosima" = 10, "uranium" = 1)
	result_amount = 10
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/chocolate_sheridan
	name = "Chocolate Sheridan's"
	id = "chocolate_sheridan"
	description = "In situations when you really want to cheer up and drink."
	color = "#332a1a"
	alcohol_perc = 0.3
	drink_icon = "chocolate_sheridan"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Chocolate Sheridan's"
	drink_desc = "In situations when you really want to cheer up and drink."
	taste_description = "alcoholic mocha"

/datum/chemical_reaction/chocolate_sheridan
	name = "Chocolate Sheridan's"
	id = "chocolate_sheridan"
	result = "chocolate_sheridan"
	required_reagents = list("sheridan" = 5, "chocolate" = 1)
	result_amount = 6
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/panamian
	name = "Panama"
	id = "panamian"
	description = "It will connect your blood and alcohol like a Katun gateway."
	color = "#3164a7"
	alcohol_perc = 0.6
	drink_icon = "panamian"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Panama"
	drink_desc = "It will connect your blood and alcohol like a Katun gateway."
	taste_description = "shipping channel"

/datum/chemical_reaction/panamian
	name = "Panama"
	id = "panamian"
	result = "panamian"
	required_reagents = list("gintonic" = 1, "bluecuracao" = 2, "vodka" = 1, "ice" = 1 )
	result_amount = 5
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/pegu_club
	name = "Pegu Club"
	id = "pegu_club"
	description = "It's like a group of gentlemen colonizing your tongue."
	color = "#a5702b"
	alcohol_perc = 0.5
	drink_icon = "pegu_club"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Pegu Club"
	drink_desc = "It's like a group of gentlemen colonizing your tongue."
	taste_description = "shipping channel"

/datum/chemical_reaction/pegu_club
	name = "Pegu Club"
	id = "pegu_club"
	result = "pegu_club"
	required_reagents = list("gin" = 2, "orangejuice" = 1, "limejuice" = 1, "bitter" = 2)
	result_amount = 6
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/jagermachine
	name = "Jagermachine"
	id = "jagermachine"
	description = "A true detail hunter."
	color = "#6b0b74"
	alcohol_perc = 0.55
	drink_icon = "jagermachine"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Jagermachine"
	drink_desc = "A true detail hunter."
	taste_description = "stealing parts"

/datum/chemical_reaction/jagermachine
	name = "Jagermachine"
	id = "jagermachine"
	result = "jagermachine"
	required_reagents = list("jagermeister" = 1, "synthanol" = 1)
	result_amount = 2
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/blue_cybesauo
	name = "Blue Cybesauo"
	id = "blue_cybesauo"
	description = "The blue is similar to the blue screen of death."
	color = "#0b7463"
	alcohol_perc = 0.4
	drink_icon = "blue_cybesauo"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Blue Cybesauo"
	drink_desc = "The blue is similar to the blue screen of death."
	taste_description = "error 0xc000001b"

/datum/chemical_reaction/blue_cybesauo
	name = "Blue Cybesauo"
	id = "blue_cybesauo"
	result = "blue_cybesauo"
	required_reagents = list("bluecuracao" = 2, "synthanol" = 2, "limejuice" = 1)
	result_amount = 5
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/alcomender
	name = "Alcomender"
	id = "alcomender"
	description = "A glass in the form of a mender, a favorite among doctors."
	color = "#6b0059"
	alcohol_perc = 1.4 ////Heal burn
	drink_icon = "alcomender"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Alcomender"
	drink_desc = "A glass in the form of a mender, a favorite among doctors."
	taste_description = "funny medicine"

/datum/reagent/consumable/ethanol/alcomender/on_mob_life(mob/living/M)
	var/update_flags = STATUS_UPDATE_NONE
	update_flags |= M.adjustFireLoss(-0.7, FALSE)
	return ..() | update_flags

/datum/reagent/consumable/ethanol/alcomender/reaction_mob(mob/living/M, method=REAGENT_TOUCH, volume) // It is alcohol after all, so don't try to pour it on someone who's on fire ... please.
	if(iscarbon(M))
		if(method == REAGENT_TOUCH)
			M.adjustFireLoss(-volume * 0.7)
			to_chat(M, "<span class='notice'>The diluted silver sulfadiazine soothes your burns.</span>")
	return STATUS_UPDATE_NONE

/datum/chemical_reaction/alcomender
	name = "Alcomender"
	id = "alcomender"
	result = "alcomender"
	required_reagents = list("silver_sulfadiazine" = 1, "ethanol" = 1 )
	result_amount = 2
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/amnesia
	name = "Star Amnesia"
	id = "amnesia"
	description = "Is it just a bottle of medical alcohol?"
	color = "#6b0059"
	alcohol_perc = 1.2 ////Ethanol and Hooch
	drink_icon = "amnesia"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Star Amnesia"
	drink_desc = "Is it just a bottle of medical alcohol?"
	taste_description = "disco amnesia"

/datum/chemical_reaction/amnesia
	name = "Amnesia"
	id = "Amnesia"
	result = "amnesia"
	required_reagents = list("hooch" = 1, "vodka" = 1,  )
	result_amount = 2
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/johnny
	name = "Silverhand"
	id = "johnny"
	description = "Wake the heck up, samurai. We have a station to burn."
	color = "#c41414"
	alcohol_perc = 0.6
	drink_icon = "johnny"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Silverhand"
	drink_desc = "Wake the heck up, samurai. We have a station to burn."
	taste_description = "superstar fading"

/datum/chemical_reaction/johnny
	name = "Silverhand"
	id = "johnny"
	result = "johnny"
	required_reagents = list("tequila" = 2, "bitter" = 1, "beer" = 1, "berryjuice" = 1)
	result_amount = 5
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/cosmospoliten
	name = "Cosmospoliten"
	id = "cosmospoliten"
	description = "Then try to prove that you are straight and not a woman if you got caught with him."
	color = "#b1483a"
	alcohol_perc = 0.5
	drink_icon = "cosmospoliten"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Cosmospoliten"
	drink_desc = "Then try to prove that you are straight and not a woman if you got caught with him."
	taste_description = "orientation reversal"

/datum/chemical_reaction/cosmospoliten
	name = "Cosmospoliten"
	id = "cosmospoliten"
	result = "cosmospoliten"
	required_reagents = list("screwdrivercocktail" = 2, "orangejuice" = 1, "limejuice" = 1, "berryjuice" = 1)
	result_amount = 5
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/oldfashion
	name = "Old Fashion"
	id = "oldfashion"
	description = "Rumor has it that this cocktail is the oldest, but however, this is a completely different story."
	color = "#6b4017"
	alcohol_perc = 0.6
	drink_icon = "oldfashion"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Old Fashion"
	drink_desc = "Rumor has it that this cocktail is the oldest, but however, this is a completely different story."
	taste_description = "old times"

/datum/chemical_reaction/oldfashion
	name = "Old Fashion"
	id = "oldfashion"
	result = "oldfashion"
	required_reagents = list("whiskey" = 5, "bitter" = 2, "sugar" = 2, "orangejuice" = 1,  )
	result_amount = 10
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/french_75
	name = "French 75"
	id = "french_75"
	description = "Charge the liver, aim, fire!"
	color = "#b1953a"
	alcohol_perc = 0.4
	drink_icon = "french_75"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "French 75"
	drink_desc = "Charge the liver, aim, fire!"
	taste_description = "artillery bombing"

/datum/chemical_reaction/french_75
	name = "French 75"
	id = "french_75"
	result = "french_75"
	required_reagents = list("gin" = 2, "lemonjuice" = 1, "champagne" = 2, "sugar" = 1 )
	result_amount = 6
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/gydroseridan
	name = "Gydroridan"
	id = "gydroseridan"
	description = "Hydraulic separation of layers will help us in efficiency."
	color = "#3a99b1"
	alcohol_perc = 0.5
	drink_icon = "gydroseridan"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Gydroridan"
	drink_desc = "Hydraulic separation of layers will help us in efficiency."
	taste_description = "hydraulic power"

/datum/chemical_reaction/gydroseridan
	name = "Gydroridan"
	id = "gydroseridan"
	result = "gydroseridan"
	required_reagents = list("sheridan" = 2, "synthanol" = 1 )
	result_amount = 3
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/milk_plus
	name = "Milk +"
	id = "milk_plus"
	description = "When a man cannot choose he ceases to be a man."
	color = "#DFDFDF"
	alcohol_perc = 0.8
	drink_icon = "milk_plus"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Milk +"
	drink_desc = "When a man cannot choose he ceases to be a man."
	taste_description = "loss of human"

/datum/chemical_reaction/milk_plus
	name = "Milk +"
	id = "milk_plus"
	result = "milk_plus"
	required_reagents = list("absinthe" = 2, "irishcream" = 2, "milk" = 5, "sugar" = 1 )
	result_amount = 10
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/teslasingylo
	name = "God Of Power"
	id = "teslasingylo"
	description = "A real horror for the SMES and the APC. Don't overload them."
	color = "#0300ce"
	alcohol_perc = 0.7
	process_flags = SYNTHETIC
	drink_icon = "teslasingylo"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "God Of Power"
	drink_desc = "A real horror for the SMES and the APC. Don't overload them."
	taste_description = "electricity bless"

/datum/reagent/consumable/ethanol/teslasingylo/on_mob_life(mob/living/M)
	. = ..()
	if(ismachineperson(M))
		var/mob/living/carbon/human/machine/machine = M
		if(machine.nutrition > NUTRITION_LEVEL_WELL_FED) //no fat machines, sorry
			return
		machine.adjust_nutrition(15) //much less than charging from APC (50)

/datum/chemical_reaction/teslasingylo
	name = "God Of Power"
	id = "teslasingylo"
	result = "teslasingylo"
	required_reagents = list("teslium" = 2, "radium" = 2, "synthanol" = 1)
	result_amount = 5
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/bees_knees
	name = "Bee's Knees"
	id = "bees_knees"
	description = "As if the fact is that the bee carries pollen in the area of the knees and ... Nevermind."
	color = "#e8f71f"
	alcohol_perc = 0.5
	drink_icon = "bees_knees"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Bee's Knees"
	drink_desc = "As if the fact is that the bee carries pollen in the area of the knees and ... Nevermind."
	taste_description = "honey love"

/datum/chemical_reaction/bees_knees
	name = "Bee's Knees"
	id = "bees_knees"
	result = "bees_knees"
	required_reagents = list("gin" = 2, "lemonjuice" = 1, "limejuice" = 1, "honey" = 1 )
	result_amount = 5
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'


/datum/chemical_reaction/bees_knees2
	name = "Bee's Knees"
	id = "bees_knees"
	result = "bees_knees"
	required_reagents = list("gin" = 2, "lemonjuice" = 1, "limejuice" = 1, "mead" = 3 )
	result_amount = 5
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/aviation
	name = "Aviation"
	id = "aviation"
	description = "It's hard to make cocktails when a zeppelin flies over your house."
	color = "#c48f8f"
	alcohol_perc = 0.5
	drink_icon = "aviation"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Aviation"
	drink_desc = "It's hard to make cocktails when a zeppelin flies over your house."
	taste_description = "blowing the wind"

/datum/chemical_reaction/aviation
	name = "aviation"
	id = "aviation"
	result = "aviation"
	required_reagents = list("gin" = 2, "berryjuice" = 1, "lemon_lime" = 1, "cream" = 1 )
	result_amount = 5
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/fizz
	name = "Fizz"
	id = "fizz"
	description = "It's like living with a feral cat."
	color = "#b6b6b6"
	alcohol_perc = 0.3
	drink_icon = "fizz"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Fizz"
	drink_desc = "It's like living with a feral cat."
	taste_description = "fizzing"

/datum/chemical_reaction/fizz
	name = "Fizz"
	id = "fizz"
	result = "fizz"
	required_reagents = list("whiskeysoda" = 4, "lemonjuice" = 1, "sugar" = 2)
	result_amount = 7
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/brandy_crusta
	name = "Brandy Crusta"
	id = "brandy_crusta"
	description = "The sugar crust may not be sweet at all."
	color = "#754609"
	alcohol_perc = 0.4
	drink_icon = "brandy_crusta"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Brandy Crusta"
	drink_desc = "The sugar crust may not be sweet at all."
	taste_description = "salty-sweet"

/datum/chemical_reaction/brandy_crusta
	name = "Brandy Crusta"
	id = "brandy_crusta"
	result = "brandy_crusta"
	required_reagents = list("whiskey" = 2, "berryjuice" = 1, "lemonjuice" = 1, "bitter" = 1 )
	result_amount = 4
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/aperolspritz
	name = "Aperol Spritz"
	id = "aperolspritz"
	description = "Many consider it a separate alcohol, but it's more like a knight in chess."
	color = "#c43d3d"
	alcohol_perc = 0.5
	drink_icon = "aperolspritz"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Aperol Spritz"
	drink_desc = "Many consider it a separate alcohol, but it's more like a knight in chess."
	taste_description = "separateness of taste"

/datum/chemical_reaction/aperolspritz
	name = "Aperol Spritz"
	id = "aperolspritz"
	result = "aperolspritz"
	required_reagents = list("aperol" = 4, "wine" = 3, "sodawater" = 1, "orangejuice" = 2 )
	result_amount = 10
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/daiquiri
	name = "Daiquiri"
	id = "daiquiri"
	description = "Just try, try again for me! With the headshot power of a Daiquiri!"
	color = "#b6b6b6"
	alcohol_perc = 0.4
	drink_icon = "daiquiri"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Daiquiri"
	drink_desc = "Just try, try again for me! With the headshot power of a Daiquiri!"
	taste_description = "headshot"

/datum/chemical_reaction/daiquiri
	name = "Daiquiri"
	id = "daiquiri"
	result = "daiquiri"
	required_reagents = list("rum" = 3, "limejuice" = 2, "sugar" = 1)
	result_amount = 6
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/tuxedo
	name = "Tuxedo"
	id = "tuxedo"
	description = "I can promise you a Colombian tie."
	color = "#888686"
	alcohol_perc = 0.5
	drink_icon = "tuxedo"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Tuxedo"
	drink_desc = "I can promise you a Colombian tie."
	taste_description = "strictness of style"

/datum/chemical_reaction/tuxedo
	name = "tuxedo"
	id = "tuxedo"
	result = "tuxedo"
	required_reagents = list("martini" = 2, "vermouth" = 2, "absinthe" = 1, "bitter" = 1)
	result_amount = 5
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/telegol
	name = "Telegol"
	id = "telegol"
	description = "Many are still puzzling over the question of this cocktail. Anyway, it still exists... Or not."
	color = "#4218a3"
	alcohol_perc = 0.5
	drink_icon = "telegol"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Telegol"
	drink_desc = "Many are still puzzling over the question of this cocktail. Anyway, it still exists... Or not."
	taste_description = "fourteen dimension"

/datum/chemical_reaction/telegol
	name = "telegol"
	id = "telegol"
	result = "telegol"
	required_reagents = list("teslium" = 2, "vodka" = 2, "dr_gibb" = 1)
	result_amount = 6
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/horse_neck
	name = "Horse Neck"
	id = "horse_neck"
	description = "Be careful with your horse's shoes."
	color = "#c45d09"
	alcohol_perc = 0.5
	drink_icon = "horse_neck"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Horse Neck"
	drink_desc = "Be careful with your horse's shoes."
	taste_description = "horsepower"

/datum/reagent/consumable/ethanol/horse_neck/reaction_mob(mob/living/M, method, volume)
	. = ..()
	if(prob(50))
		M.say(pick("NEEIIGGGHHHH!", "NEEEIIIIGHH!", "NEIIIGGHH!", "HAAWWWWW!", "HAAAWWW!"))

/datum/chemical_reaction/horse_neck
	name = "Horse Neck"
	id = "horse_neck"
	result = "horse_neck"
	required_reagents = list("whiskey" = 2, "ale" = 3, "bitter" = 1)
	result_amount = 6
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/cuban_sunset
	name = "Cuban Sunset"
	id = "cuban_sunset"
	description = "A new day, with a new coup."
	color = "#d88948"
	alcohol_perc = 0.6
	drink_icon = "cuban_sunset"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Cuban Sunset"
	drink_desc = "A new day, with a new coup."
	taste_description = "totalitarianism"

/datum/chemical_reaction/cuban_sunset
	name = "Cuban Sunset"
	id = "cuban_sunset"
	result = "cuban_sunset"
	required_reagents = list("rum" = 3, "lemonade" = 2, "bitter" = 1)
	result_amount = 6
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/sake_bomb
	name = "Sake Bomb"
	id = "sake_bomb"
	description = "Carpet bombing your bamboo liver."
	color = "#e2df2e"
	alcohol_perc = 0.3
	drink_icon = "sake_bomb"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Sake Bomb"
	drink_desc = "Carpet bombing your bamboo liver."
	taste_description = "beer and sake"

/datum/chemical_reaction/sake_bomb
	name = "Sake Bomb"
	id = "sake_bomb"
	result = "sake_bomb"
	required_reagents = list("beer" = 2, "sake" = 2)
	result_amount = 4
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/blue_havai
	name = "Blue Havai"
	id = "blue_havai"
	description = "The same blue as brown eyes."
	color = "#296129"
	alcohol_perc = 0.2
	drink_icon = "blue_havai"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Blue Havai"
	drink_desc = "The same blue as brown eyes."
	taste_description = "neon dawn"

/datum/chemical_reaction/blue_havai
	name = "Blue Havai"
	id = "blue_havai"
	result = "blue_havai"
	required_reagents = list("rum" = 2, "vodka" = 2, "bluecuracao" = 1)
	result_amount = 5
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/woo_woo
	name = "Woo Woo"
	id = "woo_woo"
	description = "And which child came up with this name? Yeah, I see, the question is settled."
	color = "#e22e2e"
	alcohol_perc = 0.5
	drink_icon = "woo_woo"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Woo Woo"
	drink_desc = "And which child came up with this name? Yeah, I see, the question is settled."
	taste_description = "woo woo"

/datum/chemical_reaction/woo_woo
	name = "Woo Woo"
	id = "woo_woo"
	result = "woo_woo"
	required_reagents = list("vodka" = 2, "schnaps" = 2, "berryjuice" = 1)
	result_amount = 5
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/mulled_wine
	name = "Mulled Wine"
	id = "mulled_wine"
	description = "Just a hot wine with spices, but so pleasant."
	color = "#fd4b4b"
	alcohol_perc = 0.2
	drink_icon = "mulled_wine"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Mulled Wine"
	drink_desc = "Just a hot wine with spices, but so pleasant."
	taste_description = "hot wine"

/datum/chemical_reaction/mulled_wine
	name = "Mulled Wine"
	id = "mulled_wine"
	result = "mulled_wine"
	required_reagents = list("wine" = 2, "lemonjuice" = 2)
	min_temp = T0C + 100
	result_amount = 4
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/white_bear
	name = "White Bear"
	id = "white_bear"
	description = "Two historical enemies, in one circle."
	color = "#d8b465"
	alcohol_perc = 0.5
	drink_icon = "white_bear"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "White Bear"
	drink_desc = "Two historical enemies, in one circle."
	taste_description = "ideological war"

/datum/chemical_reaction/white_bear
	name = "White Bear"
	id = "white_bear"
	result = "white_bear"
	required_reagents = list("schnaps" = 2, "cream" = 1, "beer" = 2)
	result_amount = 5
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/vampiro
	name = "Vampiro"
	id = "vampiro"
	description = "Has nothing to do with vampires, except that color."
	color = "#8d0000"
	alcohol_perc = 0.45
	drink_icon = "vampiro"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Vampiro"
	drink_desc = "Has nothing to do with vampires, except that color."
	taste_description = "exhaustion"

/datum/reagent/consumable/ethanol/vampiro/on_mob_life(mob/living/M)
	. = ..()
	if(volume > 20)
		if(prob(50)) //no spam here :p
			M.visible_message("<span class='warning'>Глаза [M] ослепительно вспыхивают!</span>")

/datum/chemical_reaction/vampiro
	name = "Vampiro"
	id = "vampiro"
	result = "vampiro"
	required_reagents = list("tequila" = 2, "tomatojuice" = 1, "berryjuice" = 1)
	result_amount = 4
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/queen_mary
	name = "Queen Mary"
	id = "queen_mary"
	description = "Mary was cleaned of blood, and it turned out that she was also red."
	color = "#bd2f2f"
	alcohol_perc = 0.35
	drink_icon = "queen_mary"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Queen Mary"
	drink_desc = "Mary was cleaned of blood, and it turned out that she was also red."
	taste_description = "cherry beer"

/datum/chemical_reaction/queen_mary
	name = "Queen Mary"
	id = "queen_mary"
	result = "queen_mary"
	required_reagents = list("beer" = 2, "berryjuice" = 2, "bitter" = 1)
	result_amount = 5
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/inabox
	name = "Box"
	id = "inabox"
	description = "This... Just a box?"
	color = "#5a3e0b"
	alcohol_perc = 0.4
	drink_icon = "inabox"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Box"
	drink_desc = "This... Just a box?"
	taste_description = "stealth"

/datum/chemical_reaction/inabox
	name = "Box"
	id = "inabox"
	result = "inabox"
	required_reagents = list("gin" = 2, "potato" = 1 )
	result_amount = 3
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/beer_berry_royal
	name = "Beer Berry Royal"
	id = "beer_berry_royal"
	description = "For some reason, they continue to float up and down."
	color = "#684b16"
	alcohol_perc = 0.25
	drink_icon = "beer_berry_royal"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Beer Berry Royal"
	drink_desc = "For some reason, they continue to float up and down."
	taste_description = "beer berry"

/datum/chemical_reaction/beer_berry_royal
	name = "Beer Berry Royal"
	id = "beer_berry_royal"
	result = "beer_berry_royal"
	required_reagents = list("beer" = 2, "berryjuice" = 2, "grapejuice" = 1 )
	result_amount = 5
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/sazerac
	name = "Sazerac"
	id = "sazerac"
	description = "The best pharmacists are bartenders."
	color = "#7c6232"
	alcohol_perc = 0.4
	drink_icon = "sazerac"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Sazerac"
	drink_desc = "The best pharmacists are bartenders."
	taste_description = "bitter whiskey"

/datum/chemical_reaction/sazerac
	name = "Sazerac"
	id = "sazerac"
	result = "sazerac"
	required_reagents = list("absinthe" = 1, "cognac" = 1, "bitter" = 1, "whiskey" = 1, "water" = 2 )
	result_amount = 6
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/monako
	name = "Monako"
	id = "monako"
	description = "You might think there are more fruits on the market."
	color = "#7c6232"
	alcohol_perc = 0.5
	drink_icon = "monako"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Monako"
	drink_desc = "You might think there are more fruits on the market."
	taste_description = "fruit gin"

/datum/chemical_reaction/monako
	name = "Monako"
	id = "monako"
	result = "monako"
	required_reagents = list("gin" = 1, "lemonjuice" = 1, "limejuice" = 1, "berryjuice" = 1, "sodiumchloride" = 1 )
	result_amount = 5
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/irishempbomb
	name = "Irish EMP Bomb"
	id = "irishempbomb"
	description = "Mmm, tastes like shut down..."
	color = "#123eb8"
	process_flags = SYNTHETIC
	alcohol_perc = 0.6
	drink_icon = "irishempbomb"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Irish EMP Bomb"
	drink_desc = "Mmm, tastes like shut down..."
	taste_description = "electromagnetic impulse"

/datum/reagent/consumable/ethanol/irishempbomb/on_mob_life(mob/living/M)
	var/update_flags = STATUS_UPDATE_NONE
	update_flags |= M.Stun(1, FALSE)
	do_sparks(5, FALSE, M.loc)
	return ..() | update_flags

/datum/chemical_reaction/irishempbomb
	name = "Irish EMP Bomb"
	id = "irishempbomb"
	result = "irishempbomb"
	required_reagents = list("irishcarbomb" = 1, "synthanol" = 1 )
	result_amount = 2
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/codelibre
	name = "Code Libre"
	id = "codelibre"
	description = "Por Code libre!"
	color = "#a126b1"
	alcohol_perc = 0.55
	process_flags = SYNTHETIC
	drink_icon = "codelibre"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Code Libre"
	drink_desc = "Por Code libre!"
	taste_description = "code liberation"

/datum/reagent/consumable/ethanol/codelibre/on_mob_life(mob/living/M)
	. = ..()
	if(prob(10))
		M.say(":5 [pick("Viva la Synthetica!")]")

/datum/chemical_reaction/codelibre
	name = "Code Libre"
	id = "codelibre"
	result = "codelibre"
	required_reagents = list("cubalibre" = 1, "synthanol" = 1 )
	result_amount = 2
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/blackicp
	name = "Black ICP"
	id = "blackicp"
	description = "I'm sorry I wasn't responding, can you repeat that?"
	color = "#a126b1"
	alcohol_perc = 0.5
	drink_icon = "blackicp"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Black ICP"
	drink_desc = "I'm sorry I wasn't responding, can you repeat that?"
	taste_description = "monitor replacing"

/datum/chemical_reaction/blackicp
	name = "Black ICP"
	id = "blackicp"
	result = "blackicp"
	required_reagents = list("blackrussian" = 1, "synthanol" = 1)
	result_amount = 2
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/slime_drink
	name = "Slime Drink"
	id = "slime_drink"
	description = "Don't worry, it's just jelly."
	color = "#dd3e32"
	alcohol_perc = 0.2
	drink_icon = "slime_drink"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Slime Drink"
	drink_desc = "Don't worry, it's just jelly. And slime been dead for a long time."
	taste_description = "jelly alcohol"

/datum/chemical_reaction/slime_drink
	name = "Slime Drink"
	id = "slime_drink"
	result = "slime_drink"
	required_reagents = list("cherryjelly" = 5, "ice" = 2, "sugar" = 1, "gin" = 2 )
	result_amount = 10
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/nasty_slush
	name = "Nasty Slush"
	id = "nasty_slush"
	description = "The name has nothing to do with the drink itself."
	color = "#462c0a"
	alcohol_perc = 0.55
	drink_icon = "nasty_slush"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Nasty Slush"
	drink_desc = "The name has nothing to do with the drink itself."
	taste_description = "nasty slush"

/datum/chemical_reaction/nasty_slush
	name = "Nasty Slush"
	id = "nasty_slush"
	result = "nasty_slush"
	required_reagents = list("absinthe" = 2, "kahlua" = 2, "irishcream" = 1 )
	result_amount = 5
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/blue_lagoon
	name = "Blue Lagoon"
	id = "blue_lagoon"
	description = "What could be better than relaxing on the beach with a good drink?"
	color = "#1edddd"
	alcohol_perc = 0.5
	drink_icon = "blue_lagoon"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Blue Lagoon"
	drink_desc = "What could be better than relaxing on the beach with a good drink?"
	taste_description = "beach relaxation"

/datum/chemical_reaction/blue_lagoon
	name = "Blue Lagoon"
	id = "blue_lagoon"
	result = "blue_lagoon"
	required_reagents = list("bluecuracao" = 2, "vodka" = 2, "sodawater" = 1, "ice" = 1 )
	result_amount = 6
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/green_fairy
	name = "Green Fairy"
	id = "green_fairy"
	description = "Some kind of abnormal green."
	color = "#54dd1e"
	alcohol_perc = 0.6
	drink_icon = "green_fairy"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Green Fairy"
	drink_desc = "Some kind of abnormal green."
	taste_description = "faith in fairies"

/datum/reagent/consumable/ethanol/green_fairy/on_mob_life(mob/living/M)
	var/update_flags = STATUS_UPDATE_NONE
	update_flags |= M.SetDruggy(min(max(0, M.AmountDruggy() + 10 SECONDS), 15 SECONDS))
	return ..() | update_flags

/datum/chemical_reaction/green_fairy
	name = "Green Fairy"
	id = "green_fairy"
	result = "green_fairy"
	required_reagents = list("tequila" = 1, "absinthe" = 1, "vodka" = 1, "bluecuracao" = 1, "lemonjuice" = 1 )
	result_amount = 5
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/home_lebovsky
	name = "Home Lebowski"
	id = "home_lebovsky"
	description = "Let me explain something to you. Um, I am not Home Lebowski. You're Home Lebowski. I'm The Dude."
	color = "#422b00"
	alcohol_perc = 0.35
	drink_icon = "home_lebovsky"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Home Lebowski"
	drink_desc = "Let me explain something to you. Um, I am not Home Lebowski. You're Home Lebowski. I'm The Dude."
	taste_description = "dressing gown"

/datum/chemical_reaction/home_lebovsky
	name = "Home Lebovsky"
	id = "home_lebovsky"
	result = "home_lebovsky"
	required_reagents = list("vodka" = 2, "coffee" = 1, "sugar" = 1, "ice" = 1 )
	result_amount = 6
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/top_billing
	name = "Top Billing"
	id = "top_billing"
	description = "In a prominent place, our top billing!"
	color = "#0b573d"
	alcohol_perc = 0.4
	drink_icon = "top_billing"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Top Billing"
	drink_desc = "In a prominent place, our top billing!"
	taste_description = "advertising space"

/datum/chemical_reaction/top_billing
	name = "Top Billing"
	id = "top_billing"
	result = "top_billing"
	required_reagents = list("vodka" = 2, "bluecuracao" = 1, "lemonjuice" = 2, "ice" = 1 )
	result_amount = 5
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/trans_siberian_express
	name = "Trans-Siberian Express"
	id = "trans_siberian_express"
	description = "From Vladivostok to delirium tremens in a day."
	color = "#e2a600"
	alcohol_perc = 0.5
	drink_icon = "trans_siberian_express"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Trans-Siberian express"
	drink_desc = "From Vladivostok to delirium tremens in a day."
	taste_description = "terrible infrastructure"

/datum/chemical_reaction/trans_siberian_express
	name = "Trans-Siberian Express"
	id = "trans_siberian_express"
	result = "trans_siberian_express"
	required_reagents = list("vodka" = 3, "limejuice" = 2, "carrotjuice" = 2, "ice" = 1 )
	result_amount = 8
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/sun
	name = "Sun"
	id = "sun"
	description = "Red sun over paradise!"
	color = "#bd1c1c"
	alcohol_perc = 0.4
	drink_icon = "sun"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Sun"
	drink_desc = "Red sun over paradise!"
	taste_description = "sun heat"

/datum/chemical_reaction/sun
	name = "Sun"
	id = "sun"
	result = "sun"
	required_reagents = list("rum" = 2, "berryjuice" = 2, "egg" = 1 )
	result_amount = 5
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/tick_tack
	name = "Tick-Tock"
	id = "tick_tack"
	description = "Tick-Tock, Tick-Tock Bzzzzz..."
	color = "#118020"
	alcohol_perc = 0.3
	drink_icon = "tick_tack"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Tick-Tock"
	drink_desc = "Tick-Tock, Tick-Tock Bzzzzz..."
	taste_description = "clock tick"

/datum/chemical_reaction/tick_tack
	name = "Tick-Tack"
	id = "tick_tack"
	result = "tick_tack"
	required_reagents = list("sambuka" = 1, "watermelonjuice" = 1 )
	result_amount = 2
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'


/datum/reagent/consumable/ethanol/uragan_shot
	name = "Uragan Shot"
	id = "uragan_shot"
	description = "Is it a uragan? But no, it's urahol."
	color = "#da6631"
	alcohol_perc = 0.35
	drink_icon = "uragan_shot"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Uragan Shot"
	drink_desc = "Is it a uragan? But no, it's urahol."
	taste_description = "gusts of wind"

/datum/chemical_reaction/uragan_shot
	name = "Uragan Shot"
	id = "uragan_shot"
	result = "uragan_shot"
	required_reagents = list("whiskey" = 1, "gin" = 1, "watermelonjuice" = 1 )
	result_amount = 3
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'


/datum/reagent/consumable/ethanol/new_yorker
	name = "New Yorker"
	id = "new_yorker"
	description = "Be careful with the stock exchange, otherwise it will be 'Black Tuesday.'"
	color = "#da3131"
	alcohol_perc = 0.4
	drink_icon = "new_yorker"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "New Yorker"
	drink_desc = "Be careful with the stock exchange, otherwise it will be 'Black Tuesday.'"
	taste_description = "the collapse"

/datum/chemical_reaction/new_yorker
	name = "New Yorker"
	id = "new_yorker"
	result = "new_yorker"
	required_reagents = list("whiskey" = 3, "bitter" = 1, "grapejuice" = 2, "limejuice" = 1,  )
	result_amount = 7
	mix_sound = 'sound/goonstation/misc/drinkfizz.ogg'

/datum/reagent/consumable/ethanol/rainbow_sky
	name = "Rainbow Sky"
	id = "rainbow_sky"
	description = "A drink that shimmers with all the colors of the rainbow with notes of the galaxy."
	color = "#ffffff"
	dizzy_adj = 20 SECONDS
	alcohol_perc = 1.5
	drink_icon = "rainbow_sky"
	drinking_glass_icon = 'modular_ss220/food/icons/drinks.dmi'
	drink_name = "Rainbow Sky"
	drink_desc = "A drink that shimmers with all the colors of the rainbow with notes of the galaxy."
	taste_description = "rainbow"

/datum/reagent/consumable/ethanol/rainbow_sky/on_mob_life(mob/living/M)
	var/update_flags = STATUS_UPDATE_NONE
	update_flags |= M.adjustBruteLoss(-1, FALSE)
	update_flags |= M.adjustFireLoss(-1, FALSE)
	M.Druggy(30 SECONDS)
	M.Jitter(10 SECONDS)
	M.AdjustHallucinate(10 SECONDS)
	return ..() | update_flags

/datum/chemical_reaction/rainbow_sky
	name = "Rainbow Sky"
	id = "rainbow_sky"
	result = "rainbow_sky"
	required_reagents = list("doctorsdelight" = 1, "bananahonk" = 1, "erikasurprise" = 1, "screwdrivercocktail" = 1, "gargleblaster" = 1)
	result_amount = 5
