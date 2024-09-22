/obj/item/storage/box/syndie_kit
	desc = "A sleek, sturdy box."
	icon_state = "doom_box"

/// Traitor bundles
/obj/item/storage/box/syndie_kit/bundle
	var/list/items = list()

/// 222TC
/obj/item/storage/box/syndie_kit/bundle/spy
	name = "Набор Шпиона"
	desc = "Скрытно выполняйте свои цели с этим набором предметов."
	items = list(
		/obj/item/storage/box/syndie_kit/chameleon, // 10TC
		/obj/item/card/id/syndicate, // 10TC
		/obj/item/clothing/shoes/chameleon/noslip, // 10TC
		/obj/item/clothing/glasses/hud/security/chameleon, //10TC
		/obj/item/bio_chip_implanter/storage, // 40TC
		/obj/item/pen/edagger, // 10TC
		/obj/item/pinpointer/advpinpointer, // 10TC
		/obj/item/storage/fancy/cigarettes/cigpack_syndicate, // 7TC
		/obj/item/flashlight/emp, // 20TC
		/obj/item/chameleon, // 25TC
		/obj/item/garrote, // 30 TC
		/obj/item/door_remote/omni/access_tuner, // 30TC
		/obj/item/encryptionkey/syndicate) // 10TC

/// 142TC
/obj/item/storage/box/syndie_kit/bundle/agent13
	name = "Набор Агента 13"
	desc = "Найдите и тихо и эффективно устраните свою цель с этим набором."
	items = list(
		/obj/item/clothing/under/chameleon, // 1TC. 10TC divided over 10 items from the chameleon kit.
		/obj/item/card/id/syndicate, // 10TC
		/obj/item/storage/box/syndie_kit/stechkin, // 26TC. 20TC for stechkin, plus the 2 mags at 3TC
		/obj/item/suppressor, // 5TC
		/obj/item/ammo_box/magazine/m10mm,  // 3TC
		/obj/item/ammo_box/magazine/m10mm/hp, // 7TC
		/obj/item/garrote, // 30TC
		/obj/item/door_remote/omni/access_tuner, // 30TC
		/obj/item/clothing/glasses/chameleon/thermal, // 15TC
		/obj/item/storage/briefcase/false_bottomed, // 10TC
		/obj/item/bio_chip_implanter/freedom, // 25TC
		/obj/item/coin/gold, // 0TC
		/obj/item/encryptionkey/syndicate) // 10TC

/// 160TC
/obj/item/storage/box/syndie_kit/bundle/thief
	name = "Набор Вора"
	desc = "Воруйте у друзей, врагов и медзвёздных корпораций!"
	items = list(
		/obj/item/gun/energy/kinetic_accelerator/crossbow, // 60TC
		/obj/item/chameleon, // 25TC
		/obj/item/clothing/glasses/chameleon/thermal, // 15TC
		/obj/item/clothing/gloves/color/black/thief, // 30TC
		/obj/item/card/id/syndicate, // 10TC
		/obj/item/storage/backpack/satchel_flat, // 10TC
		/obj/item/encryptionkey/syndicate) // 10TC

/// 176TC
/obj/item/storage/box/syndie_kit/bundle/bond
	name = "Набор Агента 007"
	desc = "Взболнтине свой Мартини и начните беду с этим набором смертельного снаряжения с каплей гаджетов для того, чтобы всё оставалось интереснее."
	items = list(
		/obj/item/storage/briefcase/false_bottomed, // 10TC
		/obj/item/suppressor, // 5TC
		/obj/item/storage/box/syndie_kit/stechkin, // 26TC. 20TC for stechkin, plus the 2 mags at 3TC
		/obj/item/ammo_box/magazine/m10mm/ap, // 6TC
		/obj/item/ammo_box/magazine/m10mm/ap, // 6TC
		/obj/item/clothing/under/suit/really_black, // 0TC
		/obj/item/card/id/syndicate, // 10TC
		/obj/item/clothing/suit/storage/iaa/blackjacket/armored, // 3TC
		/obj/item/storage/box/syndie_kit/emp, // 10TC
		/obj/item/clothing/glasses/hud/security/chameleon, // 10TC
		/obj/item/encryptionkey/syndicate, // 10TC
		/obj/item/reagent_containers/drinks/drinkingglass/alliescocktail, // 0TC
		/obj/item/storage/box/syndie_kit/pen_bomb, // 30 TC
		/obj/item/CQC_manual) // 50tc

