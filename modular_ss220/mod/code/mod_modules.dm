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
	var/static/list/overridebulky = list(
		/obj/item/gun/energy/gun,
		/obj/item/gun/energy/gun/advtaser,
		/obj/item/gun/energy/gun/nuclear,
		/obj/item/gun/energy/immolator,
		/obj/item/gun/energy/immolator/multi,
		/obj/item/gun/energy/laser,
		/obj/item/gun/energy/laser/retro,
		/obj/item/gun/energy/laser/retro/old,
		/obj/item/gun/energy/xray,
	)

/obj/item/mod/module/holster/on_use()
	if(!holstered)
		var/obj/item/gun/holding = mod.wearer.get_active_hand()
		if(!holding)
			to_chat(mod.wearer, "<span class='warning'>Nothing to holster!</span>")
			return
		for(var/type in overridebulky)
			if(holding.type == type)
				holstered = holding
				mod.wearer.visible_message("<span class='notice'>[mod.wearer] holsters [holstered].</span>", "<span class='notice'>You holster [holstered].</span>")
				mod.wearer.unequip(mod.wearer.get_active_hand())
				holstered.forceMove(src)
				return
		. = ..()
	else . = ..()
