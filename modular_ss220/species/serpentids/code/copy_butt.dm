/obj/machinery/photocopier/copyass(scanning = FALSE)
	. = .. ()
	if(ishuman(copymob)) //Suit checks are in check_mob
		var/mob/living/carbon/human/H = copymob
		var/temp_img = icon(H.dna.species.butt_sprite_icon, H.dna.species.butt_sprite)
	..img = temp_img
	var/icon/small_img = icon(temp_img) //Icon() is needed or else temp_img will be rescaled too >.>
	var/icon/ic = icon('icons/obj/items.dmi',"photo")
	small_img.Scale(8, 8)
	ic.Blend(small_img,ICON_OVERLAY, 10, 13)
	p.icon = ic
	return p
