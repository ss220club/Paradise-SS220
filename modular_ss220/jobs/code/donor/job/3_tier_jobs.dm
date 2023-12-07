/datum/job/donor/administrator
	title = "Administrator"
	ru_title = "Сервис-Администратор"
	relate_job = "Bar"
	access = list(ACCESS_THEATRE, ACCESS_LIBRARY, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_HYDROPONICS, ACCESS_MINERAL_STOREROOM, ACCESS_JANITOR)
	minimal_access = list(ACCESS_THEATRE, ACCESS_LIBRARY, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_HYDROPONICS, ACCESS_MINERAL_STOREROOM, ACCESS_JANITOR)
	hidden_from_job_prefs = TRUE
	outfit = /datum/outfit/job/donor/administrator
	important_information = "Ваша должность нацелена на свободный РП-отыгрыш и не разрешает нарушать правила сервера. \
	\nВы АДМИНИСТРАТОР. Данная роль нацелена для налаживания работы в Отделе Обслуживания. Наладьте производство, \
	помогите главе персонала пока он занимается бумагами, убедитесь что каждый работник выполняет свою работу и делает это КАЧЕСТВЕННО! \
	А если всё замечательно, значит устройте новое развлечение или событие для экипажа. Довольный экипаж - работоспособный экипаж. \
	\nВы не являетесь заменой главы персонала и подчиняетесь ему напрямую. Вы не являетесь главой сервисного отдела. \
	Вы помощник, ассистент, консультант, наблюдатель, организатор."

/datum/outfit/job/donor/administrator
	name = "Сервис-Администратор"
	jobtype = /datum/job/donor/administrator

	uniform = /obj/item/clothing/under/rank/procedure/iaa
	suit = /obj/item/clothing/suit/storage/iaa/blackjacket
	shoes = /obj/item/clothing/shoes/laceup
	head = /obj/item/clothing/head/fez
	gloves = /obj/item/clothing/gloves/color/white
	belt = /obj/item/storage/belt/fannypack/black
	glasses = /obj/item/clothing/glasses/regular
	l_ear = /obj/item/radio/headset/headset_service
	pda = /obj/item/pda/librarian
	id = /obj/item/card/id/administrator
	backpack_contents = list(
		/obj/item/clothing/under/rank/procedure/lawyer/black = 1,
		/obj/item/clothing/under/misc/waiter = 1,
		/obj/item/eftpos = 1,
		/obj/item/clipboard = 1,
		/obj/item/reagent_containers/glass/rag = 1,
	)


