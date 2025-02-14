/obj/item/storage/lockbox/experimental_weapon/gateway
	name = "A-48 classified lockbox"
	desc = "Contains a classifed item for experimental purposes."
	var/static/list/loot_options = list(
		/obj/item/gun/energy/sparker/selfcharge = 5,
		/obj/item/mod/module/sphere_transform = 5,
		/obj/item/mod/module/stealth/ninja = 5,

		/obj/item/organ/internal/cyberimp/arm/katana = 1,
		/obj/item/organ/internal/cyberimp/arm/toolset_abductor = 1,
		/obj/item/organ/internal/cyberimp/arm/medibeam = 1,
		/obj/item/organ/internal/heart/demon/pulse = 1,
		/obj/item/organ/internal/eyes/cybernetic/eyesofgod = 1,
	)

/obj/item/storage/lockbox/experimental_weapon/gateway/populate_contents()
	var/spawn_type = pick(loot_options)
	new spawn_type(src)
