/datum/game_test/attack_chain_cult_dagger/Run()
	var/datum/test_puppeteer/cultist = new(src)
	var/datum/test_puppeteer/victim = cultist.spawn_puppet_nearby()
	var/datum/test_puppeteer/cultist_bro = cultist.spawn_puppet_nearby()

	cultist.puppet.mind.add_antag_datum(/datum/antagonist/cultist)
	cultist_bro.puppet.mind.add_antag_datum(/datum/antagonist/cultist)
	cultist.spawn_obj_in_hand(/obj/item/melee/cultblade/dagger)
	cultist.set_intent("harm")

	TEST_ASSERT_EQUAL(victim.puppet.health, victim.puppet.getMaxHealth(), "victim puppet is damaged before tests")
	TEST_ASSERT_EQUAL(cultist_bro.puppet.health, cultist_bro.puppet.getMaxHealth(), "cultist puppet is damaged before tests")
	TEST_ASSERT(istype(cultist.puppet.get_active_hand(), /obj/item/melee/cultblade/dagger), "cultist's active hand has no dagger")

	cultist.click_on(victim)
	sleep(2 SECONDS)
	cultist.click_on(cultist_bro)

	for(var/log_text in victim.puppet.attack_log_old)
		log_world("victim: " + log_text)

	for(var/log_text in cultist_bro.puppet.attack_log_old)
		log_world("cultist_bro: " + log_text)

	TEST_ASSERT(victim.check_attack_log("Attacked with ritual dagger"), "non-cultist missing dagger attack log")
	TEST_ASSERT_NOTEQUAL(victim.puppet.health, victim.puppet.getMaxHealth(), "cultist attacking non-cultist with dagger caused no damage")
	TEST_ASSERT_EQUAL(cultist_bro.puppet.health, cultist_bro.puppet.getMaxHealth(), "cultist attacking cultist with dagger caused damage")
