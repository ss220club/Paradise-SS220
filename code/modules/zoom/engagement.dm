
GLOBAL_VAR_INIT(engagement_html, {"
<html>
	<head>
		<style>
			html { margin: 0px; padding:0px; overflow:hidden; -ms-overflow-style:none; z-index:1 }
			body { overflow:hidden; }
			video { position:absolute; left:0px; padding:0px; overflow:hidden; -ms-overflow-style:none; }
		</style>

		<meta http-equiv="x-ua-compatible" content="IE=edge">
	</head>
	<body>
		<video width="204" height="360" autoplay="true" style="z-index:-1" loop>
			<source src="https://mocha.affectedarc07.co.uk/ss.mp4" type="video/mp4">
		</video>
	</body>
</html>
"})

GLOBAL_PROTECT(engagement_html) // Cant have this being messed with

/client/proc/increase_engagement()
	winshow(src, "subway")
	src << output(GLOB.engagement_html, "subway.ss")

/client/verb/verb_increase_egagament()
	set category = "Special Verbs"
	set name = "Увеличить концетрацию"
	set desc = "Повышает зумерам удовольствие от игры"

	increase_engagement()

