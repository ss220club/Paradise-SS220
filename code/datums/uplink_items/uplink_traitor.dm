// TRAITOR ONLY GEAR

// JOB SPECIFIC GEAR

/datum/uplink_item/jobspecific
	category = "Снаряжение, уникальное для должности"
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST) // Stops the job specific category appearing for nukies

//Clown
/datum/uplink_item/jobspecific/clowngrenade
	name = "Banana Grenade"
	desc = "Граната, что взрывается брендовыми ХОНК! кожурками от бананов, генетически модифицированных, чтобы быть очень скользкими и выделять едкую кислоту, когда на них наступают."
	reference = "BG"
	item = /obj/item/grenade/clown_grenade
	cost = 15
	job = list("Clown")

/datum/uplink_item/jobspecific/clownslippers
	name = "Clown Acrobatic Shoes"
	desc = "Модифицированные клоунские ботинки, оснащённые встроенной пропульсионной системой, что позволяет пользователю короткие подкаты под кем угодно. Включение амортизаторов убирает замедление от ботинок."
	reference = "CAS"
	item = /obj/item/clothing/shoes/clown_shoes/slippers
	cost = 15
	surplus = 75
	job = list("Clown")

/datum/uplink_item/jobspecific/cmag
	name = "Jestographic Sequencer"
	desc = "Шутографический сиквенсер, также известный как клоунский емаг. Это маленькая карта, которая инвертирует доступ на любой двери, где была использована. Идеально подходит для блокировки отделов от командования. Хонк!"
	reference = "CMG"
	item = /obj/item/card/cmag
	cost = 20
	surplus = 75
	job = list("Clown")

/datum/uplink_item/jobspecific/trick_revolver
	name = "Trick Revolver"
	desc = "Револьвер, который стреляет в обратную сторону и убьёт любого, кто попытается им воспользоваться. Идеален для линчевателей или просто для хорошей шутки."
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
	desc = "Специализированный однозарядный дробовик с установленной маскировочной системой для мимикрирования под трость. Дробовик способен скрыть свой спусковой крючок вместе с глушителем. Поставляется в коробке вместе с 6 специализированными снарядами шрапнели, покрытыми токсином немоты и одним снарядом уже заряженным в дробовик."
	reference = "MCS"
	item = /obj/item/storage/box/syndie_kit/caneshotgun
	cost = 40
	job = list("Mime")

/datum/uplink_item/jobspecific/mimery
	name = "Guide to Advanced Mimery Series"
	desc = "Содержит два мануала для изучения продвинутых пантомим. Вы сможете стрелять беcшумными пулями из пальца и создавать большие невидимые стены, что могут заблокировать целый коридор."
	reference = "AM"
	item = /obj/item/storage/box/syndie_kit/mimery
	cost = 50
	job = list("Mime")
	surplus = 0 // I feel this just isn't healthy to be in these crates.

/datum/uplink_item/jobspecific/combat_baking
	name = "Combat Bakery Kit"
	desc = "Набор нелегального запечённого оружия. Содержит багет, который опытный мим может использовать как меч, \
		пару метательных круассанов и рецепт, чтобы создать больше оружия при необходимости. Когда работа будет выполнена, съешьте улики."
	reference = "CBK"
	item = /obj/item/storage/box/syndie_kit/combat_baking
	cost = 25 //A chef can get a knife that sharp easily, though it won't block. While you can get endless boomerang, they are less deadly than a stech, and slower / more predictable.
	job = list("Mime", "Chef")

// Shaft miner
/datum/uplink_item/jobspecific/pressure_mod
	name = "Kinetic Accelerator Pressure Mod"
	desc = "Набор модификации, что позволяет Кинетеческому Акселератору наносить серьёзный урон в условиях нормального давления. Занимает 35% места для модификаций."
	reference = "KPM"
	item = /obj/item/borg/upgrade/modkit/indoors
	cost = 25 //you need two for full damage, so total of 50 for maximum damage
	job = list("Shaft Miner", "Explorer")
	surplus = 0 // Requires a KA to even be used.

