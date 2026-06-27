// TRAITOR ONLY GEAR

// JOB SPECIFIC GEAR

/datum/uplink_item/jobspecific
	category = "Профессиональные инструменты"
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST) // Stops the job specific category appearing for nukies

//Clown
/datum/uplink_item/jobspecific/clowngrenade
	name = "Банановая граната"
	// name = "Banana Grenade"
	desc = "Граната, которая при взрыве разбрасывает банановую кожуру, генетически модифицированную для придания \
ей сильной скользкости."
	// desc = "A grenade that scatters banana peels upon detonation, genetically modified to be extremely slippery when stepped on."
	reference = "BG"
	item = /obj/item/grenade/clown_grenade
	cost = 10 // SS220 EDIT PRICE UP/DOWN 15 -> 10
	job = list("Clown")

/datum/uplink_item/jobspecific/clownslippers
	name = "Клоунские ботинки акробата"
	// name = "Clown Acrobat Slippers"
	desc = "Особенные клоунские туфли со встроенной системой ускорения. Позволяют эффектно проскользнуть прямо под ногами \
окружающих! При включении компенсаторов походки избавляют от фирменной клоунской неуклюжести."
	// desc = "Special clown shoes with a built-in acceleration system. Allows you to slide dramatically right under people's feet. When gait compensators are enabled, they eliminate the signature clown clumsiness."
	reference = "CAS"
	item = /obj/item/clothing/shoes/clown_shoes/slippers
	cost = 15
	surplus = 75
	job = list("Clown")

/datum/uplink_item/jobspecific/cmag
	name = "Шуточный секвенсор"
	// name = "Joke Sequencer"
	desc = "Также известен как «Cmag». Небольшая карта, которая инвертирует доступы на любом шлюзе. \
Идеально подходит для того, чтобы оставить вульп запертыми в дормах. Хонк!"
	// desc = "Also known as 'Cmag'. A small card that inverts access on any airlock. Perfect for leaving vulps locked in their dorms. Honk!"
	reference = "CMG"
	item = /obj/item/card/cmag
	cost = 15 // SS220 EDIT PRICE UP/DOWN 20 -> 15
	surplus = 75
	job = list("Clown")

/datum/uplink_item/jobspecific/trick_revolver
	name = "Револьвер для приколов"
	// name = "Trick Revolver"
	desc = "Револьвер, который стреляет не в цель, а в своего владельца. Отличный подарок для чрезмерно бдительных героев или \
просто ценителей очень чёрного юмора."
	// desc = "A revolver that shoots not at the target, but at its owner. A great gift for overly vigilant heroes or just connoisseurs of very dark humor."
	reference = "CTR"
	item = /obj/item/storage/box/syndie_kit/fake_revolver
	cost = 5
	job = list("Clown")

/datum/uplink_item/jobspecific/trick_grenade
	name = "Липкая граната"
	// name = "Trick Grenade"
	desc = "Синдикатовская мини-бомба, которая при активации приклеит её к рукам владельца. Вы же знаете, каково это, \
	быть взорванным собственной гранатой...?"
	// desc = "Syndicate Minibomb with glue ejectors that will stick it to the user's hands on activation."
	reference = "CGN"
	item = /obj/item/storage/box/syndie_kit/fake_minibomb
	cost = 5
	job = list("Clown")

/datum/uplink_item/jobspecific/clown_car
	name = "Хонк мобиль"
	// name = "Clown Car"
	desc = "Непревзойдённый транспорт для поистине достойного мастера клоунад! Просто вставьте личный гудок в замок зажигания, \
	садитесь за руль и готовьтесь к самой забавной поездке в вашей жизни! Вы можете таранить любых членов экипажа, \
	которых встретите, и заталкивать их в свою машину, похищая и запирая внутри, пока кто-то не спасёт их или они не выберутся \
	сами. Только не врежьтесь в стены или торговые автоматы — весь бюджет был потрачен Синдикатом на дизайн этого шедевра, \
	поэтому на пружинных сиденьях пришлось сэкономить! Теперь и с встроенной системой разлития смазки, которая защитит вас \
	от разъяренных фанатов, желающих вашего автографа! Премиум-функции доступны только для владельцев криптографического \
	секвенсора."
	// desc = "The Clown Car is the ultimate transportation method for any worthy clown! Simply insert your bikehorn and get in, and get ready to have the funniest ride of your life! You can ram any crew you come across and stuff them into your car, kidnapping them and locking them inside until someone saves them or they manage to crawl out. Be sure not to ram into any walls or vending machines, as the springloaded seats are very sensitive. Now with our included lube defense mechanism which will protect you against any angry shitcurity! Premium features can be unlocked with a cryptographic sequencer!"
	reference = "CCR"
	item = /obj/tgvehicle/sealed/car/clowncar
	cost = 50
	job = list("Clown")
	surplus = 0
	hijack_only = TRUE

//mime
/datum/uplink_item/jobspecific/caneshotgun
	name = "Трость-дробовик с крайне летальными патронами"
	// name = "Cane Shotgun and Assassination Shells"
	desc = "Специальный однозарядный дробовик со встроенным устройством маскировки под трость. Дробовик способен \
	скрывать своё содержимое, а также имеет резьбу для установки глушителя. В комплекте 6 картечных патронов, покрытых \
	токсином глушения против голосовых связок жертвы, и 1 уже заряжен в ствол."
	// desc = "A specialized, one shell shotgun with a built-in cloaking device to mimic a cane. The shotgun is capable of hiding its contents and the pin alongside being suppressed. Comes boxed with 6 specialized shrapnel rounds laced with a silencing toxin, and 1 preloaded in the shotgun's chamber."
	reference = "MCS"
	item = /obj/item/storage/box/syndie_kit/caneshotgun
	cost = 20 // SS220 EDIT PRICE UP/DOWN 40 -> 20
	job = list("Mime")

/datum/uplink_item/jobspecific/mimery
	name = "Руководство по улучшенным пантомимам"
	// name = "Guide to Advanced Mimery Series"
	desc = "Содержит два руководства для обучения по улучшенным пантомимам. Вы сможете стрелять смертельными \
	беззвучными пулями прямо из пальцев и создавать широкие воображаемые стены, способные заблокировать целый коридор!"
	// desc = "Contains two manuals to teach you advanced Mime skills. You will be able to shoot lethal bullets that silence out of your fingers, and create large walls that can block an entire hallway!"
	reference = "AM"
	item = /obj/item/storage/box/syndie_kit/mimery
	cost = 65 // SS220 EDIT PRICE UP/DOWN 50 -> 65
	job = list("Mime")
	surplus = 0 // I feel this just isn't healthy to be in these crates.

/datum/uplink_item/jobspecific/combat_baking
	name = "Боевой набор пекаря"
	// name = "Combat Bakery Kit"
	desc = "Набор тайного оружия из выпечки. Содержит багет, который можно использовать как меч, \
	так же пару метательных круассанов и рецепт для выпекания новых. Когда работа сделана, съешьте улики!"
	// desc = "A kit of clandestine baked weapons. Contains a baguette which a skilled mime could use as a sword, a pair of throwing croissants, and the recipe to make more on demand. Once the job is done, eat the evidence."
	reference = "CBK"
	item = /obj/item/storage/box/syndie_kit/combat_baking
	cost = 15 // SS220 EDIT PRICE UP/DOWN 25 -> 15 //A chef can get a knife that sharp easily, though it won't block. While you can get endless boomerang, they are less deadly than a stech, and slower / more predictable.
	job = list("Mime", "Chef")

// Shaft miner

/datum/uplink_item/jobspecific/pressure_mod
	name = "Модкит 'Давления' для кинетического акселератора"
	// name = "Kinetic Accelerator Pressure Mod"
	desc = "Модкит, позволяющий кинетическим акселераторам наносить значительно больше повреждений в помещениях с нормальной \
	атмосферой. Занимает 35% выделенного объёма акселератора."
	// desc = "A modification kit which allows Kinetic Accelerators to do greatly increased damage while indoors. Occupies 35% mod capacity."
	reference = "KPM"
	item = /obj/item/borg/upgrade/modkit/indoors
	cost = 25 //you need two for full damage, so total of 50 for maximum damage
	job = list("Shaft Miner", "Explorer")
	surplus = 0 // Requires a KA to even be used.

