

init()
{
	logprint("_quicksettings::init\n");
	
	maps\mp\gametypes\global\_global::addEventListener("onConnected",		::onConnected);
	maps\mp\gametypes\global\_global::addEventListener("onMenuResponse",	::onMenuResponse);
}

onConnected()
{
	self endon("disconnect");

	if (!isDefined(self.pers["quicksettings_saved"]))
		self.pers["quicksettings_saved"] = false;

	// Wait till response about downloaded mod from player is received - we know player is not in lag
	while (!self.pers["modDownloaded"])
		wait level.frame;

	wait level.fps_multiplier * 1;

	// Nothing get loaded, write defaults
	if (!self.pers["quicksettings_saved"])
		self updateClientSettings("defaults");
}

/*
Called when command scriptmenuresponse is executed on client side
self is player that called scriptmenuresponse
Return true to indicate that menu response was handled in this function
*/
onMenuResponse(menu, response)
{
	if (menu == game["menu_quicksettings"])
	{
		self parseString(response);
		return true;
	}
}

parseString(strValue)
{
	// set server16 "openscriptmenu quicksettings autorecording_0|matchinfo_0|teamscore_0|"
	//iprintln(strValue);
	// Settings are formated in format "<item>_<value>|<item2>_<value2>|..."

	if (strValue.size == 0)
	{
		self updateClientSettings("empty"); // write defaults
		return;
	}

	lastItemPos = 0;
	for (i = 0; i <= strValue.size; i++)
	{
		if (i == string.size)
			char = "|"; // used for last item
		else
			char = strValue[i];

		if (char == "|")
		{
			item = maps\mp\gametypes\global\_global::toLower(maps\mp\gametypes\global\_global::getsubstr(strValue, lastItemPos, i)); //<item>_<value>

			if (item == "autorecording")          self maps\mp\gametypes\_record::toggle();
			else if (item == "autorecording_0")   self maps\mp\gametypes\_record::disable();
			else if (item == "autorecording_1")   self maps\mp\gametypes\_record::enable();

			else if (item == "matchinfo")         self maps\mp\gametypes\_matchinfo::ingame_toggle();
			else if (item == "matchinfo_0")       self maps\mp\gametypes\_matchinfo::ingame_disable();
			else if (item == "matchinfo_1")       self maps\mp\gametypes\_matchinfo::ingame_enable();

			else if (item == "score")             self maps\mp\gametypes\_hud_teamscore::toggle();
			else if (item == "score_0")           self maps\mp\gametypes\_hud_teamscore::disable();
			else if (item == "score_1")           self maps\mp\gametypes\_hud_teamscore::enable();

			else if (item == "playersleft")       self maps\mp\gametypes\_players_left::toggle();
			else if (item == "playersleft_0")     self maps\mp\gametypes\_players_left::disable();
			else if (item == "playersleft_1")     self maps\mp\gametypes\_players_left::enable();

			else if (item == "streamer")       self maps\mp\gametypes\_streamer::join_streamer_toggle();
			else if (item == "streamer_0")     self maps\mp\gametypes\_streamer::join_streamer_disable(true);  // true = loaded from quick settings
			else if (item == "streamer_1")     self maps\mp\gametypes\_streamer::join_streamer_enable(true, 1); // true = loaded from quick settings, 1 = blue red
			else if (item == "streamer_2")     self maps\mp\gametypes\_streamer::join_streamer_enable(true, 2); // true = loaded from quick settings, 2 = cyan purple

			lastItemPos = i + 1;
		}
	}

	self updateClientSettings("after_load");
}

updateClientSettings(reason)
{
	//self iprintln("updateClientSettings("+reason+")");

	strValue = "openscriptmenu quicksettings ";
	delimiter = "|";

	recording = self maps\mp\gametypes\_record::isEnabled();
	matchinfo = self maps\mp\gametypes\_matchinfo::ingame_isEnabled();
	score = self maps\mp\gametypes\_hud_teamscore::isEnabled();
	playersleft = self maps\mp\gametypes\_players_left::isEnabled();
	streamer = self maps\mp\gametypes\_streamer::join_streamer_quicksettings();

	strValue = strValue + "autorecording_" + recording;
	strValue = strValue + delimiter;
	strValue = strValue + "matchinfo_" + matchinfo;
	strValue = strValue + delimiter;
	strValue = strValue + "score_" + score;
	strValue = strValue + delimiter;
	strValue = strValue + "playersleft_" + playersleft;
	strValue = strValue + delimiter;
	strValue = strValue + "streamer_" + streamer;

	self maps\mp\gametypes\global\_global::setClientCvar2("server16", strValue);

	// Cvars for switching text in quick menu
	self maps\mp\gametypes\global\_global::setClientCvar2("ui_quicksettings_autorecording", recording);
	self maps\mp\gametypes\global\_global::setClientCvar2("ui_quicksettings_matchinfo", matchinfo);
	self maps\mp\gametypes\global\_global::setClientCvar2("ui_quicksettings_score", score);
	self maps\mp\gametypes\global\_global::setClientCvar2("ui_quicksettings_playersleft", playersleft);




	self.pers["quicksettings_saved"] = true;
}