/datum/species/grey/handle_reagents(mob/living/carbon/human/H, datum/reagent/R)
	if(R.id == "facid")
		return TRUE
	. = ..()

/datum/reagent/acid/facid/reaction_mob(mob/living/M, method = REAGENT_TOUCH, volume)
	if(ishuman(M) && isgrey(M)) // Ради вот этой строчки пришлось скопировать весь код. Надо будет следить специально для греев, если будут изменять facid
		var/mob/living/carbon/human/H = M
		if(method == REAGENT_TOUCH)
			if(volume > 9)
				if(!H.wear_mask && !H.head)
					var/obj/item/organ/external/affecting = H.get_organ("head")
					if(istype(affecting))
						affecting.disfigure()
					H.adjustFireLoss(min(max(8, (volume - 5) * 3), 75))
					H.emote("scream")
					return
				else
					var/melted_something = FALSE
					if(H.wear_mask && !(H.wear_mask.resistance_flags & ACID_PROOF))
						to_chat(H, "<span class='danger'>Your [H.wear_mask.name] melts away!</span>")
						qdel(H.wear_mask)
						melted_something = TRUE

					if(H.head && !(H.head.resistance_flags & ACID_PROOF))
						melted_something = TRUE
						if(istype(H.head, /obj/item/clothing/head/mod) && ismodcontrol(H.back))
							var/obj/item/mod/control/C = H.back
							var/name = H.head.name
							C.seal_part(H.head, FALSE)
							C.retract(null, H.head)
							to_chat(H, "<span class='danger'>Your [name] melts away as your [C.name] performs emergency cleaning on the helmet, deactivating the suit!</span>")
						else
							to_chat(H, "<span class='danger'>Your [H.head.name] melts away!</span>")
							qdel(H.head)
					if(melted_something)
						return

		if(volume >= 5)
			H.emote("scream")
			H.adjustFireLoss(min(max(8, (volume - 5) * 3), 75))
		to_chat(H, "<span class='warning'>The blueish acidic substance stings[volume < 5 ? " you, but isn't concentrated enough to harm you" : null]!</span>")
		return
	. = ..()