/datum/uplink_item/jobspecific/mining_charge_hacker
	name = "Взломщик шахтёрских зарядов"
	// name = "Mining Charge Hacker"
	desc = "Выглядит и работает как продвинутый шахтёрский сканер, но позволяет размещать шахтёрские заряды где угодно и \
	подрывать не только камни, но и стены. Используйте его на шахтёрском заряде, чтобы отключить его системы безопасности. \
	Перераспределяет взрывную мощность зарядов на меньшую область поражения, но с большей эффективностью."
	// desc = "Looks and functions like an advanced mining scanner, but allows mining charges to be placed anywhere and destroy more than rocks. Use it on a mining charge to override its safeties. Reduces explosive power of mining charges due to the modification of their internals."
	reference = "MCH"
	item = /obj/item/t_scanner/adv_mining_scanner/syndicate
	cost = 15 // SS220 EDIT PRICE UP/DOWN 25 -> 15
	job = list("Shaft Miner")

//Chef

/datum/uplink_item/jobspecific/specialsauce
	name = "Особый соус от шеф-повара"
	// name = "Chef Excellence's Special Sauce"
	desc = "Специальный соус, изготовленный из сильно ядовитых мухоморов. Чем дольше соус находится в жертве, \
	тем большие последствия для неё будут от послевкусия."
	// desc = "A custom sauce made from the highly poisonous fly amanita mushrooms. Anyone who ingests it will take variable toxin damage depending on how long it has been in their system, with a higher dosage taking longer to metabolize."
	reference = "CESS"
	item = /obj/item/reagent_containers/condiment/syndisauce
	cost = 5 // SS220 EDIT PRICE UP/DOWN 10 -> 5
	job = list("Chef")
	surplus = 0 // Far too specific in its use.

/datum/uplink_item/jobspecific/meatcleaver
	name = "Мясницкий тесак"
	// name = "Meat Cleaver"
	desc = "Зловещий мясницкий тесак, наносящий повреждения, сравнимые с Энергетическим мечом, но с дополнительным \
	преимуществом: после смерти жертвы им удобно рубить её на куски мяса!"
	// desc = "A mean looking meat cleaver that does damage comparable to an Energy Sword, but with the added benefit of chopping your victim into hunks of meat after they've died."
	reference = "MC"
	item = /obj/item/kitchen/knife/butcher/meatcleaver
	cost = 30 // SS220 EDIT PRICE UP/DOWN 40 -> 30
	job = list("Chef")

/datum/uplink_item/jobspecific/syndidonk
	name = "Донк-покеты Синдиката"
	// name = "Syndicate Donk Pockets"
	desc = "Коробка высококачественных донк-покетов со смесью восстанавливающих и стимулирующих химических веществ внутри."
	// desc = "A box of highly specialized Donk pockets with a number of regenerative and stimulating chemicals inside of them; the box comes equipped with a self-heating mechanism."
	reference = "SDP"
	item = /obj/item/storage/box/syndidonkpockets
	cost = 10
	job = list("Chef")

//Chaplain
/datum/uplink_item/jobspecific/missionary_kit
	name = "Стартовый набор миссионера"
	// name = "Missionary Starter Kit"
	desc = "Коробка, содержащая посох миссионера, робу миссионера и библию. Одежды и посох можно объединить силой \
	веры, чтобы на короткое время обращать жертв на свою сторону с расстояния и заставлять их выполнять ваши приказы. \
	Библия — для библейских дел."
	// desc = "A box containing a missionary staff, missionary robes, and bible. The robes and staff can be linked to allow you to convert victims at range for a short time to do your bidding. The bible is for bible stuff."
	reference = "MK"
	item = /obj/item/storage/box/syndie_kit/missionary_set
	cost = 75
	job = list("Chaplain")
	surplus = 0 // Controversial maybe, but with the ease of mindslaving with this item I'd prefer it stay chaplain specific.

/datum/uplink_item/jobspecific/artistic_toolbox
	name = "Его Светлость"
	// name = "His Grace"
	desc = "Невероятно опасное оружие из самого сердца техтоннелей, населённых Грей Тайдами. После активации Он \
	будет жаждать только одного - КРОВИ. Убивайте Им чтобы поглощать трупы для утоления вечного голода. Его Светлость \
	дарует своему владельцу постепенное восстановление организма и полный иммунитет к оглушениям. Но будьте осторожны: \
	если Он станет слишком голодным - роль Жертвы займёте Вы. Однако, если оставить Его в покое достаточно долго, Он \
	снова уснёт. Чтобы пробудить Его Светлость, просто откройте Его."
	// desc = "An incredibly dangerous weapon recovered from a station overcome by the Grey Tide. Once activated, He will thirst for blood and must be used to kill to sate that thirst. His Grace grants gradual regeneration and complete stun immunity to His wielder, but be wary: if He gets too hungry, He will become impossible to drop and eventually kill you if not fed. However, if left alone for long enough, He will fall back to slumber. To activate His Grace, simply unlatch Him."
	reference = "HG"
	item = /obj/item/his_grace
	cost = 100
	job = list("Chaplain")
	surplus = 0 //No lucky chances from the crate; if you get this, this is ALL you're getting
	hijack_only = TRUE //This is a murderbone weapon, as such, it should only be available in those scenarios.

//Janitor

/datum/uplink_item/jobspecific/cautionsign
	name = "Противопехотная мина"
	// name = "Proximity Mine"
	desc = "Противопехотная мина с датчиком приближения, искусно замаскированная под знак «Осторожно, \
	мокрый пол», которая активируется при пробегании мимо неё. Разложите её, чтобы запустить 15-секундный \
	таймер для отбегания, или сложите обратно, чтобы обезвредить."
	// desc = "An Anti-Personnel proximity mine cleverly disguised as a wet floor caution sign that is triggered by running past it. Activate it to start the 15 second timer and activate again to disarm."
	reference = "PM"
	item = /obj/item/caution/proximity_sign
	cost = 5 // SS220 EDIT PRICE UP/DOWN 10 -> 5
	job = list("Janitor")

/datum/uplink_item/jobspecific/titaniumbroom
	name = "Титановая метла"
	// name = "Titanium Push Broom"
	desc = "Метла с укреплённой ручкой для удобной хватки и металлической щёткой, а вы что ожидали? \
	Она просто создана для того, чтобы дать себе больше работы, избивая клоунов или ассистентов. \
	В момент драки, удары по целям будут иметь различные свойства в зависимости от ваших намерений."
	// desc = "A push broom with a reinforced handle and a metal wire brush, perfect for giving yourself more work by beating up assistants. When wielded, hitting people will have different effects based on your intent."
	reference = "TPBR"
	item = /obj/item/push_broom/traitor
	cost = 45 // SS220 EDIT PRICE UP/DOWN 60 -> 45
	job = list("Janitor")
	surplus = 0 //no reflect memes

//Virology

/datum/uplink_item/jobspecific/viral_injector
	name = "Вирусный инъектор"
	// name = "Viral Injector"
	desc = "Модифицированный гипоспрей, замаскированный под функциональную пипетку. \
	Пипетка может заражать жертв вирусами при инъекции."
	// desc = "A modified hypospray disguised as a functional pipette. The pipette can infect victims with viruses upon injection."
	reference = "VI"
	item = /obj/item/reagent_containers/dropper/precision/viral_injector
	cost = 10 // SS220 EDIT PRICE UP/DOWN 15 -> 10
	job = list("Virologist")

/datum/uplink_item/jobspecific/cat_grenade
	name = "Граната доставки диких кошек"
	// name = "Feral Cat Delivery Grenade"
	desc = "Капсула содержит 5 одичавших и свирепых кошек, которые только и ждут открытия клетки, \
	чтобы расцарапать морды всем на своём пути."
	// desc = "The feral cat delivery grenade contains 5 dehydrated feral cats in a similar manner to dehydrated monkeys, which, upon detonation, will be re-hydrated by a small reservoir of water contained within the grenade. These cats will then attack anything in sight."
	item = /obj/item/grenade/spawnergrenade/feral_cats
	reference = "CCLG"
	cost = 10
	job = list("Psychiatrist")//why? Becuase its funny that a person in charge of your mental wellbeing has a cat granade..

