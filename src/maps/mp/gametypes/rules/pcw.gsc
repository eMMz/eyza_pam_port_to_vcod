

Load()
{
	game["ruleCvars"] = GetCvars(game["ruleCvars"]);
}

GetCvars(arr)
{
	if (level.gametype == "sd")
		arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_sd_strat_time", 6);	// Time before round starts where players cannot move

	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_recording", 0); 						// Starts automatically recording when match starts
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_matchinfo", 1); 						// Show match info in menu (1 = without team names, 2 = with team names)
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_auto_deadchat", 0);

	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_bash", 0);							// Bash mode can be called via menu in readyup


	return arr;
}
