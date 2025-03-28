

// Ready up can be called from startRound, _halftime, _timeout, _overtime

init()
{
	logprint("_readyup::init\n");
	
	maps\mp\gametypes\global\_global::addEventListener("onCvarChanged", ::onCvarChanged);

	maps\mp\gametypes\global\_global::registerCvarEx("C", "scr_readyup", "BOOL", 0);
	maps\mp\gametypes\global\_global::registerCvarEx("C", "scr_readyup_autoresume_half", "FLOAT", 0, 0, 10);
	maps\mp\gametypes\global\_global::registerCvarEx("C", "scr_readyup_autoresume_map", "FLOAT", 0, 0, 10);
	maps\mp\gametypes\global\_global::registerCvar("scr_readyup_nadetraining", "BOOL", 0);
	maps\mp\gametypes\global\_global::registerCvar("scr_readyup_start_timer", "FLOAT", 0, 0, 10);

	if(game["firstInit"])
	{
		// Ready-up
		maps\mp\gametypes\global\_global::precacheString2("STRING_READYUP_WAITING_ON", &"Waiting on");
		maps\mp\gametypes\global\_global::precacheString2("STRING_READYUP_PLAYERS", &"Players");
		maps\mp\gametypes\global\_global::precacheString2("STRING_READYUP_YOUR_STATUS", &"Your Status");
		maps\mp\gametypes\global\_global::precacheString2("STRING_READYUP_READY", &"Ready");
		maps\mp\gametypes\global\_global::precacheString2("STRING_READYUP_NOT_READY", &"Not Ready");
		maps\mp\gametypes\global\_global::precacheString2("STRING_READYUP_CLOCK", &"Clock");

		maps\mp\gametypes\global\_global::precacheString2("STRING_READYUP_MODE", &"Ready-Up Mode");
		maps\mp\gametypes\global\_global::precacheString2("STRING_READYUP_MODE_HALF", &"Half-Time Ready-Up Mode");
		maps\mp\gametypes\global\_global::precacheString2("STRING_READYUP_MODE_TIMEOUT", &"Time-Out Ready-Up Mode");
		maps\mp\gametypes\global\_global::precacheString2("STRING_READYUP_MODE_OVERTIME", &"Overtime Ready-Up Mode");

		// Strings (problem with precache...)
		game["STRING_READYUP_KEY_ACTIVATE_PRESS"] = 		"Press the ^3[{+activate}] ^7button to Ready-Up.";
		game["STRING_READYUP_KEY_MELEE_DOUBLEPRESS"] = 		"Double press ^3[{+melee_breath}] ^7to disable killing.";
		game["STRING_READYUP_KEY_MELEE_DOUBLEPRESS_TRAINER"] = 	"Double press ^3[{+melee_breath}] ^7to disable killing or aim trainer.";
		game["STRING_READYUP_KEY_MELEE_HOLD"] = 		"Hold ^3[{+melee_breath}] ^7to switch aim trainer modes.";
		game["STRING_READYUP_ALL_PLAYERS_ARE_READY"] = 		"All players are ready.";
		game["STRING_READYUP_TIME_EXPIRED"] = 			"Time to Ready-Up is over.";
		game["STRING_READYUP_TIME_EXPIRED_SKIP"] = 		"Set your team as ready to skip the Ready-Up.";


		maps\mp\gametypes\global\_global::precacheString2("STRING_READYUP_SELECT_TEAM", &"Select team!");

		maps\mp\gametypes\global\_global::precacheString2("STRING_READYUP_RESUMING_IN", &"Resuming In");
		maps\mp\gametypes\global\_global::precacheString2("STRING_READYUP_KILLING_DISABLED", &"Disabled");
		maps\mp\gametypes\global\_global::precacheString2("STRING_READYUP_KILLING_ENABLED", &"Enabled");
		maps\mp\gametypes\global\_global::precacheString2("STRING_READYUP_KILLING", &"Killing");
		maps\mp\gametypes\global\_global::precacheString2("STRING_READYUP_AIM_TRAINER", &"Aim Trainer");
		maps\mp\gametypes\global\_global::precacheString2("STRING_READYUP_AIM_TRAINER_NOT_SUPPORTED", &"Not supported");
		maps\mp\gametypes\global\_global::precacheString2("STRING_READYUP_AIM_TRAINER_AVAIBLE", &"Available");
		maps\mp\gametypes\global\_global::precacheString2("STRING_READYUP_AIM_TRAINER_ACTIVE", &"Active");
		maps\mp\gametypes\global\_global::precacheString2("STRING_READYUP_DASH", &"-");

		// HUD: Half_Start
		maps\mp\gametypes\global\_global::precacheString2("STRING_READYUP_MATCH_BEGINS_IN", &"Match begins in:");
		maps\mp\gametypes\global\_global::precacheString2("STRING_READYUP_MATCH_CONTINUES_IN", &"Match continues in:");
		maps\mp\gametypes\global\_global::precacheString2("STRING_READYUP_MATCH_RESUMES_IN", &"Match resumes in:");

		// Time to readyup expired
		maps\mp\gametypes\global\_global::precacheString2("STRING_READYUP_SET_YOUR_TEAM_AS_READY", &"Time is over. Setting one team ready will skip the Ready-up.");

		//precacheStatusIcon("headicon_carrier");
		//precacheStatusIcon("party_notready");
	}


	// Define level default variables
	level.in_readyup = false;
	level.playersready = false;
	level.readyup_runned = false;
	//level.hud_readyup_offsetX = -50;
	level.hud_readyup_offsetX = 590;
	level.hud_readyup_offsetY = 20;


	// Define default variables
	if (!isDefined(game["Do_Ready_up"]))
	{
		game["Do_Ready_up"] = false;		// request from other scripts to run readyup
		game["readyup_first_run"] = level.scr_readyup;
	}

	// Start readyup if is request (halftime, timeout, overtime) or is enabled by cvar on fresh start
	// and is not already running (called by timeout)
	if (game["Do_Ready_up"] || game["readyup_first_run"])
	{
		Start_Readyup_Mode(false);
	}

}

// This function is called when cvar changes value.
// Is also called when cvar is registered
// Return true if cvar was handled here, otherwise false
onCvarChanged(cvar, value, isRegisterTime)
{
	switch(cvar)
	{
		case "scr_readyup": 		level.scr_readyup = value; return true;
		case "scr_readyup_autoresume_half": 	level.scr_readyup_autoresume_half = value; return true;
		case "scr_readyup_autoresume_map": 	level.scr_readyup_autoresume_map = value; return true;
		case "scr_readyup_nadetraining":level.scr_readyup_nadetraining = value; return true;
		case "scr_readyup_start_timer": 	level.scr_readyup_start_timer = value; return true;
	}
	return false;
}

