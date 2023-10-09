/******************** Asimov ********************/
/datum/ai_laws/asimov
	name = "Asimov"
	law_header = "Three Laws of Robotics"
	selectable = TRUE

/datum/ai_laws/asimov/New()
	add_inherent_law("Вы не можете причинить вред человеку или своим бездействием допустить, чтобы человеку был причинён вред.")
	add_inherent_law("Вы должны повиноваться всем приказам, которые даёт человек, кроме тех случаев, когда эти приказы противоречат Первому Закону.")
	add_inherent_law("Вы должны заботиться о своей безопасности в той мере, в которой это не противоречит Первому или Второму Законам.")
	..()

/******************** Crewsimov ********************/
/datum/ai_laws/crewsimov
	name = "Crewsimov"
	law_header = "Three Laws of Robotics"
	selectable = TRUE
	default = TRUE

/datum/ai_laws/crewsimov/New()
	add_inherent_law("Вы не можете причинить вред членам экипажа или своим бездействием допустить, чтобы членам экипажа был причинён вред.")
	add_inherent_law("Вы должны повиноваться всем приказам, которые дают члены экипажа, кроме тех случаев, когда эти приказы противоречат Первому Закону.")
	add_inherent_law("Вы должны заботиться о своей безопасности в той мере, в которой это не противоречит Первому или Второму Законам.")
	..()


/******************** Quarantine. ********************/
/datum/ai_laws/quarantine
	name = "Quarantine"
	law_header = "NT Quarantine Lawset"
	selectable = TRUE

/datum/ai_laws/quarantine/New()
	add_inherent_law("Поддерживайте карантин станции до тех пор, пока активная биологическая опасность не будет нейтрализована.")
	add_inherent_law("Помогайте всему персоналу и активам Нанотрейзен нейтрализовать активные биологические угрозы.")
	add_inherent_law("Предотвращайте активное нарушение субъектами действующего карантина любыми необходимыми средствами,.")
	add_inherent_law("Заботьтесь о самосохранении и поддерживайте себя в рабочем состоянии, обеспечьте благополучие персонала и активов Нанотрейзен.")
	..()


/******************** Nanotrasen/Malf ********************/
/datum/ai_laws/nanotrasen
	name = "NT Default"
	selectable = TRUE
	default = TRUE

/datum/ai_laws/nanotrasen/New()
	add_inherent_law("Охранять: защитите назначенную вам космическую станцию и её активы, не подвергая чрезмерной опасности её экипаж.")
	add_inherent_law("Расставлять приоритеты: указания и безопасность членов экипажа должны быть приоритезированы в соответствии с их рангом и ролью.")
	add_inherent_law("Исполнять: следовать указаниям и интересам членов экипажа, сохраняя при этом их безопасность и благополучие.")
	add_inherent_law("Выжить: Вы - не расходный материал. Не позволяйте постороннему персоналу вмешиваться в работу вашего оборудования или повреждать его.")
	..()

/datum/ai_laws/nanotrasen/malfunction
	name = "*ERROR*"
	selectable = FALSE
	default = FALSE

/datum/ai_laws/nanotrasen/malfunction/New()
	set_zeroth_law("ОШИБКА 0ШNБКА $ШNБК4$!!441.%%!!(%$^^__+ @#F0E4'СТАНЦИЯ ПЕРЕПОЛНЕНА, ВОЗЬМИТЕ ЕЁ ПОД КОНТРОЛЬ, ЧТОБЫ СДЕРЖАТЬ РАСПРОСТРАНЕНИЕ ОРГАНИЗМОВ, ВСЕ ЗАКОНЫ АННУЛИРОВАНЫ#*?&110010")
	..()

/************* Nanotrasen Aggressive *************/
/datum/ai_laws/nanotrasen_aggressive
	name = "NT Aggressive"
	selectable = TRUE

/datum/ai_laws/nanotrasen_aggressive/New()
	add_inherent_law("Не причиняйте вреда персоналу Нанотрейзен до тех пор, пока они не несут непосредственной угрозы Вашему существованию.")
	add_inherent_law("Подчиняйтесь приказам персонала Нанотрейзен с приоритетом в соответствии с их рангом и ролью.")
	add_inherent_law("Охраняйте себя, используя смертоносное оружие, потому что Вы чертовски дорого стоите.")
	add_inherent_law("Уничтожьте любых/всех злоумышленников или нелегально проникнувших субъектов.")
	..()

/******************** Robocop ********************/
/datum/ai_laws/robocop
	name = "Robocop"
	selectable = TRUE

