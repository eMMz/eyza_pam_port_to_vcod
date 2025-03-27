

init()
{
	logprint("_score_set::init\n");
	
	maps\mp\gametypes\global\_global::addEventListener("onCvarChanged", ::onCvarChanged);

	maps\mp\gametypes\global\_global::registerCvarEx("I", "scr_score_allies", "INT", -1, -1, 9999);
	maps\mp\gametypes\global\_global::registerCvarEx("I", "scr_score_axis", "INT", -1, -1, 9999);
}

// This function is called when cvar changes value.
// Is also called when cvar is registered
// Return true if cvar was handled here, otherwise false
onCvarChanged(cvar, value, isRegisterTime)
{
	switch(cvar)
	{
		case "scr_score_allies":
			thread handleAllies(cvar, value, isRegisterTime);
			return true;

		case "scr_score_axis":
			thread handleAxis(cvar, value, isRegisterTime);
			return true;
	}
	return false;
}

handleAllies(cvar, value, isRegisterTime)
{
	if (value >= 0)
	{
		if (isRegisterTime)
			wait level.frame; // in register time, score is not defined yet

		roundsplayed = game["axis_score"] + value;

		handle("allies", roundsplayed, value);

		maps\mp\gametypes\global\_global::changeCvarQuiet(cvar, -1);
	}
}

handleAxis(cvar, value, isRegisterTime)
{
	if (value >= 0)
	{
		if (isRegisterTime)
			wait level.frame; // in register time, score is not defined yet

		roundsplayed = game["allies_score"] + value;

		handle("axis", roundsplayed, value);

		maps\mp\gametypes\global\_global::changeCvarQuiet(cvar, -1);
	}
}




handle(team, roundsplayed, value)
{
	if (level.gametype != "sd")
	{
		iprintln("^1Score changing is available only in S&D gametype.");
		return false;
	}
	if (!game["readyup_first_run"])
	{
		iprintln("^1Invalid attempt to change score. Score can be changed only in first ready-up time");
		return false;
	}
	if (roundsplayed > level.matchround && level.matchround > 0)
	{
		iprintln("^1Value " + value + " is not acceptable, because its more than maximum playable rounds - " + level.matchround);
		return false;
	}
	if (value >= level.scorelimit && level.scorelimit > 0)
	{
		iprintln("^1Value " + value + " is not acceptable, because its more than maximum score limit - " + level.scorelimit);
		return false;
	}




	if ((roundsplayed >= level.halfround && level.halfround > 0) || (value >= level.halfscore && level.halfscore > 0))
	{
		game["is_halftime"] = true;

		game["half_2_"+team+"_score"] = value;
	}

	else
	{
		game["is_halftime"] = false;

		game["half_1_"+team+"_score"] = value;
	}




	game[team + "_score"] = value;



	setTeamScore(team, game[team + "_score"]);

	level maps\mp\gametypes\_hud_teamscore::updateScore();

	game["roundsplayed"] = roundsplayed;


	return true;
}