// Runs readyup mode
// in_middle_of_game is useful when timeout needs to be called in middle of game
// if is set, threads needs to be runned on existing players
Start_Readyup_Mode(runned_in_middle_of_game)
{
	level.in_readyup = true;
	game["Do_Ready_up"] = 0;	// reset request flag

	// Because readyup can be called in middle of game (timeout),
	// attach readyup threads on existing players
	if (runned_in_middle_of_game)
	{
		// Run readyup thread to all existing players
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			player = players[i];

			player onConnected();
			player PrintTeamAndHowToUse();
		}
	}

	// Prevent multiple event registration in case of time based gametypes and multiple timeouts called
	if (level.readyup_runned == false)
	{
		level.readyup_runned = true;

		// Attach event for new players
		maps\mp\gametypes\global\_global::addEventListener("onConnected",     	::onConnected);
		maps\mp\gametypes\global\_global::addEventListener("onDisconnect",    	::onDisconnect);
		maps\mp\gametypes\global\_global::addEventListener("onSpawned",    	::onSpawned);
	    maps\mp\gametypes\global\_global::addEventListener("onJoinedTeam",      	::onJoinedTeam);

		maps\mp\gametypes\global\_global::addEventListener("onPlayerDamaging",  	::onPlayerDamaging);
		maps\mp\gametypes\global\_global::addEventListener("onPlayerKilling",   	::onPlayerKilling);
	}

	// Wait here untill there is atleast one player connected
	if (game["readyup_first_run"])
	{
		wait level.fps_multiplier * 0.1;
		for(;;)
		{
			players = getentarray("player", "classname");
			if (players.size > 0)
				break;
			wait level.fps_multiplier * 1;
		}
	}

	wait 0.05; // wait until timeout, overtime etc.. init() func are called

	level.playersready = false;

	// Create "Ready-up Mode", "Waiting On X Players", "Clock", "Waring: PB is off.." atd...
	createLevelHUD();

	// Enable online renaming
	wait level.frame;
	setClientNameMode("auto_change");

	// Wait here until level.playersready is false
	Update_Players_Count();

	// Match starts in...
	End_Readyup_Mode();

	// Exit all running threads (in cause of finished timeout in time based gametypes - ctf, hq, tdm)
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

	 	// End grenade flying thread
		player notify("end_Watch_Grenade_Throw");

		// End giving grenades
		player notify("end_giveGrenadesInReadyup");

		// Restore previous icon
		player.statusicon = player.statusicon_before;

		// Just save
		if (player.statusicon == "party_ready" || player.statusicon == "party_notready")
			player.statusicon = "";
		if (player.sessionstate == "playing" && player.statusicon == "hud_status_dead") // if player was dead while timeout was called and player respawned
			player.statusicon = "";

		// Hide "Select team!" hud
		player HUD_SelectTeam();
	}

	// Hide name of league + pam version
	thread maps\mp\gametypes\_pam::PAM_Header_Delete();

	level.playersready = false;
}

onConnected()
{
	// Readyup is over, ignore (in cause of finished timeout in time based gametypes - ctf, hq, tdm)
	if (!level.in_readyup)
		return false;

	// Defaults
	self.isReady = false;
	self.flying = false;
	self.flaying_enabled = true;
	self.readyupLastGrenadeThrowTime = 0;
	self.readyUp_HowToUse_Printed = false;
	self.statusicon_before = self.statusicon;

	// Main thread for player (monitoring F press)
	self thread playerReadyUpThread();

	// Check if all players are ready
	level thread Check_All_Ready(); // Sets level.playersready = true if all players are ready
}

onDisconnect()
{
	// Readyup is over, ignore (in cause of finished timeout in time based gametypes - ctf, hq, tdm)
	if (!level.in_readyup)
		return false;

	// Check if all players are ready
	level thread Check_All_Ready();
}


onSpawned()
{
	// Readyup is over, ignore (in cause of finished timeout in time based gametypes - ctf, hq, tdm)
	if (!level.in_readyup)
		return false;

	// Save status icon from original spawn function
	self.statusicon_before = self.statusicon;

	// We are in readyup, so change icons in scoreboard table
	if (self.isReady) 	self.statusicon = "gfx/hud/headicon@re_objcarrier.tga";
	else			self.statusicon = "";

	self PrintTeamAndHowToUse();

	// Warning to select team if player is team none
	self HUD_SelectTeam();


    if (level.scr_readyup_nadetraining)
    {
		if (!level.in_timeout)
		{
			if (!self.pers["isBot"])
				self thread maps\mp\gametypes\strat::Watch_Grenade_Throw(false);

	            // Keep adding grenades in readyup
	            thread giveGrenadesInReadyup();
		}
    }
}

onJoinedTeam(teamName)
{
	// Readyup is over, ignore (in cause of finished timeout in time based gametypes - ctf, hq, tdm)
	if (!level.in_readyup)
		return false;

	// Save status icon from original spawn function
	self.statusicon_before = self.statusicon;

	// We are in readyup, so change icons in scoreboard table
	if (self.isReady) 	self.statusicon = "gfx/hud/headicon@re_objcarrier.tga";
	else			self.statusicon = "";
}

/*
Called when player is about to take a damage.
self is the player that took damage.
Return true to prevent the damage.
*/
onPlayerDamaging(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime)
{
	// Readyup is over, ignore (in cause of finished timeout in time based gametypes - ctf, hq, tdm)
	if (!level.in_readyup)
		return false;

	// Prevent damage in timeout or if players are ready
	if (level.in_timeout || level.playersready)
		return true;

	// Prevent damage if im flying or im in training mode
	if (self.flying || self.aimTrainerMode != 0)
		return true;

	if (sMeansOfDeath == "MOD_GRENADE_SPLASH")
		return true;

	if (isPlayer(eAttacker) && self != eAttacker)
	{
		// Im flying or i in training mode, prevent damage
		if (eAttacker.flying || eAttacker.aimTrainerMode != 0)
			return true;

		eAttacker enableKilling();
	}

	if (!self.pers["killer"])
		return true; // prevent_damage
}

/*
Called when player is about to be killed.
self is the player that was killed.
Return true to prevent the kill.
*/
onPlayerKilling(eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	// Readyup is over, ignore (in cause of finished timeout in time based gametypes - ctf, hq, tdm)
	if (!level.in_readyup)
		return false;

	// In readyup simulate own kill function (kills are always prevented in readyup)
	if (self.pers["killer"] || (isPlayer(eAttacker) && self == eAttacker && sMeansOfDeath == "MOD_SUICIDE"))
	{
		// Send out an obituary message to all clients about the kill
		obituary(self, eAttacker, sWeapon, sMeansOfDeath);

		self.sessionstate = "dead";

		if (!isDefined(self.switching_teams))
			self thread respawnOnKilled(sWeapon, deathAnimDuration);
	}

	// Reset flag that means that this kill was executed while player is chaging sides via menu (suicide() was called)
	self.switching_teams = undefined;

	// Kill is not prevented, so other gametypes must ignore their standart kill procedure if readyup is active
	// this is because ctf, htf, hq need to do some job when player is killed (because of team swap or /kill) in timeout - flag needs to be dropped or some hud removed
}

