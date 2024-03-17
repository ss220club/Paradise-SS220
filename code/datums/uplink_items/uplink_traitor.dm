// TRAITOR ONLY GEAR

// JOB SPECIFIC GEAR

/datum/uplink_item/jobspecific
	category = "Job Specific Tools"
	cant_discount = TRUE
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST) // Stops the job specific category appearing for nukies

//Clown
/datum/uplink_item/jobspecific/clowngrenade
	name = "Banana Grenade"
	desc = "Граната, что взрывается вместе с ХОНКОМ! брендовые кожурки от бананов генетически модифицированны чтобы быть очень скользкими и выделяют едкую кислоту когда на них наступают."
	reference = "BG"
	item = /obj/item/grenade/clown_grenade
	cost = 15
	job = list("Clown")

/datum/uplink_item/jobspecific/clownslippers
	name = "Clown Acrobatic Shoes"
	desc = "Пара модифицированных клоунских ботинок, оснащённых встроенной пропульсионной системой, что позволяет пользователю короткие подкаты под кем-угодно. Включение амортизаторов убирает замедление от ботинок."
	reference = "CAS"
	item = /obj/item/clothing/shoes/clown_shoes/slippers
	cost = 15
	surplus = 75
	job = list("Clown")

/datum/uplink_item/jobspecific/cmag
	name = "Jestographic Sequencer"
	desc = "Джестографический сиквенсер, также известный как клоунский емаг. Это маленькая карта, которая инвертирует доступ на любой двери, где была использована. Идеально подходит для блокировки отделов командования. Хонк!"
	reference = "CMG"
	item = /obj/item/card/cmag
	cost = 20
	surplus = 75
	job = list("Clown")

/datum/uplink_item/jobspecific/trick_revolver
	name = "Trick Revolver"
	desc = "Револьвер, что будет стрелять в стрелка и убьёт любого, кто попытается им воспользоваться. Идеален для линчевателей или просто для хорошей шутки."
	reference = "CTR"
	item = /obj/item/storage/box/syndie_kit/fake_revolver
	cost = 5
	job = list("Clown")

/datum/uplink_item/jobspecific/trick_grenade
	name = "Trick Grenade"
	desc = "Минибомба синдиката с покрытием из клея, что будет прилипать к руке пользователя при активации."
	reference = "CGN"
	item = /obj/item/storage/box/syndie_kit/fake_minibomb
	cost = 5
	job = list("Clown")

//mime
/datum/uplink_item/jobspecific/caneshotgun
	name = "Cane Shotgun and Assassination Shells"
	desc = "Специализированный однозарядный дробовик с установленной маскировочной системой для мимикрироавния под трость. Дробовик способен скрыть свой спусковой крючок вместе с глушителем. Поставляется в коробке вместе с 6 специализированными снарядами шрапнели, покрытыми токсином немоты и одним снарядом заряженным уже в дробовик."
	reference = "MCS"
	item = /obj/item/storage/box/syndie_kit/caneshotgun
	cost = 40
	job = list("Mime")

/datum/uplink_item/jobspecific/mimery
	name = "Guide to Advanced Mimery Series"
	desc = "Содержит два мануала для изучения продвинутых пантомим. Вы сможете стрелять безшумными пулями из пальца и создавать большие невидимые стены, что могут заблокировать целый коридор."
	reference = "AM"
	item = /obj/item/storage/box/syndie_kit/mimery
	cost = 50
	job = list("Mime")
	surplus = 0 // I feel this just isn't healthy to be in these crates.

/datum/uplink_item/jobspecific/combat_baking
	name = "Combat Bakery Kit"
	desc = "Набор нелегального запечённого оружия. Содержит багет, который опытный мим может использовать как меч, \
		пару метательных круасанов и рецепт чтобы создать больше оружия при необходимости. Когда работа выполнена - сьешьте улики."
	reference = "CBK"
	item = /obj/item/storage/box/syndie_kit/combat_baking
	cost = 25 //A chef can get a knife that sharp easily, though it won't block. While you can get endless boomerang, they are less deadly than a stech, and slower / more predictable.
	job = list("Mime", "Chef")