/datum/uplink_item/jobspecific/mining_charge_hacker
	name = "Mining Charge Hacker"
	desc = "Looks and functions like an advanced mining scanner, but allows mining charges to be placed anywhere and destroy more than rocks. \
	Use it on a mining charge to override its safeties. Reduces explosive power of mining charges due to the modification of their internals."
	reference = "MCH"
	item = /obj/item/t_scanner/adv_mining_scanner/syndicate
	cost = 25
	job = list("Shaft Miner")

//Chef
/datum/uplink_item/jobspecific/specialsauce
	name = "Chef Excellence's Special Sauce"
	desc = "Особый соус, сделанный из крайне ядовитых мухоморов. Любой, кто его попробует, получит различную степень отравления, которая варьируется от того, насколько долго он находился в организме. Чем больше доза, тем дольше метаболизм."
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
	desc = "Коробка, содержащая в себе посох миссионера, робы миссионера и библию. Робы и посох могут быть связаны и позволят конвертировать жертв на расстоянии на короткое время для исполнения вашей воли. Библия нужна для библейских дел."
	reference = "MK"
	item = /obj/item/storage/box/syndie_kit/missionary_set
	cost = 75
	job = list("Chaplain")
	surplus = 0 // Controversial maybe, but with the ease of mindslaving with this item I'd prefer it stay chaplain specific.

/datum/uplink_item/jobspecific/artistic_toolbox
	name = "His Grace"
	desc = "Невероятно опасное оружие, полученное со станции, уничтоженной набегом ассистентов. Когда Он активирован, Он будет жаждать крови и должен быть использован для убийства чтобы удовлетворить Его жажду. \
	Его Святейшество дарует постепенную регенерацию и полный иммунитет к станам для своего владельца, но будьте осторожны: если Он станет очень голоден, Его будет невозможно выбросить из рук и Он убьёт вас, если вы Его не покормите. \
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
	desc = "Противопехотная сенсорная мина, умно замаскированная под знак мокрого пола, которая может сдетонировать при прохождении по ней. Активируйте её, чтобы начать 15 секундный отсчёт, и активируйте ещё, чтобы обезвредить её."
	reference = "PM"
	item = /obj/item/caution/proximity_sign
	cost = 10
	job = list("Janitor")

/datum/uplink_item/jobspecific/titaniumbroom
	name = "Titanium Push Broom"
	desc = "Метла с усиленной рукояткой и щёткой из металлической проволоки, идеальна для создания самому себе большей работы избиванием ассистентов. \
	Когда находится в двух руках, вы будете отражать снаряды, а избивание людей будет иметь разные эффекты в зависимости от вашего интента."
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
	desc = "Пара гладких перчаток для помощи в кражах. При их ношении, вы сможете обворовать свою цель, не давая ей узнать об этом. Кража с этими перчатками переместит предмет вам прямо в руку."
	reference = "PPG"
	item = /obj/item/clothing/gloves/color/black/thief
	cost = 30
	job = list("Assistant")

//Bartender

/datum/uplink_item/jobspecific/drunkbullets
	name = "Boozey Shotgun Shells"
	desc = "Коробка, содержащая в себе 6 снарядов для дробовика, которые симулируют эффекты сильного опьянения на цели, наиболее эффективны при наличии любого типа алкоголя в крови цели."
	reference = "BSS"
	item = /obj/item/storage/box/syndie_kit/boolets
	cost = 10
	job = list("Bartender")

//Botanist
/datum/uplink_item/jobspecific/bee_briefcase
	name = "Briefcase Full of Bees"
	desc = "На первый взгляд безобидный чемодан, полный не таких уж и безобидных синди пчёл. Вколите в чемодан кровь, чтобы натренировать пчёл игнорировать доноров. ПРЕДУПРЕЖДЕНИЕ: экзотические типы крови, как слаймовое желе, не будут работать. Чемодан также внедряется в систему интеркомов на станции, чтобы транслировать сообщения ТЕРРОРА."
	reference = "BEE"
	item = /obj/item/bee_briefcase
	cost = 50
	job = list("Botanist")

//Engineer

/datum/uplink_item/jobspecific/powergloves
	name = "Power Bio-Chip"
	desc = "Био-чип, что может использовать электричество станции для доставки коротких электрических дуг к цели. \
			Для использования необходимо стоять на запитанной проводке. \
			Может быть активирован при помощи alt+click или при нажатии средней кнопки мыши. Интент обезоруживания будет наносить стамина урон и вызывать тряску, в то время как интент вреда будет наносить урон, основанный на мощности тока в проводах, на которых вы стоите. Может быть включен / отключен при помощи кнопки."
	reference = "PG"
	item = /obj/item/bio_chip_implanter/shock
	cost = 50
	job = list("Station Engineer", "Chief Engineer")