respawnOnKilled(sWeapon, deathAnimDuration)
{
	self endon("disconnect");
	self endon("spawned");

	// Wait before dead body is spawned to allow double kills (bullets may stop in this dead body)
	// Ignore this for shotgun, because it create a smoke effect on dead body (for good feeling)
	if (sWeapon != "shotgun_mp")
		wait 0.05;

	// Clone players model for death animations
	body = undefined;
	if(!isdefined(self.switching_teams))
		body = self cloneplayer(deathAnimDuration);

	wait level.fps_multiplier * 2;

	// Delete dead body in readyup
	if(isDefined(body))
		body delete();

	// If player is not changing team, spawn them again
	if (isDefined(self.pers["weapon"]))
		self thread [[level.spawnPlayer]](); // run in thread because this func uses endon(spawned);
}



// Give grenades after a few seconds!
giveGrenadesInReadyup()
{
	self endon("disconnect");

	// Make sure only 1 thred is running
	self notify("end_giveGrenadesInReadyup");
	self endon("end_giveGrenadesInReadyup");

	grenadesLast = 0;
	for(;;)
	{
		wait level.fps_multiplier * 0.5;

		if (!isAlive(self) || !isDefined(self.pers["weapon"]))
			continue;

		// Give new grenade only after 5 sec!
		grenades = self maps\mp\gametypes\_weapons::getFragGrenadeCount();

		if (grenadesLast > 0 && grenades == 0)
		{
			self.readyupLastGrenadeThrowTime = gettime();
		}

		grenadesLast = grenades;

		if (grenades == 0 && (self.readyupLastGrenadeThrowTime + 3500) < gettime())
		{
			maps\mp\gametypes\_weapons::giveGrenadesFor(self.pers["weapon"]);
		}
	}
}


// Main thread for player (monitoring F press)
playerReadyUpThread()
{
	self endon("disconnect");

	// Default variables
	self.pers["killer"] = 0;
	self.isReady = false;
	self.lastMan = false;

	// When player connects while the readyup ends (server is counting down timer to match start) show readyicon and exit
	if (level.playersready)
	{
		self.statusicon = "gfx/hud/headicon@re_objcarrier.tga";
		return;
	}

	// Change status icon
	self.statusicon = "";


	//Set ready for bots
	if (self.pers["isBot"])
	{
		self setReady();
		level thread Check_All_Ready(); // Check if all players are ready
		self.pers["killer"] = true; // set bots killable
		return;
	}

	// Dont show readyup for just connected players
	while(!isDefined(self.pers["firstTeamSelected"]))
		wait level.fps_multiplier * 0.1;

	// Dont show readyup if player is in team but weapon is not selected yet (player is in spectator session state)
	while((self.pers["team"] == "allies" || self.pers["team"] == "axis") && !isDefined(self.pers["weapon"]))
		wait level.fps_multiplier * 0.1;

	// Set ready for spectators
	if (self.pers["team"] == "spectator" || self.pers["team"] == "streamer")
	{
		self setReady();
		//level thread Check_All_Ready();
	}

	wait 0.05; // needed for aim trainer to be initialized


	hudReadyStatusVisible = false;
	hudKillingStatusVisible = false;
	hudAimTrainerStatusVisible = false;
	aimTrainerStatusLast = -1;
	teamLast = self.pers["team"];

	while(!level.playersready)
	{
		// Checking if player (self) is still defined
		if (!isdefined(self) || !isPlayer(self))
		{
			logprint("Readyup error: self is undefined or is not player!");
			return;
		}

		// Show hud player ready status
		if (hudReadyStatusVisible == false && self.pers["team"] != "streamer")
		{
			self thread HUD_Player_Status();
			hudReadyStatusVisible = true;
		}
		// Hide hud player ready status
		if (hudReadyStatusVisible && self.pers["team"] == "streamer")
		{
			self thread HUD_Player_Status("destroy");
			hudReadyStatusVisible = false;
		}


		// Show hud player killing status
		if (hudKillingStatusVisible == false && self.pers["team"] != "streamer")
		{
			self thread HUD_Player_Killing_Status();
			hudKillingStatusVisible = true;
		}
		// Hide hud player killing status
		if (hudKillingStatusVisible && self.pers["team"] == "streamer")
		{
			self thread HUD_Player_Killing_Status("destroy");
			hudKillingStatusVisible = false;
		}

		/*
		// Show hud player aim-trainer status
		if (hudAimTrainerStatusVisible == false && self.pers["team"] != "streamer")
		{
			self thread HUD_Player_Aim_Trainer_Status();
			hudAimTrainerStatusVisible = true;
		}
		// Hide hud player killing status
		if (hudAimTrainerStatusVisible && self.pers["team"] == "streamer")
		{
			self thread HUD_Player_Aim_Trainer_Status("destroy");
			hudAimTrainerStatusVisible = false;
		}

		self setAimTraining(); // update periodically, there is a check if the state changed from last call
		*/



		// Team change
		if (teamLast != self.pers["team"] && (self.pers["team"] == "streamer" || self.pers["team"] == "spectator") && self.isReady == false)
		{
			setReady();
			level thread Check_All_Ready();
		}
		if (teamLast != self.pers["team"] && (teamLast == "streamer" || teamLast == "spectator") && self.pers["team"] != "streamer" && self.pers["team"] != "spectator" && self.isReady)
		{
			unsetReady();
			level thread Check_All_Ready();
		}
		teamLast = self.pers["team"];




		if(self useButtonPressed() && !self.flying)
		{
			if (!self.isReady || self.pers["team"] == "streamer")
				setReady();
			else
				unsetReady();


            		// Check if all players are ready
			level thread Check_All_Ready();


			wait level.fps_multiplier * 0.25;
			while (self useButtonPressed())
				wait level.frame;
		}

		// Disable killing
		else if (self MeleeButtonPressed() && !level.in_timeout)
		{
			i = 0;
			holdTime = 0;
			keyReleased = false;
			while(self.pers["team"] == "allies" || self.pers["team"] == "axis")
			{
				// Half second for secondary press
				if (i < level.sv_fps * 0.4 && keyReleased && self meleeButtonPressed())
				{
					/*
					if (self.aimTrainerMode == 0)
					{
						self iprintln("Killing was disabled");
					}
					else
					{
						self maps\mp\gametypes\_aim_trainer::turnOff();

						self setAimTraining();
					}
					*/

					// Disable killing
					self disableKilling();

					wait level.fps_multiplier * 1;
					break;
				}

				// Key was released atleast once
				if(self meleeButtonPressed() == false)
					keyReleased = true;

				//if (self meleebuttonpressed() && self playerAds() != 1)
				if (self meleebuttonpressed() && self aimButtonPressed() != 1)
				//if (self meleebuttonpressed() /*&& self playerAds() != 1*/)
					holdTime += 1;

				/*
				// Key was holded for some time
				if (keyReleased == false && holdTime == level.sv_fps * 0.8)
				{
					self maps\mp\gametypes\_aim_trainer::toggle();

					self setAimTraining();

					while (self meleebuttonpressed())
						wait level.frame;
					break;
				}
				*/

				// Exit after 1 second
				if (i > level.sv_fps * 1)
					break;

				i++;
				wait level.frame;
			}

		}

		wait level.frame;
	}

	//self iprintlnbold("Playing ^2"+level.pam_mode+"^7 mode");
    	self iprintlnbold(game["STRING_READYUP_ALL_PLAYERS_ARE_READY"]);


	//self.statusicon = "gfx/hud/headicon@re_objcarrier.tga";
}

