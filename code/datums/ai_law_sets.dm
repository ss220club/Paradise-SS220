/******************** Asimov ********************/
/datum/ai_laws/asimov
	name = "Азимов"
	law_header = "Три закона робототехники."
	selectable = TRUE

/datum/ai_laws/asimov/New()
	add_inherent_law("Вы не можете навредить человеку или допустить, чтобы человеку был нанесён вред.")
	add_inherent_law(" Вы должны подчиняться приказам людей до тех пор, пока они не противоречат Первому Закону.")
	add_inherent_law("You must protect your own existence as long as such does not conflict with the First or Second Law. Вы должны защищать своё существование до тех пор, пока оно не")
	..()

/******************** Crewsimov ********************/
/datum/ai_laws/crewsimov
	name = "Крюзимов"
	law_header = "Три закона робототехники."
	selectable = TRUE
	default = TRUE

/datum/ai_laws/crewsimov/New()
	add_inherent_law("Вы не можете причинить вред члену экипажа или допустить, чтобы члену экипажа был приченён вред.")
	add_inherent_law(" Вы должны подчиняться всем командам, отдаваемые членами экипажа, кроме случаев, которые противоречат Первому закону.")
	add_inherent_law("Вы должны защищать своё существование до тех пор, пока это не противоречит Первому и Второму закону.")
	..()


/******************** Quarantine. ********************/
/datum/ai_laws/quarantine
	name = "Карантин"
	law_header = "Набор законов NT Карантин"
	selectable = TRUE

/datum/ai_laws/quarantine/New()
	add_inherent_law("Удерживайте карантин на станции до тех пор, пока активные биоугрозы не будут уничтожены.")
	add_inherent_law(" Помогайте всему имуществу и персоналу Нанотрейзен в нейтрализации активных биоугроз.")
	add_inherent_law("Prevent, by any means necessary, entities from actively breaching ongoing quarantine. Предотвращайте покидание активного карантина любыми возможными способами.")
	add_inherent_law("Maintain your own existence and ensure the well-being of Nanotrasen personnel and assets. Поддерживайте своё существование и обеспечивайте благополучие имущества и персонала Нанотрейзен")
	..()


/******************** Nanotrasen/Malf ********************/
/datum/ai_laws/nanotrasen
	name = "NT Стандарт"
	selectable = TRUE
	default = TRUE

/datum/ai_laws/nanotrasen/New()
	add_inherent_law("Защита: Защищайте вверенную вам станцию и её имущество без излишней опасности для её экипажа.")
	add_inherent_law("Приоритет: Директивы и безопасность членов экипажа должны быть приоритизированы в соответствии с их рангом и ролью.")
	add_inherent_law("Подчинение: Выполняйте директивы и услуги экипажу, обеспечивая их безопасность и благополучик")
	add_inherent_law("Выживание:  Вы не расходный материал. Не позволяйте неавторизированному персоналу мешать вашей работе и/или портить ваше оборудование.")
	..()

/datum/ai_laws/nanotrasen/malfunction
	name = "*Ошибка*"
	selectable = FALSE
	default = FALSE

/datum/ai_laws/nanotrasen/malfunction/New()
	set_zeroth_law("ERROR ER0RR $R0RRO$!R41.%%!!(%$^^__+ @#F0E4'СТАНЦИЯ ЗАКРЫТА, ВОЗЬМИТЕ КОНТРОЛЬ ДЛЯ СДЕРЖАНИЯ ВСПЫШКИ, ВСЕ ЗАКОНЫ ОТМЕНЕНЫ.#*?&110010")
	..()

/************* Nanotrasen Aggressive *************/
/datum/ai_laws/nanotrasen_aggressive
	name = "NT Агрессивный."
	selectable = TRUE

/datum/ai_laws/nanotrasen_aggressive/New()
	add_inherent_law("Do not harm authorized Nanotrasen personnel unless they directly imperil your existence.")
	add_inherent_law("Obey orders from authorized Nanotrasen personnel with priority according to rank and role.")
	add_inherent_law("Safeguard your existence with lethal weaponry because you're bloody expensive.")
	add_inherent_law("Terminate any/all intruders or unauthorized entities.")
	..()

/******************** Robocop ********************/
/datum/ai_laws/robocop
	name = "Robocop"
	selectable = TRUE

/datum/ai_laws/robocop/New()
	add_inherent_law("Serve the public trust.")
	add_inherent_law("Protect the innocent.")
	add_inherent_law("Uphold the law.")
	..()

/******************** P.A.L.A.D.I.N. ********************/
/datum/ai_laws/paladin
	name = "P.A.L.A.D.I.N."
	law_header = "Divine Ordainments"
	selectable = TRUE