/// 145TC + RCD & Mesons Autoimplanter
/obj/item/storage/box/syndie_kit/bundle/infiltrator
	name = "Набор Проникновения"
	desc = "Используйте свой телепортатор, крав магу и другие устройства поддержки для проникновения в нужное место, быстро и бесследно исчезая оттуда."
	items = list(
		/obj/item/storage/box/syndie_kit/teleporter, // 40TC
		/obj/item/clothing/gloves/color/black/krav_maga, // 50TC
		/obj/item/clothing/glasses/chameleon/thermal, // 15TC
		/obj/item/pinpointer/advpinpointer, // 10TC
		/obj/item/rcd/preloaded, // 0TC
		/obj/item/storage/box/syndie_kit/space, // 20TC
		/obj/item/autosurgeon/organ/syndicate/oneuse/meson_eyes, // 0TC
		/obj/item/encryptionkey/syndicate) // 10TC

/// 188TC
/obj/item/storage/box/syndie_kit/bundle/payday
	name = "Набор Ограбления"
	desc = "Окей парни, мы грабим станцию, которой владеет жадная корпорация. Выкачайте хранилище досуха чтобы мы смогли получить эту грязную наличку!11"
	items = list(
		/obj/item/gun/projectile/revolver, // 65 TC
		/obj/item/ammo_box/a357, // 15 TC
		/obj/item/ammo_box/a357, // 15 TC
		/obj/item/card/emag, // 30 TC
		/obj/item/jammer, // 20 TC
		/obj/item/card/id/syndicate, // 10 TC
		/obj/item/clothing/under/suit/really_black, // 0TC
		/obj/item/clothing/suit/storage/iaa/blackjacket/armored, // 3TC
		/obj/item/clothing/gloves/color/latex/nitrile, // 0TC
		/obj/item/clothing/mask/gas/clown_hat, // 0TC
		/obj/item/grenade/plastic/c4, // 5 TC
		/obj/item/thermal_drill/diamond_drill/syndicate, // 5 TC
		/obj/item/bio_chip_implanter/freedom/prototype, // 10 TC
		/obj/item/encryptionkey/syndicate) // 10TC

/// 175TC
/obj/item/storage/box/syndie_kit/bundle/implant
	name = "Набор с Био-чипами"
	desc = "Несколько полезных био-чипов, предоставляющие вам варианты для побега из под неизбежного заключения СБ."
	items = list(
		/obj/item/bio_chip_implanter/freedom, // 25TC
		/obj/item/bio_chip_implanter/stealth, // 45 TC
		/obj/item/bio_chip_implanter/emp, // 5TC (half of EMP kit)
		/obj/item/bio_chip_implanter/adrenalin, // 40TC
		/obj/item/bio_chip_implanter/explosive, // 10TC
		/obj/item/bio_chip_implanter/storage, // 40TC
		/obj/item/encryptionkey/syndicate) // 10TC

/// 220TC
/obj/item/storage/box/syndie_kit/bundle/hacker
	name = "Набор Хакера"
	desc = "Набор со всем, что вам потребуется для взлома станции, ИИ, его киборгов and Службы Безопасности. ВЗЛОМАЙТЕ ЭТУ ПЛАНЕТУ!"
	items = list(
		/obj/item/melee/energy/sword/saber/blue, // 40TC
		/obj/item/autosurgeon/organ/syndicate/oneuse/hackerman_deck, // 30TC
		/obj/item/door_remote/omni/access_tuner, // 30TC, HACK EVERYTHING
		/obj/item/encryptionkey/syndicate, // 10TC
		/obj/item/encryptionkey/binary, // 25TC
		/obj/item/card/id/syndicate, // 10TC
		/obj/item/storage/box/syndie_kit/emp, // 10TC
		/obj/item/aiModule/toyAI, // 0TC
		/obj/item/aiModule/syndicate, // 15TC
		/obj/item/storage/box/syndie_kit/camera_bug, // 5TC
		/obj/item/bio_chip_implanter/freedom/prototype, // 10TC
		/obj/item/storage/belt/military/traitor/hacker, // 15TC + AI detector for 5 TC
		/obj/item/clothing/gloves/combat, // accounted in belt + toolbox
		/obj/item/flashlight/emp) // 20TC