/datum/job/donor/tourist_tsf
	title = "Tourist TSF"
	ru_title = "Турист ТСФ"
	relate_job = "Assistant"
	access = list(ACCESS_LIBRARY, ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_LIBRARY, ACCESS_MAINT_TUNNELS)
	hidden_from_job_prefs = TRUE
	outfit = /datum/outfit/job/donor/tourist_tsf
	important_information = "Ваша должность нацелена на свободный РП-отыгрыш и не разрешает нарушать правила сервера. \
	\nВы ТУРИСТ ТСФ. Вы прибыли сюда для отдыха и возможно для подработок. На вас по прежнему действует КЗ НТ, не смотря на то \
	что вы являетесь гражданином ТСФ. ТСФ и СССП недоброжелательно относятся друг к другу, но это по прежнему не дает нарушать правила сервера.	\
	\nТранс-Солнечная Федерация, так-же известная как Правительство Солнечной Системы и Окрестных Колоний, она же Солнечная Федерация до 2199-о года, является крупнейшим первоначально человеческим правительством и одним из крупнейших правительств в Галактике. Это военная республика, состоящая из различных колонизированных систем и собственно, самого Солнца. \
	\n\nНесмотря на свою мощь, Федерация пережила множество мятежей и расколов группировок. Последние пока продолжают платить налоги и держать себя в руках, как правило они игнорируются массовыми бюрократическими процессами. Сопротивление, с другой стороны, встречает полное и безраздельное политическое внимание. \
	\nСамое крупное и мощное восстание против Федерации произошло в 2443 году, когда население системы «Лебедь» приняло участие в массовом истреблении всего федерального персонала на борту военно-морской базы «Оаху», что привело к 5 310 военным потерям. За «рёзней на Оаху», как ее позже назвали, быстро последовало объявление войны и провозглашение независимости губернатором системы «Лебедь» Малфоем Эймсом. После передачи этих деклараций он преобразовал правительство «Лебедь» в Союз Советских Социалистических Планет. Это вызвало самую крупную мобилизацию человеческой военной мощи со времен Третьей мировой войны. Армада из 105 судов прибыла в систему «Лебедь», быстро сокрушив скудную оборону повстанцев СССП, в результате чего была уничтожена военно-морская станция «Оаху», 15 захваченных судов ТСФ и 6 боевых кораблей под флагом СССП. По прибытии на Лебедь Прайм флот ТСФ опубликовал декларацию, согласно которой жители планеты немедленно покинут планету или будут убиты в ходе последующей ядерной бомбардировки, которая состоится через три дня. Миллионы душ были эвакуированы в течение этих трёх дней, вызвав массовый кризис беженцев в соседних системах в пределах досягаемости прыжков гражданских судов, и официальные оценки ТСФ предполагали, что в последовавшем ядерном пожаре погибло до 760 000 гражданских лиц. \
	\nЭто применение подавляющей силы смягчило необходимость в длительной планетарной осаде и стратегии захвата, позволив ТСФ быстро и эффективно восстановить свое господство над системой Лебедь. Несогласные лоялистские группы в конечном счете объединятся в различных секторах сразу за пределами досягаемости ТСФ, строя станции, которые гордо несли флаг и язык СССП. Многие из этих станций позже были заброшены, благодаря некачественным строительным материалам и технологиям, но несколько из этих станций были уничтожены неизвестной, враждебной и обладающей ядерным потенциалом силой. \
	"

/datum/outfit/job/donor/tourist_tsf
	name = "Турист ТСФ"
	jobtype = /datum/job/donor/tourist_tsf

	uniform = /obj/item/clothing/under/solgov
	suit = /obj/item/clothing/suit/hooded/hoodie/blue
	shoes = /obj/item/clothing/shoes/combat
	head = /obj/item/clothing/head/soft/solgov/marines
	belt = /obj/item/storage/belt/fannypack/black
	gloves = /obj/item/clothing/gloves/fingerless
	id = /obj/item/card/id/tourist_tsf
	backpack_contents = list(
		/obj/item/clothing/under/pants/shorts/blue  = 1,
	)

/datum/outfit/job/donor/tourist_tsf/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(visualsOnly)
		return
	H.add_language("Tradeband")


/datum/job/donor/tourist_ussp
	title = "Tourist USSP"
	ru_title = "Турист СССП"
	relate_job = "Assistant"
	access = list(ACCESS_LIBRARY, ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_LIBRARY, ACCESS_MAINT_TUNNELS)
	hidden_from_job_prefs = TRUE
	outfit = /datum/outfit/job/donor/tourist_ussp
	important_information = "Ваша должность нацелена на свободный РП-отыгрыш и не разрешает нарушать правила сервера. \
	\nВы ТУРИСТ СССП. Вы прибыли сюда для отдыха и возможно для подработок. На вас по прежнему действует КЗ НТ, не смотря на то \
	что вы являетесь гражданином СССП. ТСФ и СССП недоброжелательно относятся друг к другу, но это по прежнему не дает нарушать правила сервера. \
	\n\nСоюз Советских Социалистических планет (также известный как СССП или Космическая Россия) является маленьким человеческим правительством находящимся в изгнании. \
	\nМногие граждане СССП обвиняют Транс-Солнечную Федерацию как в разрушении нескольких станций, таких как KC 13, так и в изгнании их из системы Лебедя. В настоящее время СССП признана Транс-Солнечной Федерацией террористической организацией, хотя это не помешало различным организациям и корпорациям, таким как Нанотрейзен, время от времени заключать с ними торговые сделки. \
	\nСССП является, по большому счету, политически нейтральной организацией, в отличие от большинства планетарных правительств, несмотря на их обиды с Транс-Солнечной Федерацией. Одним из немногих исключений из этого правила являются продолжающиеся военные действия СССП против того, что они называют «космическими фашистами», часто проводя рейды на любые компании, которые работают с Республикой Элизиум. \
	"


