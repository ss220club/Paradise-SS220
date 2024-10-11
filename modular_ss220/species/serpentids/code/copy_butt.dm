/obj/machinery/photocopier/copyass(scanning = FALSE)
	if(!scanning) //If we're just storing this as a file inside the copier then we don't expend toner
		if(toner < 5)
			visible_message("<span class='notice'>A yellow light on [src] flashes, indicating there's not enough toner to finish the operation.</span>")
			return null
		total_copies++

	var/icon/temp_img

	if(emagged)
		if(ishuman(copymob))
			var/mob/living/carbon/human/H = copymob
			var/obj/item/organ/external/G = H.get_organ("groin")
			G.receive_damage(0, 30)
			H.emote("scream")
		else
			copymob.apply_damage(30, BURN)
		to_chat(copymob, "<span class='notice'>Something smells toasty...</span>")
	if(ishuman(copymob)) //Suit checks are in check_mob
		var/mob/living/carbon/human/H = copymob
		temp_img = icon(H.dna.species.butt_sprite_icon, H.dna.species.butt_sprite)
	else if(isdrone(copymob))
		temp_img = icon('icons/obj/butts.dmi', "drone")
	else if(isnymph(copymob))
		temp_img = icon('icons/obj/butts.dmi', "nymph")
	else if(isalien(copymob) || istype(copymob,/mob/living/simple_animal/hostile/alien)) //Xenos have their own asses, thanks to Pybro.
		temp_img = icon('icons/obj/butts.dmi', "xeno")
	else
		return
	var/obj/item/photo/p = new /obj/item/photo (loc)
	if(scanning)
		p.forceMove(src)
	else if(folder)
		p.forceMove(folder)
	p.desc = "You see [copymob]'s ass on the photo."
	p.pixel_x = rand(-10, 10)
	p.pixel_y = rand(-10, 10)
	p.img = temp_img
	var/icon/small_img = icon(temp_img) //Icon() is needed or else temp_img will be rescaled too >.>
	var/icon/ic = icon('icons/obj/items.dmi',"photo")
	small_img.Scale(8, 8)
	ic.Blend(small_img,ICON_OVERLAY, 10, 13)
	p.icon = ic
	return p
