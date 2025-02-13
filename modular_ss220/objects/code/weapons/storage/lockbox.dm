/obj/item/storage/lockbox/experimental_weapon/gateway
	name = "A-48 classified lockbox"
	desc = "Contains a classifed item for experimental purposes."

/obj/item/storage/lockbox/experimental_weapon/gateway/populate_contents()
	var/spawn_type = pick(/obj/item/gun/energy/gun/mini/selfcharge, /obj/item/mod/module/sphere_transform, /obj/item/mod/module/stealth/ninja)
	if(prob(25))
		var/list/organ_loot = list(
			/obj/item/organ/internal/cyberimp/arm/katana,
			/obj/item/organ/internal/cyberimp/arm/toolset_abductor,
			/obj/item/organ/internal/cyberimp/arm/medibeam,
			/obj/item/organ/internal/heart/demon/pulse,
			/obj/item/organ/internal/eyes/cybernetic/eyesofgod,
		)
		spawn_type = pick(organ_loot)
	new spawn_type(src)