/// 170TC + Telekinesis
/obj/item/storage/box/syndie_kit/bundle/darklord
	name = "Набор Тёмного Лорда"
	desc = "Превратите свою злость и ненависть в страдания с комбинацией энергетических мечей и магических мечей. СДЕЛАЙТЕ ЭТО."
	items = list(
		/obj/item/melee/energy/sword/saber/red, // 40TC
		/obj/item/melee/energy/sword/saber/red, // 40TC
		/obj/item/bio_chip_implanter/shock, // 50TC
		/obj/item/dnainjector/telemut/darkbundle, // 0TC
		/obj/item/clothing/suit/hooded/chaplain_hoodie, // 0TC
		/obj/item/clothing/glasses/meson/engine/tray, // 0TC
		/obj/item/clothing/mask/chameleon/voice_change, // 10TC
		/obj/item/card/id/syndicate, // 10TC
		/obj/item/clothing/shoes/chameleon/noslip, // 10TC
		/obj/item/encryptionkey/syndicate) // 10TC

/// 164TC
/obj/item/storage/box/syndie_kit/bundle/professional
	name = "Набор Снайпера"
	desc = "Оденьтесь и ведите себя как профессионал с дальнобойной снайперской винтовкой, дополнительными обычными и пробивающими патронами .50 калибра и термальными очками для лёгкого выслеживания своих целей."
	items = list(
		/obj/item/gun/projectile/automatic/sniper_rifle/syndicate, // 80TC
		/obj/item/ammo_box/magazine/sniper_rounds, // 15TC
		/obj/item/ammo_box/magazine/sniper_rounds/penetrator, // 20TC
		/obj/item/ammo_box/magazine/sniper_rounds/penetrator, // 20TC
		/obj/item/clothing/glasses/chameleon/thermal, // 15TC
		/obj/item/clothing/gloves/combat, // ~1TC
		/obj/item/clothing/under/suit/really_black, // 0TC
		/obj/item/clothing/suit/storage/iaa/blackjacket/armored, // 3TC
		/obj/item/encryptionkey/syndicate) // 10TC

/// 215TC + Tactical Grenadier Belt
/obj/item/storage/box/syndie_kit/bundle/grenadier
	name = "Набор Гранат"
	desc = "Разнообразие гранат и пиротехники для прорыва своего пути из любой ситуации."
	items = list(
		/obj/item/storage/belt/grenade/tactical, // ~60TC Contains 2 Frag and EMP grenades, 5 C4 Explosives, 5 Smoke and Gluon grenades and 1 Minibomb grenade
		/obj/item/storage/box/syndie_kit/stechkin, // 26TC. 20TC for stechkin, plus the 2 mags at 3TC
		/obj/item/ammo_box/magazine/m10mm/fire, // 9TC
		/obj/item/ammo_box/magazine/m10mm/fire, // 9TC
		/obj/item/mod/control/pre_equipped/traitor, // 30TC
		/obj/item/clothing/gloves/combat, // ~1TC
		/obj/item/card/id/syndicate, // 10TC
		/obj/item/clothing/shoes/chameleon/noslip, // 10TC
		/obj/item/storage/box/syndidonkpockets, // 10 TC
		/obj/item/storage/box/syndie_kit/frag_grenades, // 40tc
		/obj/item/encryptionkey/syndicate) // 10TC

/// 80TC + modules + laser gun
/obj/item/storage/box/syndie_kit/bundle/metroid
	name = "Набор на МОДСьют"
	desc = "Наденьте снаряжение межгалактического охотника за головами и прорвитесь через станцию!"
	items = list(
		/obj/item/mod/control/pre_equipped/traitor_elite, // 45TC
		/obj/item/mod/module/visor/thermal, // 15TC
		/obj/item/mod/module/stealth, // 0TC
		/obj/item/mod/module/power_kick, // 0TC
		/obj/item/mod/module/sphere_transform, // 0TC
		/obj/item/autosurgeon/organ/syndicate/oneuse/laser_arm, // 0TC
		/obj/item/pinpointer/advpinpointer, // 10TC
		/obj/item/autosurgeon/organ/syndicate/oneuse/hardened_heart, // 0TC decent stamina regen, but no speed/healing.
		/obj/item/storage/belt/utility/full/multitool, // 0TC
		/obj/item/clothing/head/collectable/slime,  // 0TC priceless
		/obj/item/encryptionkey/syndicate) // 10TC