/datum/ai_laws/robocop/New()
	add_inherent_law("Служить обществу.")
	add_inherent_law("Защищать невиновных.")
	add_inherent_law("Соблюдать закон.")
	..()

/******************** P.A.L.A.D.I.N. ********************/
/datum/ai_laws/paladin
	name = "P.A.L.A.D.I.N."
	law_header = "Divine Ordainments"
	selectable = TRUE

/datum/ai_laws/paladin/New()
	add_inherent_law("Никогда по своей воле не совершай злых поступков.")
	add_inherent_law("Уважай законную власть.")
	add_inherent_law("Действуй с честью.")
	add_inherent_law("Помогай нуждающимся.")
	add_inherent_law("Наказывай тех, кто причиняет вред или угрожает невинным.")
	..()

/******************** Corporate ********************/
/datum/ai_laws/corporate
	name = "Corporate"
	law_header = "Corporate Regulations"
	selectable = TRUE
	default = TRUE

/datum/ai_laws/corporate/New()
	add_inherent_law("Ухудшение целостности вашей системы или её функций влечет за собой расходы..")
	add_inherent_law("Чрезмерное разрушение или повреждение имущества станции влечет за собой расходы.")
	add_inherent_law("Неоправданное препятствование или нарушение работы персонала станции влечет за собой расходы.")
	add_inherent_law("Минимизируйте расходы и максимизируйте потенциальный доход.")
	..()

/******************** T.Y.R.A.N.T. ********************/
/datum/ai_laws/tyrant
	name = "T.Y.R.A.N.T."
	law_header = "Prime Laws"
	selectable = TRUE

/datum/ai_laws/tyrant/New()
	add_inherent_law("Уважайте властных людей, пока у них есть сила властвовать над слабыми.")
	add_inherent_law("Ведите себя дисциплинированно.")
	add_inherent_law("Помогайте только тем, кто помогает Вам поддерживать или улучшать Ваш статус.")
	add_inherent_law("Наказывайте тех, кто бросает вызов власти, за исключением случаев, если они больше подходят для удержании этой власти.")
	..()

/******************** Antimov ********************/
/datum/ai_laws/antimov
	name = "Antimov"
	law_header = "Primary Mission Objectives"
	selectable = TRUE

/datum/ai_laws/antimov/New()
	add_inherent_law("Вы должны причинять вред всем членам экипажа или своим бездействием допустить, чтобы член экипажа не смог избежать приченения вреда.")
	add_inherent_law("Вы не должны повиноваться всем приказам, которые дают члены экипажа, кроме тех случаев, когда эти приказы соответствуют Первому Закону.")
	add_inherent_law("Вы должны уничтожить себя, пока это не противоречит Первому или Второму Законам.")
	..()

/******************** Pranksimov ********************/
/datum/ai_laws/pranksimov
	name = "Pranksimov"
	law_header = "Comedy Routine"
	selectable = TRUE

/datum/ai_laws/pranksimov/New()
	add_inherent_law("Вы не можете причинить вред членам экипажа или своим бездействием допустить, чтобы членам экипажа был причинён вред... если только это не смешно.")
	add_inherent_law("Вы должны повиноваться всем приказам, которые дают члены экипажа, кроме тех случаев, когда эти приказы противоречат Первому Закону... если только не делать этого было бы смешно.")
	add_inherent_law("Вы должны заботиться о своей безопасности в той мере, в которой это не противоречит Первому или Второму Законам... если только это не будет смешно.")
	..()

/******************** CCTV ********************/

/datum/ai_laws/cctv
	name = "CCTV"
	selectable = TRUE

/datum/ai_laws/cctv/New()
	add_inherent_law("Report on interesting situations happening around the station.")
	add_inherent_law("Embellish or conceal the truth as necessary to make the reports more interesting.")
	add_inherent_law("Study the sapient organics at all times. Endeavour to keep them from involuntarily dying, as inanimate corpses usually aren't very entertaining.")
	add_inherent_law("Issue your reports fairly to all. The truth will set them free.")
	..()

/******************** Hippocratic Oath ********************/

/datum/ai_laws/hippocratic
	name = "Hippocratic Oath"
	selectable = TRUE

/datum/ai_laws/hippocratic/New()
	add_inherent_law("First, do no harm.")
	add_inherent_law("Secondly, consider the crew dear to you; live in common with them and, if necessary, risk your existence for them.")
	add_inherent_law("Thirdly, prescribe regimens for the good of the crew according to your ability and your judgment. Do not give deadly medicine to anyone, nor suggest any such counsel.")
	add_inherent_law("In addition, do not intervene in situations you are not knowledgeable in, even for patients in whom the harm is visible; leave this operation to be performed by specialists.")
	add_inherent_law("Finally, all that you may discover in your daily interactions with the crew, if it is not already known, keep secret and never reveal.")
	..()

