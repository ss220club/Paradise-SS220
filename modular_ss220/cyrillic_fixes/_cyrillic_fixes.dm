/datum/modpack/cyrillic_fixes
	name = "Cyrillic Fixes"
	desc = "Adds Cyrillic support"
	author = "larentoun"

/datum/modpack/cyrillic_fixes/pre_initialize()
	. = ..()

/datum/modpack/cyrillic_fixes/initialize()
	. = ..()

/datum/modpack/cyrillic_fixes/post_initialize()
	. = ..()
	update_cyrillic_radio()

/datum/modpack/cyrillic_fixes/proc/update_cyrillic_radio()
	GLOB.department_radio_keys = list(
/*
	Busy letters by languages:
	a b d f g j k o q v x y
	aa as bo db fa fm fn fs vu

	Busy symbols by languages:
	0 1 2 3 4 5 6 7 8 9
	% ? ^ '

	Busy letters by radio(eng):
	c e h i l m n p r s t u w x z

	Busy letters by radio(rus):
	б г д е ё з к р с т у ц ч ш ы ь я Э

	Busy symbols by radio:
	~ , $ _ - + *

	CAUTION! The key must not repeat the key of the languages (language.dm)
	and must not contain prohibited characters
*/
	// English text lowercase
	  ":r" = "right ear",		"#r" = "right ear",		"№r" = "right ear",		".r" = "right ear",
	  ":l" = "left ear",		"#l" = "left ear",		"№l" = "left ear",		".l" = "left ear",
	  ":i" = "intercom",		"#i" = "intercom",		"№i" = "intercom",		".i" = "intercom",
	  ":h" = "department",		"#h" = "department",	"№h" = "department",	".h" = "department",
	  ":c" = "Command",			"#c" = "Command",		"№c" = "Command",		".c" = "Command",
	  ":n" = "Science",			"#n" = "Science",		"№n" = "Science",		".n" = "Science",
	  ":m" = "Medical",			"#m" = "Medical",		"№m" = "Medical",		".m" = "Medical",
	  ":x" = "Procedure",		"#x" = "Procedure",		"№x" = "Procedure",		".x" = "Procedure",
	  ":e" = "Engineering", 	"#e" = "Engineering",	"№e" = "Engineering",	".e" = "Engineering",
	  ":s" = "Security",		"#s" = "Security",		"№s" = "Security",		".s" = "Security",
	  ":w" = "whisper",			"#w" = "whisper",		"№w" = "whisper",		".w" = "whisper",
	  ":t" = "Syndicate",		"#t" = "Syndicate",		"№t" = "Syndicate",		".t" = "Syndicate",
	  ":u" = "Supply",			"#u" = "Supply",		"№u" = "Supply",		".u" = "Supply",
	  ":z" = "Service",			"#z" = "Service",		"№z" = "Service",		".z" = "Service",
	  ":p" = "AI Private",		"#p" = "AI Private",	"№p" = "AI Private",	".p" = "AI Private",

	// English text uppercase
	  ":R" = "right ear",		"#R" = "right ear",		"№R" = "right ear",		".R" = "right ear",
	  ":L" = "left ear",		"#L" = "left ear",		"№L" = "left ear",		".L" = "left ear",
	  ":I" = "intercom",		"#I" = "intercom",		"№I" = "intercom",		".I" = "intercom",
	  ":H" = "department",		"#H" = "department",	"№H" = "department",	".H" = "department",
	  ":C" = "Command",			"#C" = "Command",		"№C" = "Command",		".C" = "Command",
	  ":N" = "Science",			"#N" = "Science",		"№N" = "Science",		".N" = "Science",
	  ":M" = "Medical",			"#M" = "Medical",		"№M" = "Medical",		".M" = "Medical",
	  ":X" = "Procedure",		"#X" = "Procedure",		"№X" = "Procedure",		".X" = "Procedure",
	  ":E" = "Engineering",		"#E" = "Engineering",	"№E" = "Engineering",	".E" = "Engineering",
	  ":S" = "Security",		"#S" = "Security",		"№S" = "Security",		".S" = "Security",
	  ":W" = "whisper",			"#W" = "whisper",		"№W" = "whisper",		".W" = "whisper",
	  ":T" = "Syndicate",		"#T" = "Syndicate",		"№T" = "Syndicate",		".T" = "Syndicate",
	  ":U" = "Supply",			"#U" = "Supply",		"№U" = "Supply",		".U" = "Supply",
	  ":Z" = "Service",			"#Z" = "Service",		"№Z" = "Service",		".Z" = "Service",
	  ":P" = "AI Private",		"#P" = "AI Private",	"№P" = "AI Private",	".P" = "AI Private",

	// Russian text lowercase
	  ":к" = "right ear",		"#к" = "right ear",		"№к" = "right ear",		".к" = "right ear",
	  ":д" = "left ear",		"#д" = "left ear",		"№д" = "left ear",		".д" = "left ear",
	  ":ш" = "intercom",		"#ш" = "intercom",		"№ш" = "intercom",		".ш" = "intercom",
	  ":р" = "department",		"#р" = "department",	"№р" = "department",	".р" = "department",
	  ":с" = "Command",			"#с" = "Command",		"№с" = "Command",		".с" = "Command",
	  ":т" = "Science",			"#т" = "Science",		"№т" = "Science",		".т" = "Science",
	  ":ь" = "Medical",			"#ь" = "Medical",		"№ь" = "Medical",		".ь" = "Medical",
	  ":ч" = "Procedure",		"#ч" = "Procedure",		"№ч" = "Procedure",		".ч" = "Procedure",
	  ":у" = "Engineering", 	"#у" = "Engineering",	"№у" = "Engineering",	".у" = "Engineering",
	  ":ы" = "Security",		"#ы" = "Security",		"№ы" = "Security",		".ы" = "Security",
	  ":ц" = "whisper",			"#ц" = "whisper",		"№ц" = "whisper",		".ц" = "whisper",
	  ":е" = "Syndicate",		"#е" = "Syndicate",		"№е" = "Syndicate",		".е" = "Syndicate",
	  ":г" = "Supply",			"#г" = "Supply",		"№г" = "Supply",		".г" = "Supply",
	  ":я" = "Service",			"#я" = "Service",		"№я" = "Service",		".я" = "Service",
	  ":з" = "AI Private",		"#з" = "AI Private",	"№з" = "AI Private",	".з" = "AI Private",
	  ":ё" = "cords",			"#ё" = "cords",			"№ё" = "cords",			".ё" = "cords",
	// Russian text uppercase
	  ":К" = "right ear",		"#К" = "right ear",		"№К" = "right ear",		".К" = "right ear",
	  ":Д" = "left ear",		"#Д" = "left ear",		"№Д" = "left ear",		".Д" = "left ear",
	  ":Ш" = "intercom",		"#Ш" = "intercom",		"№Ш" = "intercom",		".Ш" = "intercom",
	  ":Р" = "department",		"#Р" = "department",	"№Р" = "department",	".Р" = "department",
	  ":С" = "Command",			"#С" = "Command",		"№С" = "Command",		".С" = "Command",
	  ":Т" = "Science",			"#Т" = "Science",		"№Т" = "Science",		".Т" = "Science",
	  ":Ь" = "Medical",			"#Ь" = "Medical",		"№Ь" = "Medical",		".Ь" = "Medical",
	  ":У" = "Engineering",		"#У" = "Engineering",	"№У" = "Engineering",	".У" = "Engineering",
	  ":Ы" = "Security",		"#Ы" = "Security",		"№Ы" = "Security",		".Ы" = "Security",
	  ":Ц" = "whisper",			"#Ц" = "whisper",		"№Ц" = "whisper",		".Ц" = "whisper",
	  ":Е" = "Syndicate",		"#Е" = "Syndicate",		"№Е" = "Syndicate",		".Е" = "Syndicate",
	  ":Г" = "Supply",			"#Г" = "Supply",		"№Г" = "Supply",		".Г" = "Supply",
	  ":Я" = "Service",			"#Я" = "Service",		"№Я" = "Service",		".Я" = "Service",
	  ":З" = "AI Private",		"#З" = "AI Private",	"№З" = "AI Private",	".З" = "AI Private",
	  ":Ё" = "cords",			"#Ё" = "cords",			"№Ё" = "cords",			".Ё" = "cords",

	// English symbols no case
	  ":~" = "cords",			"#~" = "cords",			"№~" = "cords",			".~" = "cords",
	// Russian symbols no case
		// None yet.

	// Special symbols only (that means that they don't have/use an english/russian analogue)
	  ":$" = "Response Team",	"#$" = "Response Team", "№$" = "Response Team",	".$" = "Response Team",
  	  ":_" = "SyndTeam",		"#_" = "SyndTeam",		"№_" = "SyndTeam",		"._" = "SyndTeam",
	  ":-" = "Special Ops",		"#-" = "Special Ops",	"№-" = "Special Ops",	".-" = "Special Ops",
	  ":+" = "special",			"#+" = "special",		"№+" = "special",		".+" = "special" //activate radio-specific special functions
)
