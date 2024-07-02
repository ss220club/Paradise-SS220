/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/nomad/carbine
	equip_cooldown = 0.5 SECONDS
	name = "\improper FNX-66 Carbine"
	icon_state = "mecha_carbine"
	origin_tech = "materials=4;combat=4"
	projectile = /obj/item/projectile/bullet/weakbullet3
	fire_sound = 'sound/weapons/gunshots/gunshot_rifle.ogg'
	projectiles_per_shot = 3
	projectiles = 100
	projectile_energy_cost = 0

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/nomad/missile
	name = "\improper Nomad Light Missile Rack"
	icon_state = "mecha_missilerack_six"
	origin_tech = "combat=5;materials=4;engineering=4"
	projectile = /obj/item/projectile/missile/light
	fire_sound = 'sound/effects/bang.ogg'
	projectiles_per_shot = 1
	projectiles = 10
	projectile_energy_cost = 0
	projectile = /obj/item/projectile/missile/light
	harmful = TRUE

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/nomad/proc/prepareProjectile(mob/living/carbon/gunner, turf/curloc, dir, spread, target, targloc, params)
	var/obj/item/projectile/A = new projectile(curloc)
	A.firer = gunner
	A.firer_source_atom = src
	A.original = target
	A.current = curloc
	A.preparePixelNomadProjectile(get_step(curloc, dir), target, targloc, gunner, params, spread)
	A.fire()

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/nomad/action(target, params)
	if(!action_checks(target))
		return

	var/obj/mecha/combat/nomad/parsed_chassis = chassis

	if(!parsed_chassis)
		return

	var/turf/curloc = get_turf(chassis)
	var/turf/targloc = get_turf(target)
	if(!targloc || !istype(targloc) || !curloc)
		return
	if(targloc == curloc)
		return

	set_ready_state(0)
	for(var/i=1 to get_shot_amount())
		var/spread = 0
		if(variance)
			if(randomspread)
				spread = round((rand() - 0.5) * variance)
			else
				spread = round((i / projectiles_per_shot - 0.5) * variance)
		var/projectileDir1 = parsed_chassis.dir == EAST ? EAST : parsed_chassis.dir == WEST ? WEST : WEST
		var/projectileDir2 = parsed_chassis.dir == EAST ? EAST : parsed_chassis.dir == WEST ? WEST : EAST
		prepareProjectile(parsed_chassis.gunner, curloc, projectileDir1, spread, target, targloc, params)
		prepareProjectile(parsed_chassis.gunner, curloc, projectileDir2, spread, target, targloc, params)
		chassis.use_power(energy_drain)
		projectiles--
		playsound(chassis, fire_sound, 50, 1)

		sleep(max(0, projectile_delay))
	set_ready_state(0)
	log_message("Fired from [name], targeting [target].")
	add_attack_logs(parsed_chassis.gunner, target, "fired a [src]")
	do_after_cooldown()

/obj/item/projectile/proc/preparePixelNomadProjectile(turf/startloc, atom/target, turf/targloc, mob/living/user, params, spread)
	var/turf/curloc = get_turf(user)
	loc = startloc
	starting = startloc
	current = curloc
	yo = targloc.y - curloc.y
	xo = targloc.x - curloc.x

	if(params)
		var/list/mouse_control = params2list(params)
		if(mouse_control["icon-x"])
			p_x = text2num(mouse_control["icon-x"])
		if(mouse_control["icon-y"])
			p_y = text2num(mouse_control["icon-y"])
		if(mouse_control["screen-loc"])
			//Split screen-loc up into X+Pixel_X and Y+Pixel_Y
			var/list/screen_loc_params = splittext(mouse_control["screen-loc"], ",")

			//Split X+Pixel_X up into list(X, Pixel_X)
			var/list/screen_loc_X = splittext(screen_loc_params[1],":")

			//Split Y+Pixel_Y up into list(Y, Pixel_Y)
			var/list/screen_loc_Y = splittext(screen_loc_params[2],":")
			var/x = (text2num(screen_loc_X[1]) - 1) * world.icon_size + text2num(screen_loc_X[2])
			var/y = (text2num(screen_loc_Y[1]) - 1) * world.icon_size + text2num(screen_loc_Y[2])

			//Calculate the "resolution" of screen based on client's view and world's icon size. This will work if the user can view more tiles than average.
			var/list/screenview = getviewsize(user.client.view)

			var/ox = round((screenview[1] * world.icon_size) / 2) - user.client.pixel_x //"origin" x
			var/oy = round((screenview[2] * world.icon_size) / 2) - user.client.pixel_y //"origin" y
			var/angle = ATAN2(y - oy, x - ox)
			Angle = angle
	if(spread)
		Angle += spread