/datum/outfit/job/donor/tourist_ussp
	name = "Турист СССП"
	jobtype = /datum/job/donor/tourist_ussp

	uniform = /obj/item/clothing/under/new_soviet
	suit = /obj/item/clothing/suit/sovietcoat
	shoes = /obj/item/clothing/shoes/combat
	head = /obj/item/clothing/head/sovietsidecap
	belt = /obj/item/storage/belt/fannypack/red
	gloves = /obj/item/clothing/gloves/fingerless
	glasses = /obj/item/clothing/glasses/sunglasses/big
	id = /obj/item/card/id/tourist_ussp
	backpack_contents = list(
		/obj/item/clothing/under/pants/shorts/red = 1,
		/obj/item/clothing/head/ushanka = 1,
	)

/datum/outfit/job/donor/tourist_ussp/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(visualsOnly)
		return
	H.add_language("Neo-Russkiya")


/datum/job/donor/manager_janitor
	title = "Cleaning Manager"
	ru_title = "Менеджер по Клинингу"
	alt_titles = list("Ловец Крыс", "Уборщик I-разряда", "Уборщик II-разряда", "Уборщик III-разряда", "Уборщик IV-разряда", "Уборщик V-разряда")
	relate_job = "Janitor"
	access = list(ACCESS_JANITOR, ACCESS_MAINT_TUNNELS, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_MEDICAL)
	minimal_access = list(ACCESS_JANITOR, ACCESS_MAINT_TUNNELS, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_MEDICAL)
	hidden_from_job_prefs = TRUE
	outfit = /datum/outfit/job/donor/manager_janitor
	important_information = "Ваша должность нацелена на свободный РП-отыгрыш и не разрешает нарушать правила сервера. \
	\nВы Менеджер по Клинингу. Вы уборщик этой станции и должны следить за чистотой на ней. Вы давно на этой работе и снабжены лучшим снаряжением для идеальной работы. \
	Вы тот кто отделяет станцию от хаоса и обеспечивает порядок. Вы - настоящая действующая сила на этой станции."

/datum/outfit/job/donor/manager_janitor
	name = "Менеджер по Клинингу"
	jobtype = /datum/job/donor/manager_janitor

	uniform = /obj/item/clothing/under/rank/civilian/janitor
	suit = /obj/item/clothing/suit/apron/overalls
	shoes = /obj/item/clothing/shoes/galoshes/dry
	gloves = /obj/item/clothing/gloves/color/purple
	mask = /obj/item/clothing/mask/bandana/purple
	head = /obj/item/clothing/head/soft/purple
	belt = /obj/item/storage/belt/janitor/full
	r_pocket = /obj/item/door_remote/janikeyring
	l_ear = /obj/item/radio/headset/headset_service
	pda = /obj/item/pda/janitor
	id = /obj/item/card/id/manager_janitor
	backpack_contents = list(
		/obj/item/clothing/head/beret/purple_normal = 1,
		/obj/item/clothing/suit/storage/iaa/purplejacket = 1,
		/obj/item/clipboard = 1,
	)