//Assistant

/datum/uplink_item/jobspecific/pickpocketgloves
	name = "Перчатки карманника"
	// name = "Pickpocket's Gloves"
	desc = "Пара элегантных перчаток, прямо как у карманников. Пока вы носите их, вы можете обкрадывать свою цель, \
	не привлекая внимания ни её, ни окружающих. При успехе в своём деле, предмет будет прямо у вас в руках."
	// desc = "A pair of sleek gloves to aid in pickpocketing. While wearing these, you can loot your target without them knowing. Pickpocketing puts the item directly into your hand."
	reference = "PPG"
	item = /obj/item/clothing/gloves/color/black/thief
	cost = 15 // SS220 EDIT PRICE UP/DOWN 30 -> 15
	job = list("Assistant")

//Bartender

/datum/uplink_item/jobspecific/drunkbullets
	name = "Опьяняющие патроны"
	// name = "Boozey Shotgun Shells"
	desc = "Коробка, содержащая 6 патронов для дробовика, которые имитируют эффект тяжёлго запоя на цели, \
	становясь тем эффективнее, чем менее 'сухая' жертва."
	// desc = "A box containing 6 shotgun shells that simulate the effects of extreme drunkenness on the target, more effective for each type of alcohol in the target's system."
	reference = "BSS"
	item = /obj/item/storage/box/syndie_kit/boolets
	cost = 5 // SS220 EDIT PRICE UP/DOWN 10 -> 5
	job = list("Bartender")

//Botanist

/datum/uplink_item/jobspecific/bee_briefcase
	name = "Чемодан, полный пчёл"
	// name = "Briefcase Full of Bees"
	desc = "На первый взгляд безобидный чемоданчик, полный не таких уж и невинных пчел, выведенных лучшими \
	гидропонистами Синдиката. Закапайте в чемоданчик немного крови, чтобы приучить пчел игнорировать донора. \
	ВНИМАНИЕ: экзотические группы крови не подходят. Готовьтесь к началу Конца, ибо с вами в эфире неподражаемый, \
	энергичный, целеустремлённый и просто безумный гений, Доктор Би!"
	// desc = "A seemingly innocent briefcase full of not-so-innocent Syndicate-bred bees. Inject the case with blood to train the bees to ignore the donor(s), WARNING: exotic blood types such as slime jelly do not work. It also wirelessly taps into station intercoms to broadcast a message of TERROR."
	reference = "BEE"
	item = /obj/item/bee_briefcase
	cost = 50
	job = list("Botanist")

//Engineer

/datum/uplink_item/jobspecific/powergloves
	name = "Био-чип силы"
	// name = "Power Bio-Chip"
	desc = "Био-чип, который может использовать энергию станции, чтобы нанести короткий электрический разряд по цели. \
	Владелец должен стоять на подключённом кабеле для использования. Намерение помощи/обезоруживания повысит усталость \
	жертвы и вызовет дрожь, в то время как намерение вреда/захвата нанесёт урон в зависимости от мощности сети, \
	на кабеле которой вы стоите. Можно изменять состояние использования по желанию."
	// desc = "A Bio-Chip that can utilize the power of the station to deliver a short arc of electricity at a target. Must be standing on a powered cable to use. Activated by alt-clicking, or pressing the middle mouse button. Help/disarm intent will deal stamina damage and cause jittering, while harm/grab intent will deal damage based on the power of the cable you're standing on. Can be toggled on / off via the action button."
	reference = "PG"
	item = /obj/item/bio_chip_implanter/shock
	cost = 30 // SS220 EDIT PRICE UP/DOWN 50 -> 30
	job = list("Station Engineer", "Chief Engineer")

/datum/uplink_item/jobspecific/meltdown_rod
	name = "Стержень ядерного расплава"
	// name = "Nuclear Meltdown Rod"
	desc = "Специально разработанный ядерный стержень, гарантированно вызывающий расплавление любого реактора, в который помещён."
	// desc = "A specially designed nuclear rod, guaranteed to cause the meltdown of any reactor it's placed into. For those tasked with detonating the station's nuclear warhead, this will not achieve that end."
	reference = "SMDR"
	item = /obj/item/nuclear_rod/fuel/meltdown
	cost = 25
	job = list("Station Engineer", "Chief Engineer")
	hijack_only = TRUE
	excludefrom = list(UPLINK_TYPE_NUCLEAR)

//RD

/datum/uplink_item/jobspecific/telegun
	name = "Телеган"
	// name = "Telegun"
	desc = "Чрезвычайно высокотехнологичное энергетическое оружие, использующее технологию Блюспейса для телепортации живых целей. \
	Выберите целевой маяк и сверы чистого Блюспейса отправят цель к указаному месту. Может отправлять цели только к маякам \
	в секторе, если они не эммагнуты!"
	// desc = "An extremely high-tech energy gun that utilizes jury-rigged bluespace technology to teleport away living targets. Select the target beacon on the telegun itself; projectiles will send targets to the beacon locked onto. Can only send targets to beacons in-sector unless they are emagged!"
	reference = "TG"
	item = /obj/item/gun/energy/telegun
	cost = 50
	job = list("Scientist")
	hijack_only = TRUE
	surplus = 0

//Roboticist

/datum/uplink_item/jobspecific/syndiemmi
	name = "Синдикатский MMI"
	// name = "Syndicate MMI"
	desc = "Разработанный Синдикатом ММИ, который поработит разум любого мозга, вставленного в него, пока он находится внутри. \
	Киборги, созданные с этим ММИ, получат свод законов Синдиката, но будут казаться имеющими обычный свод законов и \
	синхронизацию с ИИ станции. Обеспечивает иммунитет к дистанционному детонированию и блокированию шасси, если киборг не \
	еммагнут. Его также можно вставить в мех, но ММИ не поместится в ядро ИИ."
	// desc = "A syndicate developed man-machine-interface which will mindslave any brain inserted into it, for as long as it's inside. Cyborgs made with this MMI will be permanently slaved to you, but will appear to have a normal set of laws and be synchronized to the station AI, if present. Provides immunity to remote detonation and allows overriding lockdowns if the cyborg is not also emagged. It can also be inserted into a mech, but will not fit inside an AI core."
	reference = "SMMI"
	item = /obj/item/mmi/syndie
	cost = 10
	job = list("Roboticist")
	surplus = 0

//Librarian

/datum/uplink_item/jobspecific/etwenty
	name = "E20"
	// name = "The E20"
	desc = "Кажущийся безобидным кубик, но те, кто не боятся бросать его для атаки, почувствуют истиный эффект! \
	Имеет четырёхсекундный таймер и градацию силы взрыва пропорционально выпавшему числу."
	// desc = "A seemingly innocent die, those who are not afraid to roll for attack will find its effects quite explosive. Has a four second timer."
	reference = "ETW"
	item = /obj/item/dice/d20/e20
	cost = 15
	job = list("Librarian")
	surplus = 0

//Botanist

/datum/uplink_item/jobspecific/ambrosiacruciatus
	name = "Семена амброзии Круциатус"
	// name = "Ambrosia Cruciatus Seeds"
	desc = "Часть печально известного семейства амброзий, этот вид практически неотличим от амброзии вульгарис\
	, но его ветви содержат отвратительный токсин. Восьми юнитов достаточно, чтобы свести жертву с ума!"
	// desc = "Part of the notorious Ambrosia family, this species is nearly indistinguishable from Ambrosia Vulgaris- but its' branches contain a revolting toxin. Eight units are enough to drive victims insane."
	reference = "BRO"
	item = /obj/item/seeds/ambrosia/cruciatus
	cost = 5
	job = list("Botanist")
	surplus = 0 // Even botanists would struggle to use this effectively, nevermind a coroner.

//Atmos Tech

