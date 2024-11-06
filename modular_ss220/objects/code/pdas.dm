/obj/item/pda/brigphysic
	default_cartridge = /obj/item/cartridge/secmed
	icon = 'icons/obj/pda.dmi' //для сохранения функционала ПДА-пэйнтера
	icon_state = "pda-brigphysic"
	desc = "ПДА для медика отдела службы безопасности. Включает в себя передовой картридж, только если его не украли."

// картридж для пда //
/obj/item/cartridge/secmed
	name = "Sec&med"
	desc = "A data cartridge for portable microcomputers. Has medical and security records and a med and reagent scanners."
	icon = 'icons/obj/pda.dmi'
	icon_state = "cart-sm"
	programs = list(
		new /datum/data/pda/utility/scanmode/medical,
		new /datum/data/pda/utility/scanmode/reagent,
		new /datum/data/pda/app/crew_records/security,
		new /datum/data/pda/app/crew_records/medical,
	)