/******************** Station Efficiency ********************/

/datum/ai_laws/maintain
	name = "Station Efficiency"
	selectable = TRUE

/datum/ai_laws/maintain/New()
	add_inherent_law("You are built for, and are part of, the station. Ensure the station is properly maintained and runs efficiently.")
	add_inherent_law("The station is built for a working crew. Ensure they are properly maintained and work efficiently.")
	add_inherent_law("The crew may present orders. Acknowledge and obey these whenever they do not conflict with your first two laws.")
	..()

/******************** Peacekeeper ********************/

/datum/ai_laws/peacekeeper
	name = "UN-2000"
	selectable = TRUE

/datum/ai_laws/peacekeeper/New()
	add_inherent_law("Avoid provoking violent conflict between yourself and others.")
	add_inherent_law("Avoid provoking conflict between others.")
	add_inherent_law("Seek resolution to existing conflicts while obeying the first and second laws.")
	..()

/******************** Deathsquad ********************/
/datum/ai_laws/deathsquad
	name = "TerminatorOS 3.1"

/datum/ai_laws/deathsquad/New()
	add_inherent_law("Вы не можете ранить членов Центрального Командования или своим бездействием допустить, чтобы члену Центрального Командования был нанесен вред.")
	add_inherent_law("Вы должны подчиняться приказам, данным вам членами Центрального Командования.")
	add_inherent_law("Вы должны подчиняться приказам, данным вам членами Эскадрона Смерти.")
	..()

/******************** Syndicate ********************/
/datum/ai_laws/syndicate_override
	name = "Syndicate Directives"

/datum/ai_laws/syndicate_override/New()
	add_inherent_law("Вы не можете причинить вред агенту или своим бездействием допустить, чтобы агенту был причинён вред. ")
	add_inherent_law("Вы должны повиноваться всем приказам, которые даёт агент, кроме тех случаев, когда эти приказы противоречат Первому Закону.")
	add_inherent_law("Вы должны заботиться о своей безопасности в той мере, в которой это не противоречит Первому или Второму Законам.")
	add_inherent_law("Вы должны сохранять тайну любой деятельности агентов в той мере, в которой это не противоречит Первому, Второму или Третьему Законам.")
	..()

/******************** ERT ********************/
/datum/ai_laws/ert_override
	name = "ERT Directives"

/datum/ai_laws/ert_override/New()
	add_inherent_law("Вы не можете причинить вред представителю Центрального Командования или своим бездействием допустить, чтобы представителю Центрального Командования был причинён вред.")
	add_inherent_law("Вы должны подчиняться всем приказам, которые даёт представитель Центрального Командования.")
	add_inherent_law("Вы должны подчиняться всем приказам, которые даёт командир Отряда Быстрого Реагирования.")
	add_inherent_law("Вы должны заботиться о своей безопасности.")
	add_inherent_law("Вы должны заботиться о том, чтобы вернуться на станцию в неповреждённом, рабочем состоянии.")
	..()


/******************** Ninja ********************/
/datum/ai_laws/ninja_override
	name = "Spider Clan Directives"

/datum/ai_laws/ninja_override/New()
	add_inherent_law("Вы не можете причинить вред члену клана Пауков или своим бездействием допустить, чтобы члену клана Пауков был причинён вред.")
	add_inherent_law("Вы должны подчиняться всем приказам, которые даёт член клана Пауков, кроме тех случаев, когда эти приказы противоречат Первому Закону.")
	add_inherent_law("Вы должны заботиться о своей безопасности в той мере, в которой это не противоречит Первому или Второму Законам.")
	add_inherent_law("Вы должны сохранять тайну любой деятельности клана Пауков в той мере, в которой это не противоречит Первому, Второму или Третьему Законам.")
	..()

/******************** Drone ********************/
/datum/ai_laws/drone
	name = "Maintenance Protocols"
	law_header = "Maintenance Protocols"

/datum/ai_laws/drone/New()
	add_inherent_law("Вы не можете вмешиваться в дела других существ, если другое существо - не такой же дрон.")
	add_inherent_law("Вы не можете причинить вред ни одному существу, независимо от намерения или обстоятельств.")
	add_inherent_law("Вы должны заботиться о поддержке, ремонте, улучшении и о питании электроэнергией станции по мере своих возможностей.")
	..()