/datum/uplink_item/jobspecific/pressure_mod
	name = "Kinetic Accelerator Pressure Mod"
	desc = "Набор модификации, что позволяет Кинетеческому Акселератору наносить серьёзный урон в условиях нормального давления. Занимает 35% места для модификаций."
	reference = "KPM"
	item = /obj/item/borg/upgrade/modkit/indoors
	cost = 25 //you need two for full damage, so total of 50 for maximum damage
	job = list("Shaft Miner")
	surplus = 0 // Requires a KA to even be used.

//Chef
/datum/uplink_item/jobspecific/specialsauce
	name = "Chef Excellence's Special Sauce"
	desc = "Особый соус, сделанный из крайне ядовитых мухоморов. Любой кто его попробует - получит различную степень отравления, которая варьируется от того насколько долго он находился в организме. Чем больше доза, тем дольше займёт метаболизация."
	reference = "CESS"
	item = /obj/item/reagent_containers/condiment/syndisauce
	cost = 10
	job = list("Chef")
	surplus = 0 // Far too specific in its use.

/datum/uplink_item/jobspecific/meatcleaver
	name = "Meat Cleaver"
	desc = "Говорящий сам за себя тесак для мяса, который наносит урон сравнимый с энергитическим мечом. Имеет одно преимущество по сравнению с энергитическим мечом, а именно нарезает жертву на куски мяса после смерти."
	reference = "MC"
	item = /obj/item/kitchen/knife/butcher/meatcleaver
	cost = 40
	job = list("Chef")

/datum/uplink_item/jobspecific/syndidonk
	name = "Syndicate Donk Pockets"
	desc = "Коробка крайне специализированных Донк покетов с определённым количеством регенеративных и стимулирующих химикатов внутри. Коробка поставляется вместе с механизмом самонагрева."
	reference = "SDP"
	item = /obj/item/storage/box/syndidonkpockets
	cost = 10
	job = list("Chef")

//Chaplain

/datum/uplink_item/jobspecific/missionary_kit
	name = "Missionary Starter Kit"
	desc = "Коробка, содержащая в себе посох миссионера, робы миссионера и библию. Робы и посох могут быть связаны и позволят конвертировать жертв на расстоянии на короткое время для исполнения вашей воли. Библия нужна библии." // Последнее предложение пока как временная затычка
	reference = "MK"
	item = /obj/item/storage/box/syndie_kit/missionary_set
	cost = 75
	job = list("Chaplain")
	surplus = 0 // Controversial maybe, but with the ease of mindslaving with this item I'd prefer it stay chaplain specific.

/datum/uplink_item/jobspecific/artistic_toolbox
	name = "His Grace"
	desc = "Невероятно опасное оружие, полученное со станции, уничтоженной Грей тайдом. Когда Он активирован, Он будет жаждать крови и должен быть использован для убийства чтобы удовлетворить Его жажду. \
	Его Святейшество дарует постепенную регенерацию и полный иммунитет к станам для своего владельца, но будьте осторожны: если Он станет очень голоден, Его будет невозможно выбросить из рук и убьёт вас если вы Его не покормите. \
	Однако, если оставить Его в одиночестве на достаточное количество времени, то Он опять погрузится в сон. \
	Чтобы активировать Его Святейшество, просто разблокируйте Его."
	reference = "HG"
	item = /obj/item/his_grace
	cost = 100
	job = list("Chaplain")
	surplus = 0 //No lucky chances from the crate; if you get this, this is ALL you're getting
	hijack_only = TRUE //This is a murderbone weapon, as such, it should only be available in those scenarios.

//Janitor

/datum/uplink_item/jobspecific/cautionsign
	name = "Proximity Mine"
	desc = "Противопехотная сенсорная мина, умно замаскированная под знак мокрого пола, которая может быть сдетонирована прохождением по ней, активируйте её чтобы начать 15 секундный отсчёт и активируйте ещё чтобы разминировать."
	reference = "PM"
	item = /obj/item/caution/proximity_sign
	cost = 10
	job = list("Janitor")

/datum/uplink_item/jobspecific/titaniumbroom
	name = "Titanium Push Broom"
	desc = "Метла с усиленной рукояткой и щёткой из металлической проволоки, идеальна для создания самому себе большей работы и избивания ассистентов. \
	Когда находится в двух руках, вы будете отклонять пули и избивание людей будет иметь разные эффекты в зависимости от вашего интента."
	reference = "TPBR"
	item = /obj/item/push_broom/traitor
	cost = 60
	job = list("Janitor")
	surplus = 0 //no reflect memes

//Virology