/datum/job/donor/apprentice
	title = "Apprentice"
	ru_title = "Подмастерье"
	alt_titles = list("Ассистент-Механик", "Ассистент I-го разряда", "Ассистент II-го разряда", "Ассистент III-го разряда", "Ассистент IV-го разряда", "Ассистент V-го разряда")
	relate_job = "Assistant"
	access = list(ACCESS_LIBRARY, ACCESS_MAINT_TUNNELS, ACCESS_CONSTRUCTION, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_LIBRARY, ACCESS_MAINT_TUNNELS, ACCESS_CONSTRUCTION, ACCESS_MINERAL_STOREROOM)
	hidden_from_job_prefs = TRUE
	outfit = /datum/outfit/job/donor/apprentice
	important_information = "Ваша должность нацелена на свободный РП-отыгрыш и не разрешает нарушать правила сервера. \
	\nВы ПОДМАСТЕРЬЕ. Вы ассистент с полномочиями для работы на станции. Построить свою мастерскую или заняться другим полезным для станции и вас делом - ваша стезя. \
	Но серые комбинезоны и тулбоксы так и манят вас..."

/datum/outfit/job/donor/apprentice
	name = "Подмастерье"
	jobtype = /datum/job/donor/apprentice

	uniform = /obj/item/clothing/under/color/grey
	suit = /obj/item/clothing/suit/apron/overalls
	back = /obj/item/storage/backpack
	shoes = /obj/item/clothing/shoes/workboots
	mask = /obj/item/clothing/mask/gas
	head = /obj/item/clothing/head/soft/grey
	belt = /obj/item/storage/belt/fannypack/white
	gloves = /obj/item/clothing/gloves/color/grey
	l_hand = /obj/item/storage/toolbox/mechanical
	r_hand = /obj/item/flag/grey
	id = /obj/item/card/id/apprentice
	backpack_contents = list(
		/obj/item/clothing/head/welding = 1,
		/obj/item/flashlight = 1,
		/obj/item/clothing/under/pants/shorts/grey = 1,
		/obj/item/clothing/under/misc/assistantformal = 1,
	)


/datum/job/donor/guard
	title = "Guard"
	ru_title = "Охранник"
	alt_titles = list("Сторож Сервиса", "Охранник Сервиса", "Вышибала Сервиса")
	relate_job = "Bar"
	access = list(ACCESS_MAINT_TUNNELS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_HYDROPONICS, ACCESS_LIBRARY)
	minimal_access = list(ACCESS_MAINT_TUNNELS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_HYDROPONICS, ACCESS_LIBRARY)
	hidden_from_job_prefs = TRUE
	outfit = /datum/outfit/job/donor/guard
	important_information = "Ваша должность нацелена на свободный РП-отыгрыш и не разрешает нарушать правила сервера. \
	\nВы ОХРАННИК. Данная роль нацелена на обеспечение порядка в баре и на кухне. Вы то что отдаляет кухню от хаоса и пьяных ассистентов. \
	Вы уполномочены вышвыривать из бара каждого, кто нарушает порядок. \
	\nВы НЕ являетесь службой безопасности, данная роль не дает вам полномочия охотиться за антагонистами."

/datum/outfit/job/donor/guard
	name = "Охранник"
	jobtype = /datum/job/donor/guard

	uniform = /obj/item/clothing/under/rank/civilian/bartender
	suit = /obj/item/clothing/suit/armor/vest/old	// с замедлением
	belt = /obj/item/melee/classic_baton
	shoes = /obj/item/clothing/shoes/jackboots/noisy
	head = /obj/item/clothing/head/bowlerhat
	glasses = /obj/item/clothing/glasses/sunglasses/big
	l_ear = /obj/item/radio/headset/headset_service
	pda = /obj/item/pda/bar
	id = /obj/item/card/id/guard
	backpack_contents = list(
		/obj/item/clothing/suit/jacket/leather = 1,
		)


/datum/job/donor/migrant
	title = "Migrant"
	ru_title = "Мигрант"
	relate_job = "Assistant"
	access = list(ACCESS_LIBRARY, ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_LIBRARY, ACCESS_MAINT_TUNNELS)
	hidden_from_job_prefs = TRUE
	outfit = /datum/outfit/job/donor/migrant
	important_information = "Ваша должность нацелена на свободный РП-отыгрыш и не разрешает нарушать правила сервера. \
	\nВы МИГРАНТ. Сами вы прибыли на эту станцию или так вынудили обстоятельства, но вы теперь тут. \
	Присмотритесь к этой корпорации. Возможно здесь вы захотите жить и работать?"

