/mob/living/carbon/human/projectile_hit_check(obj/item/projectile/P)
	if(P.original && P.original == src)
		return TRUE
	return !density
