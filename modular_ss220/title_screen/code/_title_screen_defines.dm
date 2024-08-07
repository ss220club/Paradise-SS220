#define DEFAULT_TITLE_SCREEN_IMAGE_PATH 'modular_ss220/title_screen/icons/default.gif'

#define DEFAULT_TITLE_HTML {"
	<html>
		<head>
			<title>Title Screen</title>
			<meta http-equiv="X-UA-Compatible" content="IE=edge">
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
			<link rel="stylesheet" type="text/css" href="v4shim.css">
			<link rel="stylesheet" type="text/css" href="font-awesome.css">
			<style type='text/css'>
				@font-face {
					font-family: "Fixedsys";
					src: url("FixedsysExcelsior3.01Regular.ttf");
				}
				body,
				html {
					font-family: Verdana, Geneva, sans-serif;
					font-size: 1.2vw;
					overflow: hidden;
					text-align: center;
					-ms-user-select: none;
					user-select: none;
					cursor: default;
					margin: 0;
					background-color: black;
				}

				img {
					border-style: none;
				}

				hr {
					border: 0.1em solid rgba(255, 255, 255, 0.1);
				}

				.bg {
					position: absolute;
					width: auto;
					height: 100vmin;
					min-width: 100vmin;
					min-height: 100vmin;
					top: 50%;
					left: 50%;
					transform: translate(-50%, -50%);
					z-index: 0;
				}

				.container_notice {
					position: absolute;
					box-sizing: border-box;
					width: auto;
					top: calc(50% - 10vmin);
					right: 25%;
					transform: translate(-50%, -50%);
					z-index: 1;
				}

				.menu_notice {
					display: inline-block;
					text-decoration: none;
					width: 100%;
					text-align: left;
					color: red;
					text-shadow: 1px 0px black, -1px 0px black, 0px 1px black, 0px -1px black, 2px 0px black, -2px 0px black, 0px 2px black, 0px -2px black;
					margin-right: 0%;
					margin-top: 0px;
					font-size: 3vmin;
					line-height: 2vmin;
				}

				.container_menu {
					display: flex;
					flex-direction: column;
					justify-content: space-between;
					position: absolute;
					box-sizing: border-box;
					bottom: 0;
					left: 0;
					width: 22.5em;
					height: 100vh;
					background: linear-gradient(90deg, rgba(0,0,0,0.8) 91%, rgba(0,0,0,0) 100%);
					z-index: 2;
				}

				.container_logo {
					display: flex;
					flex-direction: column;
					align-items: center;
					margin: 1em 2em 1em 0;
				}

				.logo {
					width: 17.5vw;
				}

				.character {
					width: 100%;
					margin: 0 1em;
					font-weight: bold;
					font-size: 1.2rem;
					text-align: right;
					color: #d4dfec;
				}

				.character:first-of-type {
					margin: 1.25em 0 0.5em 1.5em;
					font-weight: normal;
					font-size: 1.1rem;
					text-align: left;
					color: #898989;
				}

				.container_buttons {
					flex: 1;
					text-align: left;
					margin: 5em 2em 2.5em 0;
				}

				.menu_button {
					display: block;
					cursor: pointer;
					overflow: hidden;
					font-size: 1.4rem;
					text-decoration: none;
					box-sizing: border-box;
					width: 100%;
					margin-bottom: 0.25em;
					padding: 0.25em 0.5em;
					color: #898989;
					border-radius: 0 0.25em 0.25em 0;
					transition: color 0.2s, background-color 0.2s;
				}

				.menu_button:hover,
				.link_button:hover {
					background-color: rgba(255, 255, 255, 0.075);
					color: #d4dfec;
				}

				.menu_button:active
				.link_button:active {
					background-color: rgba(255,255,255, 0.125);
					color: #d4dfec;
				}

				.container_links {
					display: flex;
					margin-right: 1em;
				}

				.link_button {
					cursor: pointer;
					width: 100%;
					font-size: 1.5rem;
					padding: 0.5em;
					color: #898989;
					transition: color 0.2s, background-color 0.2s;
				}
			</style>
		</head>
		<body>
			"}