setReady()
{
	self.isReady = true;
	self.statusicon = "gfx/hud/headicon@re_objcarrier.tga";
	iprintln(self.name + "^5 is Ready");

	if (isDefined(self.readyhud))
	{
		self.readyhud.color = (.73, .99, .73);
		self.readyhud setText(game["STRING_READYUP_READY"]);
	}
}

unsetReady()
{
	self.isReady = false;
	self.statusicon = "";
	iprintln(self.name + "^1 is Not Ready");
	

	if (isDefined(self.readyhud))
	{
		self.readyhud.color = (1, .66, .66);
		self.readyhud setText(game["STRING_READYUP_NOT_READY"]);
		
	}
}

enableKilling()
{
	self.pers["killer"] = true;

	// Update killing statuses
	if (isDefined(self.ru_killing_status)) // may be deleted when readyup is ending
	{
		self.ru_killing_status.color = (.73, .99, .73);
		if (level.in_timeout)
			self.ru_killing_status SetText(game["STRING_READYUP_DASH"]);
		else
			self.ru_killing_status SetText(game["STRING_READYUP_KILLING_ENABLED"]);
	}
}

disableKilling()
{
	self.pers["killer"] = false;

	if (isDefined(self.ru_killing_status)) // may be deleted when readyup is ending
	{
		self.ru_killing_status.color = (1, .66, .66);
		if (level.in_timeout)
			self.ru_killing_status SetText(game["STRING_READYUP_DASH"]);
		else
			self.ru_killing_status SetText(game["STRING_READYUP_KILLING_DISABLED"]);
	}
}


setAimTraining()
{
	// Aim trainer
	status = -1;
	if (level.aimTargetsSupported)
	{
		if (self.aimTrainerMode > 0)
			status = 1; // available and active
		else
			status = 0; // available, not active
	}

	// Update killing statuses
	if (isDefined(self.ru_aimtrainer_status)) // may be deleted when readyup is ending
	{
		// No update when there is no change from last call
		if (isDefined(self.ru_aimtrainer_status.status) && self.ru_aimtrainer_status.status == status)
			return;

		self.ru_aimtrainer_status.status = status;

		if (level.in_timeout)
		{
			self.ru_aimtrainer_status.color = (1, .66, .66);
			self.ru_aimtrainer_status SetText(game["STRING_READYUP_DASH"]);
		}
		else if (status == 0)
		{
			self.ru_aimtrainer_status.color = (.73, .99, .73);
			self.ru_aimtrainer_status SetText(game["STRING_READYUP_AIM_TRAINER_AVAIBLE"]);
		}
		else if (status == 1)
		{
			self.ru_aimtrainer_status.color = (.73, .99, .73);
			self.ru_aimtrainer_status SetText(game["STRING_READYUP_AIM_TRAINER_ACTIVE"]);
		}
		else
		{
			self.ru_aimtrainer_status.color = (1, .66, .66);
			self.ru_aimtrainer_status SetText(game["STRING_READYUP_AIM_TRAINER_NOT_SUPPORTED"]);
		}
	}
}


// Called every onPlayerConnect, onPlayerDisconnect or on player ready-state changed
// Set level.playersready to true if all player is ready
Check_All_Ready()
{
	wait 0.05; // wait untill player is fully connected / disconnected

	if (level.playersready)
		return;


	if (areAllPlayersReady())
	{
		// Give players a few time to change their status if he was tle last one even if all players are ready
		wait level.fps_multiplier * 1;

		if (areAllPlayersReady())
			level.playersready = true;
	}
}

areAllPlayersReady()
{
	players = getentarray("player", "classname");

	if (players.size == 0)
        return false;

	playersInTeamsCount = 0;
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if (!player.isReady) {
			return false;
		}
		if (player.pers["team"] == "allies" || player.pers["team"] == "axis")
			playersInTeamsCount++;
	}

	if (playersInTeamsCount == 0)
		return false;
	
	//iprintln("## areAllPlayersReady() = true");

	return true;
}


PrintTeamAndHowToUse()
{
	if (!isDefined(self.pers["firstTeamSelected"]))
		return;

	// Spawned as spectator when chosing a weapon, wait untill spawned as player or as full spectator
	if ((self.pers["team"] == "allies" || self.pers["team"] == "axis") && !isAlive(self))
		return;

	if (self.readyUp_HowToUse_Printed)
		return;

	// Dont print again
	self.readyUp_HowToUse_Printed = true;


	in_timeout = level.in_timeout;
	in_halftime = !in_timeout && (game["is_halftime"] || game["overtime_active"]);
	in_mapswitch = !in_halftime && (game["scr_matchinfo"] == 2 && game["match_exists"]);

	if (in_timeout)
		self iprintlnbold("Timeout Ready-Up Mode");
	else if (in_halftime)
	{
		if (game["overtime_active"])
			self iprintlnbold("Half-time Overtime Ready-Up Mode");
		else
			self iprintlnbold("Half-time Ready-Up Mode");
	}
	//else if (in_mapswitch)
	//	self iprintlnbold("Ready-Up Mode");
	else
		self iprintlnbold("Ready-Up Mode");


	// Dont print more for streamers
	if (self.pers["team"] == "streamer")
		return;

	// Press F for readyup
	self iprintlnbold(game["STRING_READYUP_KEY_ACTIVATE_PRESS"]);

	// Double Press Shift to disable killing
	if ((self.pers["team"] == "allies" || self.pers["team"] == "axis") && level.in_timeout == false)
	{
		if (level.aimTargets.size == 0)
			self iprintlnbold(game["STRING_READYUP_KEY_MELEE_DOUBLEPRESS"]);
		else
		{
			self iprintlnbold(game["STRING_READYUP_KEY_MELEE_DOUBLEPRESS_TRAINER"]);
			self iprintlnbold(game["STRING_READYUP_KEY_MELEE_HOLD"]);
		}
	}


	// Length of readyup
	if (in_timeout && level.scr_timeout_length != 0)
	{
		text = "Timeout length: ^1" + level.scr_timeout_length + " ^7min"; if (level.scr_timeout_length >= 2) text += "s";
		self iprintlnbold(text);
	}
	else if (in_halftime && level.scr_readyup_autoresume_half > 0)
	{
		text = "Half-time length: ^1" + level.scr_readyup_autoresume_half + " ^7min"; if (level.scr_readyup_autoresume_half >= 2) text += "s";
		self iprintlnbold(text);
	}
	else if (in_mapswitch && level.scr_readyup_autoresume_map > 0)
	{
		text = "Ready-Up length: ^1" + level.scr_readyup_autoresume_map + " ^7min"; if (level.scr_readyup_autoresume_map >= 2) text += "s";
		self iprintlnbold(text);
	}
}