/datum/outfit/job/donor/migrant
	name = "Мигрант"
	jobtype = /datum/job/donor/migrant

	uniform = /obj/item/clothing/under/costume/pirate_rags
	suit = /obj/item/clothing/suit/poncho
	shoes = /obj/item/clothing/shoes/sandal
	head = /obj/item/clothing/head/sombrero
	mask = /obj/item/clothing/mask/fakemoustache
	belt = /obj/item/storage/belt/fannypack/orange
	id = /obj/item/card/id/migrant
	backpack_contents = list(
		/obj/item/reagent_containers/food/drinks/bottle/tequila = 1,
		/obj/item/reagent_containers/food/snacks/taco = 6,
		/obj/item/reagent_containers/food/snacks/nachos = 3,
		/obj/item/reagent_containers/food/snacks/cheesenachos = 3,
		/obj/item/reagent_containers/food/snacks/cubannachos = 3,
		/obj/item/clothing/suit/poncho/red = 1,
		/obj/item/clothing/suit/poncho/green = 1,
		)


/datum/job/donor/uncertain
	title = "Uncertain"
	ru_title = "Забытый Ассистент"
	alt_titles = list("Безработный", "Свободный Ассистент", "Отрабатыващий Ассистент", "Ассистент Технических Тоннелей")
	access = list(ACCESS_LIBRARY, ACCESS_MAINT_TUNNELS, ACCESS_CONSTRUCTION)
	minimal_access = list(ACCESS_LIBRARY, ACCESS_MAINT_TUNNELS, ACCESS_CONSTRUCTION)
	hidden_from_job_prefs = TRUE
	outfit = /datum/outfit/job/donor/uncertain
	important_information = "Ваша должность нацелена на свободный РП-отыгрыш и не разрешает нарушать правила сервера. \
	\nВы БЕЗРАБОТНЫЙ. Данная роль нацелена на бездумное брождение по техническим тоннелям. Вас когда-то оставили без работы, \
	возможно эвакуационный шаттл улетел без вас, возможно технологии заменили вашу работу, причины могут быть разные. \
	Но суть всего этого одна - вы были брошены и занимаетесь собственным выживанием."

/datum/outfit/job/donor/uncertain
	name = "Забытый Ассистент"
	jobtype = /datum/job/donor/uncertain

	uniform = /obj/item/clothing/under/costume/kilt
	suit = /obj/item/clothing/suit/unathi/mantle
	shoes = /obj/item/clothing/shoes/footwraps
	head = /obj/item/clothing/head/beanie/yellow
	glasses = /obj/item/clothing/glasses/eyepatch
	belt = /obj/item/storage/belt/fannypack/black
	mask = /obj/item/clothing/mask/cigarette/pipe/cobpipe
	pda = /obj/item/pda/librarian
	id = /obj/item/card/id/uncertain
	backpack_contents = list(
		/obj/item/reagent_containers/food/drinks/bottle/vodka = 1,
		/obj/item/storage/fancy/cigarettes/cigpack_random = 2,
		/obj/item/reagent_containers/food/snacks/doshik = 3,
		/obj/item/reagent_containers/food/snacks/doshik_spicy = 3,
		/obj/item/clothing/suit/mantle/old = 1,
		/obj/item/clothing/head/flatcap = 1,
		/obj/item/clothing/suit/browntrenchcoat = 1,
		/obj/item/clothing/accessory/horrible = 1,
		/obj/item/clothing/under/costume/pirate_rags = 1,
		/obj/item/clothing/head/cowboyhat = 1,
		/obj/item/clothing/shoes/sandal = 1,
		)

	backpack = /obj/item/storage/backpack/explorer
	satchel = /obj/item/storage/backpack/satchel/explorer
	dufflebag = /obj/item/storage/backpack/duffel
