/mob/living/simple_animal/hostile/megafauna/drop_loot()
	if(enraged || prob(75))
		return ..()
	new /obj/structure/closet/crate/necropolis/tendril(loc)

/mob/living/simple_animal/hostile/megafauna/ancient_robot/drop_loot()
	if(enraged || prob(75))
		return ..()
	new /obj/structure/closet/crate/necropolis/tendril(loc)

/mob/living/simple_animal/hostile/megafauna/bubblegum/drop_loot()
	if(!enraged)
		return ..()
	var/crate_type = pick(loot)
	var/obj/structure/closet/crate/C = new crate_type(loc)
	new /obj/item/melee/spellblade/random(C)

/obj/structure/closet/crate/necropolis/bubblegum/populate_contents()
	new /obj/item/clothing/suit/space/hostile_environment(src)
	new /obj/item/clothing/head/helmet/space/hostile_environment(src)

/obj/item/melee/spellblade/random/afterattack__legacy__attackchain(atom/target, mob/living/user, proximity, params)
	if(is_mining_level(user.z) || istype(get_area(user), /area/ruin/space/bubblegum_arena) || user.health < 80 || iswizard(user))
		return ..()
