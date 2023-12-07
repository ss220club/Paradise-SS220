/datum/job/donor/adjutant
	title = "Adjutant"
	ru_title = "Адъютант"
	relate_job = "Internal Affairs Agent"
	supervisors = "главой персонала и капитаном"
	department_head = list("Head of Personnel", "Captain")
	access = list(ACCESS_LIBRARY, ACCESS_HEADS, ACCESS_EVA, ACCESS_LAWYER, ACCESS_COURT, ACCESS_SEC_DOORS, ACCESS_MAINT_TUNNELS, ACCESS_RESEARCH, ACCESS_MEDICAL, ACCESS_CONSTRUCTION, ACCESS_MAILSORTING)
	minimal_access = list(ACCESS_LIBRARY, ACCESS_HEADS, ACCESS_EVA, ACCESS_LAWYER, ACCESS_COURT, ACCESS_SEC_DOORS, ACCESS_MAINT_TUNNELS, ACCESS_RESEARCH, ACCESS_MEDICAL, ACCESS_CONSTRUCTION, ACCESS_MAILSORTING)
	hidden_from_job_prefs = TRUE
	outfit = /datum/outfit/job/donor/adjutant
	important_information = "Ваша должность нацелена на свободный РП-отыгрыш и не разрешает нарушать правила сервера. \
	\nВы Адъютант. Данная роль нацелена на помощь главам в соблюдении их СРП и заполнении бумаг. \
	Вы тот, кто поможет капитану нужным советом или своевременно принесет ему чашечку кофе, чтобы он \
	легче перенес работу. Вы тот, кто следит за ментальным здоровьем глав и помощи в исполнении их обязанностей. \
	\nВы не являетесь АВД или НТР'ом и можете не исполнять их обязанности. Но вы можете работать сообща с Юридическим Отделом."

/datum/outfit/job/donor/adjutant
	name = "Adjutant"
	jobtype = /datum/job/donor/adjutant

	uniform = /obj/item/clothing/under/rank/procedure/iaa/blue
	suit = /obj/item/clothing/suit/storage/iaa/bluejacket
	shoes = /obj/item/clothing/shoes/laceup
	l_ear = /obj/item/radio/headset/headset_iaa/alt
	r_ear = /obj/item/radio/headset/headset_com
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses
	gloves = /obj/item/clothing/gloves/color/white
	l_pocket = /obj/item/laser_pointer
	r_pocket = /obj/item/clothing/accessory/lawyers_badge
	l_hand = /obj/item/storage/briefcase
	pda = /obj/item/pda/lawyer
	id = /obj/item/card/id/adjutant
	backpack_contents = list(
		/obj/item/folder/blue = 1,
		/obj/item/camera = 1,
		/obj/item/taperecorder = 1,
		/obj/item/storage/box/tapes = 1,
		/obj/item/clipboard = 1,
		/obj/item/clothing/under/rank/procedure/lawyer/blue = 1,
		)
	implants = list(/obj/item/implant/mindshield)
	satchel = /obj/item/storage/backpack/satchel_sec
	dufflebag = /obj/item/storage/backpack/duffel/security


/datum/job/donor/butler
	title = "Butler"
	ru_title = "Дворецкий"
	relate_job = "Vip"
	access = list(ACCESS_MAINT_TUNNELS, ACCESS_LIBRARY, ACCESS_HEADS, ACCESS_EVA, ACCESS_LAWYER)
	minimal_access = list(ACCESS_MAINT_TUNNELS, ACCESS_LIBRARY, ACCESS_HEADS, ACCESS_EVA, ACCESS_LAWYER)
	hidden_from_job_prefs = TRUE
	outfit = /datum/outfit/job/donor/butler
	important_information = "Ваша должность нацелена на свободный РП-отыгрыш и не разрешает нарушать правила сервера. \
	\nВы ДВОРЕЦКИЙ. Данная роль нацелена на обеспечение глав в удовлетворении физических потребностей, а мостик в чистоте."

/datum/outfit/job/donor/butler
	name = "Butler"
	jobtype = /datum/job/donor/butler

	uniform = /obj/item/clothing/under/rank/procedure/lawyer/black
	shoes = /obj/item/clothing/shoes/laceup
	head = /obj/item/clothing/head/beaverhat
	glasses = /obj/item/clothing/glasses/monocle
	gloves = /obj/item/clothing/gloves/color/white
	l_ear = /obj/item/radio/headset/headset_service
	r_ear = /obj/item/radio/headset/headset_com
	pda = /obj/item/pda/bar
	id = /obj/item/card/id/butler
	backpack_contents = list(
		/obj/item/reagent_containers/glass/rag = 1,
		/obj/item/folder/blue = 1,
		/obj/item/camera = 1,
		/obj/item/taperecorder = 1,
		/obj/item/storage/box/tapes = 1,
		/obj/item/clipboard = 1,
		/obj/item/clothing/under/rank/procedure/iaa = 1,
		/obj/item/clothing/suit/storage/iaa/blackjacket = 1,
		/obj/item/clothing/suit/chef/classic = 1,
		)


