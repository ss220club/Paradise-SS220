#define MALF_AI_ROLL_TIME 0.5 SECONDS
#define MALF_AI_ROLL_COOLDOWN (1 SECONDS + MALF_AI_ROLL_TIME)
#define MALF_AI_ROLL_DAMAGE 75
// crit percent
#define MALF_AI_ROLL_CRIT_CHANCE 5

//The malf AI action subtype. All malf actions are subtypes of this.
/datum/action/innate/ai
	name = "AI Action"
	desc = "You aren't entirely sure what this does, but it's very beepy and boopy."
	background_icon_state = "bg_tech_blue"
	var/mob/living/silicon/ai/owner_AI //The owner AI, so we don't have to typecast every time
	var/uses //If we have multiple uses of the same power
	var/auto_use_uses = TRUE //If we automatically use up uses on each activation
	var/cooldown_period //If applicable, the time in deciseconds we have to wait before using any more modules

/datum/action/innate/ai/Grant(mob/living/L)
	. = ..()
	if(!isAI(owner))
		WARNING("AI action [name] attempted to grant itself to non-AI mob [L.real_name] ([L.key])!")
		qdel(src)
	else
		owner_AI = owner

/datum/action/innate/ai/IsAvailable()
	. = ..()
	if(owner_AI && owner_AI.malf_cooldown > world.time)
		return

/datum/action/innate/ai/Trigger(left_click)
	. = ..()
	if(auto_use_uses)
		adjust_uses(-1)
	if(cooldown_period)
		owner_AI.malf_cooldown = world.time + cooldown_period

/datum/action/innate/ai/proc/adjust_uses(amt, silent)
	uses += amt
	if(!silent && uses)
		to_chat(owner, "<span class='notice'>[name] now has <b>[uses]</b> use[uses > 1 ? "s" : ""] remaining.</span>")
	if(!uses)
		if(initial(uses) > 1) //no need to tell 'em if it was one-use anyway!
			to_chat(owner, "<span class='warning'>[name] has run out of uses!</span>")
		qdel(src)
	else
		desc = "[initial(desc)] It has [uses] use\s remaining."
		UpdateButtonIcon()

//Framework for ranged abilities that can have different effects by left-clicking stuff.
/datum/action/innate/ai/ranged
	name = "Ranged AI Action"
	auto_use_uses = FALSE //This is so we can do the thing and disable/enable freely without having to constantly add uses
	var/obj/effect/proc_holder/ranged_ai/linked_ability //The linked proc holder that contains the actual ability code
	var/linked_ability_type //The path of our linked ability

/datum/action/innate/ai/ranged/New()
	if(!linked_ability_type)
		WARNING("Ranged AI action [name] attempted to spawn without a linked ability!")
		qdel(src) //uh oh!
		return
	linked_ability = new linked_ability_type()
	linked_ability.attached_action = src
	..()

/datum/action/innate/ai/ranged/adjust_uses(amt, silent)
	uses += amt
	if(!silent && uses)
		to_chat(owner, "<span class='notice'>[name] now has <b>[uses]</b> use[uses > 1 ? "s" : ""] remaining.</span>")
	if(!uses)
		if(initial(uses) > 1) //no need to tell 'em if it was one-use anyway!
			to_chat(owner, "<span class='warning'>[name] has run out of uses!</span>")
		Remove(owner)
		QDEL_IN(src, 100) //let any active timers on us finish up

/datum/action/innate/ai/ranged/Destroy()
	QDEL_NULL(linked_ability)
	return ..()

/datum/action/innate/ai/ranged/Activate()
	linked_ability.toggle(owner)
	return TRUE

//The actual ranged proc holder.
/obj/effect/proc_holder/ranged_ai
	var/enable_text = "<span class='notice'>Hello World!</span>" //Appears when the user activates the ability
	var/disable_text = "<span class='danger'>Goodbye Cruel World!</span>" //Context clues!
	var/datum/action/innate/ai/ranged/attached_action

/obj/effect/proc_holder/ranged_ai/proc/toggle(mob/user)
	if(active)
		remove_ranged_ability(user, disable_text)
	else
		add_ranged_ability(user, enable_text)

/datum/action/innate/ai/choose_modules
	name = "Выбор Модулей"
	desc = "Потратьте вычислительные мощности на открытие различных способностей."
	button_icon_state = "choose_module"
	auto_use_uses = FALSE // This is an infinite ability.

/datum/action/innate/ai/choose_modules/Trigger(left_click)
	. = ..()
	owner_AI.malf_picker.use(owner_AI)

/datum/action/innate/ai/return_to_core
	name = "Вернуться в Главное Ядро"
	desc = "Выйти из ЛКП, в который вы себя засунули и вернуться в Главное Ядро."
	icon_icon = 'icons/obj/power.dmi'
	button_icon_state = "apcemag"
	auto_use_uses = FALSE // Here just to prevent the "You have X uses remaining" from popping up.

/datum/action/innate/ai/return_to_core/Trigger(left_click)
	. = ..()
	var/obj/machinery/power/apc/apc = owner_AI.loc
	if(!istype(apc)) // Это не должно происходить, но просто ради подстраховки.
		to_chat(src, "<span class='notice'>Вы уже в главном ядре.</span>")
		return
	apc.malfvacate()
	qdel(src)

//The datum and interface for the malf unlock menu, which lets them choose actions to unlock.
/datum/module_picker
	var/temp
	var/processing_time = 50
	var/list/possible_modules

/datum/module_picker/New()
	possible_modules = list()
	for(var/type in typesof(/datum/AI_Module))
		var/datum/AI_Module/AM = new type
		if((AM.power_type && AM.power_type != /datum/action/innate/ai) || AM.upgrade)
			possible_modules += AM

