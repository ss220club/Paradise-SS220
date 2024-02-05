#define SPELLBOOK_AVAILABLE_POINTS 4
#define MAGIVENDS_PRODUCTS_REFILL_VALUE 20
#define WIZARD_GREETING ("<span class='danger'>Вы — маг рейва!</span>")
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
		src.learn_rave_spells()
		for(var/obj/item/spellbook/S in current.contents)
			S.op = 0
			S.remove_harmful_spells_and_items()
			S.uses = SPELLBOOK_AVAILABLE_POINTS
		SSticker.mode.forge_rave_wizard_objectives(src)
		SSticker.mode.greet_rave_wizard(src)
		SSticker.mode.update_wiz_icons_added(src)
		SSticker.mode.name_wizard(current)

/datum/mind/proc/learn_rave_spells()
	var/spell_paths = list(/obj/effect/proc_holder/spell/projectile/beer_missile,
							/obj/effect/proc_holder/spell/aoe/conjure/timestop/dance,
							/obj/effect/proc_holder/spell/great_revelry,
							/obj/effect/proc_holder/spell/touch/rocker,
							/obj/effect/proc_holder/spell/aoe/conjure/summon_disco)
	for(var/spell_path in spell_paths)
		var/S = new spell_path
		src.AddSpell(S)

/obj/item/spellbook/proc/remove_harmful_spells_and_items()
	src.main_categories -= "Magical Items"
	src.main_categories -= "Loadouts"
	src.spell_categories -= "Offensive"
	src.spell_categories -= "Rituals"

/datum/game_mode/proc/greet_rave_wizard(datum/mind/wizard, you_are=1)
	SEND_SOUND(wizard.current, sound('sound/ambience/antag/ragesmages.ogg'))
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
	var/datum/event_meta/nothing_event = available_events[1]
	nothing_event.weight -= RAVE_WIZARD_EVENT_WEIGHT
	available_events += list(new /datum/event_meta(EVENT_LEVEL_MAJOR, "Rave Wizard", /datum/event/rave_wizard, RAVE_WIZARD_EVENT_WEIGHT, is_one_shot = TRUE))

#undef MAGIVENDS_PRODUCTS_REFILL_VALUE
#undef WIZARD_GREETING
#undef WIZARD_WIKI
#undef SPELLBOOK_AVAILABLE_POINTS
#undef RAVE_WIZARD_EVENT_WEIGHT