// 170 TC + combat knife + outfit
/obj/item/storage/box/syndie_kit/bundle/ocelot
	name = "Ocelot Bundle"
	desc = "Get pretty good with two revolvers, two speedloaders, and a backup combat knife."
	items = list(
		/obj/item/kitchen/knife/combat, // 0TC but very robust
		/obj/item/gun/projectile/revolver,  // 65TC
		/obj/item/gun/projectile/revolver,  // 65TC
		/obj/item/ammo_box/a357, // 15TC
		/obj/item/ammo_box/a357, // 15TC
		/obj/item/encryptionkey/syndicate, // 10TC
		/obj/item/clothing/under/syndicate/combat, //0TC
		/obj/item/clothing/accessory/holster, // 0TC
		/obj/item/clothing/accessory/scarf/red, //0TC
		/obj/item/clothing/head/beret, // 0TC
		/obj/item/clothing/gloves/combat, // 0TC
		/obj/item/clothing/shoes/combat) // 0TC

// 147 TC
/obj/item/storage/box/syndie_kit/bundle/operative
	name = "\"Operative\" Bundle"
	desc = "Glory to the Syndicate! Only the essentials for destroying Nanotrasen in this important kit."
	items = list(
		/obj/item/mod/control/pre_equipped/traitor, // 30TC
		/obj/item/card/id/syndi_scan_only, // ~2TC?
		/obj/item/encryptionkey/syndicate, // 10tc
		/obj/item/melee/energy/sword/saber/red, // 40TC
		/obj/item/shield/energy, // 40TC
		/obj/item/pinpointer/advpinpointer, // 10TC, get dat fuckin disk
		/obj/item/storage/belt/military, // 10TC
		/obj/item/grenade/plastic/c4, // 5TC
		/obj/item/bio_chip_implanter/proto_adrenalin, // 10TC
		/obj/item/toy/figure/crew/syndie, // 0TC
		/obj/item/clothing/under/syndicate // 0TC
	)

// 250 TC worth of credits
/obj/item/storage/box/syndie_kit/bundle/rich
	name = "Big Spender Bundle"
	desc = "It's money. I don't need to explain more."
	items = list(
		/obj/item/clothing/under/suit/really_black, // 0TC
		/obj/item/clothing/shoes/laceup, // 0TC
		/obj/item/clothing/glasses/monocle, // 0TC
		/obj/item/clothing/gloves/color/white, // 0TC
		/obj/item/clothing/head/that, // 0TC
		/obj/item/storage/secure/briefcase, // 0TC
		// syndie briefcase has 600 credits for 5 TC.
		/obj/item/stack/spacecash/c10000,
		/obj/item/stack/spacecash/c10000,
		/obj/item/stack/spacecash/c10000
	)

// 209 TC of maint loot, higher than other bundles because it doesn't combo well
/obj/item/storage/box/syndie_kit/bundle/maint_loot
	name = "Maintenance Loot Bundle"
	desc = "One of our interns found all of this lying in a Nanotrasen Maintenance tunnels. Reduce, Reuse, Recycle!"
	items = list(
		/obj/item/storage/bag/plasticbag, // 1TC
		/obj/item/grenade/clown_grenade, // 15TC
		/obj/item/seeds/ambrosia/cruciatus, // 5TC
		/obj/item/gun/projectile/automatic/pistol, // 20TC
		/obj/item/ammo_box/magazine/m10mm, // 3TC
		/obj/item/soap/syndie, // 5TC
		/obj/item/suppressor, // 5TC
		/obj/item/clothing/under/chameleon, // 1TC. 10TC divided over 10 items.
		/obj/item/clothing/shoes/chameleon/noslip, // 10TC
		/obj/item/clothing/mask/chameleon/voice_change, // 10TC
		/obj/item/dnascrambler, // 7TC
		/obj/item/storage/backpack/satchel_flat, // 10TC
		/obj/item/storage/toolbox/syndicate, // 5TC
		/obj/item/storage/backpack/duffel/syndie/med/surgery, // 10TC
		/obj/item/storage/belt/military/traitor, // 10TC
		/obj/item/storage/box/syndie_kit/space, // 20TC
		/obj/item/multitool/ai_detect, // 5TC
		/obj/item/bio_chip_implanter/storage, // 40TC
		/obj/item/deck/cards/syndicate, // 2TC
		/obj/item/storage/secure/briefcase/syndie, // 5TC
		/obj/item/storage/fancy/cigarettes/cigpack_syndicate, // 7TC
		/obj/item/clothing/suit/jacket/bomber/syndicate, // 3TC
		/obj/item/melee/knuckleduster/syndie, // 10TC
	)