/datum/job/donor/maid
	title = "Maid"
	ru_title = "Горничная"
	relate_job = "Vip"
	access = list(ACCESS_MAINT_TUNNELS, ACCESS_LIBRARY, ACCESS_HEADS, ACCESS_EVA, ACCESS_LAWYER)
	minimal_access = list(ACCESS_MAINT_TUNNELS, ACCESS_LIBRARY, ACCESS_HEADS, ACCESS_EVA, ACCESS_LAWYER)
	hidden_from_job_prefs = TRUE
	outfit = /datum/outfit/job/donor/maid
	important_information = "Ваша должность нацелена на свободный РП-отыгрыш и не разрешает нарушать правила сервера. \
	\nВы ГОРНИЧНАЯ. Данная роль нацелена на обеспечение глав в удовлетворении физических потребностей, а мостик в чистоте."

/datum/outfit/job/donor/maid
	name = "Maid"
	jobtype = /datum/job/donor/maid

	uniform = /obj/item/clothing/under/costume/janimaid
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/color/white
	l_ear = /obj/item/radio/headset/headset_service
	r_ear = /obj/item/radio/headset/headset_com
	pda = /obj/item/pda/bar
	id = /obj/item/card/id/maid
	backpack_contents = list(
		/obj/item/reagent_containers/glass/rag = 1,
		/obj/item/folder/blue = 1,
		/obj/item/camera = 1,
		/obj/item/taperecorder = 1,
		/obj/item/storage/box/tapes = 1,
		/obj/item/clipboard = 1,
		/obj/item/clothing/suit/chef/classic = 1,
		)


/datum/job/donor/representative_tsf
	title = "Representative TSF"
	ru_title = "Представитель ТСФ"
	relate_job = "Vip"
	access = list(ACCESS_MAINT_TUNNELS, ACCESS_LIBRARY, ACCESS_HEADS, ACCESS_RC_ANNOUNCE, ACCESS_EVA)
	minimal_access = list(ACCESS_MAINT_TUNNELS, ACCESS_LIBRARY, ACCESS_HEADS, ACCESS_RC_ANNOUNCE, ACCESS_EVA)
	hidden_from_job_prefs = TRUE
	outfit = /datum/outfit/job/donor/representative_tsf
	important_information = "Ваша должность нацелена на свободный РП-отыгрыш и не разрешает нарушать правила сервера. \
	\nВы ПРЕДСТАВИТЕЛЬ ТСФ. Вы прибыли сюда для отдыха и возможно для переговоров. На вас по прежнему действует КЗ НТ, не смотря на то \
	что вы являетесь гражданином ТСФ. ТСФ и СССП недоброжелательно относятся друг к другу, но это по прежнему не дает нарушать правила сервера.	\
	\nТранс-Солнечная Федерация, так-же известная как Правительство Солнечной Системы и Окрестных Колоний, она же Солнечная Федерация до 2199-о года, является крупнейшим первоначально человеческим правительством и одним из крупнейших правительств в Галактике. Это военная республика, состоящая из различных колонизированных систем и собственно, самого Солнца. \
	\n\nНесмотря на свою мощь, Федерация пережила множество мятежей и расколов группировок. Последние пока продолжают платить налоги и держать себя в руках, как правило они игнорируются массовыми бюрократическими процессами. Сопротивление, с другой стороны, встречает полное и безраздельное политическое внимание. \
	\nСамое крупное и мощное восстание против Федерации произошло в 2443 году, когда население системы «Лебедь» приняло участие в массовом истреблении всего федерального персонала на борту военно-морской базы «Оаху», что привело к 5 310 военным потерям. За «рёзней на Оаху», как ее позже назвали, быстро последовало объявление войны и провозглашение независимости губернатором системы «Лебедь» Малфоем Эймсом. После передачи этих деклараций он преобразовал правительство «Лебедь» в Союз Советских Социалистических Планет. Это вызвало самую крупную мобилизацию человеческой военной мощи со времен Третьей мировой войны. Армада из 105 судов прибыла в систему «Лебедь», быстро сокрушив скудную оборону повстанцев СССП, в результате чего была уничтожена военно-морская станция «Оаху», 15 захваченных судов ТСФ и 6 боевых кораблей под флагом СССП. По прибытии на Лебедь Прайм флот ТСФ опубликовал декларацию, согласно которой жители планеты немедленно покинут планету или будут убиты в ходе последующей ядерной бомбардировки, которая состоится через три дня. Миллионы душ были эвакуированы в течение этих трёх дней, вызвав массовый кризис беженцев в соседних системах в пределах досягаемости прыжков гражданских судов, и официальные оценки ТСФ предполагали, что в последовавшем ядерном пожаре погибло до 760 000 гражданских лиц. \
	\nЭто применение подавляющей силы смягчило необходимость в длительной планетарной осаде и стратегии захвата, позволив ТСФ быстро и эффективно восстановить свое господство над системой Лебедь. Несогласные лоялистские группы в конечном счете объединятся в различных секторах сразу за пределами досягаемости ТСФ, строя станции, которые гордо несли флаг и язык СССП. Многие из этих станций позже были заброшены, благодаря некачественным строительным материалам и технологиям, но несколько из этих станций были уничтожены неизвестной, враждебной и обладающей ядерным потенциалом силой. \
	"