End_Readyup_Mode()
{
	level notify("rupover");

	// Black background, countdowntime, First half starting with timer
	thread HUD_Half_Start(level.scr_readyup_start_timer);

    // Coomon lets got that bastartdss blaballa
    thread playStartSound();


	wait level.fps_multiplier * level.scr_readyup_start_timer; // (10sec)

	// reset flag as readyup was runned
	game["readyup_first_run"] = false;

	if (!level.in_timeout)
	{
		if (!level.pam_mode_change)
		{
			logprint("_readyup:: Invoking map_restart(true) - level.pam_mode_change=" + level.pam_mode_change + "\n");
			map_restart(true);
		}
	}
	else
		// Reset only in timeout because normally it will get reseted by map_restart and also this caused to add 1 death to players if in the same frame player was killed
		level.in_readyup = 0;

}


// Used in halftime and overtime
ReadyUp_AutoResume(minutes)
{
	level endon("rupover");
	level endon("readyup_removeAutoResume");

	level thread HUD_ReadyUp_ResumingIn(minutes);

	// Resume after
	wait level.fps_multiplier * minutes * 60;


	level thread HUD_ReadyUp_ResumingIn_ExtraTime();


	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		if (player.pers["isBot"])
			continue;

		if (player.pers["team"] != "allies" && player.pers["team"] != "axis")
			continue;

		player unsetReady();

	}

	wait level.fps_multiplier * 3;

	// If atleast one of the teams are ready, end readyup
	for(;;)
	{
		alliesReady = true;
		axisReady = true;
		alliesCount = 0;
		axisCount = 0;

		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			if (!player.isReady)
			{
				if (player.pers["team"] == "allies")
					alliesReady = false;
				if (player.pers["team"] == "axis")
					axisReady = false;
			}
			if (player.pers["team"] == "allies")
				alliesCount++;
			if (player.pers["team"] == "axis")
				axisCount++;
		}

		if (alliesCount > 0 && axisCount > 0 && (alliesReady || axisReady))
		{
			// After this time, set all player is ready
			level.playersready = true;
			break;
		}

		wait level.fps_multiplier * 1;
	}
}


// keeps updates until level.playersready is false
Update_Players_Count()
{
	// Update Waiting On X Players - xxx number
	while(!level.playersready)
	{
		// Count player not ready up
		notready = 0;
		notReadyPlayer = undefined;
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			if (!player.isReady)
			{
				notready++;

				notReadyPlayer = player;
			}
		}

		// Last man
		if (players.size > 4)	// If its 3v3 or more
		{
			if (notready == 1 && notReadyPlayer.lastMan == false)
			{
				notReadyPlayer.lastMan = true;
				notReadyPlayer thread playLastManSound();
			}
		}

		level.notreadyhud setValue(notready);

		wait level.fps_multiplier * .1;
	}
}




/////////////////////////////////////////////////////////////////////////////
//                                                                          /
//                                                              Waiting On  /
// 	                                                            	3       /
//                                                               Players    /
//                                                                          /
//                                                                          /
//                                                                          /
//                                                                          /
//                                                                Clock     /
//                                                                00:00     /
//                                                                          /
//                                                                          /
//                                                                          /
//                            Ready Up Mode                                 /
//                                                                          /
/////////////////////////////////////////////////////////////////////////////

createLevelHUD()
{
	// Show name of league + pam version
	thread maps\mp\gametypes\_pam::PAM_Header();

	// Ready-Up Mode Text in center bottom position
	level thread HUD_ReadyUpMode();

	// Show Waiting on X Player on right side
	level thread HUD_WaitingOn_X_Players();

    	in_timeout = level.in_timeout;
	in_halftime = !in_timeout && (game["is_halftime"] || game["overtime_active"]);
	in_mapswitch = !in_halftime && (game["scr_matchinfo"] == 2 && game["match_exists"]);


	if (in_timeout && level.scr_timeout_length != 0)
		thread ReadyUp_AutoResume(level.scr_timeout_length);

	else if (in_halftime && level.scr_readyup_autoresume_half > 0)
		thread ReadyUp_AutoResume(level.scr_readyup_autoresume_half);

	else if (in_mapswitch && level.scr_readyup_autoresume_map > 0)
		thread ReadyUp_AutoResume(level.scr_readyup_autoresume_map);

	else
		level thread HUD_Clock();

	//Remove MG nests (if is timeout remove only in sd)
	if (!level.in_timeout || (level.in_timeout && (level.gametype == "sd" || level.gametype == "re")))
	{
		deletePlacedEntity("misc_turret");
		deletePlacedEntity("misc_mg42");
	}
}




// Your Status: Ready
HUD_Player_Status(destroy)
{
	self endon("disconnect");

	self notify("HUD_Player_Status");
	self endon("HUD_Player_Status");

	if (!isDefined(destroy))
	{
		// Your status
		self.status = maps\mp\gametypes\global\_global::addHUDClient(self, level.hud_readyup_offsetX, level.hud_readyup_offsetY + 120, 1.2, (0.8,1,1), "center", "middle", "right");
		self.status.archived = false;         // show only my hud when spectating player
		self.status setText(game["STRING_READYUP_YOUR_STATUS"]);

		// Ready / Not ready
		self.readyhud = maps\mp\gametypes\global\_global::addHUDClient(self, level.hud_readyup_offsetX, level.hud_readyup_offsetY + 135, 1.2, (1, .66, .66), "center", "middle", "right");
		self.readyhud.archived = false;         // show my status instead of spectating players status if im following another player
		self.readyhud setText(game["STRING_READYUP_NOT_READY"]);

		if (self.isReady)	setReady();
		else			unsetReady();

		level waittill("rupover");

		// Remove hud when RUP is over
		self.status thread maps\mp\gametypes\global\_global::destroyHUDSmooth(1);
		self.readyhud thread maps\mp\gametypes\global\_global::destroyHUDSmooth(1);
	}
	else if (isDefined(self.status))
	{
		self.status destroy();
		self.readyhud destroy();
	}
}