//RD

/datum/uplink_item/jobspecific/telegun
	name = "Telegun"
	desc = "Очень высокотехнологичное энергетическое оружие, что использует блюспейс технологию для телепортации живых целей. Выберите маяк, куда телепортировать цели, на самом оружии. Снаряды телепортируют цели на выбранный маяк. Может отправлять цели только на невзломанные маяки в одном секторе с вами и на любой взломанный маяк!"
	reference = "TG"
	item = /obj/item/gun/energy/telegun
	cost = 50
	job = list("Research Director")

//Roboticist
/datum/uplink_item/jobspecific/syndiemmi
	name = "Syndicate MMI"
	desc = "Разработанный Синдикатом нейро-компьютерный интерфейс, который поработит любой мозг, помещённый в него, тех пор, пока тот находится внутри. Киборги, созданные при помощи этого интерфейса, будут перманентно порабощены вашей воле, а в остальном будут функционировать нормально."
	reference = "SMMI"
	item = /obj/item/mmi/syndie
	cost = 10
	job = list("Roboticist")
	surplus = 0


//Librarian
/datum/uplink_item/jobspecific/etwenty
	name = "The E20"
	desc = "На первый взгляд безобидная кость, но те, кто не побоится её бросить для атаки, найдут её эффекты довольно взрывными. Имеет 4 секундный таймер."
	reference = "ETW"
	item = /obj/item/dice/d20/e20
	cost = 15
	job = list("Librarian")
	surplus = 0

//Botanist
/datum/uplink_item/jobspecific/ambrosiacruciatus
	name = "Ambrosia Cruciatus Seeds"
	desc = "Часть пресловутой семьи Амброзии. Эта разновидность практически неотличима от Амброзии Вульгарис, но её ветки содержат отвратительнейший токсин. 8 юнитов уже достаточно, чтобы свести жертву с ума."
	reference = "BRO"
	item = /obj/item/seeds/ambrosia/cruciatus
	cost = 5
	job = list("Botanist")
	surplus = 0 // Even botanists would struggle to use this effectively, nevermind a coroner.

//Atmos Tech
/datum/uplink_item/jobspecific/contortionist
	name = "Contortionist's Jumpsuit"
	desc = "Крайне гибкий костюм, что поможет передвигаться по вентиляционным трубам по всей станции. Поставляется вместе с карманами и слотом для ID карты, но не может быть использован без снятия практически всех вещей, включая рюкзак, пояс, шлем и броню. Свободные руки также необходимы для того, чтобы залезть внутрь вентиляции."
	reference = "AIRJ"
	item = /obj/item/clothing/under/rank/engineering/atmospheric_technician/contortionist
	cost = 30
	job = list("Life Support Specialist")

/datum/uplink_item/jobspecific/energizedfireaxe
	name = "Energized Fire Axe"
	desc = "Пожарный топор со встроенным массивным энергетическим зарядом. При ударе кого-либо при наличии заряда будет отбрасывать цель назад, ненадолго оглушая, но требует некоторого времени для перезарядки. Также он намного острее, чем обычный топор, и может пробивать лёгкую броню."
	reference = "EFA"
	item = /obj/item/fireaxe/energized
	cost = 40
	job = list("Life Support Specialist")

//Stimulants

/datum/uplink_item/jobspecific/stims
	name = "Stimulants"
	desc = "Очень нелегальное соединение, содержащееся в компактном авто-инжекторе. Когда вколот, делает пользователя невосприимчивым к оглушению и многократно повышает способность тела к регенерации."
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
	desc = "Передовая технология смертоносной канцелярии. Этот гаджет будет пропитывать любой кусок бумаги разнообразными ядами, основанных на выбранном цвете чернил. Чёрные - нормальные чернила. Красные чернила - чернила с очень летальным ядом. Зелёные чернила вызывают радиационное облучение. Синие будут периодически бить жертву током. Жёлтые будут парализовать. Поставляющиеся в комплекте перчатки защитят вас от собственных ядов."
	reference = "PP"
	item = /obj/item/storage/box/syndie_kit/poisoner
	cost = 10
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
	job = list("Head of Personnel", "Quartermaster", "Cargo Technician", "Librarian", "Coroner", "Psychiatrist", "Virologist")