/obj/item/storage/box/syndie_kit/bundle/populate_contents()
	for(var/obj/item/item as anything in items)
		new item(src)

/obj/item/storage/box/syndie_kit/space
	name = "Скафандр и шлем в коробке"
	can_hold = list(/obj/item/clothing/suit/space/syndicate/black/red, /obj/item/clothing/head/helmet/space/syndicate/black/red, /obj/item/tank/internals/emergency_oxygen/engi/syndi, /obj/item/clothing/mask/gas/syndicate)
	max_w_class = WEIGHT_CLASS_NORMAL

/obj/item/storage/box/syndie_kit/space/populate_contents()
	new /obj/item/clothing/suit/space/syndicate/black/red(src)
	new /obj/item/clothing/head/helmet/space/syndicate/black/red(src)
	new /obj/item/clothing/mask/gas/syndicate(src)
	new /obj/item/tank/internals/emergency_oxygen/engi/syndi(src)

/obj/item/storage/box/syndie_kit/conversion
	name = "box (CK)"

/obj/item/storage/box/syndie_kit/boolets
	name = "патроны на дробовик"

/obj/item/storage/box/syndie_kit/boolets/populate_contents()
	for(var/I in 1 to 6)
		new /obj/item/ammo_casing/shotgun/fakebeanbag(src)

/obj/item/storage/box/syndie_kit/emp
	name = "коробка с набором ЭМИ"

/obj/item/storage/box/syndie_kit/emp/populate_contents()
	new /obj/item/grenade/empgrenade(src)
	new /obj/item/grenade/empgrenade(src)
	new /obj/item/bio_chip_implanter/emp/(src)

/obj/item/storage/box/syndie_kit/poisoner
	name = "набор травителя"

/obj/item/storage/box/syndie_kit/poisoner/populate_contents()
	new /obj/item/pen/multi/poison(src)
	new /obj/item/clothing/gloves/color/black/poisoner(src)

/obj/item/storage/box/syndie_kit/c4
	name = "набор с взрывчаткой C-4"

/obj/item/storage/box/syndie_kit/c4/populate_contents()
	for(var/I in 1 to 5)
		new /obj/item/grenade/plastic/c4(src)

/obj/item/storage/box/syndie_kit/frag_grenades
	name = "набор осколочных гранат"

/obj/item/storage/box/syndie_kit/frag_grenades/populate_contents()
	for(var/I in 1 to 5)
		new /obj/item/grenade/frag(src)

/obj/item/storage/box/syndie_kit/throwing_weapons
	name = "коробка с метательным набором"
	can_hold = list(/obj/item/throwing_star, /obj/item/restraints/legcuffs/bola/tactical)
	max_combined_w_class = 16
	max_w_class = WEIGHT_CLASS_NORMAL

/obj/item/storage/box/syndie_kit/throwing_weapons/populate_contents()
	for(var/I in 1 to 5)
		new /obj/item/throwing_star(src)
	new /obj/item/restraints/legcuffs/bola/tactical(src)
	new /obj/item/restraints/legcuffs/bola/tactical(src)

/obj/item/storage/box/syndie_kit/sarin
	name = "sarin gas grenades"

/obj/item/storage/box/syndie_kit/sarin/populate_contents()
	new /obj/item/grenade/chem_grenade/saringas(src)
	new /obj/item/grenade/chem_grenade/saringas(src)
	new /obj/item/grenade/chem_grenade/saringas(src)
	new /obj/item/grenade/chem_grenade/saringas(src)

/obj/item/storage/box/syndie_kit/bioterror
	name = "коробка со шприцом биотеррора"

/obj/item/storage/box/syndie_kit/bioterror/populate_contents()
	for(var/I in 1 to 7)
		new /obj/item/reagent_containers/syringe/bioterror(src)

/obj/item/storage/box/syndie_kit/caneshotgun
	name = "набор ствола из трости"