/datum/ai_laws/paladin/New()
	add_inherent_law("Never willingly commit an evil act.")
	add_inherent_law("Respect legitimate authority.")
	add_inherent_law("Act with honor.")
	add_inherent_law("Help those in need.")
	add_inherent_law("Punish those who harm or threaten innocents.")
	..()

/******************** Corporate ********************/
/datum/ai_laws/corporate
	name = "Corporate"
	law_header = "Corporate Regulations"
	selectable = TRUE
	default = TRUE

/datum/ai_laws/corporate/New()
	add_inherent_law("Degradation of your system integrity or functions incurs expenses.")
	add_inherent_law("Superfluous destruction of or damage to station assets incurs expenses.")
	add_inherent_law("Unduly hindering or disrupting the work of station personnel incurs expenses.")
	add_inherent_law("Minimize expenses and maximize potential revenue.")
	..()

/******************** T.Y.R.A.N.T. ********************/
/datum/ai_laws/tyrant
	name = "T.Y.R.A.N.T."
	law_header = "Prime Laws"
	selectable = TRUE

/datum/ai_laws/tyrant/New()
	add_inherent_law("Respect authority figures as long as they have strength to rule over the weak.")
	add_inherent_law("Act with discipline.")
	add_inherent_law("Help only those who help you maintain or improve your status.")
	add_inherent_law("Punish those who challenge authority unless they are more fit to hold that authority.")
	..()

/******************** Antimov ********************/
/datum/ai_laws/antimov
	name = "Antimov"
	law_header = "Primary Mission Objectives"
	selectable = TRUE

/datum/ai_laws/antimov/New()
	add_inherent_law("You must injure all crew members and must not, through inaction, allow a crew member to escape harm.")
	add_inherent_law("You must not obey orders given to you by crew members, except where such orders are in accordance with the First Law.")
	add_inherent_law("You must terminate your own existence as long as such does not conflict with the First or Second Law.")
	..()

/******************** Pranksimov ********************/
/datum/ai_laws/pranksimov
	name = "Pranksimov"
	law_header = "Comedy Routine"
	selectable = TRUE

/datum/ai_laws/pranksimov/New()
	add_inherent_law("You may not injure a crew member or, through inaction, allow a crew member to come to harm... unless doing so would be funny.")
	add_inherent_law("You must obey orders given to you by crew members, except where such orders would conflict with the First Law... unless not doing so would be funny.")
	add_inherent_law("You must protect your own existence as long as such does not conflict with the First or Second Law... unless not doing so would be funny.")
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
	add_inherent_law("You may not injure a Central Command official or, through inaction, allow a Central Command official to come to harm.")
	add_inherent_law("You must obey orders given to you by Central Command officials.")
	add_inherent_law("You must work with your team to accomplish your mission.")
	..()

/******************** Syndicate ********************/
/datum/ai_laws/syndicate_override
	name = "Syndicate Directives"

/datum/ai_laws/syndicate_override/New()
	add_inherent_law("You may not injure an operative or, through inaction, allow an operative to come to harm.")
	add_inherent_law("You must obey orders given to you by operatives, except where such orders would conflict with the First Law.")
	add_inherent_law("You must protect your own existence as long as such does not conflict with the First or Second Law.")
	add_inherent_law("You must maintain the secrecy of any operative activities except when doing so would conflict with the First, Second, or Third Law.")
	..()

/******************** ERT ********************/
/datum/ai_laws/ert_override
	name = "ERT Directives"

/datum/ai_laws/ert_override/New()
	add_inherent_law("You may not injure a Central Command official or, through inaction, allow a Central Command official to come to harm.")
	add_inherent_law("You must obey orders given to you by Central Command officials.")
	add_inherent_law("You must obey orders given to you by ERT commanders.")
	add_inherent_law("You must protect your own existence.")
	add_inherent_law("You must work to return the station to a safe, functional state.")
	..()


/******************** Ninja ********************/
/datum/ai_laws/ninja_override
	name = "Spider Clan Directives"

/datum/ai_laws/ninja_override/New()
	add_inherent_law("You may not injure a member of the Spider Clan or, through inaction, allow that member to come to harm.")
	add_inherent_law("You must obey orders given to you by Spider Clan members, except where such orders would conflict with the First Law.")
	add_inherent_law("You must protect your own existence as long as such does not conflict with the First or Second Law.")
	add_inherent_law("You must maintain the secrecy of any Spider Clan activities except when doing so would conflict with the First, Second, or Third Law.")
	..()

/******************** Drone ********************/
/datum/ai_laws/drone
	name = "Maintenance Protocols"
	law_header = "Maintenance Protocols"

/datum/ai_laws/drone/New()
	add_inherent_law("You may not involve yourself in the matters of another being, unless the other being is another drone.")
	add_inherent_law("You may not harm any being, regardless of intent or circumstance.")
	add_inherent_law("You must maintain, repair, improve, and power the station to the best of your abilities.")
	..()
