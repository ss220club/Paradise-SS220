// TRAITOR ONLY GEAR

// JOB SPECIFIC GEAR

//Clown
/datum/uplink_item/jobspecific/clowngrenade
	name = "Banana Grenade"
	desc = "A grenade that explodes into HONK! brand banana peels that are genetically modified to be extra slippery and extrude caustic acid when stepped on."
	reference = "BG"
	item = /obj/item/grenade/clown_grenade
	cost = 15
	job = list("Clown")

/datum/uplink_item/jobspecific/clownslippers
	name = "Clown Acrobatic Shoes"
	desc = "A pair of modified clown shoes fitted with a built-in propulsion system that allows the user to perform a short slip below anyone. Turning on the waddle dampeners removes the slowdown on the shoes."
	reference = "CAS"
	item = /obj/item/clothing/shoes/clown_shoes/slippers
	cost = 10
	surplus = 75
	job = list("Clown")

/datum/uplink_item/jobspecific/cmag
	name = "Jestographic Sequencer"
	desc = "The jestographic sequencer, also known as a cmag, is a small card that inverts the access on any door it's used on. Perfect for locking command out of their own departments. Honk!"
	reference = "CMG"
	item = /obj/item/card/cmag
	cost = 15
	surplus = 75
	job = list("Clown")

/datum/uplink_item/jobspecific/clown_car
	name = "Clown Car"
	desc = "The Clown Car is the ultimate transportation method for any worthy clown! \
			Simply insert your bikehorn and get in, and get ready to have the funniest ride of your life! \
			You can ram any crew you come across and stuff them into your car, kidnapping them and locking them inside until \
			someone saves them or they manage to crawl out. Be sure not to ram into any walls or vending machines, as the springloaded seats \
			are very sensitive. Now with our included lube defense mechanism which will protect you against any angry shitcurity! \
			Premium features can be unlocked with a cryptographic sequencer!"
	reference = "CCR"
	item = /obj/tgvehicle/sealed/car/clowncar
	cost = 50
	job = list("Clown")
	surplus = 0
	hijack_only = TRUE

//mime
/datum/uplink_item/jobspecific/caneshotgun
	name = "Cane Shotgun and Assassination Shells"
	desc = "A specialized, one shell shotgun with a built-in cloaking device to mimic a cane. The shotgun is capable of hiding its contents and the pin alongside being suppressed. Comes boxed with 6 specialized shrapnel rounds laced with a silencing toxin, and 1 preloaded in the shotgun's chamber."
	reference = "MCS"
	item = /obj/item/storage/box/syndie_kit/caneshotgun
	cost = 20
	job = list("Mime")

/datum/uplink_item/jobspecific/mimery
	name = "Guide to Advanced Mimery Series"
	desc = "Contains two manuals to teach you advanced Mime skills. You will be able to shoot lethal bullets that silence out of your fingers, and create large walls that can block an entire hallway!"
	reference = "AM"
	item = /obj/item/storage/box/syndie_kit/mimery
	cost = 65
	job = list("Mime")
	surplus = 0 // I feel this just isn't healthy to be in these crates.

/datum/uplink_item/jobspecific/combat_baking
	name = "Combat Bakery Kit"
	desc = "A kit of clandestine baked weapons. Contains a baguette which a skilled mime could use as a sword, \
		a pair of throwing croissants, and the recipe to make more on demand. Once the job is done, eat the evidence."
	reference = "CBK"
	item = /obj/item/storage/box/syndie_kit/combat_baking
	cost = 15 //A chef can get a knife that sharp easily, though it won't block. While you can get endless boomerang, they are less deadly than a stech, and slower / more predictable.
	job = list("Mime", "Chef")

// Shaft miner
/datum/uplink_item/jobspecific/mining_charge_hacker
	name = "Mining Charge Hacker"
	desc = "Looks and functions like an advanced mining scanner, but allows mining charges to be placed anywhere and destroy more than rocks. \
	Use it on a mining charge to override its safeties. Reduces explosive power of mining charges due to the modification of their internals."
	reference = "MCH"
	item = /obj/item/t_scanner/adv_mining_scanner/syndicate
	cost = 15
	job = list("Shaft Miner")

