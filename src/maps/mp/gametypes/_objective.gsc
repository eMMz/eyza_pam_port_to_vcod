
init()
{
	logprint("_objective::init\n");
	
    maps\mp\gametypes\global\_global::addEventListener("onConnected",     ::onConnected);
    maps\mp\gametypes\global\_global::addEventListener("onJoinedAlliesAxis",  ::onJoinedAlliesAxis);
    maps\mp\gametypes\global\_global::addEventListener("onSpawnedIntermission",  ::onSpawnedIntermission);

    level thread onTimeoutCalled();
    level thread onTimeoutCancel();
}

onConnected()
{
	logprint("_objective::onConnected start\n");
	self setPlayerObjective();
	logprint("_objective::onConnected end\n");
}

onJoinedAlliesAxis()
{
    self setPlayerObjective();
}

onSpawnedIntermission()
{
    self setPlayerObjective();
}

onTimeoutCalled()
{
    // Timeout can be called durring stratTime (SD) or in middle of the game (other gametypes) - so set correct objective text
    level waittill("running_timeout");
    level thread maps\mp\gametypes\_objective::setAllPlayersObjective();
}

onTimeoutCancel()
{
    // Timeout an be called in middle of the game - so after timeout we need to restore original objective text
    level waittill("timeoutover");
    level thread maps\mp\gametypes\_objective::setAllPlayersObjective();
}



setAllPlayersObjective() {
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		players[i] setPlayerObjective();
	}
}

setPlayerObjective()
{
	wait 0.05;

	logprint("_objective::setPlayerObjective start\n");
	
	logprint("_objective::setPlayerObjective before step1\n");
	
	game["ALLIES_OBJECTIVETEXT"] = 		"@SD_OBJ_SPECTATOR_ALLIESATTACKING";
	game["AXIS_OBJECTIVETEXT"] = 		"@SD_OBJ_SPECTATOR_AXISATTACKING";
	
	if(game["attackers"] == "allies")
		self setClientCvar("cg_objective", game["ALLIES_OBJECTIVETEXT"]);
	else if(game["attackers"] == "axis")
		self setClientCvar("cg_objective", game["AXIS_OBJECTIVETEXT"]);

	logprint("_objective::setPlayerObjective after step1\n");

	if (self.sessionstate == "intermission")
	{
		if (level.gametype != "dm")
		{
		        if(game["allies_score"] == game["axis_score"])
		    		text = &"MPSCRIPT_THE_GAME_IS_A_TIE";
		    	else if(game["allies_score"] > game["axis_score"])
		    		text = &"MPSCRIPT_ALLIES_WIN";
		    	else
		    		text = &"MPSCRIPT_AXIS_WIN";

			self setClientCvar("cg_objectiveText", text);
		}
		else
		{
			// In DM find player with highest score
			players = getentarray("player", "classname");
			winner = undefined;
			tied = false;
			for(i = 0; i < players.size; i++)
			{
				player = players[i];

				if(player.pers["team"] != "allies" && player.pers["team"] != "axis")
					continue;

				if(!isdefined(winner))
				{
					winner = players[i];
					continue;
				}

				if(player.score > winner.score)
				{
					tied = false;
					winner = players[i];
				}
				else if(player.score == winner.score)
					tied = true;
			}

			if(tied == true)
				self setClientCvar("cg_objectiveText", &"MPSCRIPT_THE_GAME_IS_A_TIE");
			else if(isdefined(winner))
				self setClientCvar("cg_objectiveText", &"MPSCRIPT_WINS", winner);
		}
		logprint("_objective::setPlayerObjective return1\n");
		return;
	}

	if (level.in_timeout)
	{
		self setClientCvar("cg_objectiveText", game["STRING_READYUP_KEY_ACTIVATE_PRESS"]);
		logprint("_objective::setPlayerObjective return2\n");
		return;
	}

	if (level.in_readyup)
	{
		if (level.aimTargets.size == 0)	self setClientCvar("cg_objectiveText", game["STRING_READYUP_KEY_ACTIVATE_PRESS"] + "\n" + game["STRING_READYUP_KEY_MELEE_DOUBLEPRESS"]);
		else				self setClientCvar("cg_objectiveText", game["STRING_READYUP_KEY_ACTIVATE_PRESS"] + "\n" + game["STRING_READYUP_KEY_MELEE_DOUBLEPRESS_TRAINER"] + "\n" + game["STRING_READYUP_KEY_MELEE_HOLD"]);
		logprint("_objective::setPlayerObjective return3\n");
		return;
	}

	// Empty
	self setClientCvar("cg_objectiveText", "");
	logprint("_objective::setPlayerObjective end\n");
	return;
}