///Хитиновые конечности - прочее
/obj/item/organ/external/head/doll
	icon_name = "empty"
	icobase = 'modular_ss220/species/eventdoll/icons/placeholder.dmi'

/obj/item/organ/external/head/doll/New(mob/living/carbon/holder)
	. = update_icon_alt(holder)
	if(.)
		.. ()

/obj/item/organ/external/chest/doll
	icon_name = "empty"
	icobase = 'modular_ss220/species/eventdoll/icons/placeholder.dmi'

/obj/item/organ/external/chest/doll/New(mob/living/carbon/holder)
	. = update_icon_alt(holder)
	if(.)
		.. ()

/obj/item/organ/external/groin/doll
	icon_name = "empty"
	icobase = 'modular_ss220/species/eventdoll/icons/placeholder.dmi'

/obj/item/organ/external/groin/doll/New(mob/living/carbon/holder)
	. = update_icon_alt(holder)
	if(.)
		.. ()

/obj/item/organ/external/arm/doll
	icon_name = "empty"
	icobase = 'modular_ss220/species/eventdoll/icons/placeholder.dmi'

/obj/item/organ/external/arm/doll/New(mob/living/carbon/holder)
	. = update_icon_alt(holder)
	if(.)
		.. ()

/obj/item/organ/external/arm/right/doll
	icon_name = "empty"
	icobase = 'modular_ss220/species/eventdoll/icons/placeholder.dmi'

/obj/item/organ/external/arm/right/doll/New(mob/living/carbon/holder)
	. = update_icon_alt(holder)
	if(.)
		.. ()

/obj/item/organ/external/leg/doll
	icon_name = "empty"
	icobase = 'modular_ss220/species/eventdoll/icons/placeholder.dmi'

/obj/item/organ/external/leg/doll/New(mob/living/carbon/holder)
	. = update_icon_alt(holder)
	if(.)
		.. ()

/obj/item/organ/external/hand/doll
	icon_name = "empty"
	icobase = 'modular_ss220/species/eventdoll/icons/placeholder.dmi'

/obj/item/organ/external/hand/doll/New(mob/living/carbon/holder)
	. = update_icon_alt(holder)
	if(.)
		.. ()

/obj/item/organ/external/hand/right/doll
	icon_name = "empty"
	icobase = 'modular_ss220/species/eventdoll/icons/placeholder.dmi'

/obj/item/organ/external/hand/right/doll/New(mob/living/carbon/holder)
	. = update_icon_alt(holder)
	if(.)
		.. ()

/obj/item/organ/external/leg/right/doll
	icon_name = "empty"
	icobase = 'modular_ss220/species/eventdoll/icons/placeholder.dmi'

/obj/item/organ/external/leg/right/doll/New(mob/living/carbon/holder)
	. = update_icon_alt(holder)
	if(.)
		.. ()

/obj/item/organ/external/foot/doll
	icon_name = "empty"
	icobase = 'modular_ss220/species/eventdoll/icons/placeholder.dmi'

/obj/item/organ/external/foot/doll/New(mob/living/carbon/holder)
	. = update_icon_alt(holder)
	if(.)
		.. ()

/obj/item/organ/external/foot/right/doll
	icon_name = "empty"
	icobase = 'modular_ss220/species/eventdoll/icons/placeholder.dmi'

/obj/item/organ/external/foot/right/doll/New(mob/living/carbon/holder)
	. = update_icon_alt(holder)
	if(.)
		.. ()

/obj/item/organ/external/proc/update_icon_alt(mob/living/carbon/holder)
	if(ishuman(holder))
		var/mob/living/carbon/human/H = holder
		replaced(H)
		sync_colour_to_human(H)
		properly_attached = TRUE

	if(is_robotic())
		// These can just be slapped on.
		properly_attached = TRUE

	get_icon()

	// so you can just smack the limb onto a guy to start the "surgery"
	var/application_surgery
	if(!is_robotic())
		application_surgery = /datum/surgery/reattach
	else
		application_surgery = /datum/surgery/reattach_synth

	AddComponent(/datum/component/surgery_initiator/limb, forced_surgery = application_surgery)

	return FALSE
