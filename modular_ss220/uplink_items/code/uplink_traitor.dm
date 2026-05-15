// TRAITOR ONLY GEAR

// JOB SPECIFIC GEAR

//Clown
/datum/uplink_item/jobspecific/clowngrenade
	cost = 10
	job = list("Clown")

/datum/uplink_item/jobspecific/clownslippers
	cost = 10
	job = list("Clown")

/datum/uplink_item/jobspecific/cmag
	cost = 15
	job = list("Clown")

/datum/uplink_item/jobspecific/clown_car
	cost = 50
	job = list("Clown")
	hijack_only = TRUE

//mime
/datum/uplink_item/jobspecific/caneshotgun
	cost = 20
	job = list("Mime")

/datum/uplink_item/jobspecific/mimery
	cost = 65
	job = list("Mime")

/datum/uplink_item/jobspecific/combat_baking
	cost = 15 //A chef can get a knife that sharp easily, though it won't block. While you can get endless boomerang, they are less deadly than a stech, and slower / more predictable.
	job = list("Mime", "Chef")

// Shaft miner
/datum/uplink_item/jobspecific/mining_charge_hacker
	cost = 15
	job = list("Shaft Miner")

//Chef
/datum/uplink_item/jobspecific/specialsauce
	cost = 5
	job = list("Chef")

/datum/uplink_item/jobspecific/meatcleaver
	cost = 30
	job = list("Chef")

//Chaplain

/datum/uplink_item/jobspecific/artistic_toolbox
	cost = 100
	job = list("Chaplain")
	hijack_only = TRUE //This is a murderbone weapon, as such, it should only be available in those scenarios.

//Janitor

/datum/uplink_item/jobspecific/cautionsign
	cost = 5
	job = list("Janitor")

/datum/uplink_item/jobspecific/titaniumbroom
	cost = 45
	job = list("Janitor")

//Virology

/datum/uplink_item/jobspecific/viral_injector
	cost = 10
	job = list("Virologist")

//Assistant

/datum/uplink_item/jobspecific/pickpocketgloves
	cost = 15
	job = list("Assistant")

//Bartender

/datum/uplink_item/jobspecific/drunkbullets
	cost = 5
	job = list("Bartender")

//Engineer

/datum/uplink_item/jobspecific/powergloves
	cost = 30
	job = list("Station Engineer", "Chief Engineer")

/datum/uplink_item/jobspecific/meltdown_rod
	cost = 25
	job = list("Station Engineer", "Chief Engineer")
	hijack_only = TRUE
	excludefrom = list(UPLINK_TYPE_NUCLEAR)

//Atmos Tech
/datum/uplink_item/jobspecific/contortionist
	cost = 20
	job = list("Life Support Specialist")

/datum/uplink_item/jobspecific/energizedfireaxe
	cost = 45
	job = list("Life Support Specialist")

//Stimulants

/datum/uplink_item/jobspecific/stims
	cost = 35
	job = list("Scientist", "Research Director", "Geneticist", "Chief Medical Officer", "Medical Doctor", "Psychiatrist", "Chemist", "Paramedic", "Coroner", "Virologist")

// Paper contact poison pen

/datum/uplink_item/jobspecific/poison_pen
	cost = 5
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
	job = list("Head of Personnel", "Quartermaster", "Cargo Technician", "Librarian", "Coroner", "Psychiatrist", "Virologist")

// Tarot card generator, librarian and Chaplain.

/datum/uplink_item/jobspecific/tarot_generator
	cost = 50 //This can do a lot of stuff, but is quite random. As such, higher price.
	job = list("Chaplain", "Librarian")

// -------------------------------------
// ITEMS BLACKLISTED FROM NUCLEAR AGENTS
// -------------------------------------

/datum/uplink_item/dangerous/guardian
	cost = 50

/datum/uplink_item/dangerous/guardian/spawn_item(turf/loc, obj/item/uplink/U)
	if(..() != UPLINK_SPECIAL_SPAWNING)
		return FALSE

	new /obj/item/storage/box/syndie_kit/guardian/uplink(loc, cost)

/datum/uplink_item/stealthy_weapons/martialarts
	cost = 55
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
	can_discount = FALSE

/datum/uplink_item/stealthy_weapons/bearserk
	cost = 30
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/stealthy_tools/frame
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
	cost = 10

/datum/uplink_item/stealthy_tools/silicon_cham_suit
	cost = 15
	excludefrom = list(UPLINK_TYPE_NUCLEAR)

/datum/uplink_item/stealthy_weapons/sleepy_pen
	cost = 20
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/stealthy_weapons/dart_pistol
	cost = 10
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/// Nukies get combat gloves plus instead
/datum/uplink_item/stealthy_weapons/combat_minus
	cost = 45
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

// -----------------------------------
// PRICES OVERRIDEN FOR NUCLEAR AGENTS
// -----------------------------------

/datum/uplink_item/explosives/detomatix
	cost = 15
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