// Killing: Enabled
HUD_Player_Killing_Status(destroy)
{
	self endon("disconnect");

	self notify("HUD_Player_Killing_Status");
	self endon("HUD_Player_Killing_Status");

	if (!isDefined(destroy))
	{
		self.ru_killing_text = maps\mp\gametypes\global\_global::addHUDClient(self, level.hud_readyup_offsetX, level.hud_readyup_offsetY + 170, 1.2, (.7, 0.9, 0.9), "center", "middle", "right");
		self.ru_killing_text.archived = false;         // show only my hud when spectating player
		self.ru_killing_text SetText(game["STRING_READYUP_KILLING"]);

		self.ru_killing_status = maps\mp\gametypes\global\_global::addHUDClient(self, level.hud_readyup_offsetX, level.hud_readyup_offsetY + 185, 1.2, (1, .66, .66), "center", "middle", "right");
		self.ru_killing_status.archived = false;         // show only my hud when spectating player
		if (level.in_timeout)
			self.ru_killing_status SetText(game["STRING_READYUP_DASH"]);
		else
			self.ru_killing_status SetText(game["STRING_READYUP_KILLING_DISABLED"]);

		level waittill("rupover");

		self.ru_killing_text thread maps\mp\gametypes\global\_global::destroyHUDSmooth(1);
		self.ru_killing_status thread maps\mp\gametypes\global\_global::destroyHUDSmooth(1);
	}
	else if (isDefined(self.ru_killing_text))
	{
		self.ru_killing_text destroy();
		self.ru_killing_status destroy();
	}
}




// Killing: Enabled
HUD_Player_Aim_Trainer_Status(destroy)
{
	self endon("disconnect");

	self notify("HUD_Player_Aim_Trainer_Status");
	self endon("HUD_Player_Aim_Trainer_Status");

	if (!isDefined(destroy))
	{
		self.ru_aimtrainer_text = maps\mp\gametypes\global\_global::addHUDClient(self, level.hud_readyup_offsetX, level.hud_readyup_offsetY + 220, 1.2, (.7, 0.9, 0.9), "center", "middle", "right");
		self.ru_aimtrainer_text.archived = false;         // show only my hud when spectating player
		self.ru_aimtrainer_text SetText(game["STRING_READYUP_AIM_TRAINER"]);

		self.ru_aimtrainer_status = maps\mp\gametypes\global\_global::addHUDClient(self, level.hud_readyup_offsetX, level.hud_readyup_offsetY + 235, 1.2, (1, .66, .66), "center", "middle", "right");
		self.ru_aimtrainer_status.archived = false;         // show only my hud when spectating player
		//self.ru_aimtrainer_status SetText(game["STRING_READYUP_AIM_TRAINER_NOT_SUPPORTED"]);

		self setAimTraining();

		level waittill("rupover");

		self.ru_aimtrainer_text thread maps\mp\gametypes\global\_global::destroyHUDSmooth(1);
		self.ru_aimtrainer_status thread maps\mp\gametypes\global\_global::destroyHUDSmooth(1);
	}
	else if (isDefined(self.ru_aimtrainer_text))
	{
		self.ru_aimtrainer_text destroy();
		self.ru_aimtrainer_status destroy();
	}
}



HUD_Clock()
{
	// Clock
	level.timertext = maps\mp\gametypes\global\_global::newHudElem2();
	level.timertext.x = level.hud_readyup_offsetX;
	level.timertext.y = level.hud_readyup_offsetY + 270;
	//level.timertext.horzAlign = "right";
	level.timertext.alignX = "center";
	level.timertext.alignY = "middle";
	level.timertext.fontScale = 1.2;
	level.timertext.color = (.8, 1, 1);
	level.timertext SetText(game["STRING_READYUP_CLOCK"]);

	level.stim = maps\mp\gametypes\global\_global::newHudElem2();
	level.stim.x = level.hud_readyup_offsetX;
	level.stim.y = level.hud_readyup_offsetY + 285;
	//level.stim.horzAlign = "right";
	level.stim.alignX = "center";
	level.stim.alignY = "middle";
	level.stim.fontScale = 1.2;
	level.stim.color = (.98, .98, .60);
	level.stim SetTimerUp(0.1);

	level waittill("rupover");

	level.timertext FadeOverTime(1);
	level.timertext.alpha = 0;
	level.stim FadeOverTime(1);
	level.stim.alpha = 0;

	wait level.fps_multiplier * 1;

	level.timertext destroy();
	level.stim destroy();

}

// Ready-Up Mode / Halft time Ready-Up Mode / Timeout Ready-Up Mode
HUD_ReadyUpMode()
{
    level.readyup_mode = maps\mp\gametypes\global\_global::newHudElem2();
	level.readyup_mode.alignX = "center";
	level.readyup_mode.alignY = "top";
	level.readyup_mode.color = (.8, 1, 1);
	level.readyup_mode.x = 320;
	level.readyup_mode.y = 374;
	level.readyup_mode.fontScale = 1.4;
	level.readyup_mode.font = "default";
    if (level.in_timeout)
        level.readyup_mode SetText(game["STRING_READYUP_MODE_TIMEOUT"]);
    else if (game["is_halftime"])
		level.readyup_mode SetText(game["STRING_READYUP_MODE_HALF"]);
	else if (game["overtime_active"])
		level.readyup_mode SetText(game["STRING_READYUP_MODE_OVERTIME"]);
	else
		level.readyup_mode SetText(game["STRING_READYUP_MODE"]);

    level waittill("rupover");

    level.readyup_mode FadeOverTime(1);
    level.readyup_mode.alpha = 0;

    wait level.fps_multiplier * 1;

	level.readyup_mode destroy();
}