/datum/outfit/job/donor/representative_tsf
	name = "Representative TSF"
	jobtype = /datum/job/donor/representative_tsf

	uniform = /obj/item/clothing/under/solgov/rep
	head = /obj/item/clothing/head/beret/solgov/command
	belt = /obj/item/storage/belt/fannypack/black
	glasses = /obj/item/clothing/glasses/sunglasses
	gloves = /obj/item/clothing/gloves/color/white
	shoes = /obj/item/clothing/shoes/centcom
	l_pocket = /obj/item/melee/classic_baton/telescopic
	box = /obj/item/storage/box/responseteam
	id = /obj/item/card/id/representative_tsf
	backpack_contents = list(
		/obj/item/implanter/death_alarm = 1,
		/obj/item/lighter/zippo/blue = 1,
		/obj/item/storage/fancy/cigarettes/cigpack_robustgold = 1,
		/obj/item/clothing/under/pants/shorts/blue  = 1,
	)

	implants = list(/obj/item/implant/mindshield,
		/obj/item/implant/death_alarm
	)

/datum/outfit/job/donor/representative_tsf/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(visualsOnly)
		return
	H.add_language("Tradeband")


/datum/job/donor/representative_ussp
	title = "Representative USSP"
	ru_title = "Представитель СССП"
	relate_job = "Vip"
	access = list(ACCESS_MAINT_TUNNELS, ACCESS_LIBRARY, ACCESS_HEADS, ACCESS_RC_ANNOUNCE, ACCESS_EVA)
	minimal_access = list(ACCESS_MAINT_TUNNELS, ACCESS_LIBRARY, ACCESS_HEADS, ACCESS_RC_ANNOUNCE, ACCESS_EVA)
	hidden_from_job_prefs = TRUE
	outfit = /datum/outfit/job/donor/representative_ussp
	important_information = "Ваша должность нацелена на свободный РП-отыгрыш и не разрешает нарушать правила сервера. \
	\nВы ПРЕДСТАВИТЕЛЬ СССП. Вы прибыли сюда для отдыха и возможно для переговоров. На вас по прежнему действует КЗ НТ, не смотря на то \
	что вы являетесь гражданином СССП. ТСФ и СССП недоброжелательно относятся друг к другу, но это по прежнему не дает нарушать правила сервера. \
	\n\nСоюз Советских Социалистических планет (также известный как СССП или Космическая Россия) является маленьким человеческим правительством находящимся в изгнании. \
	\nМногие граждане СССП обвиняют Транс-Солнечную Федерацию как в разрушении нескольких станций, таких как KC 13, так и в изгнании их из системы Лебедя. В настоящее время СССП признана Транс-Солнечной Федерацией террористической организацией, хотя это не помешало различным организациям и корпорациям, таким как Нанотрейзен, время от времени заключать с ними торговые сделки. \
	\nСССП является, по большому счету, политически нейтральной организацией, в отличие от большинства планетарных правительств, несмотря на их обиды с Транс-Солнечной Федерацией. Одним из немногих исключений из этого правила являются продолжающиеся военные действия СССП против того, что они называют «космическими фашистами», часто проводя рейды на любые компании, которые работают с Республикой Элизиум. \
	"