// Tarot card generator, librarian and Chaplain.

/datum/uplink_item/jobspecific/tarot_generator
	name = "Enchanted Tarot Card Deck"
	desc = "Колода магических карт Таро, \"позаимствованные\" из хранилища Федерации Магов. \
	Может произвести любую из 22 карт главных аркан, а также их обратные версии. У каждой карты свой эффект. \
	Киньте карту Таро в кого-нибудь для применении к цели или используйте в руке для применения на себе. Бесконечное количество использований, перезарядка 25 секунд, можно иметь до трёх карт в мире."
	reference = "tarot"
	item = /obj/item/tarot_generator
	cost = 55 //This can do a lot of stuff, but is quite random. As such, higher price.
	job = list("Chaplain", "Librarian")

//--------------------------//
// Species Restricted Gear //
//-------------------------//

/datum/uplink_item/species_restricted
	category = "Снаряжение, уникольное для расы"
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
	desc = "Энергетическое оружие, что запускает высокоскоростные плазменные шипы. Эти шипы попадают с силой достаточной, чтобы сбить цель с ног и оставить серьёзную рану."
	reference = "STG"
	item = /obj/item/gun/energy/spikethrower
	cost = 50
	species = list("Vox")
	surplus = 0

//IPC:
//Positonic supercharge implant: stims, 3 uses, IPC adrenals
/datum/uplink_item/species_restricted/supercharge_implant
	name = "Synthetic Supercharge Bio-chip"
	desc = "Био-чип, который можно вколоть в тело, и позже, будучи активированным, он введёт коктейль из химикатов, который снимает оглушения, снижает их время и увеличивает скорость передвижения. Может быть активирован до 3 раз."
	reference = "SSI"
	item = /obj/item/bio_chip_implanter/supercharge
	cost = 40
	species = list("Machine")
	surplus = 0


//plasmeme
/datum/uplink_item/species_restricted/fireproofing_nanites
	name = "Fireproofing Nanite Injector"
	desc = "Рой наномашин, которые поглощают излишнее тепло, позволяя пользователю становиться огнеупорным."
	reference = "FPN"
	item = /obj/item/fireproofing_injector
	cost = 25
	species = list("Plasmaman")
	surplus = 0

//Human
/datum/uplink_item/species_restricted/holo_cigar
	name = "Holo-Cigar"
	desc = "Голо-сигара, привезённая из системы Сол. Полный эффект от её крутого вида пока непонятен, но пользователи показывают повышенную точность при стрельбе с двух рук."
	reference = "SHC"
	item = /obj/item/clothing/mask/holo_cigar
	cost = 10
	species = list("Human")

//Gr(e)(a)y
/datum/uplink_item/species_restricted/prescan
	name = "Technocracy Advanced Cloning System"
	desc = "Этот набор даст вам запчасти для строительства продвинутой системы автоматического клонирования, которая после смерти клонирует любого, у кого есть установленный имплант, привязанный к машине продвинутого клонирования, после смерти. \
	Но эта процедура энергоёмка. Также после клонирования имплант должен быть возвращён для повторного использования и привязан к продвинутой системе клонирования."
	reference = "TACS"
	item = /obj/item/storage/box/syndie_kit/prescan
	cost = 25 /// A fresh start, but a start with nothing. Hard to use as well
	species = list("Grey")

// Drask
/datum/uplink_item/species_restricted/cryoregenerative_enhancer
	name = "Cryoregenerative Enhancer"
	desc = "Специально разработанные наномашины, увеличивающие регенеративные способности драсков при низкой температуре. Требуется очень холодный воздух в атмосфере или в баллоне для работы."
	reference = "CRE"
	item = /obj/item/cryoregenerative_enhancer
	cost = 25
	species = list("Drask")
	surplus = 0

// Unathi
/datum/uplink_item/species_restricted/breach_cleaver
	name = "Breach Cleaver"
	desc = "Этот массивный клинок напоминает о войнах на Могесе. Владение им наделяет вас неугасимым стремлением к воинскому мастерству. \
	Требует две руки для использования. Покупается с ножнами. Имеет разные эффекты в зависимости от интента."
	reference = "CLV"
	item = /obj/item/storage/belt/sheath/breach_cleaver
	cost = 65 // Incredibly strong melee weapon on par with a chainsaw.
	species = list("Unathi")