/datum/uplink_item/jobspecific/contortionist
	name = "Комбинезон акробата"
	// name = "Contortionist's Jumpsuit"
	desc = "Высокоэластичный комбинезон, который поможет вам ползать по станционной вентеляции. Имеет карманы \
	и слот для ID, но не может быть использован без ношения большей части снаряжения, включая рюкзак, пояс, шлем и МОД. \
	Также необходимы свободные руки, чтобы ползать внутри."
	// desc = "A highly flexible jumpsuit that will help you navigate the ventilation loops of the station internally. Comes with pockets and ID slot, but can't be used without stripping off most gear, including backpack, belt, helmet, and exosuit. Free hands are also necessary to crawl around inside."
	reference = "AIRJ"
	item = /obj/item/clothing/under/rank/engineering/atmospheric_technician/contortionist
	cost = 20 // SS220 EDIT PRICE UP/DOWN 30 -> 20
	job = list("Life Support Specialist")

/datum/uplink_item/jobspecific/contortionist_plasmaman
	name = "Комбинезон акробата для плазмаменов"
	// name = "Contortionist's Plasma Envirosuit"
	desc = "Высокоэластичный комбинезон, который поможет вам ползать по станционной вентеляции, но только Плазмаменам. Имеет карманы \
	и слот для ID, но не может быть использован без ношения большей части снаряжения, включая рюкзак, пояс, шлем и МОД. \
	Также необходимы свободные руки, чтобы ползать внутри."
	// desc = "A highly flexible envirosuit that will help you navigate the ventilation loops of the station internally, specialized for Plasmamen. Comes with pockets and ID slot, but can't be used without stripping off most gear, including backpack, belt, and exosuit. Free hands are also necessary to crawl around inside."
	reference = "AIRJP"
	item = /obj/item/clothing/under/plasmaman/atmospherics/contortionist
	cost = 20 // SS220 EDIT PRICE UP/DOWN 30 -> 20
	job = list("Life Support Specialist")
	species = list("Plasmaman")

/datum/uplink_item/jobspecific/energizedfireaxe
	name = "Энергетический пожарный топор"
	// name = "Energized Fire Axe"
	desc = "Пожарный топор с крайне мощным регенератором энергии, встроенным в него. При ударе по кому-то во время \
	полного заряда он отбросит их назад, одновременно ошеломляя их, но потребуется некоторое время для повторной зарядки. \
	Он также намного острее обычного топора и может прорезать лёгкую броню."
	// desc = "A fire axe with a massive energy charge built into it. Upon striking someone while charged it will throw them backwards while stunning them briefly, but will take some time to charge up again. It is also much sharper than a regular axe and can pierce light armor."
	reference = "EFA"
	item = /obj/item/fireaxe/energized
	cost = 45 // SS220 EDIT PRICE UP/DOWN 40 -> 45
	job = list("Life Support Specialist")

//Stimulants

/datum/uplink_item/jobspecific/stims
	name = "Стимуляторы"
	// name = "Stimulants"
	desc = "Одно из самых запрещённых соединений, содержащееся в компактном инъекторе. При введении делает \
	пользователя чрезвычайно устойчивым к истощению сил и невероятно повышает способность организма к самовосстановлению."
	// desc = "A highly illegal compound contained within a compact auto-injector; when injected it makes the user extremely resistant to incapacitation and greatly enhances the body's ability to repair itself."
	reference = "ST"
	item = /obj/item/reagent_containers/hypospray/autoinjector/stimulants
	cost = 35 // SS220 EDIT PRICE UP/DOWN 45 -> 35
	job = list("Scientist", "Research Director", "Geneticist", "Chief Medical Officer", "Medical Doctor", "Psychiatrist", "Chemist", "Paramedic", "Coroner", "Virologist")

// Genetics

/datum/uplink_item/jobspecific/magillitis_serum
	name = "Био-чип сыворотки Магиллитиса"
	// name = "Magillitis Serum Bio-chip"
	desc = "Одноразовый био-чип, содержащий экспериментальную сыворотку, вызывающую быстрый и невероятный рост мышечной \
	массы у испытуемого. Побочные эффекты могут включать гипертрихоз, вспышки ярости, потемнение кожного покрова и \
	непреодолимую тягу к бананам!"
	// desc = "A single-use bio-chip which contains an experimental serum that causes rapid muscular growth in Hominidae. Side-affects may include hypertrichosis, violent outbursts, and an unending affinity for bananas."
	reference = "MAG"
	item = /obj/item/bio_chip_implanter/gorilla_rampage
	cost = 25
	job = list("Research Director", "Geneticist")

// Paper contact poison pen

/datum/uplink_item/jobspecific/poison_pen
	name = "Ручка с ядом"
	// name = "Poison Pen"
	desc = "При создании этой ручки использовались самые передовые технологии в области смертоносных письменных принадлежностей! \
	Каждый вид чернил, находящийся в этой ручке, был изготовлен на основе одного из четырёх ядов. Чёрные чернила — обычные чернила,\
	красные чернила крайне ядовиты, зелёные чернила сильно облучают, синие чернила периодически шокируют жертву изнутри, а \
	жёлтые - парализуют через непродолжительное время. Перчатки из поставки защитят вас от последствий прикосновений к чернилам."
	// desc = "Cutting edge of deadly writing implements technology, this gadget will infuse any piece of paper with various delayed poisons based on the selected color. Black ink is normal ink, red ink is a highly lethal poison, green ink causes radiation, blue ink will periodically shock the victim, and yellow ink will paralyze. The included gloves will protect you from your own poisons."
	reference = "PP"
	item = /obj/item/storage/box/syndie_kit/poisoner
	cost = 5 // SS220 EDIT PRICE UP/DOWN 10 -> 5
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
	job = list("Head of Personnel", "Quartermaster", "Cargo Technician", "Librarian", "Coroner", "Psychiatrist", "Virologist")

// Tarot card generator, librarian and Chaplain
/datum/uplink_item/jobspecific/tarot_generator
	name = "Зачарованная колода карт Таро"
	// name = "Enchanted Tarot Card Deck"
	desc = "Магическая колода карт, «одолженная» у Федерации Магов. Способна материализовывать все 22 старших аркана и их \
	перевёрнутые версии. Каждая карта имеет особый эффект. Бросьте карту в кого-то, чтобы раскрыть её потенциал на них, или \
	испытайте судьбу на себе. Колода никогда не истощится, но ей нужно 25 секунд на накопление энергии для материализации новой \
	карты. Одновременно может поддерживать существование только трёх карт в мире."
	// desc = "A magic tarot card deck \"borrowed\" from a Wizard federation storage unit. Capable of producing magic tarot cards of the 22 major arcana, and their reversed versions. Each card has a different effect. Throw the card at someone to use it on them, or use it in hand to apply it to yourself. Unlimited uses, 25 second cooldown, can have up to 3 cards in the world."
	reference = "tarot"
	item = /obj/item/tarot_generator
	cost = 50 // SS220 EDIT PRICE UP/DOWN 55 -> 50 //This can do a lot of stuff, but is quite random. As such, higher price.
	job = list("Chaplain", "Librarian")

//--------------------------//
// Species Restricted Gear //
//-------------------------//

/datum/uplink_item/species_restricted
	category = "Видоспецифичное снаряжение"
	// category = "Species Specific Gear"
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST) // Stops the job specific category appearing for nukies

//skrell

/datum/uplink_item/species_restricted/lovepen
	name = "Ручка подавления агрессии"
	// name = "Aggression Suppression Pen"
	desc = "Гипоспрей, замаскированный под функциональную ручку, наполнен сильнодействующим химическим веществом, \
	подавляющим агрессию цели. Ручка вмещает четыре дозы препарата, которые со временем медленно восстанавливаются."
	// desc = "A hypospray disguised as a functional pen which is filled with a potent aggression suppressing chemical. The pen holds four doses of the mixture which slowly regenerates over time, but cannot be refilled."
	reference = "LP"
	item = /obj/item/pen/sleepy/love
	cost = 20
	species = list("Skrell")

//Vox

/datum/uplink_item/species_restricted/spikethrower
	name = "Шипомёт Скипджека"
	// name = "Skipjack Spikethrower"
	desc = "Энергетическое оружие, запускающее шипы из твердотельной плазмы, рассекающие атмосферу на большой скорости. \
	Эти шипы имеют достаточную инерцию, чтобы сбить цель с ног и оставить неприятную рану на теле."
	// desc = "An energy based weapon that launches high velocity plasma spikes. These spikes hit with enough force to knock the target down and leave a nasty wound."
	reference = "STG"
	item = /obj/item/gun/energy/spikethrower
	cost = 50
	species = list("Vox")
	surplus = 0