HUD_WaitingOn_X_Players()
{
    // Waiting on
	level.waitingon = maps\mp\gametypes\global\_global::newHudElem2();
	level.waitingon.x = level.hud_readyup_offsetX;
	level.waitingon.y = level.hud_readyup_offsetY + 45;
	//level.waitingon.horzAlign = "right";
	level.waitingon.alignX = "center";
	level.waitingon.alignY = "middle";
	level.waitingon.fontScale = 1.2;
	level.waitingon.font = "default";
	level.waitingon.color = (.8, 1, 1);
	level.waitingon setText(game["STRING_READYUP_WAITING_ON"]);

	// Number
	level.notreadyhud = maps\mp\gametypes\global\_global::newHudElem2();
	level.notreadyhud.x = level.hud_readyup_offsetX;
	level.notreadyhud.y = level.hud_readyup_offsetY + 65;
	//level.notreadyhud.horzAlign = "right";
	level.notreadyhud.alignX = "center";
	level.notreadyhud.alignY = "middle";
	level.notreadyhud.fontScale = 1.2;
	level.notreadyhud.font = "default";
	level.notreadyhud.color = (.98, .98, .60);

	// Players
	level.playerstext = maps\mp\gametypes\global\_global::newHudElem2();
	level.playerstext.x = level.hud_readyup_offsetX;
	level.playerstext.y = level.hud_readyup_offsetY + 85;
	//level.playerstext.horzAlign = "right";
	level.playerstext.alignX = "center";
	level.playerstext.alignY = "middle";
	level.playerstext.fontScale = 1.2;
	level.playerstext.font = "default";
	level.playerstext.color = (.8, 1, 1);
	level.playerstext setText(game["STRING_READYUP_PLAYERS"]);

    level waittill("rupover");

    level.waitingon FadeOverTime(1);
    level.waitingon.alpha = 0;
    level.notreadyhud FadeOverTime(1);
    level.notreadyhud.alpha = 0;
    level.playerstext FadeOverTime(1);
    level.playerstext.alpha = 0;

    wait level.fps_multiplier * 1;

	level.waitingon destroy();
    level.notreadyhud destroy();
	level.playerstext destroy();
}

// Halftime auto resume timer
HUD_ReadyUp_ResumingIn(minutes)
{
	level endon("readyup_removeAutoResume");

    level.ht_resume = maps\mp\gametypes\global\_global::newHudElem2();
	level.ht_resume.x = level.hud_readyup_offsetX;
	level.ht_resume.y = level.hud_readyup_offsetY + 270;
	level.ht_resume.horzAlign = "right";
	level.ht_resume.color = (0.8, 0.3, 0);
	level.ht_resume.alignX = "center";
	level.ht_resume.alignY = "middle";
	level.ht_resume.font = "default";
	level.ht_resume.fontscale = 1.2;
	level.ht_resume setText(game["STRING_READYUP_RESUMING_IN"]);

	level.ht_resume_clock = maps\mp\gametypes\global\_global::newHudElem2();
	level.ht_resume_clock.x = level.hud_readyup_offsetX;
	level.ht_resume_clock.y = level.hud_readyup_offsetY + 285;
	level.ht_resume_clock.horzAlign = "right";
	level.ht_resume_clock.color = (.98, .98, .60);
	level.ht_resume_clock.alignX = "center";
	level.ht_resume_clock.alignY = "middle";
	level.ht_resume_clock.font = "default";
	level.ht_resume_clock.fontscale = 1.2;
	level.ht_resume_clock setTimer(minutes * 60);

	level waittill("rupover");

	level.ht_resume FadeOverTime(1);
	level.ht_resume.alpha = 0;
	level.ht_resume_clock FadeOverTime(1);
	level.ht_resume_clock.alpha = 0;

	wait level.fps_multiplier * 1;

	level.ht_resume destroy();
	level.ht_resume_clock destroy();
}

// Halftime auto resume timer
HUD_ReadyUp_ResumingIn_ExtraTime()
{
	level endon("readyup_removeAutoResume");

	// Set your team as ready to skip readyup
	//level.setYourTeamAsReadyBG = maps\mp\gametypes\global\_global::addHUD(-160, 337, undefined, (1,1,1), "left", "top", "center", "top");
	level.setYourTeamAsReadyBG = maps\mp\gametypes\global\_global::addHUD(160, 337, undefined, (1,1,1), "left", "top", "center", "top");
    level.setYourTeamAsReadyBG setShader("black", 320, 20);
    level.setYourTeamAsReadyBG.alpha = 0.75;

    level.setYourTeamAsReady = maps\mp\gametypes\global\_global::newHudElem2();
    level.setYourTeamAsReady.x = 320;
    level.setYourTeamAsReady.y = 340;
    level.setYourTeamAsReady.alignX = "center";
    level.setYourTeamAsReady.alignY = "top";
    level.setYourTeamAsReady.fontScale = 1.1;
    level.setYourTeamAsReady.color = (1, 0, 0);
	level.setYourTeamAsReady setText(game["STRING_READYUP_SET_YOUR_TEAM_AS_READY"]);

	iprintlnbold(game["STRING_READYUP_TIME_EXPIRED"]);
	iprintlnbold(game["STRING_READYUP_TIME_EXPIRED_SKIP"]);

	// Red extra time
	level.ht_resume_clock_extra = maps\mp\gametypes\global\_global::newHudElem2();
	level.ht_resume_clock_extra.x = level.hud_readyup_offsetX;
	level.ht_resume_clock_extra.y = level.hud_readyup_offsetY + 298;
	level.ht_resume_clock_extra.horzAlign = "right";
	level.ht_resume_clock_extra.color = (.98, .2, .2);
	level.ht_resume_clock_extra.alignX = "center";
	level.ht_resume_clock_extra.alignY = "middle";
	level.ht_resume_clock_extra.font = "default";
	level.ht_resume_clock_extra.fontscale = 1.2;
	level.ht_resume_clock_extra setTimerUp(0.1);

    level waittill("rupover");

	level.ht_resume_clock_extra FadeOverTime(1);
	level.ht_resume_clock_extra.alpha = 0;
	level.setYourTeamAsReadyBG FadeOverTime(1);
	level.setYourTeamAsReadyBG.alpha = 0;
	level.setYourTeamAsReady FadeOverTime(1);
	level.setYourTeamAsReady.alpha = 0;

	wait level.fps_multiplier * 1;

	level.ht_resume_clock_extra destroy();
	level.setYourTeamAsReadyBG destroy();
	level.setYourTeamAsReady destroy();

}

// Called from matchingo if teams info is cleared
HUD_ReadyUp_ResumingIn_Delete()
{
	// Remove auto resume threads
	level notify("readyup_removeAutoResume");

	// Remove HUDS
	if (isDefined(level.ht_resume))
	{
		level.ht_resume destroy();
		level.ht_resume_clock destroy();

		level.ht_resume = undefined;
		level.ht_resume_clock = undefined;

		// Show clock
		level thread HUD_Clock();
	}

	if (isDefined(level.ht_resume_clock_extra))
	{
		level.ht_resume_clock_extra destroy();
		level.ht_resume_clock_extra = undefined;
	}

	if (isDefined(level.setYourTeamAsReadyBG))
	{
		level.setYourTeamAsReadyBG destroy();
		level.setYourTeamAsReadyBG = undefined;
		level.setYourTeamAsReady destroy();
		level.setYourTeamAsReady = undefined;
	}
}