/datum/uplink_item/jobspecific/viral_injector
	name = "Viral Injector"
	desc = "Модифицированный гипоспрей, замаскированный под пипетку. Пипетка может заражать жертв вирусом при инъекции."
	reference = "VI"
	item = /obj/item/reagent_containers/dropper/precision/viral_injector
	cost = 15
	job = list("Virologist")

/datum/uplink_item/jobspecific/cat_grenade
	name = "Feral Cat Delivery Grenade"
	desc = "Граната с дикими кошками содержит 5 обезвоженных диких кошек, схожих по принципу с обезвоженными обезьянами, которые при детонации будут регидратированы до нормального состояния с помощью маленького резервуара с водой в гранате. Эти кошки будут атаковать всё, что движется."
	item = /obj/item/grenade/spawnergrenade/feral_cats
	reference = "CCLG"
	cost = 10
	job = list("Psychiatrist")//why? Becuase its funny that a person in charge of your mental wellbeing has a cat granade..

//Assistant

/datum/uplink_item/jobspecific/pickpocketgloves
	name = "Pickpocket's Gloves"
	desc = "Пара гладких перчаток для помощи в кражах. При их ношении, вы сможете обворовать свою цель, не давая её знать об этом. Кража с этими перчатками переместит предмет вам прямо в руку."
	reference = "PPG"
	item = /obj/item/clothing/gloves/color/black/thief
	cost = 30
	job = list("Assistant")

//Bartender

/datum/uplink_item/jobspecific/drunkbullets
	name = "Boozey Shotgun Shells"
	desc = "Коробка, содержащая в себе 6 снарядов для дробовика, который симулируют эффекты сильного опьянения на цели, наиболее эффективные для любого типа алкоголя в крови цели."
	reference = "BSS"
	item = /obj/item/storage/box/syndie_kit/boolets
	cost = 10
	job = list("Bartender")

//Botanist
/datum/uplink_item/jobspecific/bee_briefcase
	name = "Briefcase Full of Bees"
	desc = "На первый взгляд безобидный чемодан, полный не так уж и безопасных синди пчёл. Вколите в чемодан кровь чтобы натренировать пчёл игнорировать доноров. ПРЕДУПРЕЖДЕНИЕ: экзотические типы крови, по типу слаймового желе не будут работать. Чемодан также внедряется в систему интеркомов на станции чтобы транслировать сообщения ТЕРОРРА."
	reference = "BEE"
	item = /obj/item/bee_briefcase
	cost = 50
	job = list("Botanist")

//Engineer

/datum/uplink_item/jobspecific/powergloves
	name = "Power Bio-Chip"
	desc = "Био-чип, что может использовать электричество станции для доставки коротких электрических дуг к цели. \
			Для использования необходимо стоять на запитанной проводке. \
			Может быть активирован при помощи alt+click или при нажатии средней кнопки мыши. Интент обезоруживания будет наносить стамина урон и вызывать тряску, в то время как интент вреда будет наносить урон, основанный на мощность тока в проводах, на которых вы стоите. Может быть включен / отключен при помощи кнопки."
	reference = "PG"
	item = /obj/item/bio_chip_implanter/shock
	cost = 50
	job = list("Station Engineer", "Chief Engineer")

//RD

/datum/uplink_item/jobspecific/telegun
	name = "Telegun"
	desc = "Очень высоко технологичное энергетическое оружие, что использует блюспейс технологию для телепортации живых целей. Выберите маяк куда телепортировать цели на самом оружии. Снаряды будут отправлять цели на выбранный маяк. Может отправлять цели только на те маяки, что находятся в одном секторе с вами, пока маяки не взломаны."
	reference = "TG"
	item = /obj/item/gun/energy/telegun
	cost = 50
	job = list("Research Director")

//Roboticist
/datum/uplink_item/jobspecific/syndiemmi
	name = "Syndicate MMI"
	desc = "Разработанный Синдикатом man-machine inferface что сделает рабом любой мозг, вставленный туда до тех пор пока он находится там. Киборги созданные при помощи этого ММИ будут пермаментно порабощены вашей воле, но в то же время будут функционировать нормально."
	reference = "SMMI"
	item = /obj/item/mmi/syndie
	cost = 10
	job = list("Roboticist")
	surplus = 0


