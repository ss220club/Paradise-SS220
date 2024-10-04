/*
=== Компонент разложения и восстановления органов ===
Запускает процессинг, отслеживающий состояние органов, контролирует их разложение в случае смерти владельца, в случае изъятия.

В случае, если орган в теле носителя или не уничтожается и его урон ниже 25%, то происходит постепенное самовосстановление
*/

#define BASIC_RECOVER_VALUE 0.02
#define BASIC_DECAY_VALUE 0.5

/datum/component/organ_decay
	var/obj/item/organ/internal/organ = null
	var/recover_rate
	var/decay_rate

/datum/component/organ_decay/Initialize(var/income_decay_rate = BASIC_RECOVER_VALUE, var/income_recover_rate = BASIC_DECAY_VALUE)
	. = ..()
	organ = parent
	recover_rate = income_recover_rate
	decay_rate = income_decay_rate
	START_PROCESSING(SSdcs, src)

/datum/component/organ_decay/Destroy(force, silent)
	STOP_PROCESSING(SSdcs, src)
	. = ..()

/datum/component/organ_decay/process()
	if(organ.status & ORGAN_DEAD)
		return

	var/is_no_owner = isnull(organ.owner)
	var/is_dead = (is_no_owner ? FALSE : organ.owner.stat == DEAD)

	var/is_destroying = (is_dead || (is_no_owner && !organ.is_in_freezer))
	if(is_destroying)
		organ.receive_damage(decay_rate, 1)
	if((organ.damage <= (organ.max_damage/4)) && (organ.damage > 0) && !is_destroying)
		organ.heal_internal_damage(recover_rate, FALSE)
