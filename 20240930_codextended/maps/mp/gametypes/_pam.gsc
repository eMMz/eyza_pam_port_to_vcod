
init()
{
	logprint("_pam::init\n");
	if(game["firstInit"])
	{
		maps\mp\gametypes\global\_global::precacheString2("STRING_VERSION_INFO", &"zPAM 3.33 for vCoD"); // ZPAM_RENAME
	}
}


// Info about PAM, league name
// Is removed at readyup after all players are ready
PAM_Header(fadein)
{
	// Another thread is running..
	if (isDefined(level.pam_header_visible))
		return;
	level.pam_header_visible = true;

	if (!isDefined(fadein))
		fadein = false;

	// Show global warnings
	thread maps\mp\gametypes\_warnings::update();


	// League name - Text top left corner
	pammode = maps\mp\gametypes\global\_global::addHUD(10, 3, 1.1, game["rules_stringColor"], "left", "top", "left");
	if (fadein) pammode maps\mp\gametypes\global\_global::showHUDSmooth(.5);
	pammode setText(game["rules_leagueString"]);

	// MR12 or Classic or 15min
	pammode2 = maps\mp\gametypes\global\_global::addHUD(10, 17, 0.8, game["rules_stringColor"], "left", "top", "left");
	if (fadein) pammode2 maps\mp\gametypes\global\_global::showHUDSmooth(.5);
	pammode2 setText(game["rules_formatString"]);

	// russian, LAN, 2v2
	pammode3 = maps\mp\gametypes\global\_global::addHUD(50, 17, 0.8, game["rules_stringColor"], "left", "top", "left");
	if (fadein) pammode3 maps\mp\gametypes\global\_global::showHUDSmooth(.5);
	pammode3 setText(game["leagueOptionsString"]);

	// zPAM v3.00
	pam_version = maps\mp\gametypes\global\_global::addHUD(-20, 25, 1.2, (0.8,1,1), "right", "top", "right");
	if (fadein) pam_version maps\mp\gametypes\global\_global::showHUDSmooth(.5);
	pam_version setText(game["STRING_VERSION_INFO"]);



	level waittill("pam_hud_delete");

	// Hide global warnings
	thread maps\mp\gametypes\_warnings::hide();




	pammode thread maps\mp\gametypes\global\_global::destroyHUDSmooth(0.5);
	pammode2 thread maps\mp\gametypes\global\_global::destroyHUDSmooth(0.5);
	pammode3 thread maps\mp\gametypes\global\_global::destroyHUDSmooth(0.5);
	pam_version thread maps\mp\gametypes\global\_global::destroyHUDSmooth(0.5);

	level.pam_header_visible = undefined;
}


PAM_Header_Delete()
{
	level notify("pam_hud_delete");
}