//IPC:

//Positronic supercharge implant: stims, 3 uses, IPC adrenals
/datum/uplink_item/species_restricted/supercharge_implant
	name = "Синтетический био-чип сверхзаряда"
	// name = "Synthetic Supercharge Bio-chip"
	desc = "Био-чип, устанавливаемый под внешнюю часть корпуса. При активации вводит химический коктелйь из реагентов, которые \
	снимают перегруженность внутренних механизмов, устраняют ошибочные данные о направлении передвижения и уменьшают трение \
	для вывода механизмов на более высокую скорость работы. Имеет 3 капсулы со смесью."
	// desc = "A bio-chip injected into the body, and later activated manually to inject a chemical cocktail, which has the effect of removing and reducing the time of all stuns and increasing movement speed. Can be activated up to 3 times."
	reference = "SSI"
	item = /obj/item/bio_chip_implanter/supercharge
	cost = 40
	species = list("Machine")
	surplus = 0

//plasmeme

/datum/uplink_item/species_restricted/fireproofing_nanites
	name = "Инжектор огнестойких нанитов"
	// name = "Fireproofing Nanite Injector"
	desc = "Рой наномашин, которые поглощают избыточное количество тепла, позволяя владельцу стать полностью огнеупорным."
	// desc = "A swarm of nanomachines that absorb excess amounts of heat, allowing the user to become practically fireproof."
	reference = "FPN"
	item = /obj/item/fireproofing_injector
	cost = 25
	species = list("Plasmaman")
	surplus = 0

//Human

/datum/uplink_item/species_restricted/holo_cigar
	name = "Голо-Сигара"
	// name = "Holo-Cigar"
	desc = "Голо-Сигара, импортированая из Солнечной системы. При работе повышает концентрацию пользователя, позволяя \
	стрелять с двух рук или использовать двуручное оружие с одной, прямо как настоящий Спец агент элитных сил Синдиката!"
	// desc = "A holo-cigar imported from the Sol system. The full effects of looking so badass aren't understood yet, but users show an increase in precision while dual-wielding firearms."
	reference = "SHC"
	item = /obj/item/clothing/mask/holo_cigar
	cost = 10
	species = list("Human")

//Grey

/datum/uplink_item/species_restricted/prescan
	name = "Продвинутая система клонирования"
	// name = "Technocracy Advanced Cloning System"
	desc = "Группа умнейших из умнейших учёных Синдиката собрала все необходимые компоненты для постройки \
	усовершенствованной автоматической системы клонирования, чтобы клонировать владельца специального имплантата, \
	передающего мысли, чувства, память и разум в новое тело. Команда сделала его таким полезным и мощным ценой ресурсоемкости, \
	большого времени перезарядки для повторной активации и долгой задержки при подключении к системе."
	// desc = "This kit will give you the parts to build an advanced automatic cloning system, to clone whoever has the linked implant installed on death. Power intensive, implant must be recovered for reuse, and implanter must be linked to cloner."
	reference = "TACS"
	item = /obj/item/storage/box/syndie_kit/prescan
	cost = 25 /// A fresh start, but a start with nothing. Hard to use as well
	species = list("Grey")

// Drask
/datum/uplink_item/species_restricted/cryoregenerative_enhancer
	name = "Криорегенеративный усилитель"
	// name = "Cryoregenerative Enhancer"
	desc = "Специально разработанные наномашины, усиливающие низкотемпературные регенеративные способности расы Драсков\
	. Для работы требуется лишь переохлаждённый воздух в окружающей среде или системе дыхания."
	// desc = "Specially designed nanomachines that enhance the low-temperature regenerative capabilities of drask. Requires supercooled air in the environment or internals to function."
	reference = "CRE"
	item = /obj/item/cryoregenerative_enhancer
	cost = 25
	species = list("Drask")
	surplus = 0

// Unathi
/datum/uplink_item/species_restricted/breach_cleaver
	name = "Тесак Прорыва"
	// name = "Breach Cleaver"
	desc = "Этот массивный двуручный клинок напоминает о войнах на Могесе. Владея им, вы наполняетесь неутолимым \
	желанием воинского совершенства. Удержать его можно лишь двумя руками для сильных атак. Поставляется в ножнах. \
	Имеет различные эффекты в зависимости от намерений воина."
	// desc = "This massive blade harkens back to the wars on Moghes. Wielding it imbues you with the unquenchable desire for martial prowess. \
	// Requires two hands to be wielded. Comes in a scabbard. Has different effects based on intent."
	reference = "CLV"
	item = /obj/item/storage/belt/sheath/breach_cleaver
	cost = 65 // Incredibly strong melee weapon on par with a chainsaw.
	species = list("Unathi")

// -------------------------------------
// ITEMS BLACKLISTED FROM NUCLEAR AGENTS
// -------------------------------------
/datum/uplink_item/dangerous/crossbow
	name = "Энергетический арбалет"
	// name = "Energy Crossbow"
	desc = "Миниатюрный энергетический арбалет. Достаточно маленький, чтобы поместиться в карман. Стреляет \
	отравленными болтами, которые сбивают цель с ног и сильно истощают её. Перезаряжается автоматически."
	// desc = "A miniature energy crossbow that is small enough both to fit into a pocket and to slip into a backpack unnoticed by observers. Fires bolts tipped with toxin, a poisonous substance that is the product of a living organism. Knocks enemies down for a short period of time. Recharges automatically."
	reference = "EC"
	item = /obj/item/gun/energy/kinetic_accelerator/crossbow
	cost = 60
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
	surplus = 50

/datum/uplink_item/dangerous/bulldog_traitor
	name = "Дробовик Бульдог"
	// name = "Bulldog Shotgun"
	desc = "Компактный и смертоносный: спроектирован для тех, кто хочет сражаться в ближнем бою. \
	Заряжен резиновой дробью. Дополнительные боеприпасы продаются отдельно."
	// desc = "Lean and mean: Optimized for people that want to get up close and personal. Comes loaded with rubbershot. Extra Ammo sold separately."
	reference = "BLSG"
	item = /obj/item/gun/projectile/automatic/shotgun/bulldog/traitor
	cost = 50
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/ammo/bull_rubbershot
	name = "Магазин для «Бульдога» (Резиновая дробь 12 калибра)"
	// name = "Bulldog - 12g Rubbershot Magazine"
	desc = "Дополнительный магазин в дробовик «Бульдог» на 8 патронов. Заряжен резиновой дробью."
	// desc = "An additional 8-round rubbershot magazine for use in the Bulldog shotgun."
	reference = "12BRU"
	item = /obj/item/ammo_box/magazine/m12g/rubbershot
	cost = 10
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/dangerous/guardian
	name = "Голопаразит"
	// name = "Holoparasites"
	reference = "HPA"
	desc = "Способные к почти невообразимым подвигам благодаря использованию голограмм жёсткого света и наномашин, \
	они требуют органического хозяина в качестве базы и источника топлива. Из-за особенностей организма цели, \
	инъекцию нельзя сделать Генокрадам и Вампирам."
	// desc = "Though capable of near sorcerous feats via use of hardlight holograms and nanomachines, they require an organic host as a home base and source of fuel. \
	// The holoparasites are unable to incoporate themselves to changeling and vampire agents."
	item = /obj/item/storage/box/syndie_kit/guardian/uplink
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
	cost = 50 // SS220 EDIT PRICE UP/DOWN 60 -> 50
	refund_path = /obj/item/guardiancreator/tech/choose
	refundable = TRUE
	surplus = 0 // This being refundable makes this a big no no in my mind.
	uses_special_spawn = TRUE

/datum/uplink_item/dangerous/guardian/spawn_item(turf/loc, obj/item/uplink/U)
	if(..() != UPLINK_SPECIAL_SPAWNING)
		return FALSE
	new /obj/item/storage/box/syndie_kit/guardian/uplink(loc, cost)