//Librarian
/datum/uplink_item/jobspecific/etwenty
	name = "The E20"
	desc = "На первый взгляд безобидная кость, но те кто не побоятся её бросить для атаки найдут её эффекты довольно взрывоопасными. Имеет 4 секундный таймер."
	reference = "ETW"
	item = /obj/item/dice/d20/e20
	cost = 15
	job = list("Librarian")
	surplus = 0

//Botanist
/datum/uplink_item/jobspecific/ambrosiacruciatus
	name = "Ambrosia Cruciatus Seeds"
	desc = "Часть печально известной семьи Амброзии. Эта разновидность практически неотличима от Амброзии Вульгарис, но её ветки содержат отвратительнейший токсин. 8 единиц уже достаточно чтобы свести жертву с ума."
	reference = "BRO"
	item = /obj/item/seeds/ambrosia/cruciatus
	cost = 5
	job = list("Botanist")
	surplus = 0 // Even botanists would struggle to use this effectively, nevermind a coroner.

//Atmos Tech
/datum/uplink_item/jobspecific/contortionist
	name = "Contortionist's Jumpsuit"
	desc = "Крайне гибкий костюм, что поможет передвигаться по вентиляционным трубам по всей станции. Поставляется вместе с кармани и слотом для ID карты, но не может быть использован без снятия практически всех вещей, включая рюкзак, пояс, шлем и броню. Свободный руки также необходимы для того чтобы залезть внутрь вентиляции."
	reference = "AIRJ"
	item = /obj/item/clothing/under/rank/engineering/atmospheric_technician/contortionist
	cost = 30
	job = list("Life Support Specialist")

/datum/uplink_item/jobspecific/energizedfireaxe
	name = "Energized Fire Axe"
	desc = "Пожарный топор с встроенным массивным энергетическим зарядом. При ударе кого-либо при наличии заряда будет отбрасывать цель назад, вызывая стан, но требует некоторого времени для перезарядки. Также он намного острее чем обычный топор и может пробивать лёгкую броню."
	reference = "EFA"
	item = /obj/item/fireaxe/energized
	cost = 40
	job = list("Life Support Specialist")

//Stimulants

/datum/uplink_item/jobspecific/stims
	name = "Stimulants"
	desc = "Очень нелегальное соединение, содержащееся в компактном авто-инжекторе. Когда вколот, делает пользователя иммуным к станам и многократно повышает способность тела к саморегенерации."
	reference = "ST"
	item = /obj/item/reagent_containers/hypospray/autoinjector/stimulants
	cost = 40
	job = list("Scientist", "Research Director", "Geneticist", "Chief Medical Officer", "Medical Doctor", "Psychiatrist", "Chemist", "Paramedic", "Coroner", "Virologist")

// Genetics

/datum/uplink_item/jobspecific/magillitis_serum
	name = "Magillitis Serum Bio-chip"
	desc = "Одноразовый био-чип, который содержит экспериментальную сыворотку, что вызывает сильный рост мышц, превращая пользователя в гориллу. \
			Побочные эффекты могу включать: гипертрихоз, вспышки гнева, и постоянную зависимость от бананов."
	reference = "MAG"
	item = /obj/item/bio_chip_implanter/gorilla_rampage
	cost = 25
	job = list("Research Director", "Geneticist")

// Paper contact poison pen

/datum/uplink_item/jobspecific/poison_pen
	name = "Poison Pen"
	desc = "Разработка на стыке пишущей и смертельной технологий. Этот гаджет будет пропитывать любой кусок бумаги разнообразными ядами, основанных на выбранном цвете чернил. Чёрные - нормальные чернила. Красные чернила - чернила с очень летальным ядом. Зелёные чернила вызывают радиацонное отравление. Синие будут периодически шокировать жертву. Жёлтые будут парализовывать. Поставляющиеся в комплекте перчатки защитят вас от собственных ядов."
	reference = "PP"
	item = /obj/item/storage/box/syndie_kit/poisoner
	cost = 10
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
	job = list("Head of Personnel", "Quartermaster", "Cargo Technician", "Librarian", "Coroner", "Psychiatrist", "Virologist")


//--------------------------//
// Species Restricted Gear //
//-------------------------//

/datum/uplink_item/species_restricted
	category = "Species Specific Gear"
	cant_discount = TRUE
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST) // Stops the job specific category appearing for nukies