//Chef
/datum/uplink_item/jobspecific/specialsauce
	name = "Chef Excellence's Special Sauce"
	desc = "A custom sauce made from the highly poisonous fly amanita mushrooms. Anyone who ingests it will take variable toxin damage depending on how long it has been in their system, with a higher dosage taking longer to metabolize."
	reference = "CESS"
	item = /obj/item/reagent_containers/condiment/syndisauce
	cost = 5
	job = list("Chef")
	surplus = 0 // Far too specific in its use.

/datum/uplink_item/jobspecific/meatcleaver
	name = "Meat Cleaver"
	desc = "A mean looking meat cleaver that does damage comparable to an Energy Sword, but with the added benefit of chopping your victim into hunks of meat after they've died."
	reference = "MC"
	item = /obj/item/kitchen/knife/butcher/meatcleaver
	cost = 30
	job = list("Chef")

//Chaplain

/datum/uplink_item/jobspecific/artistic_toolbox
	name = "His Grace"
	desc = "An incredibly dangerous weapon recovered from a station overcome by the Grey Tide. Once activated, He will thirst for blood and must be used to kill to sate that thirst. \
	His Grace grants gradual regeneration and complete stun immunity to His wielder, but be wary: if He gets too hungry, He will become impossible to drop and eventually kill you if not fed. \
	However, if left alone for long enough, He will fall back to slumber. \
	To activate His Grace, simply unlatch Him."
	reference = "HG"
	item = /obj/item/his_grace
	cost = 100
	job = list("Chaplain")
	surplus = 0 //No lucky chances from the crate; if you get this, this is ALL you're getting
	hijack_only = TRUE //This is a murderbone weapon, as such, it should only be available in those scenarios.

//Janitor

/datum/uplink_item/jobspecific/cautionsign
	name = "Proximity Mine"
	desc = "An Anti-Personnel proximity mine cleverly disguised as a wet floor caution sign that is triggered by running past it. Activate it to start the 15 second timer and activate again to disarm."
	reference = "PM"
	item = /obj/item/caution/proximity_sign
	cost = 5
	job = list("Janitor")

/datum/uplink_item/jobspecific/titaniumbroom
	name = "Titanium Push Broom"
	desc = "A push broom with a reinforced handle and a metal wire brush, perfect for giving yourself more work by beating up assistants. \
			When wielded, hitting people will have different effects based on your intent. "
	reference = "TPBR"
	item = /obj/item/push_broom/traitor
	cost = 45
	job = list("Janitor")
	surplus = 0 //no reflect memes

//Virology

/datum/uplink_item/jobspecific/viral_injector
	name = "Viral Injector"
	desc = "A modified hypospray disguised as a functional pipette. The pipette can infect victims with viruses upon injection."
	reference = "VI"
	item = /obj/item/reagent_containers/dropper/precision/viral_injector
	cost = 10
	job = list("Virologist")

//Assistant

/datum/uplink_item/jobspecific/pickpocketgloves
	name = "Pickpocket's Gloves"
	desc = "A pair of sleek gloves to aid in pickpocketing. While wearing these, you can loot your target without them knowing. Pickpocketing puts the item directly into your hand."
	reference = "PPG"
	item = /obj/item/clothing/gloves/color/black/thief
	cost = 15
	job = list("Assistant")

//Bartender

/datum/uplink_item/jobspecific/drunkbullets
	name = "Boozey Shotgun Shells"
	desc = "A box containing 6 shotgun shells that simulate the effects of extreme drunkenness on the target, more effective for each type of alcohol in the target's system."
	reference = "BSS"
	item = /obj/item/storage/box/syndie_kit/boolets
	cost = 5
	job = list("Bartender")

//Engineer

/datum/uplink_item/jobspecific/powergloves
	name = "Power Bio-Chip"
	desc = "A Bio-Chip that can utilize the power of the station to deliver a short arc of electricity at a target. \
			Must be standing on a powered cable to use. \
			Activated by alt-clicking, or pressing the middle mouse button. Help/disarm intent will deal stamina damage and cause jittering, while harm/grab intent will deal damage based on the power of the cable you're standing on. Can be toggled on / off via the action button."
	reference = "PG"
	item = /obj/item/bio_chip_implanter/shock
	cost = 30
	job = list("Station Engineer", "Chief Engineer")

