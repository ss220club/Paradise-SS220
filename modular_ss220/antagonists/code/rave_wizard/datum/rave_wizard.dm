#define SPELLBOOK_AVAILABLE_POINTS 4
/datum/antagonist/wizard/rave

/datum/objective/wizrave
	explanation_text = "Устройте вечеринку, о которой потомки будут слагать легенды."
	needs_target = FALSE
	completed = TRUE

/datum/antagonist/wizard/rave/give_objectives()
	add_antag_objective(/datum/objective/wizrave)

/datum/antagonist/wizard/rave/on_gain()
	. = ..()
	var/spell_paths = list(/datum/spell/projectile/magic_missile/beer,
							/datum/spell/aoe/conjure/timestop/dance,
							/datum/spell/great_revelry,
							/datum/spell/touch/touch/rocker,
							/datum/spell/aoe/conjure/summon_disco)
	for(var/spell_path in spell_paths)
		var/S = new spell_path
		owner.AddSpell(S)


/datum/mind/proc/enrave() //for admin spawn
	if(!has_antag_datum(/datum/antagonist/wizard/rave))
		return
	var/obj/item/spellbook/spellbook = new /obj/item/spellbook(src)
	spellbook.owner = src
	spellbook.remove_harmful_spells_and_items()
	spellbook.uses = SPELLBOOK_AVAILABLE_POINTS
	src.current.equip_to_slot_or_del(spellbook, SLOT_HUD_LEFT_HAND)


/datum/antagonist/wizard/rave/equip_wizard() //copypasta to make spellbook adjustments
	if(!ishuman(owner.current))
		return
	var/mob/living/carbon/human/new_wiz = owner.current

	//So zards properly get their items when they are admin-made.
	qdel(new_wiz.wear_suit)
	qdel(new_wiz.head)
	qdel(new_wiz.shoes)
	qdel(new_wiz.r_hand)
	qdel(new_wiz.r_store)
	qdel(new_wiz.l_store)

	if(isplasmaman(new_wiz))
		new_wiz.equipOutfit(new /datum/outfit/plasmaman/wizard)
		new_wiz.internal = new_wiz.r_hand
		new_wiz.update_action_buttons_icon()
	else
		new_wiz.equip_to_slot_or_del(new /obj/item/clothing/under/color/lightpurple(new_wiz), SLOT_HUD_JUMPSUIT)
		new_wiz.equip_to_slot_or_del(new /obj/item/clothing/head/wizard(new_wiz), SLOT_HUD_HEAD)
		new_wiz.dna.species.after_equip_job(null, new_wiz)
	new_wiz.rejuvenate() //fix any damage taken by naked vox/plasmamen/etc while round setups
	new_wiz.equip_to_slot_or_del(new /obj/item/radio/headset(new_wiz), SLOT_HUD_LEFT_EAR)
	new_wiz.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(new_wiz), SLOT_HUD_SHOES)
	new_wiz.equip_to_slot_or_del(new /obj/item/clothing/suit/wizrobe(new_wiz), SLOT_HUD_OUTER_SUIT)
	new_wiz.equip_to_slot_or_del(new /obj/item/storage/backpack/satchel(new_wiz), SLOT_HUD_BACK)
	if(new_wiz.dna.species.speciesbox)
		new_wiz.equip_to_slot_or_del(new new_wiz.dna.species.speciesbox(new_wiz), SLOT_HUD_IN_BACKPACK)
	else
		new_wiz.equip_to_slot_or_del(new /obj/item/storage/box/survival(new_wiz), SLOT_HUD_IN_BACKPACK)
	new_wiz.equip_to_slot_or_del(new /obj/item/teleportation_scroll(new_wiz), SLOT_HUD_RIGHT_STORE)
	var/obj/item/spellbook/spellbook = new /obj/item/spellbook(new_wiz)
	spellbook.owner = new_wiz
	spellbook.remove_harmful_spells_and_items()
	spellbook.uses = SPELLBOOK_AVAILABLE_POINTS
	new_wiz.equip_to_slot_or_del(spellbook, SLOT_HUD_LEFT_HAND)

	var/list/reading = list()
	reading += "You will find a list of available spells in your spell book. Choose your magic arsenal carefully."
	reading += "The spellbook is bound to you, and others cannot use it."
	reading += "In your pockets you will find a teleport scroll. Use it as needed."
	new_wiz.mind.store_memory("<B>Remember:</B> do not forget to prepare your spells.")
	new_wiz.update_icons()
	new_wiz.gene_stability += DEFAULT_GENE_STABILITY //magic
	return reading

/obj/item/spellbook/proc/remove_harmful_spells_and_items()
	main_categories -= "Magical Items"
	main_categories -= "Loadouts"
	spell_categories -= "Offensive"
	spell_categories -= "Rituals"

/datum/spellbook_entry/summon_supermatter
	category = "Offensive"

/datum/spellbook_entry/rathens
	category = "Offensive"
