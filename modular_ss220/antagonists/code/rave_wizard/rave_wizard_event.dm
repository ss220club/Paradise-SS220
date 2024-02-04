#define MAGIVENDS_PRODUCTS_REFILL_VALUE 20
#define WIZARD_GREETING ("<span class='danger'>Вы — маг рейва!</span>")
#define WIZARD_WIKI ("<span class='motd'>На вики-странице доступна более подробная информация: ([GLOB.configuration.url.wiki_url]/index.php/Wizard)</span>")

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
		new_character.mind.make_rave_wizard()
		// This puts them at the wizard spawn, worry not
		new_character.equip_to_slot_or_del(new /obj/item/reagent_containers/food/drinks/mugwort(new_wizard), SLOT_HUD_IN_BACKPACK)
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
	// Makes magivends PLENTIFUL
	for(var/obj/machinery/economy/vending/magivend/magic in GLOB.machines)
		for(var/key in magic.products)
			magic.products[key] = MAGIVENDS_PRODUCTS_REFILL_VALUE // and so, there was prosperity for mages everywhere
		magic.product_records.Cut()
		magic.build_inventory(magic.products, magic.product_records)

/datum/mind/proc/make_rave_wizard()
	if(!(src in SSticker.mode.wizards))
		SSticker.mode.wizards += src
		special_role = SPECIAL_ROLE_WIZARD
		assigned_role = SPECIAL_ROLE_WIZARD
		//ticker.mode.learn_basic_spells(current)
		if(!GLOB.wizardstart.len)
			current.loc = pick(GLOB.latejoin)
			to_chat(current, "HOT INSERTION, GO GO GO")
		else
			current.loc = pick(GLOB.wizardstart)

		SSticker.mode.equip_wizard(current)
		for(var/obj/item/spellbook/S in current.contents)
			S.op = 0
		INVOKE_ASYNC(SSticker.mode, TYPE_PROC_REF(/datum/game_mode/wizard, name_wizard), current)
		SSticker.mode.forge_rave_wizard_objectives(src)
		SSticker.mode.greet_rave_wizard(src)
		SSticker.mode.update_wiz_icons_added(src)


/datum/game_mode/proc/greet_rave_wizard(datum/mind/wizard, you_are=1)
	addtimer(CALLBACK(wizard.current, TYPE_PROC_REF(/mob, playsound_local), null, 'sound/ambience/antag/ragesmages.ogg', 100, 0), 30)
	var/list/messages = list()
	if(you_are)
		messages.Add(WIZARD_GREETING)

	messages.Add(wizard.prepare_announce_objectives(title = FALSE))
	messages.Add(WIZARD_WIKI)
	to_chat(wizard.current, chat_box_red(messages.Join("<br>")))
	wizard.current.create_log(MISC_LOG, "[wizard.current] was made into a wizard")

/datum/game_mode/proc/forge_rave_wizard_objectives(datum/mind/wizard)
	wizard.add_mind_objective(/datum/objective/wizrave)

/datum/objective/wizrave
	explanation_text = "Устройте вечеринку, о которой потомки будут слагать легенды."
	needs_target = FALSE
	completed = TRUE

/datum/event_container/major/New()
	. = ..()
	available_events += list(new /datum/event_meta(EVENT_LEVEL_MAJOR, "Rave Wizard", /datum/event/rave_wizard, 10, is_one_shot = TRUE))

#undef MAGIVENDS_PRODUCTS_REFILL_VALUE
#undef WIZARD_GREETING
#undef WIZARD_WIKI