/datum/uplink_item/stealthy_weapons/martialarts
	name = "Свиток боевых искусств"
	// name = "Martial Arts Scroll"
	desc = "Этот свиток содержит секреты древней техники боевого искусства. Вы овладеете смертоносным искусством рукопашного боя, \
	научитесь отражать выстрелы из дальнобойного оружия в защитной стойке, но примите клятву честного боя, отказавшись \
	от всего дальнобойного оружия. Записи слишком сложны для понимания их Генокрадами и Вампирами."
	// desc = "This scroll contains the secrets of an ancient martial arts technique. You will master unarmed combat, \
	// deflecting ranged weapon fire when you are in a defensive stance (throw mode). Learning this art means you will also refuse to use dishonorable ranged weaponry. \
	// Unable to be understood by vampire and changeling agents."
	reference = "SCS"
	item = /obj/item/sleeping_carp_scroll
	cost = 55 // SS220 EDIT PRICE UP/DOWN 65 -> 55
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
	can_discount = FALSE

/datum/uplink_item/stealthy_weapons/bearserk
	name = "Шкура берсерка"
	// name = "Bearserker Pelt"
	desc = "Медвежья шкура, наполняющая носителя духом медведя и знанием оккультного боевого искусства, известного как \
	Ярость Космического Медведя. Сама шкура также бронирована, обеспечивая владельцу большую выносливость. \
	Создана с любовью множеством духов культа Синдиката, известным как Дети Большой Медведицы."
	// desc = "A bear pelt that infuses the wearer with bear spirits and knowledge of an occultic martial art known as Rage of the Space Bear. \
	// The pelt itself is also armored, providing the wearer great longevity. \
	// Made with love, lots of spirits and lots of the other kind of spirits by the Syndicate-affiliated cult, Children of Ursa Major."
	reference = "BSP"
	item = /obj/item/clothing/head/bearpelt/bearserk
	cost = 30 // SS220 EDIT PRICE UP/DOWN 60 -> 30
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/stealthy_tools/traitor_belt
	name = "Пояс агента"
	// name = "Traitor's Toolbelt"
	desc = "Прочный семикарманный пояс, созданный для ношения широкого ассортимента оружия, боеприпасов и взрывчатки. \
	Он смоделирован по образцу стандартного пояса инструментов, чтобы не вызывать подозрений при ношении."
	// desc = "A robust seven-slot belt made for carrying a broad variety of weapons, ammunition and explosives. It's modeled after the standard NT toolbelt so as to avoid suspicion while wearing it."
	reference = "SBM"
	item = /obj/item/storage/belt/military/traitor
	cost = 10
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/stealthy_tools/frame
	name = "Картридж П.О.Д.С.Т.А.В.А."
	// name = "F.R.A.M.E. PDA Cartridge"
	desc = "При установке в КПК этот картридж даёт вам пять активаций PDA-вируса, которые превращают целевой PDA \
	в новый разблокированный Аплинк. Вы получите код от нового Аплинка, и новый КПК может быть заряжен телекристаллами \
	как обычно."
	// desc = "When inserted into a personal digital assistant, this cartridge gives you five PDA viruses which \
	// when used cause the targeted PDA to become a new uplink with zero TCs, and immediately become unlocked.  \
	// You will receive the unlock code upon activating the virus, and the new uplink may be charged with \
	// telecrystals normally."
	reference = "FRAME"
	item = /obj/item/cartridge/frame
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
	cost = 15 // SS220 EDIT PRICE UP/DOWN 20 -> 15

/datum/uplink_item/stealthy_tools/voice_modulator
	name = "Маскировочная маска с функцией искажения голоса"
	// name = "Chameleon Voice Modulator Mask"
	desc = "Тактическая маска Синдиката, оснащённая технологией 'Хамелеон' и модулем шумов для маскировки вашего голоса. \
	Пока модуль искажения активен, ваш голос будет неузнаваем для других."
	// desc = "A syndicate tactical mask equipped with chameleon technology and a sound modulator for disguising your voice. \
	// While the mask is active, your voice will sound unrecognizable to others."
	reference = "CVMM"
	item = /obj/item/clothing/mask/gas/voice_modulator/chameleon
	cost = 5
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/stealthy_tools/voice_changer
	name = "Маскировочная маска с изменителем голоса"
	// name = "Chameleon Voice Changer Mask"
	desc = "Тактическая маска Синдиката, оснащённая технологией 'Хамелеон' и изменителем голоса для маскировки вашего голоса. \
	Используйте его, чтобы имитировать или скрывать свою личность при разговоре, и никто не догадается!"
	// desc = "A syndicate gas mask equipped with chameleon technology and a voice changer for disguising your voice. \
	// Use it to impersonate or obfuscate your identity when talking and make nobody the wiser!"
	reference = "CVCM"
	item = /obj/item/clothing/mask/chameleon/voice_change
	cost = 10
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/stealthy_tools/silicon_cham_suit
	name = "Маскировочный костюм «Большой Брат»"
	// name = "\"Big Brother\" Obfuscation Suit"
	desc = "Тактический костюм Синдиката, оснащённый новейшей анти-кремниевой технологией и, как утверждается, \
	биологической технологией, заимствованной у разума Улья Генокрадов. \
	Пока этот костюм надет, вы будете ускользать от взора станционного ИИ."
	// desc = "A syndicate tactical suit equipped with the latest in anti-silicon technology and, allegedly,
	//biological technology learned from the Changeling Hivemind.
	// While this suit is worn, you will be unable to be tracked or seen by on-Station AI."
	reference = "BBOS"
	item = /obj/item/clothing/under/syndicate/silicon_cham
	cost = 15 // SS220 EDIT PRICE UP/DOWN 20 -> 15
	excludefrom = list(UPLINK_TYPE_NUCLEAR)