// -------------------------------------
// ITEMS BLACKLISTED FROM NUCLEAR AGENTS
// -------------------------------------

/datum/uplink_item/dangerous/crossbow
	name = "Energy Crossbow"
	desc = "Миниатюрный энергетический арбалет, он достаточно мал для того, чтобы поместиться в карман или незаметно для окружающих проскользнуть в рюкзак. Стреляет болтами, покрытыми токсином. Эта токсичная субстанция является продуктом деятельности живого организма. Сбивает врагов с ног на короткий период времени. Перезаряжается автоматически."
	reference = "EC"
	item = /obj/item/gun/energy/kinetic_accelerator/crossbow
	cost = 60
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
	surplus = 50

/datum/uplink_item/dangerous/guardian
	name = "Holoparasites"
	reference = "HPA"
	desc = "Хотя голопаразиты и способны на фантастические подвиги лишь только с помощью голограмм и наномашин, они всё также нуждаются в органическом носителе в качестве дома и источника питания. \
			Голопаразиты не способны включить себя в тела генокрадов и вампиров."
	item = /obj/item/storage/box/syndie_kit/guardian/uplink
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
	cost = 60
	refund_path = /obj/item/guardiancreator/tech/choose
	refundable = TRUE
	surplus = 0 // This being refundable makes this a big no no in my mind.
	uses_special_spawn = TRUE

/datum/uplink_item/dangerous/guardian/spawn_item(turf/loc, obj/item/uplink/U)
	if(..() != UPLINK_SPECIAL_SPAWNING)
		return FALSE

	new /obj/item/storage/box/syndie_kit/guardian/uplink(loc, cost)

/datum/uplink_item/stealthy_weapons/martialarts
	name = "Martial Arts Scroll"
	desc = "Этот свиток содержит секреты техники древнего боевого искусства. Вы станете мастером безоружного боя, \
			отражая снаряды, когда вы в защитной стойке (режим броска). Также, изучив это искусство, вы откажетесь впредь использовать бесчестное оружие дальнего боя. \
			Не может быть изучено вампирами и генокрадами агентами."
	reference = "SCS"
	item = /obj/item/sleeping_carp_scroll
	cost = 65
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
	can_discount = FALSE

/datum/uplink_item/stealthy_weapons/bearserk
	name = "Bearserker Pelt"
	desc = "Шкура медведя вселяет в носителя духов медведей и знания оккультного боевого исскусства также известного, как Ярость Космического Медведя. \
			Сама по себе шкура бронирована, давая носителю хорошую живучесть. \
			Сделано с любовью, множеством духов и белой горячкой Детьми Большой Медведицы - аффилированный с Синдикатом культ."
	reference = "BSP"
	item = /obj/item/clothing/head/bearpelt/bearserk
	cost = 60
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/stealthy_tools/traitor_belt
	name = "Traitor's Toolbelt"
	desc = "Робастный пояс на семь слотов для хранения различного оружия, амуниции и взрывчатки. Он создан на основе стандартного пояса НТ, поэтому он совершенно скрытный для ношения."
	reference = "SBM"
	item = /obj/item/storage/belt/military/traitor
	cost = 10
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/stealthy_tools/frame
	name = "F.R.A.M.E. PDA Cartridge"
	desc = "Когда вставлен в ПДА, этот картридж даст вам возможность закинуть вирус на любой ПДА. \
			Который при использовании на ПДА откроет новый аплинк без телекристаллов и не даст его заблокировать. \
			Вы получите код для разблокировки после использования вируса и новый аплинк может быть пополнен новыми телекристаллами."
	reference = "FRAME"
	item = /obj/item/cartridge/frame
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
	cost = 20

