GLOBAL_DATUM(plmaster, /obj/effect/overlay)
GLOBAL_DATUM(slmaster, /obj/effect/overlay)
GLOBAL_DATUM(wvmaster, /obj/effect/overlay)

GLOBAL_VAR_INIT(CELLRATE, 0.002)  // conversion ratio between a watt-tick and kilojoule
GLOBAL_VAR_INIT(CHARGELEVEL, 0.001) // Cap for how fast cells charge, as a percentage-per-tick (.001 means cellcharge is capped to 1% per second)

// Announcer intercom, because too much stuff creates an intercom for one message then qdel()s it.
GLOBAL_DATUM_INIT(global_announcer, /obj/item/radio/intercom, create_global_announcer())
GLOBAL_DATUM_INIT(command_announcer, /obj/item/radio/intercom/command, create_command_announcer())

// Load order issues means this can't be new'd until other code runs
// This is probably not the way I should be doing this, but I don't know how to do it right!
/proc/create_global_announcer()
	spawn(0)
		GLOB.global_announcer = new(null)
		GLOB.global_announcer.config(list("Common", "Engineering", "Medical", "Supply", "Command", "Science", "Service", "Security", "Procedure"))
	return

/proc/create_command_announcer()
	spawn(0)
		GLOB.command_announcer = new(null)
	return

///Library Catalog global is for storing a library catalog datum that will track book, category, and report lists for the library
GLOBAL_DATUM_INIT(library_catalog, /datum/library_catalog, new())

GLOBAL_LIST_INIT(paper_tag_whitelist, list("center","p","div","span","h1","h2","h3","h4","h5","h6","hr","pre",	\
	"big","small","font","i","u","b","s","sub","sup","tt","br","hr","ol","ul","li","caption","col",	\
	"table","td","th","tr"))
GLOBAL_LIST_INIT(paper_blacklist, list("java","onblur","onchange","onclick","ondblclick","onfocus","onkeydown",	\
	"onkeypress","onkeyup","onload","onmousedown","onmousemove","onmouseout","onmouseover",	\
	"onmouseup","onreset","onselect","onsubmit","onunload"))

GLOBAL_VAR_INIT(gravity_is_on, 1) //basically unused, just one admin verb..

#define TAB "&nbsp;&nbsp;&nbsp;&nbsp;"

GLOBAL_VAR_INIT(timezoneOffset, 0) // The difference betwen midnight (of the host computer) and 0 world.ticks.

// For FTP requests. (i.e. downloading runtime logs.)
// However it'd be ok to use for accessing attack logs and such too, which are even laggier.
GLOBAL_VAR_INIT(fileaccess_timer, 0)

GLOBAL_VAR_INIT(gametime_offset, 432000) // 12:00 in seconds

GLOBAL_DATUM_INIT(data_core, /datum/datacore, new) // Station datacore, manifest, etc

//Defines for MODlink frequencies
#define MODLINK_FREQ_NANOTRASEN "NT"
#define MODLINK_FREQ_SYNDICATE "SYND"
#define MODLINK_FREQ_THETA "THET"
#define MODLINK_FREQ_CENTCOM "CC"

/// Global list of all /datum/mod_theme
GLOBAL_LIST_INIT(mod_themes, setup_mod_themes())

/// Global list of all ids associated to a /datum/mod_link instance
GLOBAL_LIST_EMPTY(mod_link_ids)

GLOBAL_DATUM(main_supermatter_engine, /obj/machinery/atmospherics/supermatter_crystal)

GLOBAL_DATUM(main_fission_reactor, /obj/machinery/atmospherics/fission_reactor)

///Global list for descriptors
// SS220 EDIT START - Translated to RU
/// Physique defines
#define PHYSIQUE_SKINNY        "костлявым"
#define PHYSIQUE_FRAGILE       "хрупким"
#define PHYSIQUE_SLIM          "худощавым"
#define PHYSIQUE_DRY           "сухим"
#define PHYSIQUE_LANKY         "долговязым"
#define PHYSIQUE_WORN          "потрёпанным"
#define PHYSIQUE_AVERAGE       "обычным"
#define PHYSIQUE_LEAN          "стройным"
#define PHYSIQUE_FIT           "подтянутым"
#define PHYSIQUE_STOCKY        "крепким"
#define PHYSIQUE_MUSCULAR      "мускулистым"
#define PHYSIQUE_ATHLETIC      "атлетичным"
#define PHYSIQUE_RIPPED        "рельефным"
#define PHYSIQUE_PLUMP         "пухлым"
#define PHYSIQUE_FAT           "разжиревшим"

/// Height defines
#define HEIGHT_DWARF           "карликового"
#define HEIGHT_VERY_SHORT      "крайне низкого"
#define HEIGHT_SHORT           "низкого"
#define HEIGHT_AVERAGE         "обычного"
#define HEIGHT_TALL            "высокого"
#define HEIGHT_VERY_TALL       "очень высокого"
#define HEIGHT_GIANT           "гигантского"

GLOBAL_LIST_INIT(character_physiques, list(PHYSIQUE_SKINNY, PHYSIQUE_FRAGILE, PHYSIQUE_SLIM, PHYSIQUE_DRY, PHYSIQUE_LANKY, PHYSIQUE_WORN, PHYSIQUE_AVERAGE, PHYSIQUE_LEAN, PHYSIQUE_FIT, PHYSIQUE_STOCKY, PHYSIQUE_MUSCULAR, PHYSIQUE_ATHLETIC, PHYSIQUE_RIPPED, PHYSIQUE_PLUMP, PHYSIQUE_FAT))

GLOBAL_LIST_INIT(character_heights, list(HEIGHT_DWARF, HEIGHT_VERY_SHORT, HEIGHT_SHORT, HEIGHT_AVERAGE, HEIGHT_TALL, HEIGHT_VERY_TALL, HEIGHT_GIANT))

// SS220 EDIT END

#define GLOBAL_SPARK_LIMIT 500
/// Counter for the current amount of sparks
GLOBAL_VAR_INIT(sparks_active, 0)

#define GLOBAL_SMOKE_LIMIT 200
///Counter for the current amount of smoke
GLOBAL_VAR_INIT(smokes_active, 0)

/// what xeno organs have been scanned today?
GLOBAL_LIST_EMPTY(scanned_organs)

/// A list of types of objects we want to record in admin logs when
/// a player starts pulling them.
GLOBAL_LIST_INIT(log_pulltypes, list(
	/mob/living,
	/obj/structure/reagent_dispensers,
	/obj/machinery/atmospherics/portable/canister,
))