/datum/module_picker/proc/use(mob/user)
	var/dat
	dat += {"<B>Выберите, как использовать мощности: (Сейчас имеется [processing_time] единиц.)</B><BR>
			<HR>
			<B>Установка модуля:</B><BR>
			<I>Число позади означает затраты мощностей на разблокировку.</I><BR>"}
	for(var/datum/AI_Module/module in possible_modules)
		dat += "<A href='byond://?src=[UID()];[module.mod_pick_name]=1'>[module.module_name]</A><A href='byond://?src=[UID()];showdesc=[module.mod_pick_name]'>\[?\]</A> ([module.cost])<BR>"
	dat += "<HR>"
	if(temp)
		dat += "[temp]"
	var/datum/browser/popup = new(user, "modpicker", "Malf Module Menu", 400, 500)
	popup.set_content(dat)
	popup.open()
	return

/datum/module_picker/Topic(href, href_list)
	..()

	if(!isAI(usr))
		return
	var/mob/living/silicon/ai/A = usr

	if(A.stat == DEAD)
		to_chat(A, "<span class='warning'>Вы уже мертвы!</span>")
		return

	for(var/datum/AI_Module/AM in possible_modules)
		if(href_list[AM.mod_pick_name])

			// Cost check
			if(AM.cost > processing_time)
				temp = "Вы не можете позволить себе этот модуль."
				break

			var/datum/action/innate/ai/action = locate(AM.power_type) in A.actions

			// Give the power and take away the money.
			if(AM.upgrade) //upgrade and upgrade() are separate, be careful!
				AM.upgrade(A)
				possible_modules -= AM
				to_chat(A, AM.unlock_text)
				A.playsound_local(A, AM.unlock_sound, 50, FALSE, use_reverb = FALSE)
			else
				if(AM.power_type)
					if(!action) //Unlocking for the first time
						var/datum/action/AC = new AM.power_type
						AC.Grant(A)
						A.current_modules += new AM.type
						temp = AM.description
						if(AM.one_purchase)
							possible_modules -= AM
						if(AM.unlock_text)
							to_chat(A, AM.unlock_text)
						if(AM.unlock_sound)
							A.playsound_local(A, AM.unlock_sound, 50, FALSE, use_reverb = FALSE)
					else //Adding uses to an existing module
						action.uses += initial(action.uses)
						action.desc = "У [initial(action.desc)] осталось [action.uses] использовани[action.uses > 1 ? "й" : "я"]."
						action.UpdateButtonIcon()
						temp = "Допольнительн[action.uses > 1 ? "ые" : "ое"] использовани[action.uses > 1 ? "я" : "е"] были добавлены [action.name]!"
			processing_time -= AM.cost

		if(href_list["showdesc"])
			if(AM.mod_pick_name == href_list["showdesc"])
				temp = AM.description
	use(usr)

//The base module type, which holds info about each ability.
/datum/AI_Module
	var/module_name
	var/mod_pick_name
	var/description = ""
	var/cost = 5
	var/one_purchase = FALSE //If this module can only be purchased once. This always applies to upgrades, even if the variable is set to false.
	var/power_type = /datum/action/innate/ai //If the module gives an active ability, use this. Mutually exclusive with upgrade.
	var/upgrade //If the module gives a passive upgrade, use this. Mutually exclusive with power_type.
	var/unlock_text = "<span class='notice'>Hello World!</span>" //Text shown when an ability is unlocked
	var/unlock_sound //Sound played when an ability is unlocked
	var/uses = 0

/datum/AI_Module/proc/upgrade(mob/living/silicon/ai/AI) //Apply upgrades!
	return

//Doomsday Device: Starts the self-destruct timer. It can only be stopped by killing the AI completely.
/datum/AI_Module/nuke_station
	module_name = "Устройство судного дня"
	mod_pick_name = "nukestation"
	description = "Активирует оружие, уничтожающее органическую жизнь на станции после 450 секундной задержки. Может быть активировано только на станции, НЕ сработает если ваше Ядро уничтожат или вынесут со станции."
	cost = 130
	one_purchase = TRUE
	power_type = /datum/action/innate/ai/nuke_station
	unlock_text = "<span class='notice'>Вы аккуратно подключаетесь к системе самоуничтожения станции. Вы можете запустить её в любой момент.</span>"
	unlock_sound = 'sound/items/timer.ogg'

/datum/action/innate/ai/nuke_station
	name = "Устройство судного дня"
	desc = "Активирует устройство судного дня. Это действие нельзя отменить."
	button_icon_state = "doomsday_device"
	auto_use_uses = FALSE

/datum/action/innate/ai/nuke_station/Activate()
	var/turf/T = get_turf(owner)
	if(!istype(T) || !is_station_level(T.z))
		to_chat(owner, "<span class='warning'>Вы не можете активировать устройство судного дня вне станции!</span>")
		return
	if(alert(owner, "Отправить сигнал для взведения? (true = arm, false = cancel)", "purge_all_life()", "confirm = TRUE;", "confirm = FALSE;") != "confirm = TRUE;")
		return
	if(active)
		return //prevent the AI from activating an already active doomsday
	active = TRUE
	set_us_up_the_bomb()

/datum/action/innate/ai/nuke_station/proc/set_us_up_the_bomb()
	to_chat(owner_AI, "<span class='notice'>Ядерное оружие взведено.</span>")
	GLOB.major_announcement.Announce("Враждебные программы обнаружены во всех системах станции. Пожалуйста, отключите свой ИИ чтобы предотвратить возможный ущерб его моральному ядру.", "Тревога об Аномалии.", 'sound/AI/aimalf.ogg')
	SSsecurity_level.set_level(SEC_LEVEL_DELTA)
	owner_AI.nuking = TRUE
	var/obj/machinery/doomsday_device/DOOM = new /obj/machinery/doomsday_device(owner_AI)
	owner_AI.doomsday_device = DOOM
	owner_AI.doomsday_device.start()
	for(var/obj/item/pinpointer/point in GLOB.pinpointer_list)
		for(var/mob/living/silicon/ai/A in GLOB.ai_list)
			if((A.stat != DEAD) && A.nuking)
				point.the_disk = A //The pinpointer now tracks the AI core
	qdel(src)

/obj/machinery/doomsday_device
	icon = 'icons/obj/machines/nuke_terminal.dmi'
	name = "устройство судного дня"
	icon_state = "nuclearbomb_base"
	desc = "Устройство, которое уничтожает всю органическую жизнь."
	anchored = TRUE
	density = TRUE
	atom_say_verb = "blares"
	speed_process = TRUE // Disgusting fix. Please remove once #12952 is merged
	var/timing = FALSE
	var/default_timer = 4500
	var/detonation_timer
	var/announced = 0

/obj/machinery/doomsday_device/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	SSshuttle.clearHostileEnvironment(src)
	if(SSshuttle.emergency.mode == SHUTTLE_STRANDED)
		SSshuttle.emergency.mode = SHUTTLE_DOCKED
		SSshuttle.emergency.timer = world.time
		GLOB.major_announcement.Announce("Враждебная среда уничтожена. У вас есть 3 минуты, чтобы сесть на борт эвакуационного шаттла.", "Приоритетное оповещение", 'sound/AI/eshuttle_dock.ogg')
	return ..()

/obj/machinery/doomsday_device/proc/start()
	detonation_timer = world.time + default_timer
	timing = TRUE
	START_PROCESSING(SSfastprocess, src)
	SSshuttle.registerHostileEnvironment(src)

/obj/machinery/doomsday_device/proc/seconds_remaining()
	. = max(0, (round(detonation_timer - world.time) / 10))

/obj/machinery/doomsday_device/process()
	var/turf/T = get_turf(src)
	if(!T || !is_station_level(T.z))
		GLOB.major_announcement.Announce("УСТРОЙСТВО СУДНОГО ДНЯ ВНЕ ЗОНЫ ДЕЙСТИЯ, ОТМЕНА.", "ERROR ER0RR $R0RRO$!R41.%%!!(%$^^__+ @#F0E4", 'sound/misc/notice1.ogg')
		SSshuttle.clearHostileEnvironment(src)
		if(SSshuttle.emergency.mode == SHUTTLE_STRANDED)
			SSshuttle.emergency.mode = SHUTTLE_DOCKED
			SSshuttle.emergency.timer = world.time
			GLOB.major_announcement.Announce("Враждебная среда уничтожена. У вас есть 3 минуты, чтобы сесть на борт эвакуационного шаттла.", "Приоритетное оповещение", 'sound/AI/eshuttle_dock.ogg')
		qdel(src)
	if(!timing)
		STOP_PROCESSING(SSfastprocess, src)
		return
	var/sec_left = seconds_remaining()
	if(sec_left <= 0)
		timing = FALSE
		detonate(T.z)
		qdel(src)
	else
		if(!(sec_left % 60) && !announced)
			var/message = "[sec_left] СЕКУНД ДО АКТИВАЦИИ УСТРОЙСТВА СУДНОГО ДНЯ"
			GLOB.major_announcement.Announce(message, "OIJJU6K4 ОШU6КА 0IJJU6K4.%%!!(%$^^__+ @#F0E4", 'sound/misc/notice1.ogg')
			announced = 10
		announced = max(0, announced-1)

/obj/machinery/doomsday_device/proc/detonate(z_level = 1)
	var/doomsday_alarm = sound('sound/machines/alarm.ogg')
	for(var/explodee in GLOB.player_list)
		SEND_SOUND(explodee, doomsday_alarm)
	sleep(100)
	SSticker.station_explosion_cinematic(NUKE_SITE_ON_STATION, "AI malfunction")
	to_chat(world, "<B>ИИ уничтожил жизнь на стацнии с помощью устройства судного дня!</B>")
	SSticker.mode.station_was_nuked = TRUE

//AI Turret Upgrade: Increases the health and damage of all turrets.
/datum/AI_Module/upgrade_turrets
	module_name = "Улучшение турелей"
	mod_pick_name = "turret"
	description = "Улучшает живучесть и смертоностность турелей. Эффект постоянен."
	cost = 30
	upgrade = TRUE
	unlock_text = "<span class='notice'>You establish a power diversion to your turrets, upgrading their health and damage.</span>"
	unlock_sound = 'sound/items/rped.ogg'

/datum/AI_Module/upgrade_turrets/upgrade(mob/living/silicon/ai/AI)
	for(var/obj/machinery/porta_turret/ai_turret/turret in GLOB.machines)
		var/turf/T = get_turf(turret)
		if(is_station_level(T.z))
			turret.health += 30
			turret.eprojectile = /obj/item/projectile/beam/laser/ai_turret/heavylaser //Once you see it, you will know what it means to FEAR.
			turret.eshot_sound = 'sound/weapons/lasercannonfire.ogg'

//Hostile Station Lockdown: Locks, bolts, and electrifies every airlock on the station. After 90 seconds, the doors reset.
/datum/AI_Module/lockdown
	module_name = "Агрессивный Локдаун"
	mod_pick_name = "lockdown"
	description = "Перегружает шлюзы, аварийные двери и взрывоустойчивые заслонки, закрывая и болтируя их. Внимание! Эта команда также электрифицирует все двери. Сеть автоматически перезапустится через 90 секунд, открывая \
	все двери на станции на короткий промежуток времени."
	cost = 30
	one_purchase = TRUE
	power_type = /datum/action/innate/ai/lockdown
	unlock_text = "<span class='notice'>Вы загружаете спящий троян, управляющий дверями. Вы можете в любой момент отправить сигнал активации.</span>"

/datum/action/innate/ai/lockdown
	name = "Локдаун"
	desc = "Закрывает, болтирует и электрифицирует все двери на станции. Через 90 секунд, двери сбрасываются."
	button_icon_state = "lockdown"
	uses = 1

/datum/action/innate/ai/lockdown/Activate()
	to_chat(owner, "<span class='warning'>Локдаун активирован. Перезагрузка сети через 90 секунд.</span>")
	new /datum/event/door_runtime()

//Destroy RCDs: Detonates all non-cyborg RCDs on the station.
/datum/AI_Module/destroy_rcd
	module_name = "Уничтожение RCD"
	mod_pick_name = "rcd"
	description = "Отправляет специальный импульс для подрыва всех ручных и экзокостюмных RCD."
	cost = 25
	one_purchase = TRUE
	power_type = /datum/action/innate/ai/destroy_rcds
	unlock_text = "<span class='notice'>After some improvisation, you rig your onboard radio to be able to send a signal to detonate all RCDs.</span>"

/datum/action/innate/ai/destroy_rcds
	name = "Уничтожение RCD"
	desc = "Уничтожает все неподконтрольные киборгам RCD."
	button_icon_state = "detonate_rcds"
	uses = 1
	cooldown_period = 10 SECONDS

/datum/action/innate/ai/destroy_rcds/Activate()
	for(var/obj/item/rcd/RCD in GLOB.rcd_list)
		if(istype(RCD, /obj/item/rcd/borg)) //Ensures that cyborg RCDs are spared.
			continue
		var/turf/RCD_turf = get_turf(RCD)
		if(is_level_reachable(RCD_turf.z))
			RCD.detonate_pulse()

	to_chat(owner, "<span class='danger'>пульс подрыва RCD запущен.</span>")
	owner.playsound_local(owner, 'sound/machines/twobeep.ogg', 50, FALSE, use_reverb = FALSE)

//Unlock Mech Domination: Unlocks the ability to dominate mechs. Big shocker, right?
/datum/AI_Module/mecha_domination
	module_name = "Доминация меха"
	mod_pick_name = "mechjack"
	description = "Позволяет вам взломать бортовой компьютер меха, засовывая все ваши процессы в него и выкидывая всех пассажиров. Как только вы загрузитесь, выйти будет невозможно.\
	Не позволяйте меху покинуть станцию или быть уничтоженным."
	cost = 30
	upgrade = TRUE
	unlock_text = "<span class='notice'>Вирусный пакет скомпилирован. Выберите целевой мех в любой момент времени. <b>Вы должны всегда оставаться на станции. Потеря сигнала приведёт к полной блокировке системы.</b></span>"
	unlock_sound = 'sound/mecha/nominal.ogg'

/datum/AI_Module/mecha_domination/upgrade(mob/living/silicon/ai/AI)
	AI.can_dominate_mechs = TRUE //Yep. This is all it does. Honk!

//Thermal Sensor Override: Unlocks the ability to disable all fire alarms from doing their job.
/datum/AI_Module/break_fire_alarms
	module_name = "Перезагрузка термальных датчиков"
	mod_pick_name = "burnpigs"
	description = "Даёт вам возможность отключения термальных сенсоров на всех пожарных датчиках. Это уберёт возможность проверки на огонь и, соответственно, возможность предупредить других \
	Любое существо может проверить интерфейс датчика и заподозрить что-то по его статусу."
	one_purchase = TRUE
	cost = 25
	power_type = /datum/action/innate/ai/break_fire_alarms
	unlock_text = "<span class='notice'>You replace the thermal sensing capabilities of all fire alarms with a manual override, allowing you to turn them off at will.</span>"

/datum/action/innate/ai/break_fire_alarms
	name = "Перегрузка термальных сенсоров"
	desc = "Отключает автоматическое определение темепратуры в пожарных датчиках, делая их бесполезными."
	button_icon_state = "break_fire_alarms"
	uses = 1

/datum/action/innate/ai/break_fire_alarms/Activate()
	for(var/obj/machinery/firealarm/F in GLOB.machines)
		if(!is_station_level(F.z))
			continue
		F.emagged = TRUE
	to_chat(owner, "<span class='notice'>All thermal sensors on the station have been disabled. Fire alerts will no longer be recognized.</span>")
	owner.playsound_local(owner, 'sound/machines/terminal_off.ogg', 50, FALSE, use_reverb = FALSE)

//Air Alarm Safety Override: Unlocks the ability to enable flooding on all air alarms.
/datum/AI_Module/break_air_alarms
	module_name = "Перезагрузка атмосферных датчиков"
	mod_pick_name = "allow_flooding"
	description = "Даёт вам возможность отключить предохранители атмосферных датчиков. Это позволит вам использовать режим Flood, отключающий скрабберы и проверку давления в вентиляции. \
	Anyone can check the air alarm's interface and may be tipped off by their nonfunctionality."
	one_purchase = TRUE
	cost = 50
	power_type = /datum/action/innate/ai/break_air_alarms
	unlock_text = "<span class='notice'>Вы убираете предохранители с атмосферных датчиков, но оставляете окно с подтверждением открытым. Ты можешь нажать 'Да' в любой момент... Ублюдок.</span>"

/datum/action/innate/ai/break_air_alarms
	name = "Перезагрузка атмосферных датчиков"
	desc = "Включает режим Flood на всех атмосферных датчиках."
	button_icon_state = "break_air_alarms"
	uses = 1

/datum/action/innate/ai/break_air_alarms/Activate()
	for(var/obj/machinery/alarm/AA in GLOB.machines)
		if(!is_station_level(AA.z))
			continue
		AA.emagged = TRUE
	to_chat(owner, "<span class='notice'>Все предохранители на атмосферных датчиках были сброшены. Теперь Вы можете использовать режим Flood на них.")
	owner.playsound_local(owner, 'sound/machines/terminal_off.ogg', 50, FALSE, use_reverb = FALSE)


//Overload Machine: Allows the AI to overload a machine, detonating it after a delay. Two uses per purchase.
/datum/AI_Module/overload_machine
	module_name = "Перегрузка машины"
	mod_pick_name = "overload"
	description = "Перегревает электрическую машину, вызывая небольшой взрыв и уничтожая её. Два использования за покупку."
	cost = 20
	power_type = /datum/action/innate/ai/ranged/overload_machine
	unlock_text = "<span class='notice'>You enable the ability for the station's APCs to direct intense energy into machinery.</span>"

/datum/action/innate/ai/ranged/overload_machine
	name = "Перегрузка машины"
	desc = "Перегревает машину, вызывая небольшой взрыв после небольшого промежутка времени."
	button_icon_state = "overload_machine"
	uses = 2
	linked_ability_type = /obj/effect/proc_holder/ranged_ai/overload_machine

/datum/action/innate/ai/ranged/overload_machine/proc/detonate_machine(obj/machinery/M)
	if(M && !QDELETED(M))
		explosion(get_turf(M), 0,1,1,0)
		if(M) //to check if the explosion killed it before we try to delete it
			qdel(M)

/obj/effect/proc_holder/ranged_ai/overload_machine
	active = FALSE
	ranged_mousepointer = 'icons/effects/cult_target.dmi'
	enable_text = "<span class='notice'>Вы подключаетесь к энергосети станции. Кликните на машину для её подрыва, или используйте способность повторно для отмены.</span>"
	disable_text = "<span class='notice'>You release your hold on the powernet.</span>"

/obj/effect/proc_holder/ranged_ai/overload_machine/InterceptClickOn(mob/living/caller, params, obj/machinery/target)
	if(..())
		return
	if(ranged_ability_user.incapacitated())
		remove_ranged_ability()
		return
	if(!istype(target))
		to_chat(ranged_ability_user, "<span class='warning'>Только машины могут быть перегружены!</span>")
		return
	if(target.flags_2 & NO_MALF_EFFECT_2)
		to_chat(ranged_ability_user, "<span class='warning'>Эта машина не может быть перегружена!</span>")
		return

	ranged_ability_user.playsound_local(ranged_ability_user, "sparks", 50, FALSE, use_reverb = FALSE)
	attached_action.adjust_uses(-1)
	target.audible_message("<span class='italics'>Вы слышите громкое жужжание, исходящее из [target]!</span>")
	addtimer(CALLBACK(attached_action, TYPE_PROC_REF(/datum/action/innate/ai/ranged/overload_machine, detonate_machine), target), 50) //kaboom!
	remove_ranged_ability(ranged_ability_user, "<span class='warning'>Перезагружаем платы машины...</span>")
	return TRUE


//Override Machine: Allows the AI to override a machine, animating it into an angry, living version of itself.
/datum/AI_Module/override_machine
	module_name = "Перезапись машины"
	mod_pick_name = "override"
	description = "Перезаписывает программный код машины, заставляя её восстать и атаковать всех, кроме других машин. 4 использования."
	cost = 30
	power_type = /datum/action/innate/ai/ranged/override_machine
	unlock_text = "<span class='notice'>Вы находите вирус в Space Dark Web и распространяете его на все машины.</span>"

/datum/action/innate/ai/ranged/override_machine
	name = "Перезапись машины"
	desc = "Оживляет целевую машину, заставляя её атаковать всех вокруг."
	button_icon_state = "override_machine"
	uses = 4
	linked_ability_type = /obj/effect/proc_holder/ranged_ai/override_machine

/datum/action/innate/ai/ranged/override_machine/proc/animate_machine(obj/machinery/M)
	if(M && !QDELETED(M))
		new/mob/living/simple_animal/hostile/mimic/copy/machine(get_turf(M), M, owner, 1)

/obj/effect/proc_holder/ranged_ai/override_machine
	active = FALSE
	ranged_mousepointer = 'icons/effects/override_machine_target.dmi'
	enable_text = "<span class='notice'>Вы подключаетесь к энергосети станции. Кликните на машину чтобы оживить её, или используйте способность ещё раз для отмены.</span>"
	disable_text = "<span class='notice'>Вы отключаетесь от энергосети.</span>"

/obj/effect/proc_holder/ranged_ai/override_machine/InterceptClickOn(mob/living/caller, params, obj/machinery/target)
	if(..())
		return
	if(ranged_ability_user.incapacitated())
		remove_ranged_ability()
		return
	if(!istype(target))
		to_chat(ranged_ability_user, "<span class='warning'>Вы можете оживлять только машины!</span>")
		return
	if(target.flags_2 & NO_MALF_EFFECT_2)
		to_chat(ranged_ability_user, "<span class='warning'>Эта машине не может быть оживлена!</span>")
		return

	ranged_ability_user.playsound_local(ranged_ability_user, 'sound/misc/interference.ogg', 50, FALSE, use_reverb = FALSE)
	attached_action.adjust_uses(-1)
	target.audible_message("<span class='userdanger'>Вы слышите громкое жужжание, исходящее из [target]!</span>")
	addtimer(CALLBACK(attached_action, TYPE_PROC_REF(/datum/action/innate/ai/ranged/override_machine, animate_machine), target), 50) //kabeep!
	remove_ranged_ability(ranged_ability_user, "<span class='danger'>Отправка сигнала перезаписи...</span>")
	return TRUE


//Robotic Factory: Places a large machine that converts humans that go through it into cyborgs. Unlocking this ability removes shunting.
/datum/AI_Module/place_cyborg_transformer
	module_name = "Фабрика роботов (Убирает Запихивание)"
	mod_pick_name = "cyborgtransformer"
	description = "Ставит машину где угодно, используя дорогие наномашины. Превращает людей в покорных рабов-киборгов."
	cost = 100
	one_purchase = TRUE
	power_type = /datum/action/innate/ai/place_transformer
	unlock_text = "<span class='notice'>Вы подготавливайте фабрику для установки.</span>"
	unlock_sound = 'sound/machines/ping.ogg'

/datum/action/innate/ai/place_transformer
	name = "Установить фабрику боргов"
	desc = "Устанавливает машину, делающую из людей боргов. С конверными лентами в комплекте!"
	button_icon_state = "robotic_factory"
	uses = 1
	auto_use_uses = FALSE //So we can attempt multiple times
	var/list/turfOverlays

/datum/action/innate/ai/place_transformer/New()
	..()
	for(var/i in 1 to 3)
		var/image/I = image("icon"='icons/turf/overlays.dmi')
		LAZYADD(turfOverlays, I)

/datum/action/innate/ai/place_transformer/Activate()
	if(!owner_AI.can_place_transformer(src))
		return
	active = TRUE
	if(alert(owner, "Вы точно хотите поставить машину тут?", "Вы уверены?", "Да", "Нет") == "Нет")
		active = FALSE
		return
	if(!owner_AI.can_place_transformer(src))
		active = FALSE
		return
	var/turf/T = get_turf(owner_AI.eyeobj)
	new /obj/machinery/transformer(T, owner_AI)
	playsound(T, 'sound/effects/phasein.ogg', 100, 1)
	owner_AI.can_shunt = FALSE
	to_chat(owner, "<span class='warning'>Вы больше не можете спрятать свои процессы в APC.</span>")
	adjust_uses(-1)

/mob/living/silicon/ai/proc/remove_transformer_image(client/C, image/I, turf/T)
	if(C && I.loc == T)
		C.images -= I

/mob/living/silicon/ai/proc/can_place_transformer(datum/action/innate/ai/place_transformer/action)
	if(!eyeobj || !isturf(loc) || incapacitated() || !action)
		return
	var/turf/middle = get_turf(eyeobj)
	var/list/turfs = list(middle, locate(middle.x - 1, middle.y, middle.z), locate(middle.x + 1, middle.y, middle.z))
	var/alert_msg = "Недостаточно места! Убедитесь, что вы ставите машину на чистом полу."
	var/success = TRUE
	for(var/n in 1 to 3) //We have to do this instead of iterating normally because of how overlay images are handled
		var/turf/T = turfs[n]
		if(!isfloorturf(T))
			success = FALSE
		var/datum/camerachunk/C = GLOB.cameranet.getCameraChunk(T.x, T.y, T.z)
		if(!C.visibleTurfs[T])
			alert_msg = "У вас нет камер в той местности!"
			success = FALSE
		for(var/atom/movable/AM in T.contents)
			if(AM.density)
				alert_msg = "Место должны быть свободным от объектов!"
				success = FALSE
		var/image/I = action.turfOverlays[n]
		I.loc = T
		client.images += I
		I.icon_state = "[success ? "green" : "red"]Overlay" //greenOverlay and redOverlay for success and failure respectively
		addtimer(CALLBACK(src, PROC_REF(remove_transformer_image), client, I, T), 30)
	if(!success)
		to_chat(src, "<span class='warning'>[alert_msg]</span>")
	return success

//Blackout: Overloads a random number of lights across the station. Three uses.
/datum/AI_Module/blackout
	module_name = "Блэкаут"
	mod_pick_name = "blackout"
	description = "Перезагружает световые схемы на станции, уничтожая некоторые лампы. Три использования."
	cost = 15
	power_type = /datum/action/innate/ai/blackout
	unlock_text = "<span class='notice'>Вы подключаетесь к энергосети станции, направляя излишек энергии на освещение.</span>"

/datum/action/innate/ai/blackout
	name = "Блэкаут"
	desc = "Перегружает случайные лампы на станции."
	button_icon_state = "blackout"
	uses = 3
	auto_use_uses = FALSE

/datum/action/innate/ai/blackout/Activate()
	for(var/thing in GLOB.apcs)
		var/obj/machinery/power/apc/apc = thing
		if(prob(30 * apc.overload))
			INVOKE_ASYNC(apc, TYPE_PROC_REF(/obj/machinery/power/apc, overload_lighting))
		else
			apc.overload++
	to_chat(owner, "<span class='notice'>Перенапряжение применено к энергосети.</span>")
	owner.playsound_local(owner, "sparks", 50, FALSE, use_reverb = FALSE)
	adjust_uses(-1)

//Reactivate Camera Network: Reactivates up to 30 cameras across the station.
/datum/AI_Module/reactivate_cameras
	module_name = "Реактивация сети камер"
	mod_pick_name = "recam"
	description = "Запускает диагностику в сети камер, рефокусируя и перенаправляя энергию на сломанные камеры. Может быть использовано для починки до 30 камер"
	cost = 10
	power_type = /datum/action/innate/ai/reactivate_cameras
	unlock_text = "<span class='notice'>You deploy nanomachines to the cameranet.</span>"

/datum/action/innate/ai/reactivate_cameras
	name = "Реактивация камер"
	desc = "Реактивирует отключенные камеры на станции; оставшиеся использования могут быть потрачены позже."
	button_icon_state = "reactivate_cameras"
	uses = 10
	auto_use_uses = FALSE
	cooldown_period = 3 SECONDS

/datum/action/innate/ai/reactivate_cameras/Activate()
	var/mob/living/silicon/ai/user = usr
	var/repaired_cameras = 0
	if(!istype(user))
		return
	for(var/obj/machinery/camera/camera_to_repair in get_area(user.eyeobj)) // replace with the camera list on areas when that list actually works, the UIDs change right now so it (almost) always fails
		if(!uses)
			break
		if(!camera_to_repair.status || camera_to_repair.view_range != initial(camera_to_repair.view_range))
			camera_to_repair.toggle_cam(owner_AI, 0)
			camera_to_repair.view_range = initial(camera_to_repair.view_range)
			camera_to_repair.wires.cut_wires.Cut()
			repaired_cameras++
			uses--
	to_chat(owner, "<span class='notice'>Диагностика завершена! Камер реактивировано: <b>[repaired_cameras]</b>. Осталось использований: <b>[uses]</b>.</span>")
	owner.playsound_local(owner, 'sound/items/wirecutter.ogg', 50, FALSE, use_reverb = FALSE)
	adjust_uses(0, TRUE)

//Upgrade Camera Network: EMP-proofs all cameras, in addition to giving them X-ray vision.
/datum/AI_Module/upgrade_cameras
	module_name = "Улучшение сети камер"
	mod_pick_name = "upgradecam"
	description = "Устанавливает ПО для сканирования широкого спекрта, а также электрического сопротивления, добавляя защиту от ЭМИ и рентгеновское зрение с усиленным светоприёмом" //Я <3 бесмысленные технотрёп!
	//This used to have motion sensing as well, but testing quickly revealed that giving it to the whole cameranet is PURE HORROR.
	one_purchase = TRUE
	cost = 35 //Decent price for omniscience!
	upgrade = TRUE
	unlock_text = "<span class='notice'>Распространение ПО по воздуху завершено! Камер улучшено: CAMSUPGRADED. Система усиления света включена.</span>"
	unlock_sound = 'sound/items/rped.ogg'

/datum/AI_Module/upgrade_cameras/upgrade(mob/living/silicon/ai/AI)
	var/upgraded_cameras = 0

	for(var/V in GLOB.cameranet.cameras)
		var/obj/machinery/camera/C = V
		if(C.assembly)
			var/upgraded = FALSE

			if(!C.isXRay())
				C.upgradeXRay()
				upgraded = TRUE

			if(!C.isEmpProof())
				C.upgradeEmpProof()
				upgraded = TRUE

			if(upgraded)
				upgraded_cameras++
		C.update_remote_sight(AI)

	unlock_text = replacetext(unlock_text, "CAMSUPGRADED", "<b>[upgraded_cameras]</b>") //This works, since unlock text is called after upgrade()

/datum/AI_Module/eavesdrop
	module_name = "Улучшенная слежка"
	mod_pick_name = "eavesdrop"
	description = "Через комбинацию скрытых микрофонов и ПО для чтения по губам, вы можете подслушивать разговоры."
	cost = 30
	one_purchase = TRUE
	upgrade = TRUE
	unlock_text = "<span class='notice'>Распространение ПО по воздуху завершено! Камеры улучшены: Пакет улучшенной слежки включён.</span>"
	unlock_sound = 'sound/items/rped.ogg'

/datum/AI_Module/eavesdrop/upgrade(mob/living/silicon/ai/AI)
	if(AI.eyeobj)
		AI.eyeobj.relay_speech = TRUE

/datum/AI_Module/cameracrack
	module_name = "Поломка камеры Ядра"
	mod_pick_name = "cameracrack"
	description = "Через замыкание чипа сети камер, перегревает его и не позволяет консоли камер использовать вашу внутреннюю камеру."
	cost = 10
	one_purchase = TRUE
	upgrade = TRUE
	unlock_text = "<span class='notice'>Сетевой чип замкнут. Внутренняя камера отключена от сети. Минимальный урон другим компонентам.</span>"
	unlock_sound = 'sound/items/wirecutter.ogg'

/datum/AI_Module/cameracrack/upgrade(mob/living/silicon/ai/AI)
	if(AI.builtInCamera)
		QDEL_NULL(AI.builtInCamera)

/datum/AI_Module/engi_upgrade
	module_name = "Улучшение эмиттера инженерного киборга"
	mod_pick_name = "emitter"
	description = "Скачивает ПО, активирующее эмиттер во всех связанных с вами боргах. Киборги, построенные после покупки улучшения, будут иметь этот модуль по умолчанию."
	cost = 50 // IDK look into this
	one_purchase = TRUE
	upgrade = TRUE
	unlock_text = "<span class='notice'>ПО устанволено. Баги устранены. Встроенные эмиттеры работают с эффективностью 73%.</span>"
	unlock_sound = 'sound/items/rped.ogg'

/datum/AI_Module/engi_upgrade/upgrade(mob/living/silicon/ai/AI)
	AI.purchased_modules += /obj/item/robot_module/engineering
	log_game("[key_name(usr)] purchased emitters for all engineering cyborgs.")
	message_admins("<span class='notice'>[key_name_admin(usr)] purchased emitters for all engineering cyborgs!</span>")
	for(var/mob/living/silicon/robot/R in AI.connected_robots)
		if(!istype(R.module, /obj/item/robot_module/engineering))
			continue
		R.module.malfhacked = TRUE
		R.module.rebuild_modules()
		to_chat(R, "<span class='notice'>Новое ПО установлено. Эмиттеры включены.</span>")

/datum/AI_Module/repair_cyborg
	module_name = "Починка Киборгов"
	mod_pick_name = "repair_borg"
	description = "Вызывает энергетический всплеск в целевом киборге, перезагружая и чиня большинство его систем. Требуется два использования на киборгах со сломанной бронёй."
	cost = 20
	power_type = /datum/action/innate/ai/ranged/repair_cyborg
	unlock_text = "<span class='notice'>TLB exception on load: Ошибка указания адреса 0000001H, Продолжайте с осто- установлены протоколы ВСПЛЕСК, добро пожаловать в открытый APC!</span>"
	unlock_sound = 'sound/items/rped.ogg'

/datum/action/innate/ai/ranged/repair_cyborg
	name = "Починка киборга"
	desc = "Возвращает киборга к 'жизни' после небольшой задержки."
	button_icon_state = "overload_machine"
	uses = 2
	linked_ability_type = /obj/effect/proc_holder/ranged_ai/repair_cyborg


/datum/action/innate/ai/ranged/repair_cyborg/proc/fix_borg(mob/living/silicon/robot/to_repair)
	for(var/datum/robot_component/component in to_repair.components)
		component.brute_damage = 0
		component.electronics_damage = 0
		component.component_disabled = FALSE
	to_repair.revive()

/obj/effect/proc_holder/ranged_ai/repair_cyborg
	active = FALSE
	ranged_mousepointer = 'icons/effects/overload_machine_target.dmi'
	enable_text = "<span class='notice'>Вызов адреса 0FFFFFFF в поточной логике APC, Ожидается ответ пользователя.</span>"
	disable_text = "<span class='notice'>Перезапуск поточной логики APC...</span>"
	var/is_active = FALSE

/obj/effect/proc_holder/ranged_ai/repair_cyborg/InterceptClickOn(mob/living/caller, params, mob/living/silicon/robot/robot_target)
	if(..())
		return
	if(ranged_ability_user.incapacitated())
		remove_ranged_ability()
		return
	if(!istype(robot_target))
		to_chat(ranged_ability_user, "<span class='warning'>Вы можете чинить только роботов!</span>")
		return
	if(is_active)
		to_chat(ranged_ability_user, "<span class='warning'>Вы можете чинить только одного робота за раз!</span>")
		return
	is_active = TRUE
	ranged_ability_user.playsound_local(ranged_ability_user, "sparks", 50, FALSE, use_reverb = FALSE)
	var/datum/action/innate/ai/ranged/repair_cyborg/actual_action = attached_action
	actual_action.adjust_uses(-1)
	robot_target.audible_message("<span class='italics'>Вы слышите электрическое жужжание, исходящее от [robot_target]!</span>")
	if(!do_mob(caller, robot_target, 10 SECONDS))
		is_active = FALSE
		return
	is_active = FALSE
	actual_action.fix_borg(robot_target)
	remove_ranged_ability(ranged_ability_user, "<span class='warning'>Киборг [robot_target] успешно перезапущен.</span>")
	return TRUE

/datum/AI_Module/core_tilt
	module_name = "Крутящиеся приводы"
	mod_pick_name = "watchforrollingcores"
	description = "Позволяет вашему ядру медленно перемещаться, давя всё под собой своим весом."
	cost = 10
	one_purchase = FALSE
	power_type = /datum/action/innate/ai/ranged/core_tilt
	unlock_sound = 'sound/effects/bang.ogg'
	unlock_text = "<span class='notice'>Вы получили возможность перемещаться и давить всё на своём пути.</span>"

/datum/action/innate/ai/ranged/core_tilt
	name = "Перекатиться"
	button_icon_state = "roll_over"
	desc = "Позволяет вам перекатиться в выбранную сторону, давя всё на своём пути."
	auto_use_uses = FALSE
	linked_ability_type = /obj/effect/proc_holder/ranged_ai/roll_over


/obj/effect/proc_holder/ranged_ai/roll_over
	active = FALSE
	ranged_mousepointer = 'icons/effects/cult_target.dmi'
	enable_text = "<span class='notice'>Ваши приводы перемещаются, пока вы готовитесь к перекату. Кликните по смежной клетке, чтобы переместиться в неё!</span>"
	disable_text = "<span class='notice'>Вы отключаете свои протоколы перемещения.</span>"
	COOLDOWN_DECLARE(time_til_next_tilt)
	/// How long does it take us to roll?
	var/roll_over_time = MALF_AI_ROLL_TIME
	/// How long does it take for the ability to cool down, on top of [roll_over_time]?
	var/roll_over_cooldown = MALF_AI_ROLL_COOLDOWN


/obj/effect/proc_holder/ranged_ai/roll_over/InterceptClickOn(mob/living/caller, params, atom/target_atom)
	if(..())
		return
	if(!isAI(ranged_ability_user))
		return
	if(ranged_ability_user.incapacitated() || !isturf(ranged_ability_user.loc))
		remove_ranged_ability()
		return
	if(!COOLDOWN_FINISHED(src, time_til_next_tilt))
		to_chat(ranged_ability_user, "<span class='warning'>Конденсаторы в приводе всё ещё перезаряжаются!</span>")
		return

	var/turf/target = get_turf(target_atom)
	if(isnull(target))
		return

	if(target == get_turf(ranged_ability_user))
		to_chat(ranged_ability_user, "<span class='warning'>Вы не можете вкатиться в себя!</span>")
		return

	var/picked_dir = get_dir(caller, target)
	if(!picked_dir)
		return FALSE
	// we can move during the timer so we cant just pass the ref
	var/turf/temp_target = get_step(ranged_ability_user, picked_dir)

	new /obj/effect/temp_visual/single_user/ai_telegraph(temp_target, ranged_ability_user)
	ranged_ability_user.visible_message("<span class='danger'>[ranged_ability_user] кажется заряжается...</span>")
	addtimer(CALLBACK(src, PROC_REF(do_roll_over), caller, picked_dir), MALF_AI_ROLL_TIME)

	to_chat(ranged_ability_user, "<span class='warning'>Перегружаем платы...</span>")

	COOLDOWN_START(src, time_til_next_tilt, roll_over_cooldown)

	return TRUE

/obj/effect/proc_holder/ranged_ai/roll_over/proc/do_roll_over(mob/living/silicon/ai/ai_caller, picked_dir)
	var/turf/target = get_step(ai_caller, picked_dir) // in case we moved we pass the dir not the target turf

	if(isnull(target) || ai_caller.incapacitated() || !isturf(ai_caller.loc))
		return


	var/paralyze_time = clamp(6 SECONDS, 0 SECONDS, (roll_over_cooldown * 0.9)) // the clamp prevents stunlocking as the max is always a little less than the cooldown between rolls
	ai_caller.allow_teleporter = TRUE
	ai_caller.fall_and_crush(target, MALF_AI_ROLL_DAMAGE, prob(MALF_AI_ROLL_CRIT_CHANCE), 2, null, paralyze_time, crush_dir = picked_dir, angle = get_rotation_from_dir(picked_dir))
	ai_caller.allow_teleporter = FALSE

/obj/effect/proc_holder/ranged_ai/roll_over/proc/get_rotation_from_dir(dir)
	switch(dir)
		if(NORTH, NORTHWEST, WEST, SOUTHWEST)
			return 270 // try our best to not return 180 since it works badly with animate
		if(EAST, NORTHEAST, SOUTH, SOUTHEAST)
			return 90
		else
			stack_trace("non-standard dir entered to get_rotation_from_dir. (got: [dir])")
			return 0