/datum/uplink_item/stealthy_tools/voice_modulator
	name = "Chameleon Voice Modulator Mask"
	desc = "Тактическая маска синдиката, экипированная хамелеон технологией и модулятором голоса для его маскировки. \
			Когда маска активирована, ваш голос не смогут распознать окружающие."
	reference = "CVMM"
	item = /obj/item/clothing/mask/gas/voice_modulator/chameleon
	cost = 5
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/stealthy_tools/voice_changer
	name = "Chameleon Voice Changer Mask"
	desc = "Противогаз Синдиката с технологией Хамелеон и модулятором голоса для маскировки Вашего голоса. \
			Используйте его для выдачи себя за другого или спрятать свою личность при разговорах и обведите всех вокруг пальца!"
	reference = "CVCM"
	item = /obj/item/clothing/mask/chameleon/voice_change
	cost = 10
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/stealthy_tools/silicon_cham_suit
	name = "\"Big Brother\" Obfuscation Suit"
	desc = "Тактический комбинезон синдиката, экипированный новешей анти-синтетической технологией и якобы технологией, которая была взята с коллективного разума генокрадов. \
			Пока костюм надет вас не смогут отследить или увидеть любые станционные ИИ."
	reference = "BBOS"
	item = /obj/item/clothing/under/syndicate/silicon_cham
	cost = 20
	excludefrom = list(UPLINK_TYPE_NUCLEAR)

/datum/uplink_item/stealthy_weapons/sleepy_pen
	name = "Sleepy Pen"
	desc = "Шприц, замаскированный под ручку. Он заполнен сильным анестетиком. \ В ручке содержится две дозы вещества. \
		Не может быть восполнена."
	reference = "SP"
	item = /obj/item/pen/sleepy
	cost = 40
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/stealthy_weapons/dart_pistol
	name = "Dart Pistol Kit"
	desc = "Миниатюрная версия шприцемёта. Имеет очень тихий звук стрельбы и может помещаться в карманы. Поставляется вместе с тремя шприцами: ошеломляющим токсином, токсином немоты и смертельным нейротоксином."
	reference = "DART"
	item = /obj/item/storage/box/syndie_kit/dart_gun
	cost = 20
	surplus = 50
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/// Nukies get combat gloves plus instead
/datum/uplink_item/stealthy_weapons/combat_minus
	name = "Experimental Krav Gloves"
	desc = "Экспериментальные перчатки с установленными наночипами, которые мнгновенно дают знания боевого искусства Крав Мага носителю. Идеальны в качестве запасного оружия. Осторожно, наночипы перезапишут любые другие боевые искусства. Перчатки не выглядят также привлекательно как те, что у вардена."
	reference = "CGM"
	item = /obj/item/clothing/gloves/color/black/krav_maga
	cost = 50
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/device_tools/hyper_medipen
	name = "Hyper-regenerative Medipen"
	desc = "An autoinjector filled with a variety of medical chemicals. It rapidly heals conventional injuries and genetic damage, but loses potency just as quickly. May have side effects if multiple are used in quick succession."
	reference = "HMP"
	item = /obj/item/reagent_containers/hypospray/autoinjector/hyper_medipen
	cost = 10
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/// Nukies get Diamond Tipped Thermal Safe Drill instead
/datum/uplink_item/device_tools/thermal_drill
	name = "Amplifying Thermal Safe Drill"
	desc = "Покрытая карбидом вольфрама термальная дрель с магнитыми зажимами для сверления твёрдых объектов. Поставляется вместе с детектором безопасности и системой нанитов для поддержки вашего состояния когда служба безопасности постучится к вам."
	reference = "DRL"
	item = /obj/item/thermal_drill/syndicate
	cost = 5
	surplus = 0 // I feel like its amazing for one objective and one objective only. Far too specific.
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/suits/modsuit
	name = "Syndicate MODsuit"
	desc = "Устрашающий МОДсьют ядерных оперативников Синдиката. Вмещает в себя режим скафандра и бронекостюма \
			для быстрого перемещения по станции. Включение и выключение боевого режима модсьюта \
			позволит вам иметь мобильность, не жервуя защищённостью. \
			Поставляется вместе с баллоном для дыхания. \
			Сотрудники Nanotrasen, что видят данный МОДсьют, погружаются в ужас."
	reference = "BRHS"
	item = /obj/item/mod/control/pre_equipped/traitor
	cost = 30
	surplus = 60 //I have upped the chance of modsuits from 40, as I do feel they are much more worthwhile with the base modsuit no longer being 8 tc, and the high armor values of the elite.
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/suits/modsuit_elite
	name = "Syndicate Elite MODsuit"
	desc = "Продвинутый МОДсьют с хорошей бронёй для стандартного МОДсьюта синдиката. \
	Сотрудники Nanotrasen, что видят данный модсьют, погружаются в *настоящий* ужас."
	reference = "MSE"
	item = /obj/item/mod/control/pre_equipped/traitor_elite
	cost = 45 //45 to start, no holopara / ebow.
	surplus = 60
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/// Nukies get Nuclear Uplink Bio-chip instead
/datum/uplink_item/bio_chips/uplink
	name = "Uplink Bio-chip"
	desc = "Био-чип, который можно вколоть в тело и позже самостоятельно активировать для открытия аплинка с 50 телекристаллами. Возможность открытия аплинка после того, как вещи агента забрали, делает этот имплант идеальным для побега из заключения."
	reference = "UI"
	item = /obj/item/bio_chip_implanter/uplink
	cost = 70
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
	surplus = 0
	can_discount = FALSE

