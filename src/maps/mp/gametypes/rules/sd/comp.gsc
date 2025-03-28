

Load()
{
	game["rules_leagueString"] = &"Search and Destroy";
	game["rules_formatString"] = &"MR12"; // default

	game["ruleCvars"] = GetCvars(game["ruleCvars"]);
}

GetCvars(arr)
{
	// Match Style
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_sd_timelimit", 0);		// Time limit for map. 0=disabled (minutes)
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_sd_half_round", 12);	// Number of rounds when half-time starts. 0=ignored
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_sd_half_score", 0);	// Number of score when half-time starts. 0=ignored
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_sd_end_round", 24);	// Number of rounds when map ends. 0=ignored
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_sd_end_score", 13);	// Number of score when map ends. 0=ignored

	// Round options
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_sd_strat_time", 10);	// Time before round starts where players cannot move
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_sd_roundlength", 2.25);	// Time length of each round (min)
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_sd_end_time", 6);		// Time et the end of the round (after last player is killed) when you can finding weapons for the next round
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_sd_count_draws", 0);	// If players are killed at same time - count this round (1) or play new round (0)?
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_sd_round_report", 1);		// Print kill and damage stats at the end of the round

	// Bomb settings
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_sd_bombtimer_show", 1);	// Show bombtimr stopwatch
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_sd_bombtimer", 60);		// Time untill bomb explodes. (seconds)
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_sd_PlantTime", 5);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_sd_DefuseTime", 10);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_sd_plant_points", 0);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_sd_defuse_points", 0);

	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_sd_sniper_shotgun_info", 1);	// Show weapon info about sniper and shotgun players



	/*******************************
	  Shared gametype script cvars
	*******************************/

	// Readyup
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_readyup", 1); 			// Enable readyup [0, 1] 0 = disbled  1 = enabled
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_readyup_autoresume_half", 2); 	// Minutes to auto-resume halftime [0 - 10] 0 = disabled
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_readyup_autoresume_map", 5); 	// Minutes to auto-resume between maps [0 - 10] 0 = disabled
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_readyup_nadetraining", 1); 	// Enable strat grenade fly mode in readyup
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_readyup_start_timer", 10); 	// Count-down timer with black screen when all players are ready

	// Time-out
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_timeouts", 4);			// Total timeouts for one team
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_timeouts_half", 2); 		// How many per side
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_timeout_length", 2); 		// Length in minutes


	// Are there OT Rules?
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_overtime", 1);

	// OT Rules - MR3 format
  	if (isDefined(game["overtime_active"]) && game["overtime_active"])
  	{
		arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_sd_half_round", 3);
		arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_sd_half_score", 0);
		arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_sd_end_round", 6);
		arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_sd_end_score", game["overtime_score"] + 4); // 12 / 12  ->  16 / 16  ->  20 / 20  -> ...

		// Half auto-resume time
		arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_readyup_autoresume_half", 1); 	// Minutes to auto-resume halftime [0 - 10] 0 = disabled

		// Time-out
		arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_timeouts", 2);			// Total timeouts for one team
		arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_timeouts_half", 1); 		// How many per side
		arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_timeout_length", 1); 		// Length in minutes
	}


	// Hud Options
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_show_players_left", 1);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_show_players_names_left", 0);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_show_objective_icons", 0);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_show_hitblip", 0);

	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_show_scoreboard", 1); 		//Score in the upper left corner [0 - 1] 0=hided  1=visible  (if 1, score can be still hided by player settings)
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_show_scoreboard_limit", 1);

	// Health Regeneration
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_allow_health_regen", 1); 	// 0=no regen, 1=refill health after "scr_regen_delay"
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_allow_regen_sounds", 1);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_regen_delay", 5000); 		//Time before regen starts

	// Ambients
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_allow_ambient_fog", 0);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_allow_ambient_sounds", 0);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_allow_ambient_fire", 0);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_allow_ambient_weather", 0);


	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_allow_shellshock", 0);					// Create shell shock effect when player is hitted
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_replace_russian", 1); 					// Replace russians with Americans / Brisith
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_blackout", 0); 						// If match is in progress, show map background all over the screen and disable sounds for connected player
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_recording", 0); 						// Starts automatically recording when match starts
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_matchinfo", 2); 						// Show match info in menu (1 = without team names, 2 = with team names)
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_map_vote", 0);						// Open voting system so players can vote about next map
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_map_vote_replay", 0);					// Show option to replay this map in voting system
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_auto_deadchat", 1);					// Automaticly enable / disable deadchat
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_remove_killtriggers", 1);					// Remove some of the kill-triggers created in 1.3 path
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_bash", 1);							// Bash mode can be called via menu in readyup

	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_friendlyfire", 1);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_drawfriend", 1);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_teambalance", 0);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_spectatefree", 0);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_spectateenemy", 0);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_streamersystem", 1);				// Enable streamer system (menu overlay with auto-killcam, auto-spectator, xray, etc.. features)

	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "g_allowVote", 0);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "g_maxDroppedWeapons", 32);
	//arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "sv_fps", 30);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "sv_fps", 20);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "sv_maxRate", 25000);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "sv_timeout", 60);					// Time after 999 player is kicked
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "g_antilag", 0);					// Antilag 1 means that players ping is considered when calculating hit location - what you see on your monitor is also what the server will see
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "g_knockback", 0);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "r_fog", 0);					// Speed energy if player is hitted by grenade, other player, etc; turned off to avoid "sliding" effect

	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_fast_reload_fix", 1);				// Prevent players from shoting faster via double-scroll bug
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_shotgun_consistent", 1);			// Enable consistent shotgun to fix long shot kills and short range hits
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_prone_peek_fix", 1);				// Prevent players from doing fast peeks from prone (time, after player can prone again will be increased)
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_mg_peek_fix", 1);				// When mg is dropped, player is spawned right behid mg
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_hitbox_hand_fix", 1);				// Damage to left hand is adjusted for rifles and scopes.
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_hitbox_torso_fix", 1);					// Damage of M1, rifles, scopes and shotgun is adjusted to have less hits in game
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_killcam", 0);					// Killcam


	/*********
	WEAPONS
	*********/
	// Rifles-only mode
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_rifle_mode", 0);

	// Nade spawn counts for each class
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_boltaction_nades", 2);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_semiautomatic_nades", 2);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_smg_nades", 1);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_sniper_nades", 1);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_mg_nades", 1);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_shotgun_nades", 1);

	// Smoke spawn counts for each class
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_boltaction_smokes", 0);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_semiautomatic_smokes", 0);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_smg_smokes", 0);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_sniper_smokes", 0);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_mg_smokes", 0);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_shotgun_smokes", 1);

	// Weapon Limits by class per team
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_boltaction_limit", 99);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_sniper_limit", 1);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_semiautomatic_limit", 99);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_smg_limit", 99);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_mg_limit", 99);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_shotgun_limit", 1);

	// Allow weapon drop when player die
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_boltaction_allow_drop", 1);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_sniper_allow_drop", 0);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_semiautomatic_allow_drop", 1);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_smg_allow_drop", 1);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_mg_allow_drop", 1);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_shotgun_allow_drop", 0);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_pistol_allow_drop", 1);

	// Allow grenade / smoke drop when player die
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_allow_grenade_drop", 1);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_allow_smoke_drop", 0);

	// Player's weapon drop
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_allow_primary_drop", 1);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_allow_secondary_drop", 1);

	// Allow/Disallow Weapons
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_allow_greasegun", 1);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_allow_m1carbine", 1);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_allow_m1garand", 1);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_allow_springfield", 1);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_allow_thompson", 1);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_allow_bar", 1);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_allow_sten", 1);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_allow_enfield", 1);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_allow_enfieldsniper", 1);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_allow_bren", 1);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_allow_pps42", 1);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_allow_nagant", 1);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_allow_svt40", 1);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_allow_nagantsniper", 1);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_allow_ppsh", 1);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_allow_mp40", 1);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_allow_kar98k", 1);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_allow_g43", 1);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_allow_kar98ksniper", 1);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_allow_mp44", 1);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_allow_shotgun", 1);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_allow_fg42", 0);

	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_allow_pistols", 1);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_allow_turrets", 1);

	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_allow_panzerfaust", 0);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_allow_fg42", 0);

	// Single Shot Kills
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_no_oneshot_pistol_kills", 0);
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_no_oneshot_ppsh_kills", 0);

	// PPSH Balance - Limits range of PPSH to same as Tommy
	arr = maps\mp\gametypes\global\_global::ruleCvarDefault(arr, "scr_balance_ppsh_distance", 0);

	return arr;
}
