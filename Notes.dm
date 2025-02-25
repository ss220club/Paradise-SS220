/// Тут мы будем делать боргов great again

/obj/item/robot_module/engineering/Initialize(mapload)
	. = ..()
	basic_modules |= list(
		/obj/item/lightreplacer/cyborg,
		/obj/item/inflatable/cyborg,
		/obj/item/inflatable/cyborg/door,
		/obj/item/gps/cyborg,
		/obj/item/holosign_creator/atmos,
		)

/obj/item/holosign_creator/atmos
	name = "ATMOS holofan projector"
	desc = "A holographic projector that creates holographic barriers that prevent changes in atmosphere conditions."
	icon_state = "signmaker_engi"
	belt_icon = null
	holosign_type = /obj/structure/holosign/barrier/atmos
	creation_time = 0
	max_signs = 3

/obj/item/borg/upgrade/hypospray
	name = "cyborg hypospray upgrade"
	desc = "Adds and replaces some reagents with better ones"
	icon_state = "cyborg_upgrade2"
	origin_tech = "biotech=6;materials=5"
	require_module = TRUE
	module_type = /obj/item/robot_module/medical
	items_to_replace = list(
		/obj/item/reagent_containers/borghypo/basic = /obj/item/reagent_containers/borghypo/basic/upgraded
	)
/// ----- ///

/// > modular_ss220\silicons\code\robot_items.dm

/obj/item/holosign_creator/atmos/robot_standart
    name = "Модульный ATMOS голопроектор"
    desc = "Стандартный модуль ATMOS голопроектора, предназначенный для использования инженерными киборгами. Создаваемые голопроекции полностью блокируют перемещение газов.\
    <br>Количество создаваемых голопроекций снижено относительно немодульного аналога в целях снижения энергопотребления."
    max_signs = 1

/obj/item/holosign_creator/atmos/robot_better
    name = "Улучшенный модульный ATMOS голопроектор"
    desc = "Улучшенный модуль ATMOS голопроектора, предназначенный для использования инженерными киборгами.\
    <br>Количество создаваемых голопроекций увеличено до 3 за счёт применения улучшенных материалов."
    icon = 'modular_ss220/silicons/icons/robot_tools.dmi'
    icon_state = "atmos_holofan_better"
    max_signs = 3

/obj/item/holosign_creator/atmos/robot_best
    name = "Продвинутый модульный ATMOS голопроектор"
    desc = "Продвинутый модуль ATMOS голопроектора, предназначенный для использования инженерными киборгами.\
    <br>Количество создаваемых голопроекций увеличено до 5 за счёт точечной оптимизации микросхем и применения редких материалов."
    icon = 'modular_ss220/silicons/icons/robot_tools.dmi'
    icon_state = "atmos_holofan_best"
    max_signs = 5


/// > modular_ss220\silicons\code\robot_upgrades.dm

/obj/item/borg/upgrade/atmos_holofan_better
    name = "Улучшение модульного ATMOS голопроектора"
    desc = "Повышает энергоэффективность проектора, позволяя создавать до 3 голограмм."
    origin_tech = "materials=4;engineering=4;magnets=4"
    require_module = TRUE
    module_type = /obj/item/robot_module/engineering
    items_to_replace = list(
            /obj/item/holosign_creator/atmos/robot_standart = /obj/item/holosign_creator/atmos/robot_upgraded
    )

/obj/item/borg/upgrade/atmos_holofan_best
    name = "Оптимизация модульного ATMOS голопроектора"
    desc = "Оптимизирует энергоэффективность проектора и заменяет микросхемы на продвинутые, позволяя создавать до 5 голограмм."
    origin_tech = "materials=6;engineering=6;magnets=7;programming=6"
    require_module = TRUE
    module_type = /obj/item/robot_module/engineering
    items_to_replace = list(
            /obj/item/holosign_creator/atmos/robot_upgraded = /obj/item/holosign_creator/atmos/robot_advanced
    )


/// > modular_ss220\silicons\code\mechfabricator_designs.dm

/datum/design/borg_upgrade_atmos_better
    name = "Engineer Cyborg Upgrade (Upgraded ATMOS holofan projector)"
    id = "borg_upgrade_atmos_holofan_better"
    build_type = MECHFAB
    build_path = /obj/item/borg/upgrade/atmos_holofan_better
    req_tech = list("materials" = 5, "engineering" = 5, "magnets" = 5)
    materials = list(MAT_METAL=5000, MAT_SILVER=2500, MAT_GOLD=2500, MAT_GLASS=2500)
    construction_time = 120
    category = list("Cyborg Upgrade Modules")

/datum/design/borg_upgrade_atmos_best
    name = "Engineer Cyborg Upgrade (Advanced ATMOS holofan projector)"
    id = "borg_upgrade_atmos_holofan_best"
    build_type = MECHFAB
    build_path = /obj/item/borg/upgrade/atmos_holofan_best
    req_tech = list("materials" = 7, "engineering" = 7, "magnets" = 7, "programming" = 7)
    materials = list(MAT_TITANIUM=5000, MAT_SILVER=5000, MAT_GOLD = 5000, MAT_GLASS=2500, MAT_DIAMOND=1500)
    construction_time = 120
    category = list("Cyborg Upgrade Modules")


/// > modular_ss220\silicons\code\robot_modules.dm

/obj/item/robot_module/engineering/...
        /obj/item/holosign_creator/atmos/robot_standart

/obj/item/robot_module/syndicate_saboteur/...
        /obj/item/holosign_creator/atmos/robot_better

/// > code/game/objects/items/robot/robot_upgrades.dm

/obj/item/borg/upgrade/proc/after_install(mob/living/silicon/robot/R)
    for(var/item in items_to_replace)
        for(var/obj/item/installed_item in R.module.basic_modules)
            if(!istype(installed_item, item))
                continue
            var/replacement_type = items_to_replace[item]
            var/obj/item/replacement = new replacement_type(R.module)
            R.module.remove_item_from_lists(item)
            R.module.basic_modules += replacement

            if(replacement_type in special_rechargables)
                R.module.special_rechargables += replacement

/obj/item/borg/upgrade/proc/after_install(mob/living/silicon/robot/R)
    for(var/obj/item/installed_item in R.module.basic_modules)
        for(var/item in items_to_replace)
            if(!istype(installed_item, item)) /// Если не установлен итем - продолжаем
                continue
            var/replacement_type = items_to_replace[item]
            var/obj/item/replacement = new replacement_type(R.module)
            R.module.remove_item_from_lists(item)
            R.module.basic_modules += replacement

            if(replacement_type in special_rechargables)
                R.module.special_rechargables += replacement
            
            // Item is replaced, no need to continue
            break

/obj/item/borg/upgrade/proc/after_install(mob/living/silicon/robot/R)
	R.new_upgrade. = obj/item/borg/upgrade/items_to_replace
	for(var/item in R.modules)
		if(==istype(R.upgrade)




// Перед установкой проверяем, не будет ли дубликата улучшаемого итема;
// Если да - удаляем старый, если нет - продолжаем