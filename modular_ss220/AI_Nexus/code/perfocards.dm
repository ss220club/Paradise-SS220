// ══════════════════════════════════════════════════════════════════════════
// ПЕРФОКАРТА
// ══════════════════════════════════════════════════════════════════════════

/obj/item/perfocard
	name = "перфокарта"
	desc = "Продолговатая пластина с рядами перфорации и вплавленным шифро-чипом. Судя по всему, что-то экранирует её от банального сканирования."
	icon = 'modular_ss220/aesthetics/better_ids/icons/card.dmi'
	icon_state = "data"
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	throw_speed = 3
	throw_range = 5

	/// Уровень доступа перфокарты. 1 = базовая (РД), 2 = Т2 (ОБР)
	var/access_tier = 1
	/// Уникальный шифр-ключ, который сверяется системой КУД (условность под РП)
	var/cipher_key

/obj/item/perfocard/Initialize(mapload)
	. = ..()
	cipher_key = generate_perfocard_key()

/obj/item/perfocard/proc/generate_perfocard_key()
	// заглушка — потом можно завязать на seed раунда/GUID сервера
	return "[rand(1000, 9999)]-[rand(1000, 9999)]"

/obj/item/perfocard/t2
	name = "перфокарта Т2"
	desc = "Та же перфокарта, но шифр-чип выглядит куда сложнее — похоже, кто-то из отряда быстрого реагирования получил расширенный доступ."
	icon_state = "data" // отдельный спрайт — заведёте, когда будет иконка; иначе оставить "data"
	access_tier = 2