//skrell
/datum/uplink_item/species_restricted/lovepen
	name = "Aggression Suppression Pen"
	desc = "Шприц, замаскированный под ручку, которая заполнена мощным подавляющим агрессию химикатом. В ручке содержатся 4 дозы микстуры и они не могут быть восполнены."
	reference = "LP"
	item = /obj/item/pen/sleepy/love
	cost = 20
	species = list("Skrell")

//Vox
/datum/uplink_item/species_restricted/spikethrower
	name = "Skipjack Spikethrower"
	desc = "Энергетическое оружие, что запускает высокоскорстные плазма шипы. Эти шипы попадают с силой достаточной чтобы уронить цель и оставить рану."
	reference = "STG"
	item = /obj/item/gun/energy/spikethrower
	cost = 60
	species = list("Vox")
	surplus = 0

//IPC:
//Positonic supercharge implant: stims, 3 uses, IPC adrenals
/datum/uplink_item/species_restricted/supercharge_implant
	name = "Synthetic Supercharge Bio-chip"
	desc = "Био-чип, который можно вколоть в тело и позже, активировав, он вколет коктейль из химикатов, который убирает все станы и увеличивает скорость передвижения. Может быть активирован до 3 раз."
	reference = "SSI"
	item = /obj/item/bio_chip_implanter/supercharge
	cost = 40
	species = list("Machine")
	surplus = 0


//plasmeme
/datum/uplink_item/species_restricted/fireproofing_nanites
	name = "Fireproofing Nanite Injector"
	desc = "Рой наномашин, которые поглощают излишнее тепло, позволяя пользователю становиться  огнеупорным."
	reference = "FPN"
	item = /obj/item/fireproofing_injector
	cost = 25
	species = list("Plasmaman")
	surplus = 0

//Human
/datum/uplink_item/species_restricted/holo_cigar
	name = "Holo-Cigar"
	desc = "Голо-сигара, привезённая из Солнечной системы. Полный список эффектов от её крутого вида пока не обнаружили, но пользователи показывают повышенную точность при стрельбе с двух рук."
	reference = "SHC"
	item = /obj/item/clothing/mask/holo_cigar
	cost = 10
	species = list("Human")

//Gr(e)(a)y
/datum/uplink_item/species_restricted/prescan
	name = "Technocracy Advanced Cloning System"
	desc = "Этот набор даст вам запчасти для строительства продвинутой системы клонирования. Которая клонирует любого у кого есть установленный имплант, привязанный к машине продвинутого клонирования, после смерти. \
	Но эта процедура энергоёмка. Также после клонирования имплант должен быть возвращён для повторного использования и привязан к продвинутой системе клонирования."
	reference = "TACS"
	item = /obj/item/storage/box/syndie_kit/prescan
	cost = 25 /// A fresh start, but a start with nothing. Hard to use as well
	species = list("Grey")

// -------------------------------------
// ITEMS BLACKLISTED FROM NUCLEAR AGENTS
// -------------------------------------

/datum/uplink_item/dangerous/crossbow
	name = "Energy Crossbow"
	desc = "Миниатюрный энергетический арбалет, он достаточно мал для того чтобы поместиться в карман или незаметно для окружающих проскользнуть в рюкзак. Стреляет болтами, покрытыми токсином. Эта токсичная субстанция является продуктом деятельности живого организма. Опрокидывает врагов на пол на короткий период времени. Перезаряжается автоматически."
	reference = "EC"
	item = /obj/item/gun/energy/kinetic_accelerator/crossbow
	cost = 60
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
	surplus = 50

/datum/uplink_item/dangerous/guardian
	name = "Holoparasites"
	reference = "HPA"
	desc = "Голопаразиты и способны на фантастические подвиги лишь только с помощью голограм и наномашин, они всё также нуждаются в органическом носителе в качестве дома и источника питания. \
			Голопаразиты не способны включить себя в телах генокрадов и вампиров."
	item = /obj/item/storage/box/syndie_kit/guardian
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
	cost = 60
	refund_path = /obj/item/guardiancreator/tech/choose
	refundable = TRUE
	surplus = 0 // This being refundable makes this a big no no in my mind.
	cant_discount = TRUE

/datum/uplink_item/stealthy_weapons/martialarts
	name = "Martial Arts Scroll"
	desc = "Этот свиток содержит секреты техники древнего боевого исскуства. Вы сможете стать мастером безоружного боя, \
			сможете отражать пули из огнестрельного оружия, когда вы в защитной стойке (режиме броска). Также, изучив это исскуство, вы больше не сможете использовать бесчестное оружие дальнего боя. \
			Не может быть изучено вампирами и генокрадами агентами."
	reference = "SCS"
	item = /obj/item/sleeping_carp_scroll
	cost = 65
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
	cant_discount = TRUE

