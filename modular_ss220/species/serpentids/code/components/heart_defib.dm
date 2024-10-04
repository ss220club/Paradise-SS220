/*
=== Компонент запуска сердца ===
Отслеживает смерть носителя, и в случае чего - запускает сердце с неким шансом
*/
/datum/component/defib_heart
	var/mob/living/carbon/human/owner = null
	var/chemical_id = ""

/datum/component/defib_heart/Initialize(var/human, var/income_chemical_id = "")
	. = ..()
	owner = human
	chemical_id = income_chemical_id
	START_PROCESSING(SSdcs, src)

/datum/component/defib_heart/Destroy(force, silent)
	STOP_PROCESSING(SSdcs, src)
	. = ..()

/datum/component/defib_heart/process()
	if(!(owner))
		var/obj/item/organ/internal/limb = parent
		owner = limb.owner
	else if(owner.get_chemical_value(chemical_id) >= 0 && owner.stat == DEAD && owner.get_damage_amount() <= 100)
		var/defib_chance = owner.get_chemical_value(chemical_id)
		var/datum/reagent/chem = owner.get_chemical_path(chemical_id)
		chem.holder.remove_reagent(chemical_id, owner.get_chemical_value(chemical_id))
		if(prob(defib_chance))
			owner.setOxyLoss(0)
			owner.set_heartattack(FALSE)
			owner.update_revive()
			owner.KnockOut()
			owner.Paralyse(10 SECONDS)
			owner.emote("gasp")
			SEND_SIGNAL(owner, COMSIG_LIVING_MINOR_SHOCK, 100)
			owner.med_hud_set_health()
			owner.med_hud_set_status()
			add_attack_logs(owner, owner, "Revived by heart")
			SSblackbox.record_feedback("tally", "players_revived", 1, "self_revived")