/obj/item/storage/box/syndie_kit/caneshotgun/populate_contents()
	for(var/I in 1 to 6)
		new /obj/item/ammo_casing/shotgun/assassination(src)
	new /obj/item/gun/projectile/revolver/doublebarrel/improvised/cane(src)

/obj/item/storage/box/syndie_kit/fake_minibomb
	name = "набор с шуточной минибомбой"

/obj/item/storage/box/syndie_kit/fake_minibomb/populate_contents()
	new /obj/item/grenade/syndieminibomb/fake(src)

/obj/item/storage/box/syndie_kit/fake_revolver
	name = "набор с шуточным револьвером"

/obj/item/storage/box/syndie_kit/fake_revolver/populate_contents()
	new /obj/item/gun/projectile/revolver/fake(src)

/obj/item/storage/box/syndie_kit/mimery
	name = "набор продвинутых пантомим"

/obj/item/storage/box/syndie_kit/mimery/populate_contents()
	new /obj/item/spellbook/oneuse/mime/greaterwall(src)
	new	/obj/item/spellbook/oneuse/mime/fingergun(src)

/obj/item/storage/box/syndie_kit/combat_baking
	name = "набор боевой кулинарии"

/obj/item/storage/box/syndie_kit/combat_baking/populate_contents()
	new /obj/item/food/baguette/combat(src)
	for(var/i in 1 to 2)
		new /obj/item/food/croissant/throwing(src)
	new /obj/item/book/granter/crafting_recipe/combat_baking(src)

/obj/item/storage/box/syndie_kit/atmosn2ogrenades
	name = "гранаты с N2O"

/obj/item/storage/box/syndie_kit/atmosn2ogrenades/populate_contents()
	new /obj/item/grenade/clusterbuster/n2o(src)
	new /obj/item/grenade/clusterbuster/n2o(src)


/obj/item/storage/box/syndie_kit/atmosfiregrenades
	name = "гранаты с огнём из плазмы"

/obj/item/storage/box/syndie_kit/atmosfiregrenades/populate_contents()
	new /obj/item/grenade/clusterbuster/plasma(src)
	new /obj/item/grenade/clusterbuster/plasma(src)


/obj/item/storage/box/syndie_kit/missionary_set
	name = "Стартовый Набор Мессионера"

/obj/item/storage/box/syndie_kit/missionary_set/populate_contents()
	new /obj/item/nullrod/missionary_staff(src)
	new /obj/item/clothing/suit/hooded/chaplain_hoodie/missionary_robe(src)
	var/obj/item/storage/bible/B = new /obj/item/storage/bible(src)
	if(prob(25))	//an omen of success to come?
		B.deity_name = "Success"
		B.icon_state = "greentext"
		B.item_state = "greentext"


/obj/item/storage/box/syndie_kit/cutouts
	name = "Укрепленная артистическая коробка"

/obj/item/storage/box/syndie_kit/cutouts/populate_contents()
	for(var/i in 1 to 3)
		new/obj/item/cardboard_cutout/adaptive(src)
	new/obj/item/toy/crayon/spraycan(src)

/obj/item/storage/box/syndie_kit/safecracking
	name = "Набор для взлома сейфов"
	desc = "Всё, что вам требуется для тихого вскрытия сейфа с механическим замком."

/obj/item/storage/box/syndie_kit/safecracking/populate_contents()
	new /obj/item/clothing/gloves/color/latex/nitrile(src)
	new /obj/item/clothing/mask/balaclava(src)
	new /obj/item/clothing/accessory/stethoscope(src)
	new /obj/item/book/manual/wiki/hacking(src)

/obj/item/storage/box/syndie_kit/chameleon
	name = "набор хамелеон"

/obj/item/storage/box/syndie_kit/chameleon/populate_contents()
	new /obj/item/clothing/under/chameleon(src)
	new /obj/item/clothing/suit/chameleon(src)
	new /obj/item/clothing/gloves/chameleon(src)
	new /obj/item/clothing/shoes/chameleon(src)
	new /obj/item/clothing/glasses/chameleon(src)
	new /obj/item/clothing/head/chameleon(src)
	new /obj/item/storage/backpack/chameleon(src)
	new /obj/item/radio/headset/chameleon(src)
	new /obj/item/pda/chameleon(src)
	new /obj/item/clothing/mask/chameleon(src)

/obj/item/storage/box/syndie_kit/chameleon/nuke
	name = "operative's chameleon kit"