/datum/uplink_item/stealthy_weapons/sleepy_pen
	name = "Усыпляющая ручка"
	// name = "Sleepy Pen"
	desc = "Шприц, замаскированный под функциональную ручку, наполненый мощным снотворным. Ручка содержит две дозы смеси. \
	Ручку можно пополнять."
	// desc = "A syringe disguised as a functional pen. It's filled with a potent anesthetic. \
	// The pen holds two doses of the mixture. The pen can be refilled."
	reference = "SP"
	item = /obj/item/pen/sleepy
	cost = 20 // SS220 EDIT PRICE UP/DOWN 40 -> 20
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/stealthy_weapons/dart_pistol
	name = "Набор Дротикомёта"
	// name = "Dart Pistol Kit"
	desc = "Миниатюрная версия обычного шприцемёта. Очень тихий при выстреле и может поместиться в любой карман. \
	Поставляется с 3 шприцами: нокаутирующий яд, агент подавления голоса и смертельный нейротоксин."
	// desc = "A miniaturized version of a normal syringe gun. It is very quiet when fired and can fit into any space a small item can. Comes with 3 syringes: a knockout poison, a silencing agent and a deadly neurotoxin."
	reference = "DART"
	item = /obj/item/storage/box/syndie_kit/dart_gun
	cost = 10 // SS220 EDIT PRICE UP/DOWN 20 -> 10
	surplus = 50
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/// Nukies get combat gloves plus instead
/datum/uplink_item/stealthy_weapons/combat_minus
	name = "Экспериментальные перчатки Крав Мага"
	// name = "Experimental Krav Gloves"
	desc = "Экспериментальные перчатки с установленными наночипами, которые обучают вас искусству Крав Мага при ношении. \
	Отличны если рассматривать как дешёвое резервное оружие. Предупреждение: наночипы перезапишут любые другие боевые стили, \
	такие как CQC. Не выглядят так же круто, как у Смотрителя."
	// desc = "Experimental gloves with installed nanochips that teach you Krav Maga when worn, great as a cheap backup weapon. Warning, the nanochips will override any other fighting styles such as CQC. Do not look as fly as the Warden's"
	reference = "CGM"
	item = /obj/item/clothing/gloves/color/black/krav_maga
	cost = 45 // SS220 EDIT PRICE UP/DOWN 50 -> 45
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/device_tools/extraction_beacon
	name = "Сигнальный маяк эвакуации"
	// name = "Extraction Flare"
	desc = "Специальная сигнальная ракета для вызова портала эвакуации. Порталу требуется время для раскрытия, \
	и он будет работать только в определённых местах, откалиброваных заранее нашей командой под прикрытием. \
	Синдикат оставляет за собой право отказать в портале агентам с определёнными целями и в определённое время."
	// desc = "A special flare used to call in an extraction portal. The portal takes time to generate, and will only work in certain rooms that it is pre-calibrated for. The Syndicate withholds the right to deny a portal to agents with certain objectives."
	reference = "EXTF"
	item = /obj/item/wormhole_jaunter/extraction
	limited_stock = 1
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/device_tools/hyper_medipen
	name = "Гиперрегенеративный медипен"
	// name = "Hyper-regenerative Medipen"
	desc = "Автоинжектор, наполненный различными медицинскими химикатами. Он быстро заживляет обычные травмы \
	и восстанавливает генетические повреждения, но так же быстро теряет эффективность. Может иметь побочные эффекты \
	при частом использовании."
	// desc = "An autoinjector filled with a variety of medical chemicals. It rapidly heals conventional injuries and genetic damage, but loses potency just as quickly. May have side effects if multiple are used in quick succession."
	reference = "HMP"
	item = /obj/item/reagent_containers/hypospray/autoinjector/hyper_medipen
	cost = 10
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/// Nukies get Diamond Tipped Thermal Safe Drill instead
/datum/uplink_item/device_tools/thermal_drill
	name = "Термальная дрель для сейфов"
	// name = "Amplifying Thermal Safe Drill"
	desc = "Термобур из карбида вольфрама с магнитными зажимами для сверления закалённых сейфов. \
	Оснащён встроенной системой обнаружения службы безопасности, чтобы держать вас начеку, \
	если служба безопасность будет уже на пороге."
	// desc = "A tungsten carbide thermal drill with magnetic clamps for the purpose of drilling hardened objects. Comes with built in security detection and nanite system, to keep you up if security comes a-knocking."
	reference = "DRL"
	item = /obj/item/thermal_drill/syndicate
	cost = 5
	surplus = 0 // I feel like its amazing for one objective and one objective only. Far too specific.
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/suits/modsuit
	name = "MOD-сьют Синдиката"
	// name = "Syndicate MODsuit"
	desc = "Устрашающий кроваво-красный MOD-сьют ядерного оперативника Синдиката. Оснащён бронепластинами боевого класса и \
	режимом EVA. Боевой режим выставляет на первое место бронепластины для дополнительной устойчивости владельца к ранениям и \
	повышению удобства при передвижении, режим EVA возвращает бронепластины на исходные позиции, что позволяет сделать \
	МОД-сьют полностью герметичным. Экипаж, обычно, паникует при виде Красных, если только это не СССП."
	// desc = "The feared MODsuit of a syndicate nuclear agent. Features armor and an EVA mode \
	// for faster movement on station. Toggling the suit in and out of \
	// combat mode will allow you all the mobility of a loose fitting uniform without sacrificing armoring. \
	// Comes containing internals. \
	// Nanotrasen crew who spot these suits are known to panic."
	reference = "BRHS"
	item = /obj/item/mod/control/pre_equipped/traitor
	cost = 30
	surplus = 60 //I have upped the chance of modsuits from 40, as I do feel they are much more worthwhile with the base modsuit no longer being 8 tc, and the high armor values of the elite.
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/suits/modsuit_elite
	name = "Элитный MOD-сьют Синдиката"
	// name = "Syndicate Elite MODsuit"
	desc = "Продвинутый MOD-сьют с лучшими бронепластинами, во многом превосходит своего предшественника. \
	Корпораты НТ при виде такой красоты частенько убегают, сверкая пятками."
	// desc = "An advanced MODsuit with superior armor to the standard Syndicate MODsuit. \
	// Nanotrasen crew who spot these suits are known to *really* panic."
	reference = "MSE"
	item = /obj/item/mod/control/pre_equipped/traitor_elite
	cost = 45 //45 to start, no holopara / ebow.
	surplus = 60
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/// Nukies get Nuclear Uplink Bio-chip instead
/datum/uplink_item/bio_chips/uplink
	name = "Биочип Аплинка"
	// name = "Uplink Bio-chip"
	desc = "Био-чип, вводимый инъекцией под кожу. По желанию пользователя, открывает виртуальный Аплинк с \
	50 телекристаллами. Понадобится, чтобы удивить сокамерников магически материализовавшимся планом побега."
	// desc = "A bio-chip injected into the body, and later activated manually to open an uplink with 50 telecrystals. The ability for an agent to open an uplink after their possessions have been stripped from them makes this implant excellent for escaping confinement."
	reference = "UI"
	item = /obj/item/bio_chip_implanter/uplink
	cost = 70
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
	surplus = 0
	can_discount = FALSE

/datum/uplink_item/cyber_implants/sensory_enhancer
	name = "Сенсорный компьютер Qani-Laaca с автоимплантером"
	// name = "Qani-Laaca Sensory Computer Autoimplanter"
	desc = "Спинной имплант, который введёт в вашу кровеносную систему небольшую дозировку мефедрона — мощного стимулятора, \
	вызывающего слабые повреждения сердца.Стимулятор обеспечит более высокую мобильность при передвижении, слабое подавление \
	чувствительности к боли, заставит вас не сдаваться даже упавшим и ускорит вашу мелкую моторику рук, но не спасёт вас от \
	переутомления. Передозировка вызовет быстрое разрушение сердца, но даст вам сил уклоняться от пуль и заставит ваши руки \
	делать всё с ещё большей скоростью! Две минуты нормальной работы, пять минут для генерации новой дозировки химиката. \
	Влияет напрямую на мозг, поэтому несовместим с любыми другими имплантами этой направленности."
	// desc = "Epilepsy Warning: Drug has vibrant visual effects! \
	// This spinal implant will inject mephedrone into your system, a powerful stimulant that causes slight heart damage.\
	// This stimulant will provide faster movement speed, slight pain resistance, immunity to crawling slowdown, and faster attack speed, though no antistun.\
	// Overdosing will cause massive heart damage, but will allow the user to dodge bullets for a minute and attack even faster.\
	// Two minute normal uptime, 5 minute cooldown, unlimited uses. Incompatible with the Binyat Wireless Hacking System."
	reference = "QLSC"
	item = /obj/item/autosurgeon/organ/syndicate/oneuse/sensory_enhancer
	cost = 40
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST) //No, nukies do not get to dodge bullets.

/datum/uplink_item/badass/syndiecards
	name = "Игральные карты Синдиката"
	// name = "Syndicate Playing Cards"
	desc = "Специальная колода игральных карт с заострённой мономолекулярной кромкой и металлическим усилением, \
	что делает их смертельным оружием как при использовании в качестве клинка, так и при метании в цель. \
	Вы также можете играть в карточные игры ими!"
	// desc = "A special deck of space-grade playing cards with a mono-molecular edge and metal reinforcement, making them lethal weapons both when wielded as a blade and when thrown. \
	// You can also play card games with them."
	reference = "SPC"
	item = /obj/item/deck/cards/syndicate
	cost = 2
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
	surplus = 40

/datum/uplink_item/badass/plasticbag
	name = "Пластиковый пакет"
	// name = "Plastic Bag"
	desc = "Ничем не примечательный пластиковый пакет. Хранить в доступном для детей месте, надевать на голову, носить пиво."
	// desc = "A simple, plastic bag. Keep out of reach of small children, do not apply to head."
	reference = "PBAG"
	item = /obj/item/storage/bag/plasticbag
	cost = 1
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/bundles_tc/contractor
	name = "Набор Контрактора Синдиката"
	// name = "Syndicate Contractor Kit"
	desc = "Набор, дающий вам разрешение на выполнение особых поручений на похищение, в обмен на кредиты и дополнительные телекристаллы.\
	Подходит только для бывалых агентов."
	// desc = "A bundle granting you the privilege of taking on kidnapping contracts for credit and TC payouts that can add up to more than its initial cost."
	reference = "SCOK"
	cost = 100
	item = /obj/item/storage/box/syndie_kit/contractor
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/bundles_tc/contractor/spawn_item(turf/loc, obj/item/uplink/U)
	var/datum/mind/mind = usr.mind
	var/datum/antagonist/traitor/AT = mind.has_antag_datum(/datum/antagonist/traitor)
	if(LAZYACCESS(GLOB.contractors, mind))
		to_chat(usr, SPAN_WARNING("Error: Contractor credentials detected for the current user. Unable to provide another Contractor kit."))
		return
	else if(!AT)
		to_chat(usr, SPAN_WARNING("Error: Embedded Syndicate credentials not found."))
		return
	else if(IS_CHANGELING(usr) || mind.has_antag_datum(/datum/antagonist/vampire))
		to_chat(usr, SPAN_WARNING("Error: Embedded Syndicate credentials contain an abnormal signature. Aborting."))
		return
	var/obj/item/I = ..()
	// Init the hub
	var/obj/item/contractor_uplink/CU = locate(/obj/item/contractor_uplink) in I
	CU.hub = new(mind, CU)
	// Update their mind stuff
	LAZYSET(GLOB.contractors, mind, CU.hub)
	AT.add_antag_hud(mind.current)
	log_game("[key_name(usr)] became a Contractor")
	return I

