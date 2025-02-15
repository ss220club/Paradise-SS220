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

/obj/item/melee/spellblade/random
	name = "decrepit spellblade"

/obj/item/melee/spellblade/random/attack__legacy__attackchain(mob/living/target, mob/living/user, def_zone)
	if(is_mining_level(user.z) || istype(get_area(user), /area/ruin/space/bubblegum_arena) || user.health <= 0)
		return ..()

	var/extra_force
	var/extra_power
	if(user.health >= 80)
		extra_force = force/2
		force -= extra_force
		extra_power = power/2
		power -= extra_power
		. = ..()
		force += extra_force
		power += extra_power
		return

	extra_force = force/2 - force/2 * (80 - user.health) / 80
	extra_power = power/2 - power/2 * (80 - user.health) / 80
	force -= extra_force
	power -= extra_power
	. = ..()
	force += extra_force
	power += extra_power

/obj/item/melee/spellblade/random/afterattack__legacy__attackchain(atom/target, mob/living/user, proximity, params)
	if(is_mining_level(user.z) || istype(get_area(user), /area/ruin/space/bubblegum_arena) || user.health < 80 || iswizard(user))
		return ..()
