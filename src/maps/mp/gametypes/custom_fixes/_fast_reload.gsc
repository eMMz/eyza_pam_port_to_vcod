

init()
{
	logprint("_fast_reload::init\n");
	
	maps\mp\gametypes\global\_global::addEventListener("onCvarChanged", ::onCvarChanged);

	maps\mp\gametypes\global\_global::registerCvar("scr_fast_reload_fix", "BOOL", 0);


	level.fastReload_startTime = getTime();

	maps\mp\gametypes\global\_global::addEventListener("onConnected",     ::onConnected);
}

// This function is called when cvar changes value.
// Is also called when cvar is registered
// Return true if cvar was handled here, otherwise false
onCvarChanged(cvar, value, isRegisterTime)
{
	switch(cvar)
	{
		case "scr_fast_reload_fix":
			level.scr_fast_reload_fix = value;
			if (!isRegisterTime)
			{
				if (level.scr_fast_reload_fix) // changed to 1
			  	{
			    		players = getentarray("player", "classname");
			    		for(i = 0; i < players.size; i++)
			    		{
			      			player = players[i];
			      			player onConnected();
			    		}
			  	}
			}
			return true;
	}
	return false;
}


onConnected()
{
    if (!level.scr_fast_reload_fix)
      return;

    //self thread manageWeaponCycleDelay();
}


getCurrentWeaponSlot()
{
    weapon1 = self getweaponslotweapon("primary");
	weapon2 = self getweaponslotweapon("primaryb");

    current = self getcurrentweapon(); // can be none ()

	if(current == weapon1)
		return "primary";
	else if(current == weapon2)
		return "primaryb";
    else
        return "none";
}

getClipAmmo()
{
    currentSlot = getCurrentWeaponSlot();

    return self getweaponslotclipammo(currentSlot);
}

manageWeaponCycleDelay()
{
    self endon("disconnect");

    lastClipAmmo = 0;
    lastWeapon = "";

    // Start as activated to fix problem when the cvar is set at the end of the round
    cycleDelayActivated = true;
    cycleDelayTime = 0;

    wait level.fps_multiplier * 0.2;

    for (;;)
    {
        wait level.frame;

        // Fast reload fix was turned off by cvar
        if (!level.scr_fast_reload_fix)
        {
          if (!cycleDelayActivated) // wait until cycle dalay is restored to original state
            return;
        }

        // If we have weapon that can be bugged
        if (cycleDelayActivated)
        {
            cycleDelayTime -= level.frame;

            if (cycleDelayTime <= 0)
            {
                if (level.debug_fastreload) self iprintln("^2Fast reload bug ok");
                self maps\mp\gametypes\global\_global::setClientCvar2("cg_weaponCycleDelay", "0");

                cycleDelayActivated = false;
                cycleDelayTime = 0;
            }
        }


        currentWeapon = self getcurrentweapon();

        // Player is planting, or is using ladder
        if (currentWeapon == "none")
        {
            cycleDelayTime = 0; // reset cycle delay
            continue;
        }


        if (currentWeapon != lastWeapon)
        {
            //self iprintln("weapon switched");
            lastWeapon = currentWeapon;

            lastClipAmmo = self getClipAmmo();

            cycleDelayTime = 0; // reset cycle delay

            continue; // ignore weapon clip ammo change because weapon is changed
        }


        currentClipAmmo = self getClipAmmo();

        // If weapon fired
        if (currentClipAmmo < lastClipAmmo)
        {
            // Get time how long rechamber will take
            timer = GetRechamberTime(currentWeapon);

      			if (timer > 0)
      			{
  	            cycleDelayActivated = true;
  	            cycleDelayTime = timer - level.frame*3;

                // Send command after a few frames (this may help fix fps drop when player fire from weapon)
                wait level.frame*3;

  	            if (level.debug_fastreload) self iprintln("^1Preventing fast reload bug");
  	            self maps\mp\gametypes\global\_global::setClientCvar2("cg_weaponCycleDelay", "200");	// time in ms when player can change weapon again
      			}
        }

        lastClipAmmo = currentClipAmmo;
    }
}



/*
Hit fire                                      Ready to fire again
   ^                                                  ^
   |                                                  |
   |  Fire time   |           Rechamber time          |
   | ------------ | ----------------------------------|
   |    0.33s     |                 1s                |
   |              |                     |             |
   |              | Rechamber bolt time |             |
   |              | ------------------- |             |
   |              |        0.65s        |             |

      All able      Fire, bash, zoom        All able
                         disabled

Rechamber time - fire disabled
Rechember bolt time - bash disabled

*/
GetRechamberTime(weaponName)
{
    timer = 0;
    switch(weaponName)
    {
        case "kar98k_mp":               timer = 1.33; break;
        case "kar98k_sniper_mp":        timer = 1.33; break;

        case "enfield_mp":              timer = 1.397; break;
        case "enfield_scope_mp":        timer = 1.38; break;

        case "mosin_nagant_mp":         timer = 1.28; break;
        case "mosin_nagant_sniper_mp":  timer = 1.33; break;

        case "springfield_mp":          timer = 1.33; break;

        //case "shotgun_mp":              timer = 1.0163; break;
    }

    return timer;
}