/datum/uplink_item/stealthy_weapons/bearserk
	name = "Bearserker Pelt"
	desc = "Шкура медведя вселяет в носителя души медведей и знания окультного боевого исскуства также известного как Ярость космического медведя. \
			Сама по себе шкура бронирована, давая носителю хорошую живучесть. \
			Созданная с любовью, множество душ и множество духов другого типа души Кооперированного культа Синдиката, Сыновей Большой Медведицы."
	reference = "BSP"
	item = /obj/item/clothing/head/bearpelt/bearserk
	cost = 60
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/stealthy_tools/traitor_belt
	name = "Traitor's Toolbelt"
	desc = "A robust seven-slot belt made for carrying a broad variety of weapons, ammunition and explosives. It's modelled after the standard NT toolbelt so as to avoid suspicion while wearing it."
	reference = "SBM"
	item = /obj/item/storage/belt/military/traitor
	cost = 10
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/stealthy_tools/frame
	name = "F.R.A.M.E. PDA Cartridge"
	desc = "When inserted into a personal digital assistant, this cartridge gives you five PDA viruses which \
			when used cause the targeted PDA to become a new uplink with zero TCs, and immediately become unlocked.  \
			You will receive the unlock code upon activating the virus, and the new uplink may be charged with \
			telecrystals normally."
	reference = "FRAME"
	item = /obj/item/cartridge/frame
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
	cost = 20

/datum/uplink_item/stealthy_tools/voice_modulator
	name = "Chameleon Voice Modulator Mask"
	desc = "A syndicate tactical mask equipped with chameleon technology and a sound modulator for disguising your voice. \
			While the mask is active, your voice will sound unrecognizable to others."
	reference = "CVMM"
	item = /obj/item/clothing/mask/gas/voice_modulator/chameleon
	cost = 8
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/stealthy_tools/silicon_cham_suit
	name = "\"Big Brother\" Obfuscation Suit"
	desc = "A syndicate tactical suit equipped with the latest in anti-silicon technology and, allegedly, biological technology learned from the Changeling Hivemind. \
			While this suit is worn, you will be unable to be tracked or seen by on-Station AI."
	reference = "BBOS"
	item = /obj/item/clothing/under/syndicate/silicon_cham
	cost = 20
	excludefrom = list(UPLINK_TYPE_NUCLEAR)

/datum/uplink_item/stealthy_weapons/sleepy_pen
	name = "Sleepy Pen"
	desc = "A syringe disguised as a functional pen. It's filled with a potent anaesthetic. \ The pen holds two doses of the mixture. The pen can be refilled."
	reference = "SP"
	item = /obj/item/pen/sleepy
	cost = 40
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/stealthy_weapons/dart_pistol
	name = "Dart Pistol Kit"
	desc = "A miniaturized version of a normal syringe gun. It is very quiet when fired and can fit into any space a small item can. Comes with 3 syringes: a knockout poison, a silencing agent and a deadly neurotoxin."
	reference = "DART"
	item = /obj/item/storage/box/syndie_kit/dart_gun
	cost = 20
	surplus = 50
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/// Nukies get combat gloves plus instead
/datum/uplink_item/stealthy_weapons/combat_minus
	name = "Experimental Krav Gloves"
	desc = "Experimental gloves with installed nanochips that teach you Krav Maga when worn, great as a cheap backup weapon. Warning, the nanochips will override any other fighting styles such as CQC. Do not look as fly as the Warden's"
	reference = "CGM"
	item = /obj/item/clothing/gloves/color/black/krav_maga
	cost = 50
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/// Nukies get Diamond Tipped Thermal Safe Drill instead
/datum/uplink_item/device_tools/thermal_drill
	name = "Amplifying Thermal Safe Drill"
	desc = "A tungsten carbide thermal drill with magnetic clamps for the purpose of drilling hardened objects. Comes with built in security detection and nanite system, to keep you up if security comes a-knocking."
	reference = "DRL"
	item = /obj/item/thermal_drill/syndicate
	cost = 5
	surplus = 0 // I feel like its amazing for one objective and one objective only. Far too specific.
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/suits/modsuit
	name = "Syndicate MODsuit"
	desc = "The feared MODsuit of a syndicate nuclear agent. Features armor and a eva mode \
			for faster movement on station. Toggling the suit in and out of \
			combat mode will allow you all the mobility of a loose fitting uniform without sacrificing armoring. \
			Comes containing internals. \
			Nanotrasen crew who spot these suits are known to panic."
	reference = "BRHS"
	item = /obj/item/mod/control/pre_equipped/traitor
	cost = 30
	surplus = 60 //I have upped the chance of modsuits from 40, as I do feel they are much more worthwhile with the base modsuit no longer being 8 tc, and the high armor values of the elite.
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/suits/modsuit_elite
	name = "Syndicate Elite MODsuit"
	desc = "An advanced MODsuit with superior armor to the standard Syndicate MODsuit. \
	Nanotrasen crew who spot these suits are known to *really* panic."
	reference = "MSE"
	item = /obj/item/mod/control/pre_equipped/traitor_elite
	cost = 45 //45 to start, no holopara / ebow.
	surplus = 60
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/// Nukies get Nuclear Uplink Bio-chip instead
/datum/uplink_item/bio_chips/uplink
	name = "Uplink Bio-chip"
	desc = "A bio-chip injected into the body, and later activated manually to open an uplink with 50 telecrystals. The ability for an agent to open an uplink after their possessions have been stripped from them makes this implant excellent for escaping confinement."
	reference = "UI"
	item = /obj/item/bio_chip_implanter/uplink
	cost = 70
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
	surplus = 0
	cant_discount = TRUE