/datum/uplink_item/cyber_implants/sensory_enhancer
	name = "Qani-Laaca Sensory Computer Autoimplanter"
	desc = "Предупреждение: Наркотик может вызвать приступ у эпилептиков! \
	Этот спинной имплант будет давать вам инъекции мефедрона прямо в кровь. Мефедрон - мощный стимулянт, что вызывает урон сердцу.\
	Этот стимулянт предоставит вам увеличенную скорость передвижения, небольшое притупление боли, увеличенную скорость ударов, иммунитет к замедлению при ползании и иммунитет к электрическим дубинкам и подобного рода оружию.\
	Передозировка вызовет массивный урон сердцу, но также позволит пользователю уклоняться от пуль на минуту и атаковать ещё быстрее.\
	Время работы составляет 2 минуты, время перезарядки составляет 5 минут, бесконечное количество использований. Несовместим вместе с Binyat Wireless Hacking System."
	reference = "QLSC"
	item = /obj/item/autosurgeon/organ/syndicate/oneuse/sensory_enhancer
	cost = 40
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST) //No, nukies do not get to dodge bullets.

/datum/uplink_item/badass/syndiecards
	name = "Syndicate Playing Cards"
	desc = "Специальная колода космических игральных карт с мономолекулярными краями и металлическими усилениями, делая их летальным оружием, когда находятся в двух руках и когда брошено. \
	Вы также можете играть ими в карточные игры."
	reference = "SPC"
	item = /obj/item/deck/cards/syndicate
	cost = 2
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
	surplus = 40

/datum/uplink_item/badass/plasticbag
	name = "Plastic Bag"
	desc = "Простой пластиковый мешок. Держите его подальше от детей, не надевайте его на голову."
	reference = "PBAG"
	item = /obj/item/storage/bag/plasticbag
	cost = 1
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/bundles_TC/contractor
	name = "Syndicate Contractor Kit"
	desc = "Комплект, дающий вам привелегию принимать контракты на похищение для получения кредитов и телекристаллов, что могут давать больше телекристаллов больше чем у вас было изначально."
	reference = "SCOK"
	cost = 100
	item = /obj/item/storage/box/syndie_kit/contractor
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/bundles_TC/contractor/spawn_item(turf/loc, obj/item/uplink/U)
	var/datum/mind/mind = usr.mind
	var/datum/antagonist/traitor/AT = mind.has_antag_datum(/datum/antagonist/traitor)
	if(LAZYACCESS(GLOB.contractors, mind))
		to_chat(usr, "<span class='warning'>Ошибка: Реквизиты контракника найдены для текущего пользователя. Невозможно предоставить ещё один набор контрактника.</span>")
		return
	else if(!AT)
		to_chat(usr, "<span class='warning'>Ошибка: Встроенные реквизиты Синдиката не найдены.</span>")
		return
	else if(IS_CHANGELING(usr) || mind.has_antag_datum(/datum/antagonist/vampire))
		to_chat(usr, "<span class='warning'>Ошибка: Встроенные реквизиты Синдиката содержат странную сигнатуру. Отмена.</span>")
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
	desc = "Наборы синдиката это специализированные группы предметов, что прибудут в коробке. В сумме эти предметы стоят более 100 телекристаллов. Вы сможете выбрать один из трёх наборов после покупки."
	reference = "SYB"
	item = /obj/item/beacon/syndicate/bundle
	cost = 100
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/bundles_TC/surplus_crate
	name = "Syndicate Surplus Crate"
	desc = "Ящик, содержащий в себе случайное снаряжение Синдиката общей стоимостью 250 телекристаллов."
	reference = "SYSC"
	cost = 100
	item = /obj/item/storage/box/syndie_kit/bundle
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
	var/crate_value = 250
	uses_special_spawn = TRUE