/datum/uplink_item/jobspecific/meltdown_rod
	name = "Nuclear Meltdown Rod"
	desc = "A specially designed nuclear rod, guaranteed to cause the meltdown of any reactor it's placed into. For those tasked with detonating the station's nuclear warhead, this will not achieve that end."
	reference = "SMDR"
	item = /obj/item/nuclear_rod/fuel/meltdown
	cost = 25
	job = list("Station Engineer", "Chief Engineer")
	hijack_only = TRUE
	excludefrom = list(UPLINK_TYPE_NUCLEAR)

//Atmos Tech
/datum/uplink_item/jobspecific/contortionist
	name = "Contortionist's Jumpsuit"
	desc = "A highly flexible jumpsuit that will help you navigate the ventilation loops of the station internally. Comes with pockets and ID slot, but can't be used without stripping off most gear, including backpack, belt, helmet, and exosuit. Free hands are also necessary to crawl around inside."
	reference = "AIRJ"
	item = /obj/item/clothing/under/rank/engineering/atmospheric_technician/contortionist
	cost = 20
	job = list("Life Support Specialist")

/datum/uplink_item/jobspecific/energizedfireaxe
	name = "Energized Fire Axe"
	desc = "A fire axe with a massive energy charge built into it. Upon striking someone while charged it will throw them backwards while stunning them briefly, but will take some time to charge up again. It is also much sharper than a regular axe and can pierce light armor."
	reference = "EFA"
	item = /obj/item/fireaxe/energized
	cost = 45
	job = list("Life Support Specialist")

//Stimulants

/datum/uplink_item/jobspecific/stims
	name = "Stimulants"
	desc = "A highly illegal compound contained within a compact auto-injector; when injected it makes the user extremely resistant to incapacitation and greatly enhances the body's ability to repair itself."
	reference = "ST"
	item = /obj/item/reagent_containers/hypospray/autoinjector/stimulants
	cost = 35
	job = list("Scientist", "Research Director", "Geneticist", "Chief Medical Officer", "Medical Doctor", "Psychiatrist", "Chemist", "Paramedic", "Coroner", "Virologist")

// Paper contact poison pen

/datum/uplink_item/jobspecific/poison_pen
	name = "Poison Pen"
	desc = "Cutting edge of deadly writing implements technology, this gadget will infuse any piece of paper with various delayed poisons based on the selected color. Black ink is normal ink, red ink is a highly lethal poison, green ink causes radiation, blue ink will periodically shock the victim, and yellow ink will paralyze. The included gloves will protect you from your own poisons."
	reference = "PP"
	item = /obj/item/storage/box/syndie_kit/poisoner
	cost = 5
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
	job = list("Head of Personnel", "Quartermaster", "Cargo Technician", "Librarian", "Coroner", "Psychiatrist", "Virologist")

// Tarot card generator, librarian and Chaplain.

/datum/uplink_item/jobspecific/tarot_generator
	name = "Enchanted Tarot Card Deck"
	desc = "A magic tarot card deck \"borrowed\" from a Wizard federation storage unit. \
	Capable of producing magic tarot cards of the 22 major arcana, and their reversed versions. Each card has a different effect. \
	Throw the card at someone to use it on them, or use it in hand to apply it to yourself. Unlimited uses, 25 second cooldown, can have up to 3 cards in the world."
	reference = "tarot"
	item = /obj/item/tarot_generator
	cost = 50 //This can do a lot of stuff, but is quite random. As such, higher price.
	job = list("Chaplain", "Librarian")

// -------------------------------------
// ITEMS BLACKLISTED FROM NUCLEAR AGENTS
// -------------------------------------

/datum/uplink_item/dangerous/guardian
	name = "Holoparasites"
	reference = "HPA"
	desc = "Though capable of near sorcerous feats via use of hardlight holograms and nanomachines, they require an organic host as a home base and source of fuel. \
			The holoparasites are unable to incoporate themselves to changeling and vampire agents."
	item = /obj/item/storage/box/syndie_kit/guardian/uplink
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
	cost = 50
	refund_path = /obj/item/guardiancreator/tech/choose
	refundable = TRUE
	surplus = 0 // This being refundable makes this a big no no in my mind.
	uses_special_spawn = TRUE