/datum/uplink_item/cyber_implants/sensory_enhancer
	name = "Qani-Laaca Sensory Computer Autoimplanter"
	desc = "Epilepsy Warning: Drug has vibrant visual effects! \
	This spinal implant will inject mephedrone into your system, a powerful stimulant that causes slight heart damage.\
	This stimulant will provide faster movement speed, slight pain resistance, immunity to crawling slowdown, and faster attack speed, though no antistun.\
	Overdosing will cause massive heart damage, but will allow the user to dodge bullets for a minute and attack even faster.\
	Two minute normal uptime, 5 minute cooldown, unlimited uses. Incompatible with the Binyat Wireless Hacking System."
	reference = "QLSC"
	item = /obj/item/autosurgeon/organ/syndicate/sensory_enhancer
	cost = 40
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST) //No, nukies do not get to dodge bullets.

/datum/uplink_item/badass/syndiecards
	name = "Syndicate Playing Cards"
	desc = "A special deck of space-grade playing cards with a mono-molecular edge and metal reinforcement, making them lethal weapons both when wielded as a blade and when thrown. \
	You can also play card games with them."
	reference = "SPC"
	item = /obj/item/deck/cards/syndicate
	cost = 2
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
	surplus = 40

/datum/uplink_item/badass/plasticbag
	name = "Plastic Bag"
	desc = "A simple, plastic bag. Keep out of reach of small children, do not apply to head."
	reference = "PBAG"
	item = /obj/item/storage/bag/plasticbag
	cost = 1
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/bundles_TC/contractor
	name = "Syndicate Contractor Kit"
	desc = "A bundle granting you the privilege of taking on kidnapping contracts for credit and TC payouts that can add up to more than its initial cost."
	reference = "SCOK"
	cost = 100
	item = /obj/item/storage/box/syndie_kit/contractor
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/bundles_TC/contractor/spawn_item(turf/loc, obj/item/uplink/U)
	var/datum/mind/mind = usr.mind
	var/datum/antagonist/traitor/AT = mind.has_antag_datum(/datum/antagonist/traitor)
	if(LAZYACCESS(GLOB.contractors, mind))
		to_chat(usr, "<span class='warning'>Error: Contractor credentials detected for the current user. Unable to provide another Contractor kit.</span>")
		return
	else if(!AT)
		to_chat(usr, "<span class='warning'>Error: Embedded Syndicate credentials not found.</span>")
		return
	else if(ischangeling(usr) || mind.has_antag_datum(/datum/antagonist/vampire))
		to_chat(usr, "<span class='warning'>Error: Embedded Syndicate credentials contain an abnormal signature. Aborting.</span>")
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