/datum/uplink_item/bundles_TC/surplus_crate/spawn_item(turf/loc, obj/item/uplink/U, mob/user)
	if(..() != UPLINK_SPECIAL_SPAWNING)
		return FALSE

	new /obj/structure/closet/crate/surplus(loc, U, crate_value, cost, user)

// -----------------------------------
// PRICES OVERRIDEN FOR NUCLEAR AGENTS
// -----------------------------------

/datum/uplink_item/stealthy_weapons/cqc
	name = "CQC Manual"
	desc = "Инструкция, которая может научить вас тактическому искусству ближнего боя перед самоуничтожением и может быть изучено только одним человеком. \
			Меняет ваш урон кулаков на нелетельный стамина урон. \
			Не запрещает вам использовать оружие дальнего боя и может быть использовано вместе с перчатками полярной звезды."
	reference = "CQC"
	item = /obj/item/CQC_manual
	cost = 50
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/explosives/syndicate_bomb
	name = "Syndicate Bomb"
	desc = "Бомба синдиката с настраиваемым таймером с минимальной настройкой в 90 секунд. Заказывая бомбу, вам будет выдан маленький маяк, который телепортирует бомбу на локацию маяка. \
	Вы можете прикрутить бомбу с помощью гаечного ключа чтобы избежать обезвреживания. Экипаж может попытаться разминировать бомбу."
	reference = "SB"
	item = /obj/item/beacon/syndicate/bomb
	cost = 40
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
	surplus = 0
	hijack_only = TRUE

/datum/uplink_item/explosives/emp_bomb
	name = "EMP bomb"
	desc = "ЭМИ бомба с настраиваемым таймером с минимальной настройкой таймера в 90 секунд. Заказывая бомбу, вы получите маленький маяк на который отправится бомба при активации. \
	Вы можете прикрутить бомбу с помощью гаечного ключа для того чтобы предотвратить обезвреживание. Экипаж также может попытаться разминировать бомбу. Создаст импульс 3 раза."
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
	name = "Plasma Fire Grenades"
	desc = "Коробка, состоящая из двух гранат, что вызывают огромный плазма пожар. Могут быть использованы для создания преграды для доступа в отдел. Они особенно полезны если у вас есть атмосферный МОДсьют."
	reference = "APG"
	item = /obj/item/storage/box/syndie_kit/atmosfiregrenades
	cost = 50
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
	surplus = 0
	hijack_only = TRUE

/datum/uplink_item/stealthy_tools/chameleon
	name = "Chameleon Kit"
	desc = "Набор одежды, что содержат хамелеон технологию, позволяющая замаскироваться под любого на станции и даже больше! \
			Из-за проблем с бюджетом ботинки не предоставляют защиту от скользских поверхностей. Набор поставляется вместе с хамелеон печатью."
	reference = "CHAM"
	item = /obj/item/storage/box/syndie_kit/chameleon
	cost = 10
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/stealthy_tools/syndigaloshes
	name = "No-Slip Chameleon Shoes"
	desc = "Эти ботинки позволяют носителю бегать по скользкому полу и скользким объектам без падения на пол. \
			Они не работают на очень скользких поверхностях."
	reference = "NSSS"
	item = /obj/item/clothing/shoes/chameleon/noslip
	cost = 10
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)

/datum/uplink_item/explosives/detomatix
	name = "Detomatix PDA Cartridge"
	desc = "Когда вставлен в КПК, этот картридж даст вам 5 возможностей сдетонировать КПК других членов экипажа, где включен мессенджер. Взрывной волной жертв будет опрокидывать на пол и оглушать на продолжительный период времени."
	reference = "DEPC"
	item = /obj/item/cartridge/syndicate
	cost = 30
	excludefrom = list(UPLINK_TYPE_NUCLEAR, UPLINK_TYPE_SST)
