#define DRUGS_AMOUNT_INJECTED_BY_TUMOR 20
#define ALCOHOL_AMOUNT_INJECTED_BY_TUMOR 20

/datum/spell/touch/touch/rocker
	name = "Rocker Touch"
	desc = "Teach those foolish suits how to spend time in style"
	hand_path = /obj/item/melee/touch_attack/rocker
	school = "transmutation"
	base_cooldown = 30 SECONDS
	clothes_req = TRUE
	action_icon_state = "no_state"
	action_background_icon_state = "curse"
	action_icon = 'modular_ss220/antagonists/icons/rave.dmi'

/obj/item/melee/touch_attack/rocker
	name = "rocker touch"
	desc = "It's time for anti corpo party to start"
	catchphrase = "YRTAP SIBENG"
	on_use_sound = 'modular_ss220/antagonists/sound/metal_riff.mp3'
	icon_state = "banana_touch"
	item_state = "banana_touch"

/datum/spellbook_entry/rocker_curse
	name = "Alcoholism curse"
	spell_type = /datum/spell/touch/touch/rocker
	category = "Rave"
	cost = 1

/obj/item/melee/touch_attack/rocker/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!proximity || target == user || !ishuman(target) || !iscarbon(user) || HAS_TRAIT(user, TRAIT_HANDS_BLOCKED))
		return

	var/datum/effect_system/smoke_spread/s = new
	s.set_up(5, FALSE, target)
	s.start()

	var/mob/living/carbon/human/H = target
	H.rocker_touched()
	..()

/mob/living/carbon/human/proc/rocker_touched()
	var/obj/item/organ/internal/chrome_tumor/tumor = new
	tumor.insert(src)
	AdjustWeakened(6 SECONDS)
	unEquip(w_uniform, TRUE)
	unEquip(shoes, TRUE)
	unEquip(wear_suit, TRUE)
	equipOutfit(new /datum/outfit/rocker_cursed)

/obj/item/organ/internal/chrome_tumor
	name = "chrome tumor"
	desc = "Shiny metallic tumor"
	origin_tech = "biotech=1"
	w_class = WEIGHT_CLASS_TINY
	parent_organ = "groin"
	slot = "liver_tumor"
	destroy_on_removal = TRUE //no icon, so just let it die
	unremovable = TRUE
	var/poisoned_offset = 0
	var/suffering_delay = 1200

/obj/item/organ/internal/chrome_tumor/on_life()
	if(poisoned_offset < world.time)
		poisoned_offset = world.time + suffering_delay
		if(prob(75))
			owner?.reagents.add_reagent("beer", ALCOHOL_AMOUNT_INJECTED_BY_TUMOR) //TODO change to choose from set of reagents
		if(prob(50))
			owner?.reagents.add_reagent("space_drugs", DRUGS_AMOUNT_INJECTED_BY_TUMOR) //TODO change to choose from set of reagents


/obj/item/organ/internal/chrome_tumor/insert(mob/living/carbon/M, special = 0)
	. = ..()
	poisoned_offset = world.time

/datum/outfit/rocker_cursed
	name = "Cursed Rocker"
	uniform = /obj/item/clothing/under/color/black/nodrop
	shoes = /obj/item/clothing/shoes/jackboots/nodrop
	suit = /obj/item/clothing/suit/leathercoat/nodrop

/obj/item/clothing/under/color/black/nodrop
	flags = NODROP

/obj/item/clothing/shoes/jackboots/nodrop
	flags = NODROP

/obj/item/clothing/suit/leathercoat/nodrop
	flags = NODROP