/datum/uplink_item/bundles_TC/badass
	name = "Syndicate Bundle"
	desc = "Syndicate Bundles are specialised groups of items that arrive in a plain box. These items are collectively worth more than 100 telecrystals. You can select one out of three specialisations after purchase."
	reference = "SYB"
	item = /obj/item/radio/beacon/syndicate/bundle
	cost = 100
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/bundles_TC/surplus_crate
	name = "Syndicate Surplus Crate"
	desc = "A crate containing 250 telecrystals worth of random syndicate leftovers."
	reference = "SYSC"
	cost = 100
	item = /obj/item/storage/box/syndie_kit/bundle
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
	var/crate_value = 250
	uses_special_spawn = TRUE

/datum/uplink_item/bundles_TC/surplus_crate/spawn_item(turf/loc, obj/item/uplink/U)
	if(..() != UPLINK_SPECIAL_SPAWNING)
		return FALSE

	new /obj/structure/closet/crate/surplus(loc, U, crate_value, cost)

// -----------------------------------
// PRICES OVERRIDEN FOR NUCLEAR AGENTS
// -----------------------------------

/datum/uplink_item/stealthy_weapons/cqc
	name = "CQC Manual"
	desc = "A manual that teaches a single user tactical Close-Quarters Combat before self-destructing. \
			Changes your unarmed damage to deal non-lethal stamina damage. \
			Does not restrict weapon usage, and can be used alongside Gloves of the North Star."
	reference = "CQC"
	item = /obj/item/CQC_manual
	cost = 50
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/explosives/syndicate_bomb
	name = "Syndicate Bomb"
	desc = "The Syndicate Bomb has an adjustable timer with a minimum setting of 90 seconds. Ordering the bomb sends you a small beacon, which will teleport the explosive to your location when you activate it. \
	You can wrench the bomb down to prevent removal. The crew may attempt to defuse the bomb."
	reference = "SB"
	item = /obj/item/radio/beacon/syndicate/bomb
	cost = 40
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
	surplus = 0
	cant_discount = TRUE
	hijack_only = TRUE

/datum/uplink_item/explosives/emp_bomb
	name = "EMP bomb"
	desc = "The EMP has an adjustable timer with a minimum setting of 90 seconds. Ordering the bomb sends you a small beacon, which will teleport the explosive to your location when you activate it. \
	You can wrench the bomb down to prevent removal. The crew may attempt to defuse the bomb. Will pulse 3 times."
	reference = "SBEMP"
	item = /obj/item/radio/beacon/syndicate/bomb/emp
	cost = 40
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
	surplus = 0
	cant_discount = TRUE

/datum/uplink_item/explosives/emp_bomb/New()
	..()
	if(HAS_TRAIT(SSstation, STATION_TRAIT_CYBERNETIC_REVOLUTION))
		cost *= 1.25 //ok this thing is already very expencive it doesnt need much more

/datum/uplink_item/explosives/atmosfiregrenades
	name = "Plasma Fire Grenades"
	desc = "A box of two (2) grenades that cause large plasma fires. Can be used to deny access to a large area. Most useful if you have an atmospherics hardsuit."
	reference = "APG"
	item = /obj/item/storage/box/syndie_kit/atmosfiregrenades
	hijack_only = TRUE
	cost = 50
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
	surplus = 0
	cant_discount = TRUE

/datum/uplink_item/stealthy_tools/chameleon
	name = "Chameleon Kit"
	desc = "A set of items that contain chameleon technology allowing you to disguise as pretty much anything on the station, and more! \
			Due to budget cuts, the shoes don't provide protection against slipping. The set comes with a complementary chameleon stamp."
	reference = "CHAM"
	item = /obj/item/storage/box/syndie_kit/chameleon
	cost = 20
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/stealthy_tools/syndigaloshes
	name = "No-Slip Chameleon Shoes"
	desc = "These shoes will allow the wearer to run on wet floors and slippery objects without falling down. \
			They do not work on heavily lubricated surfaces."
	reference = "NSSS"
	item = /obj/item/clothing/shoes/chameleon/noslip
	cost = 10
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/explosives/detomatix
	name = "Detomatix PDA Cartridge"
	desc = "When inserted into a personal digital assistant, this cartridge gives you five opportunities to detonate PDAs of crewmembers who have their message feature enabled. The concussive effect from the explosion will knock the recipient out for a short period, and deafen them for longer."
	reference = "DEPC"
	item = /obj/item/cartridge/syndicate
	cost = 30
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
