/obj/item/organ/internal
	var/is_special_effect = FALSE

/obj/item/organ/internal/nucleation
	name = "nucleation organ"
	icon = 'modular_ss220/species/nucleations/icons/obj/surgery.dmi'
	desc = "A crystalized human organ. /red It has a strangely iridescent glow."
	max_integrity = 500
	is_special_effect = TRUE
	var/integrity_item_dust = 50
	var/amount_fire_loss = 20
	var/radiation_pulse_amount = 200
	var/radiation_pulse_range = 2
	var/temp_protect = ARMOR_MAX_TEMP_PROTECT

/obj/item/organ/internal/nucleation/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_SUPERMATTER_IMMUNE, ROUNDSTART_TRAIT)

/obj/item/organ/internal/nucleation/can_be_pulled(mob/user)
	if(!check_touched(user))
		return ..()
	return FALSE

/obj/item/organ/internal/nucleation/item_interaction(mob/living/user, obj/item, list/modifiers)
	if(!istype(used))
		return ..()

	if(istype(item, /obj/item/organ/internal/nucleation) || istype(item, /obj/item/organ/internal/ears/resonant_crystal))
		playsound(src, 'sound/effects/supermatter.ogg', 50, TRUE)
		radiation_pulse(user, radiation_pulse_amount, radiation_pulse_range)
		var/flash_range = rand(2, 7)
		item.obj_integrity -= integrity_item_dust
		if(item.obj_integrity <= integrity_item_dust)
			explosion(user, 0, 0, 1, flash_range)
			QDEL_NULL(item)
		obj_integrity -= integrity_item_dust
		if(obj_integrity <= integrity_item_dust)
			explosion(user, 0, 0, 1, flash_range)
			QDEL_NULL(src)
		return ITEM_INTERACT_COMPLETE

	if(istype(item, /obj/item/retractor/supermatter))
		var/obj/item/retractor/supermatter/tongs = item
		if(tongs.sliver)
			to_chat(user, SPAN_WARNING("[tongs] уже что-то удерживает!"))
			return FALSE
		forceMove(tongs)
		tongs.sliver = src
		tongs.icon_state = "supermatter_tongs_loaded"
		to_chat(user, SPAN_NOTICE("You carefully pick up [src] with [tongs]."))
	else if(istype(item, /obj/item/scalpel/supermatter) || istype(item, /obj/item/nuke_core_container/supermatter) || HAS_TRAIT(item, TRAIT_SUPERMATTER_IMMUNE)) // we don't want it to dust
		return ITEM_INTERACT_COMPLETE
	else
		try_burn_hit(I, user)
		return ITEM_INTERACT_COMPLETE

/obj/item/organ/internal/nucleation/attack(mob/living/target, mob/living/carbon/user)
	if(!try_burn_hit(affected_user = target, def_zone = target.zone_selected))
		return ..()

/obj/item/organ/internal/nucleation/activate_self(mob/living/target)
	if(!try_burn_hit(affected_user = target, def_zone = target.zone_selected))
		return ..()

/obj/item/organ/internal/nucleation/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	var/picked_def_zone = "chest"
	if(ismob(hit_atom))
		var/mob/M = hit_atom
		picked_def_zone = M.zone_selected
		if(try_burn_hit(affected_user = M, def_zone = picked_def_zone))
			return TRUE
	return ..()

/obj/item/organ/internal/nucleation/pickup(mob/living/user)
	if(!try_burn_hit(affected_user = user))
		return ..()
	user.drop_item()
	forceMove(user.drop_location())

/obj/item/organ/internal/nucleation/proc/try_burn_hit(obj/item/affected_item, mob/living/affected_user, def_zone)
	if(burn_hit(affected_item, affected_user, def_zone))
		playsound(src, 'sound/effects/supermatter.ogg', 50, TRUE)
		return TRUE
	return FALSE

/obj/item/organ/internal/nucleation/proc/burn_hit(obj/item/affected_item, mob/living/affected_user, def_zone)
	if(!(affected_item || affected_user))
		return FALSE
	. = FALSE

	if(affected_item && !HAS_TRAIT(affected_item, TRAIT_SUPERMATTER_IMMUNE))
		obj_integrity -= integrity_item_dust
		if(affected_item.obj_integrity <= integrity_item_dust)
			to_chat(affected_user, SPAN_DANGER("[affected_item] испепелился!"))
			qdel(affected_item)
			. = TRUE

	if(affected_user)
		if(!check_touched(affected_user))
			return .

		radiation_pulse(affected_user, radiation_pulse_amount, radiation_pulse_range)

		if(!ishuman(affected_user))
			affected_user.adjustFireLoss(amount_fire_loss)
			return TRUE
		var/mob/living/carbon/human/H = affected_user

		if(H.handcuffed)
			to_chat(H, SPAN_DANGER("[src] сжег надетые на вас [H.handcuffed]!"))
			QDEL_NULL(H.handcuffed)
			H.update_handcuffed()
			return TRUE

		if(!def_zone)
			def_zone = H.hand ? BODY_ZONE_PRECISE_L_HAND : BODY_ZONE_PRECISE_R_HAND
			if(H.gloves && H.gloves.max_heat_protection_temperature >= temp_protect)
				return TRUE
		var/obj/item/organ/external/organ = H.bodyparts_by_name[def_zone]
		if(organ)
			H.adjustFireLossByPart(amount_fire_loss, def_zone)
			if(organ.burn_dam >= max_damage-5)
				to_chat(H, SPAN_DANGER("Испарил вашу конечность - [organ.name]!"))
				QDEL_NULL(organ)
				return TRUE
			to_chat(H, SPAN_DANGER("Вы обожглись о [src]!"))
			return TRUE

	return .

/obj/item/organ/internal/nucleation/proc/check_touched(mob/user)
	if(user.status_flags & GODMODE || HAS_TRAIT(user, TRAIT_SUPERMATTER_IMMUNE))
		return FALSE
	return TRUE

// ============ ORGANS ============
/obj/item/organ/internal/nucleation/strange_crystal
	name = "strange crystal"
	icon_state = "strange-crystal"
	organ_tag = "strange crystal"
	parent_organ = "chest"
	slot = "heart"

/obj/item/organ/internal/ears/resonant_crystal
	name = "resonant crystal"
	icon = 'modular_ss220/species/nucleations/icons/obj/surgery.dmi'
	icon_state = "resonant-crystal"
	organ_tag = "resonant crystal"
	parent_organ = "head"
	slot = "ears"

/obj/item/organ/internal/ears/resonant_crystal/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_SUPERMATTER_IMMUNE, ROUNDSTART_TRAIT)

/obj/item/organ/internal/eyes/luminescent_crystal
	name = "luminescent eyes"
	icon = 'modular_ss220/species/nucleations/icons/obj/surgery.dmi'
	icon_state = "crystal-eyes"
	organ_tag = "luminescent eyes"
	light_color = "#1C1C00"

/obj/item/organ/internal/eyes/luminescent_crystal/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_SUPERMATTER_IMMUNE, ROUNDSTART_TRAIT)
/obj/item/organ/internal/eyes/luminescent_crystal/New()
	set_light(2)
	..()

/obj/item/organ/internal/brain/crystal
	name = "crystallized brain"
	icon = 'modular_ss220/species/nucleations/icons/obj/surgery.dmi'
	icon_state = "crystal-brain"
	organ_tag = "crystallized brain"


/obj/item/organ/internal/brain/crystal/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_SUPERMATTER_IMMUNE, ROUNDSTART_TRAIT)
