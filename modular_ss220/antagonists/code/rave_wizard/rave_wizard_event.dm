#define MAGIVENDS_PRODUCTS_REFILL_VALUE 20
#define WIZARD_WIKI ("<span class='motd'>На вики-странице доступна более подробная информация: ([GLOB.configuration.url.wiki_url]/index.php/Wizard)</span>")
#define RAVE_WIZARD_EVENT_WEIGHT 5

/datum/event/rave_wizard

/datum/event/rave_wizard/start()
	INVOKE_ASYNC(src, PROC_REF(wrappedstart))

/datum/event/rave_wizard/proc/wrappedstart()

	var/image/source = image('modular_ss220/antagonists/icons/rave.dmi', "rave_poll")
	var/list/candidates = SSghost_spawns.poll_candidates("Do you want to play as a rave Space Wizard?", ROLE_WIZARD, TRUE, poll_time = 40 SECONDS, source = source)
	var/mob/dead/observer/new_wizard = null

	if(!length(candidates))
		kill()
		return

	new_wizard = pick(candidates)

	if(new_wizard)

		var/mob/living/carbon/human/new_character = makeBody(new_wizard)
		var/datum/antagonist/wizard/rave_wizard = new /datum/antagonist/wizard/rave()
		new_character.mind.add_antag_datum(rave_wizard)
		new_character.forceMove(pick(GLOB.wizardstart))
		// This puts them at the wizard spawn, worry not
		new_character.equip_to_slot_or_del(new /obj/item/reagent_containers/drinks/mugwort(new_wizard), SLOT_HUD_IN_BACKPACK)
		new_character.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses, SLOT_HUD_GLASSES)
		populate_magivends()
		// The first wiznerd can get their mugwort from the wizard's den, new ones will also need mugwort!
		dust_if_respawnable(new_wizard)
		return TRUE
	else
		. = FALSE
		CRASH("The candidates list for rave wizard contained non-observer entries!")

// ripped from -tg-'s wizcode, because whee lets make a very general proc for a very specific gamemode
// This probably wouldn't do half bad as a proc in __HELPERS
// Lemme know if this causes species to mess up spectacularly or anything
/datum/event/rave_wizard/proc/makeBody(mob/dead/observer/ghost_candidate)
	if(!ghost_candidate?.key)
		return // Let's not steal someone's soul here
	var/mob/living/carbon/human/new_character = new(pick(GLOB.latejoin))
	ghost_candidate.client.prefs.active_character.copy_to(new_character)
	new_character.key = ghost_candidate.key
	return new_character

/datum/event/rave_wizard/proc/populate_magivends()
	for(var/obj/machinery/economy/vending/magivend/magic in GLOB.machines)
		for(var/key in magic.products)
			magic.products[key] = MAGIVENDS_PRODUCTS_REFILL_VALUE // and so, there was prosperity for mages everywhere
		magic.product_records.Cut()
		magic.build_inventory(magic.products, magic.product_records)

/datum/event_container/major/New()
	. = ..()
	ASSERT(length(available_events) > 0)
	var/datum/event_meta/nothing_event = available_events[1]
	nothing_event.weight -= RAVE_WIZARD_EVENT_WEIGHT
	available_events += list(new /datum/event_meta(EVENT_LEVEL_MAJOR, "Rave Wizard", /datum/event/rave_wizard, RAVE_WIZARD_EVENT_WEIGHT, is_one_shot = TRUE))

#undef MAGIVENDS_PRODUCTS_REFILL_VALUE
#undef WIZARD_WIKI
#undef RAVE_WIZARD_EVENT_WEIGHT