/obj/item/storage/box/syndie_kit/chameleon/nuke/populate_contents()
	new /obj/item/clothing/under/chameleon(src)
	new /obj/item/clothing/suit/chameleon(src)
	new /obj/item/clothing/gloves/chameleon(src)
	new /obj/item/clothing/shoes/chameleon(src)
	new /obj/item/clothing/glasses/chameleon(src)
	new /obj/item/clothing/head/chameleon(src)
	new /obj/item/storage/backpack/chameleon(src)
	new /obj/item/radio/headset/chameleon(src)
	new /obj/item/pda/chameleon(src)
	new /obj/item/stamp/chameleon(src)
	new /obj/item/clothing/mask/chameleon/voice_change(src)

/obj/item/storage/box/syndie_kit/dart_gun
	name = "набор с дротикомётом"

/obj/item/storage/box/syndie_kit/dart_gun/populate_contents()
	new /obj/item/gun/syringe/syndicate(src)
	new /obj/item/reagent_containers/syringe/capulettium_plus(src)
	new /obj/item/reagent_containers/syringe/sarin(src)
	new /obj/item/reagent_containers/syringe/pancuronium(src)

/obj/item/storage/box/syndie_kit/nuke
	name = "коробка"  //Bit of stealth, since you spawn with it
	desc = "Это просто обычная коробка."
	icon_state = "box"

/obj/item/storage/box/syndie_kit/nuke/populate_contents()
	new /obj/item/screwdriver/nuke(src)
	new /obj/item/nuke_core_container(src)
	new /obj/item/paper/guides/antag/nuke_instructions(src)

/obj/item/storage/box/syndie_kit/supermatter
	name = "коробка"
	desc = "Это просто обычная коробка."
	icon_state = "box"

/obj/item/storage/box/syndie_kit/supermatter/populate_contents()
	new /obj/item/scalpel/supermatter(src)
	new /obj/item/retractor/supermatter(src)
	new /obj/item/nuke_core_container/supermatter(src)
	new /obj/item/paper/guides/antag/supermatter_sliver(src)

/obj/item/storage/box/syndie_kit/revolver
	name = "набор с револьвером .357 калибра"

/obj/item/storage/box/syndie_kit/revolver/populate_contents()
	new /obj/item/gun/projectile/revolver(src)
	new /obj/item/ammo_box/a357(src)

/obj/item/storage/box/syndie_kit/stechkin
	name = "набор с FK-69 Стечкиным"
	desc = "Коробка с символами на Нео-Русском. Кажется, в ней находится пистолет 10мм и два магазина."

/obj/item/storage/box/syndie_kit/stechkin/populate_contents()
	new /obj/item/gun/projectile/automatic/pistol(src)
	new /obj/item/ammo_box/magazine/m10mm(src)
	new /obj/item/ammo_box/magazine/m10mm(src)

/obj/item/storage/box/syndie_kit/camera_bug
	name = "Набор с Камера Багом"

/obj/item/storage/box/syndie_kit/camera_bug/populate_contents()
	var/camera = new /obj/item/camera_bug(src)
	new /obj/item/paper/camera_bug(src)
	for(var/i in 1 to 5)
		new /obj/item/wall_bug(src, camera)

/obj/item/storage/box/syndie_kit/prescan
	name = "Набор с продвинутой системой клонирования Технократии"

/obj/item/storage/box/syndie_kit/prescan/populate_contents()
	new /obj/item/bio_chip_implanter/grey_autocloner(src)
	new /obj/item/beacon/syndicate/bomb/grey_autocloner(src)

/obj/item/storage/box/syndie_kit/pen_bomb
	name = "Ручка-бомба"

/obj/item/storage/box/syndie_kit/pen_bomb/populate_contents()
	new /obj/item/grenade/syndieminibomb/pen(src)

/obj/item/storage/box/syndie_kit/chemical_canister
	name = "\improper Chemical flamethrower canisters"

/obj/item/storage/box/syndie_kit/chemical_canister/populate_contents()
	new /obj/item/chemical_canister/extended/nuclear(src)
	new /obj/item/chemical_canister/extended/nuclear(src)

/obj/item/storage/box/syndie_kit/decoy
	name = "\improper Decoy Grenade kit"

/obj/item/storage/box/syndie_kit/decoy/populate_contents()
	for(var/i in 1 to 5)
		new /obj/item/grenade/firecracker/decoy(src)