/datum/uplink_item/bundles_tc/badass
	name = "Комплект экипировки и оборудования Синдиката"
	// name = "Syndicate Bundle"
	desc = "Специально подобранный набор предметов для выполнения определённой задачи. Эти предметы в совокупности стоят \
	более 100 телекристаллов. Вы можете выбрать одну из трёх специализаций после покупки или довериться нашему \
	Отделу принятия сложных решений."
	// desc = "Syndicate Bundles are specialized groups of items that arrive in a plain box. These items are collectively worth more than 100 telecrystals. You can select one out of three specializations after purchase."
	reference = "SYB"
	item = /obj/item/beacon/syndicate/bundle
	cost = 100
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/bundles_tc/surplus_crate
	name = "Ящик профицитной экипировки Синдиката"
	// name = "Syndicate Surplus Crate"
	desc = "Контейнер, в котором содержатся случайные остатки со склада Синдиката на сумму не менее 250 телекристаллов."
	// desc = "A crate containing 250 telecrystals worth of random syndicate leftovers."
	reference = "SYSC"
	cost = 100
	item = /obj/item/storage/box/syndie_kit/bundle
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
	var/crate_value = 250
	uses_special_spawn = TRUE

/datum/uplink_item/bundles_tc/surplus_crate/spawn_item(turf/loc, obj/item/uplink/U, mob/user)
	if(..() != UPLINK_SPECIAL_SPAWNING)
		return FALSE
	new /obj/structure/closet/crate/surplus(loc, U, crate_value, cost, user)

// -----------------------------------
// PRICES OVERRIDEN FOR NUCLEAR AGENTS
// -----------------------------------
/datum/uplink_item/stealthy_weapons/cqc
	name = "Руководство по CQC"
	// name = "CQC Manual"
	desc = "Руководство, которое обучает тактическому ближнему бою. Изменяет ваш стиль боя на максимизацию \
	изматывания жертвы, а не летальные последствия. Не ограничивает использование оружия и может использоваться вместе \
	с Перчатками Северной Звезды для создания превосходного комбо."
	// desc = "A manual that teaches a single user tactical Close-Quarters Combat before self-destructing. \
	// Changes your unarmed damage to deal non-lethal stamina damage. \
	// Does not restrict weapon usage, and can be used alongside Gloves of the North Star."
	reference = "CQC"
	item = /obj/item/cqc_manual
	cost = 50
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/explosives/syndicate_bomb
	name = "Бомба Синдиката"
	// name = "Syndicate Bomb"
	desc = "Заряд имеет регулируемый таймер с минимальной настройкой в 90 секунд. Заказ бомбы отправляет \
	вам маленький маяк, который телепортирует взрывчатку в ваше местоположение при активации. \
	Вы можете опустить захваты, чтобы бомбу нельзя было переместить."
	// desc = "The Syndicate Bomb has an adjustable timer with a minimum setting of 90 seconds. Ordering the bomb sends you a small beacon, which will teleport the explosive to your location when you activate it. \
	// You can wrench the bomb down to prevent removal. The crew may attempt to defuse the bomb."
	reference = "SB"
	item = /obj/item/beacon/syndicate/bomb
	cost = 40
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
	surplus = 0
	hijack_only = TRUE

/datum/uplink_item/explosives/emp_bomb
	name = "ЭМИ-бомба"
	// name = "EMP bomb"
	desc = "ЭМИ-бомба имеет регулируемый таймер с минимальной настройкой в 90 секунд. Заказ бомбы отправляет \
	вам маленький маяк, который телепортирует взрывчатку в ваше местоположение при активации. \
	Вы можете опустить захваты, чтобы бомбу нельзя было переместить. Создает мощных 3 импульса."
	// desc = "The EMP has an adjustable timer with a minimum setting of 90 seconds. Ordering the bomb sends you a small beacon, which will teleport the explosive to your location when you activate it. \
	// You can wrench the bomb down to prevent removal. The crew may attempt to defuse the bomb. Will pulse 3 times."
	reference = "SBEMP"
	item = /obj/item/beacon/syndicate/bomb/emp
	cost = 40
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
	surplus = 0
	can_discount = FALSE

/datum/uplink_item/explosives/emp_bomb/New()
	..()
	if(HAS_TRAIT(SSstation, STATION_TRAIT_CYBERNETIC_REVOLUTION))
		cost *= 1.25 //ok this thing is already very expencive it doesnt need much more

/datum/uplink_item/explosives/atmosfiregrenades
	name = "Гранаты плазменного огня"
	// name = "Plasma Fire Grenades"
	desc = "Коробка с двумя кластерными гранатами начинёнными до отказа плазмой. Прекрасно справляются с \
	аннигилированием больших областей. Полезность повышается, если у вас есть костюм защищённый от огня и перепадов давления."
	// desc = "A box of two (2) grenades that cause large plasma fires. Can be used to deny access to a large area. Most useful if you have an atmospherics hardsuit."
	reference = "APG"
	item = /obj/item/storage/box/syndie_kit/atmosfiregrenades
	cost = 50
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
	surplus = 0
	hijack_only = TRUE

/datum/uplink_item/stealthy_tools/chameleon
	name = "Маскировочный набор"
	// name = "Chameleon Kit"
	desc = "Набор предметов одежды, использующих технологию 'Хамелеон', позволяющую маскироваться практически под \
	кого угодно на станции и даже больше! Средства, выделенные научному отделу для разработки противоскользящей обуви\
	, были переданы в фонд изучения розовых вульпкан."
	// desc = "A set of items that contain chameleon technology allowing you to disguise as pretty much anything on the station, and more! \
	// Due to budget cuts, the shoes don't provide protection against slipping."
	reference = "CHAM"
	item = /obj/item/storage/box/syndie_kit/chameleon
	cost = 10
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/stealthy_tools/syndigaloshes
	name = "Маскировочные ботинки с защитой от скольжения"
	// name = "No-Slip Chameleon Shoes"
	desc = "Эта обувь позволит владельцу бегать по мокрым поверхностям и скользким предметам без падений. \
	Подошва не поможет на сильно смазанных поверхностях."
	// desc = "These shoes will allow the wearer to run on wet floors and slippery objects without falling down. \
	// They do not work on heavily lubricated surfaces."
	reference = "NSSS"
	item = /obj/item/clothing/shoes/chameleon/noslip
	cost = 10
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/explosives/detomatix
	name = "Подрывной картридж 'Детоматикс'"
	// name = "Detomatix PDA Cartridge"
	desc = "При установке в КПК этот картридж даст вам пять копий крайне опасного цифрового вируса, способного через месенжер \
	подрывать чужие КПК. Ударная волна от взрыва оглушит и собьёт с ног получателя на короткое время. Имеется большая вероятность отрыва конечностей."
	// desc = "When inserted into a personal digital assistant, this cartridge gives you five opportunities to detonate PDAs of crew members who have their message feature enabled. The concussive effect from the explosion will knock the recipient down for a short period, and deafen them for longer."
	reference = "DEPC"
	item = /obj/item/cartridge/syndicate
	cost = 15 // SS220 EDIT PRICE UP/DOWN 30 -> 15
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
