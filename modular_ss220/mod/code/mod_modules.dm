/obj/item/mod/module/insignia/red
	overlay_icon_file = 'modular_ss220/mod/icons/mob/mod_modules.dmi'

/obj/item/mod/module/insignia/red/commander
	color = "#4980a5"

/obj/item/mod/module/insignia/red/security
	color = "#b30d1e"

/obj/item/mod/module/insignia/red/engineer
	color = "#e9c80e"

/obj/item/mod/module/insignia/red/medic
	color = "#ebebf5"

/obj/item/mod/module/insignia/red/janitor
	color = "#7925c7"

/obj/item/mod/module/insignia/red/clown
	color = "#ff1fc7"

/obj/item/mod/module/insignia/red/chaplain
	color = "#f0a00c"

// holster tweak for bulky lasers
/obj/item/mod/module/holster
	var/static/list/forbidden = typesof(
		/obj/item/gun/rocketlauncher,
		/obj/item/gun/energy/lasercannon,
		/obj/item/gun/energy/lwap,
		/obj/item/gun/energy/emitter,
		/obj/item/gun/energy/pulse,
		/obj/item/gun/energy/bsg,
		/obj/item/gun/energy/meteorgun,
		/obj/item/gun/energy/temperature,
		/obj/item/gun/projectile/automatic/wt550,
		/obj/item/gun/projectile/automatic/laserrifle,
		/obj/item/gun/projectile/automatic/speargun,
		/obj/item/gun/projectile/revolver/overgrown,
		/obj/item/gun/projectile/revolver/doublebarrel,
		/obj/item/gun/projectile/shotgun,
		/obj/item/gun/projectile/automatic/sslr,
		/obj/item/gun/projectile/automatic/shotgun/bulldog,
	)

/obj/item/mod/module/holster/on_use()
	var/msg = "[holstered]"
	if(!holstered)
		var/obj/item/gun/holding = mod.wearer.get_active_hand()
		if(!holding)
			to_chat(mod.wearer, "<span class='warning'>Nothing to holster!</span>")
			return
		if(!istype(holding) || holding.w_class > WEIGHT_CLASS_BULKY)
			to_chat(mod.wearer, "<span class='warning'>It's too big to fit!</span>")
			return
		for(var/type in forbidden)
			if(istype(holding, type) && holding.w_class > WEIGHT_CLASS_NORMAL) //god no holstering a BSG / combat shotgun
				to_chat(mod.wearer, "<span class='warning'>It's too big to fit!</span>")
				return
		holstered = holding
		mod.wearer.visible_message("<span class='notice'>[mod.wearer] holsters [holstered].</span>", "<span class='notice'>You holster [holstered].</span>")
		mod.wearer.unequip(mod.wearer.get_active_hand())
		holstered.forceMove(src)
	else if(mod.wearer.put_in_active_hand(holstered))
		mod.wearer.visible_message("<span class='warning'>[mod.wearer] draws [msg], ready to shoot!</span>", \
			"<span class='warning'>You draw [msg], ready to shoot!</span>")
	else
		to_chat(mod.wearer, "<span class='warning'>You need an empty hand to draw [holstered]!</span>")