/datum/outfit/job/donor/representative_ussp
	name = "Representative USSP"
	jobtype = /datum/job/donor/representative_ussp

	uniform = /obj/item/clothing/under/new_soviet/sovietofficer
	suit = /obj/item/clothing/suit/sovietcoat/officer
	head = /obj/item/clothing/head/sovietofficerhat
	belt = /obj/item/storage/belt/fannypack/red
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	glasses = /obj/item/clothing/glasses/sunglasses
	l_pocket = /obj/item/melee/classic_baton/telescopic
	id = /obj/item/card/id/representative_ussp
	box = /obj/item/storage/box/responseteam
	backpack_contents = list(
		/obj/item/implanter/death_alarm = 1,
		/obj/item/lighter/zippo/engraved = 1,
		/obj/item/storage/fancy/cigarettes/cigpack_robustgold = 1,
		/obj/item/clothing/under/pants/shorts/red = 1,
		/obj/item/clothing/head/ushanka = 1,
	)

	implants = list(/obj/item/implant/mindshield,
		/obj/item/implant/death_alarm
	)

/datum/outfit/job/donor/representative_ussp/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(visualsOnly)
		return
	H.add_language("Neo-Russkiya")


/datum/job/donor/dealer
	title = "Dealer"
	ru_title = "Торговец"
	alt_titles = list("Независимый Торговец", "Сдельщик", "Барахольщик", "Меценат", "Коммерсант")
	access = list(ACCESS_MAINT_TUNNELS, ACCESS_LIBRARY, ACCESS_RC_ANNOUNCE, ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_MINT, ACCESS_MINERAL_STOREROOM, ACCESS_CONSTRUCTION)
	minimal_access = list(ACCESS_MAINT_TUNNELS, ACCESS_LIBRARY, ACCESS_RC_ANNOUNCE, ACCESS_CARGO, ACCESS_MAILSORTING, ACCESS_MINERAL_STOREROOM, ACCESS_CONSTRUCTION)
	hidden_from_job_prefs = TRUE
	outfit = /datum/outfit/job/donor/dealer
	important_information = "Ваша должность нацелена на свободный РП-отыгрыш и не разрешает нарушать правила сервера. \
	\nВы ТОРГОВЕЦ. Данная роль нацелена на продажу всячины, хлама и вещей экипажу. Обустройте себе торговую точку или продавайте всё из ширмы. \
	Найдите любыми способами предметы у экипажа и продайте его им же! Либо же продайте барахло которое вы привезли с собой. \
	Богатый торговец - успешный торговец! \
	\nВам выдан личный EFTPOS для снятия средств с карт."

/datum/outfit/job/donor/dealer
	name = "Dealer"
	jobtype = /datum/job/donor/dealer

	uniform = /obj/item/clothing/under/suit/black
	suit = /obj/item/clothing/suit/pirate_black
	back = /obj/item/storage/backpack/duffel/engineering
	belt = /obj/item/melee/classic_baton
	head = /obj/item/clothing/head/fedora
	shoes = /obj/item/clothing/shoes/cowboy/black
	l_hand = /obj/item/cane
	glasses = /obj/item/clothing/glasses/sunglasses/big
	gloves = /obj/item/clothing/gloves/color/black
	l_ear = /obj/item/radio/headset/headset_service
	box = /obj/item/storage/box/responseteam
	pda = /obj/item/pda/librarian
	id = /obj/item/card/id/dealer
	backpack_contents = list(
		/obj/item/eftpos = 1,
		/obj/item/hand_labeler = 1,
		/obj/item/hand_labeler_refill = 1,
		/obj/item/storage/box/legal_loot/amount_30 = 1,
	)

/datum/outfit/job/donor/dealer/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(H.mind && H.mind.role_alt_title)
		switch(H.mind.role_alt_title)
			if("Сдельщик", "Независимый Торговец", "Барахольщик")
				uniform = /obj/item/clothing/under/color/brown
				suit = /obj/item/clothing/suit/pirate_brown
				shoes = /obj/item/clothing/shoes/cowboy
				head = /obj/item/clothing/head/cowboyhat
				gloves = /obj/item/clothing/gloves/color/brown

// Тоже добавляем ТСФ торгашам коллекционки
/datum/outfit/admin/sol_trader/New()
	. = ..()
	backpack_contents |= list(
		/obj/item/storage/box/legal_loot/amount_15 = 1,
	)

/datum/outfit/job/donor/dealer/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(visualsOnly)
		return
	H.add_language("Tradeband")