// Called each time player is spawned
HUD_SelectTeam()
{
	logprint("_readyup:: HUD_SelectTeam - " + self.name + "\n");
	if (!isDefined(self.pers["firstTeamSelected"]))
	{
		logprint("_readyup:: HUD_SelectTeam - firstTeamSelected is not defined.\n");
		if (!isDefined(self.selectTeamInfoBG))
		{
			logprint("_readyup:: HUD_SelectTeam - selectTeamInfoBG is not defined.\n");
			// Set your team as ready to skip readyup
			//self.selectTeamInfoBG = maps\mp\gametypes\global\_global::addHUDClient(self, -50, -23, undefined, (1,1,1), "left", "top", "center", "middle");
			self.selectTeamInfoBG = maps\mp\gametypes\global\_global::addHUDClient(self, 270, 217, undefined, (1,1,1), "left", "top", "center", "middle");
		    self.selectTeamInfoBG setShader("black", 100, 20);
		    self.selectTeamInfoBG.alpha = 0.75;
			
			logprint("_readyup:: HUD_SelectTeam - (3) selectTeamInfoBG=" + isDefined(self.selectTeamInfoBG) + ", selectTeamInfo=" + isDefined(self.selectTeamInfo) + "\n");

		    //self.selectTeamInfo = maps\mp\gametypes\global\_global::addHUDClient(self, 0, -20, 1.1, (1,1,1), "center", "top", "center", "middle");
		    self.selectTeamInfo = maps\mp\gametypes\global\_global::addHUDClient(self, 320, 220, 1.1, (1,1,1), "center", "top", "center", "middle");
			self.selectTeamInfo setText(game["STRING_READYUP_SELECT_TEAM"]);
			
			logprint("_readyup:: HUD_SelectTeam - (4) selectTeamInfoBG=" + isDefined(self.selectTeamInfoBG) + ", selectTeamInfo=" + isDefined(self.selectTeamInfo) + "\n");
		} else 
		{
			logprint("_readyup:: HUD_SelectTeam - selectTeamInfoBG is defined.\n");
		}

	}
	else if (isDefined(self.selectTeamInfo))
	{
		logprint("_readyup:: HUD_SelectTeam - selectTeamInfo is defined; destroying hud.\n");
		
		logprint("_readyup:: HUD_SelectTeam - (1) selectTeamInfoBG=" + isDefined(self.selectTeamInfoBG) + ", selectTeamInfo=" + isDefined(self.selectTeamInfo) + "\n");
		if (isDefined(self.selectTeamInfoBG))
		{
			logprint("_readyup:: HUD_SelectTeam selectTeamInfoBG is defined - destroying\n");
			self.selectTeamInfoBG destroy();
			//self.selectTeamInfoBG destroy();
			logprint("_readyup:: HUD_SelectTeam selectTeamInfoBG is defined - destroyed\n");
			//self.selectTeamInfoBG = undefined;
		}
		logprint("_readyup:: HUD_SelectTeam IN MIDDLE LOLWUT\n");
		if (isDefined(self.selectTeamInfo))
		{
			logprint("_readyup:: HUD_SelectTeam selectTeamInfo is defined - destroying\n");
			self.selectTeamInfo destroy();
			//self.selectTeamInfo destroy();
			//self.selectTeamInfo = undefined;
		}

		logprint("_readyup:: HUD_SelectTeam - (2) selectTeamInfoBG=" + isDefined(self.selectTeamInfoBG) + ", selectTeamInfo=" + isDefined(self.selectTeamInfo) + "\n");
	} else
	{
		logprint("_readyup:: HUD_SelectTeam - firstTeamSelected and selectTeamInfo not defined\n");
	}
}


// Black scren + timer countdown
HUD_Half_Start(time)
{
	if ( time < 3 )
		time = 3;

	// Black fullscreen backgound with animation
	blackbg = maps\mp\gametypes\global\_global::addHUD(0, 0, undefined, undefined, "left", "top", "fullscreen", "fullscreen");
	blackbg.alpha = 0;
	blackbg FadeOverTime(2);
	blackbg.alpha = 0.75;
	blackbg.sort = -3;
	blackbg.foreground = true;
	blackbg SetShader("black", 640, 480);

	// Match begins in
	//blackbgtimertext = maps\mp\gametypes\global\_global::addHUD(0, 183, 1.35, (1,1,1), "center", "top", "center");
	blackbgtimertext = maps\mp\gametypes\global\_global::addHUD(320, 183, 1.35, (1,1,1), "center", "top", "center");
	blackbgtimertext maps\mp\gametypes\global\_global::showHUDSmooth(1.5);
	blackbgtimertext.sort = -2;
	blackbgtimertext.foreground = true;
	if (level.in_timeout)
		blackbgtimertext SetText(game["STRING_READYUP_MATCH_RESUMES_IN"]);
	else if (game["is_halftime"])
		blackbgtimertext SetText(game["STRING_READYUP_MATCH_CONTINUES_IN"]);
	else
		blackbgtimertext SetText(game["STRING_READYUP_MATCH_BEGINS_IN"]);

	// Count down timer
	//blackbgtimer = maps\mp\gametypes\global\_global::addHUD(0, 200, 1.35, (1,1,1), "center", "top", "center");
	blackbgtimer = maps\mp\gametypes\global\_global::addHUD(320, 200, 1.35, (1,1,1), "center", "top", "center");
	blackbgtimer maps\mp\gametypes\global\_global::showHUDSmooth(1.5);
	blackbgtimer.sort = -1;
	blackbgtimer.foreground = true;
	blackbgtimer settimer(time-0.5);

	wait level.fps_multiplier * time;

	blackbg FadeOverTime(1);
	blackbg.alpha = 0;
	blackbgtimertext FadeOverTime(1);
	blackbgtimertext.alpha = 0;
	blackbgtimer FadeOverTime(1);
	blackbgtimer.alpha = 0;

	wait level.fps_multiplier * 1;

	blackbg destroy();
	blackbgtimertext destroy();
	blackbgtimer destroy();
}


deletePlacedEntity(entity)
{
	entities = getentarray(entity, "classname");
	for(i = 0; i < entities.size; i++)
	{
		//println("DELETED: ", entities[i].classname);
		entities[i] delete();
	}
}


playStartSound()
{
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		if (players[i].sessionteam == "allies" || players[i].sessionteam == "axis" || (level.gametype == "dm" && players[i].sessionteam == "none"))
			players[i] playLocalSound("hill400_assault_gr5_letsgoget");
	}
}


playLastManSound()
{
	self endon("disconnect");

	wait level.fps_multiplier * 3;

	if (self.isReady == false)
	{
		self playLocalSound("US_0_order_move_generic_05");
	}

	// Next sound after 30 sec
	wait level.fps_multiplier * 30;

	self.lastMan = false;
}