/datum/uplink_item/dangerous/guardian/spawn_item(turf/loc, obj/item/uplink/U)
	if(..() != UPLINK_SPECIAL_SPAWNING)
		return FALSE

	new /obj/item/storage/box/syndie_kit/guardian/uplink(loc, cost)

/datum/uplink_item/stealthy_weapons/martialarts
	name = "Martial Arts Scroll"
	desc = "This scroll contains the secrets of an ancient martial arts technique. You will master unarmed combat, \
			deflecting ranged weapon fire when you are in a defensive stance (throw mode). Learning this art means you will also refuse to use dishonorable ranged weaponry. \
			Unable to be understood by vampire and changeling agents."
	reference = "SCS"
	item = /obj/item/sleeping_carp_scroll
	cost = 55
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
	can_discount = FALSE

/datum/uplink_item/stealthy_weapons/bearserk
	name = "Bearserker Pelt"
	desc = "A bear pelt that infuses the wearer with bear spirits and knowledge of an occultic martial art known as Rage of the Space Bear. \
			The pelt itself is also armored, providing the wearer great longevity. \
			Made with love, lots of spirits and lots of the other kind of spirits by the Syndicate-affiliated cult, Children of Ursa Major."
	reference = "BSP"
	item = /obj/item/clothing/head/bearpelt/bearserk
	cost = 30
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/stealthy_tools/frame
	name = "F.R.A.M.E. PDA Cartridge"
	desc = "When inserted into a personal digital assistant, this cartridge gives you five PDA viruses which \
			when used cause the targeted PDA to become a new uplink with zero TCs, and immediately become unlocked.  \
			You will receive the unlock code upon activating the virus, and the new uplink may be charged with \
			telecrystals normally."
	reference = "FRAME"
	item = /obj/item/cartridge/frame
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
	cost = 10

/datum/uplink_item/stealthy_tools/silicon_cham_suit
	name = "\"Big Brother\" Obfuscation Suit"
	desc = "A syndicate tactical suit equipped with the latest in anti-silicon technology and, allegedly, biological technology learned from the Changeling Hivemind. \
			While this suit is worn, you will be unable to be tracked or seen by on-Station AI."
	reference = "BBOS"
	item = /obj/item/clothing/under/syndicate/silicon_cham
	cost = 15
	excludefrom = list(UPLINK_TYPE_NUCLEAR)

/datum/uplink_item/stealthy_weapons/sleepy_pen
	name = "Sleepy Pen"
	desc = "A syringe disguised as a functional pen. It's filled with a potent anesthetic. \ The pen holds two doses of the mixture. The pen can be refilled."
	reference = "SP"
	item = /obj/item/pen/sleepy
	cost = 20
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/stealthy_weapons/dart_pistol
	name = "Dart Pistol Kit"
	desc = "A miniaturized version of a normal syringe gun. It is very quiet when fired and can fit into any space a small item can. Comes with 3 syringes: a knockout poison, a silencing agent and a deadly neurotoxin."
	reference = "DART"
	item = /obj/item/storage/box/syndie_kit/dart_gun
	cost = 10
	surplus = 50
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/// Nukies get combat gloves plus instead
/datum/uplink_item/stealthy_weapons/combat_minus
	name = "Experimental Krav Gloves"
	desc = "Experimental gloves with installed nanochips that teach you Krav Maga when worn, great as a cheap backup weapon. Warning, the nanochips will override any other fighting styles such as CQC. Do not look as fly as the Warden's"
	reference = "CGM"
	item = /obj/item/clothing/gloves/color/black/krav_maga
	cost = 45
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

// -----------------------------------
// PRICES OVERRIDEN FOR NUCLEAR AGENTS
// -----------------------------------

/datum/uplink_item/explosives/detomatix
	name = "Detomatix PDA Cartridge"
	desc = "When inserted into a personal digital assistant, this cartridge gives you five opportunities to detonate PDAs of crew members who have their message feature enabled. The concussive effect from the explosion will knock the recipient down for a short period, and deafen them for longer."
	reference = "DEPC"
	item = /obj/item/cartridge/syndicate
	cost = 15
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
