// All credits of the monitoring scripts goes to vPAM and Walrus. I take no credit at all into making theese scripts. 
// Adapted to fit rPAMv1.11 by Anglhz<3

init()
{
    logprint("_rpam_aimrun_fix::init\n");

    maps\mp\gametypes\global\_global::addEventListener("onCvarChanged", ::onCvarChanged);

	maps\mp\gametypes\global\_global::registerCvar("scr_rpam_aimrun_fix", "BOOL", 0);

    maps\mp\gametypes\global\_global::addEventListener("onConnected",     ::onConnected);
    maps\mp\gametypes\global\_global::addEventListener("onSpawned",     ::onSpawned);
}

// This function is called when cvar changes value.
// Is also called when cvar is registered
// Return true if cvar was handled here, otherwise false
onCvarChanged(cvar, value, isRegisterTime)
{
	switch(cvar)
	{
		case "scr_rpam_aimrun_fix":
			level.scr_rpam_aimrun_fix = value;
			if (!isRegisterTime)
			{
				if (level.scr_rpam_aimrun_fix) // changed to 1
			  	{
			    		players = getentarray("player", "classname");
			    		for(i = 0; i < players.size; i++)
			    		{
			      			player = players[i];
			      			player onConnected();
			    		}
			  	} else
                {
                    players = getentarray("player", "classname");
			    		for(i = 0; i < players.size; i++)
			    		{
			      			player = players[i];
			      			player notify("rpam_aimrun_disabled");
			    		}
                }
			}
			return true;
	}
	return false;
}

onConnected()
{
	logprint("_rpam_aimrun_fix::onConnected start\n");
    if (!level.scr_rpam_aimrun_fix)
      return;
    
    monitoring();
	logprint("_rpam_aimrun_fix::onConnected end\n");
}

onSpawned()
{
    // if (!level.scr_rpam_aimrun_fix)
    //   return;
    
    // self thread start_aimrun_monitor();
}

// 1st version ################################################
start_aimrun_monitor()
{
	self endon("spawned");
	
	//logprint("_rpam_aimrun_fix::start_aimrun_monitor\n");
	
	slots[0] = "primary";
	slots[1] = "primaryb";
	if (level.allow_pistols) {
		slots[2] = "pistol";
	}

	// Save current clip ammo of all slots.
	for (i = 0; i < slots.size; i++) {
		clip[slots[i]] = self getWeaponSlotClipAmmo(slots[i]);
	}

	do {
		for (i = 0; i < slots.size; i++) {
			clip_new = self getWeaponSlotClipAmmo(slots[i]);

			// Check if reload happened
			if (clip_new > clip[slots[i]]) {
				thread _check_aim_run(slots[i]);
			}

			clip[slots[i]] = clip_new;
		}

		wait .05;
	} while (self.sessionstate == "playing");
	//logprint("_rpam_aimrun_fix::start_aimrun_monitor stopped playing\n");
}

_check_aim_run(slot)
{
	// Aim running is done with a bolt action rifle by holding the attack button at reloading.
	// While holding the attack button after reloading, a player can aim while maintaining regular speed.
	
	//logprint("_rpam_aimrun_fix::_check_aim_run start\n");

	if (slot != "primary" && slot != "primaryb" && slot != "pistol") {
        //logprint("_rpam_aimrun_fix::_check_aim_run stop - incorrect weapon slot type\n");
		return;
	}

	weapon = self getWeaponSlotWeapon(slot);

	if (
		weapon != "enfield_mp" &&
		weapon != "m1garand_mp" &&
		weapon != "m1carbine_mp" &&
		weapon != "kar98k_mp" &&
		weapon != "kar98k_sniper_mp" &&
		weapon != "mosin_nagant_mp" &&
		weapon != "mosin_nagant_sniper_mp" &&
		weapon != "springfield_mp" &&
		weapon != "luger_mp" &&
		weapon != "colt_mp"
	) {
		return;
	}

	// Roughly 1 second after clip count is increased, weapon can fire again.
	// We will check for the attack button being pressed during a small window.
	// If inside the window a bullet is fired, the window ends.
	ammo = self getWeaponSlotClipAmmo(slot);

	// Wait for reloading animation to progress.
	wait 0.9;

	// Check during the next 0.5 second window for holding it.
	for (tick = 0; tick < 10 && self.sessionstate == "playing"; tick++) {
		// If a shot was fired (by pressing attack), aimrunning isn't relevant anymore.
		if (self getWeaponSlotClipAmmo(slot) != ammo) {
			break;
		}

		if (self attackButtonPressed()) {
			//logprint("weapon::_check_aim_run disabling weapon - aimrun detected during reloading\n");
			self disableWeapon();
		}

		wait 0.05;
		self enableWeapon();
	}
    //logprint("_rpam_aimrun_fix::_check_aim_run end\n");
}


// 2nd version #####################################################
monitoring()
{
	self endon("player_disconnected");
	self thread fastshoot_monitoring();
	self thread aimrun_monitoring();
	self thread weapon_switch_monitoring();
}

weapon_switch_monitoring()
{
	self endon("player_disconnected");
    self endon("rpam_aimrun_disabled");
	previous_weapon = "";
	current_weapon = "";

	while(1) {
		while(!isAlive(self)) {
			wait 0.25;
		}

		while (previous_weapon == current_weapon) {
			current_weapon = self GetCurrentWeapon();
			wait 0.05;
		}

		self notify("weapon_switch");
		self notify("stop_aimrun_monitoring_thread");
		previous_weapon = current_weapon;

		wait 0.20;
	}
}

fastshoot_monitoring()
{
	self endon("player_disconnected");
    self endon("rpam_aimrun_disabled");

	while(!isAlive(self))
	{
		wait 0.05;
	}

	total_ammo_previous = -1;

	while(1)
	{
		if (!isAlive(self)) {
			wait 0.05;
			continue;
		}
		total_ammo = getWeaponTotalAmmo(self);
		if (total_ammo < total_ammo_previous) {
			self notify("stop_aimrun_monitoring_thread");
		}
		total_ammo_previous = total_ammo;

		wait 0.05;
	}
}

aimrun_monitoring()
{
	self endon("player_disconnected");
    self endon("rpam_aimrun_disabled");
	//logprint("_rpam_aimrun_fix::aimrun_monitoring\n");
	while(1) {
		while (!isAlive(self)) {
			wait 0.05;
		}

        if (!level.scr_rpam_aimrun_fix)
            return;

		self thread aimrun_monitoring_thread();
		self waittill("stop_aimrun_monitoring_thread");
		//logprint("_rpam_aimrun_fix::aimrun_monitoring stop trigger\n");

		wait 0.05;
	}
}

aimrun_monitoring_thread()
{
	self endon("player_disconnected");
    self endon("rpam_aimrun_disabled");
	self endon("stop_aimrun_monitoring_thread");
	//logprint("_rpam_aimrun_fix::aimrun_monitoring_thread\n");

	current_weapon = self GetCurrentWeapon();

	if (
		current_weapon != "enfield_mp" &&
		current_weapon != "m1garand_mp" &&
		current_weapon != "m1carbine_mp" &&
		current_weapon != "kar98k_mp" &&
		current_weapon != "kar98k_sniper_mp" &&
		current_weapon != "mosin_nagant_mp" &&
		current_weapon != "mosin_nagant_sniper_mp" &&
		current_weapon != "springfield_mp" &&
		current_weapon != "luger_mp" &&
		current_weapon != "colt_mp"
	) {
		return;
	}

	slot = "";
	if (current_weapon == self getweaponslotweapon("primary")) {
		slot = "primary";
	} else if (current_weapon == self getweaponslotweapon("primaryb")) {
        slot = "primaryb";
    } else if (current_weapon == self getweaponslotweapon("pistol")) {
        slot = "pistol";
    } else {
        return;
    }

	previous_clip_ammo = self getweaponslotclipammo(slot) + 1;
	current_clip_ammo = self getweaponslotclipammo(slot);

	// wait till full reloading
	while(current_clip_ammo < previous_clip_ammo) {
		current_clip_ammo = self getweaponslotclipammo(slot);
		wait 0.15;
	}

	previous_clip_ammo = current_clip_ammo;

	time = 0;
	wait 0.5;
	MAX = 40;

	while(time < MAX && current_clip_ammo == previous_clip_ammo) {
		count = 0;
		current_clip_ammo = self getweaponslotclipammo(slot);
		while (self AttackButtonPressed() && current_clip_ammo == previous_clip_ammo && count < 10) {
			//logprint("_rpam_aimrun_fix::aimrun_monitoring_thread shoot during aimrun detected - disabling weapon\n");
			self disableWeapon();
			wait 0.05;
			self enableWeapon();
			current_clip_ammo = self getweaponslotclipammo(slot);
			count++;
			time = time +5;
			wait 0.05;
		}
		time = time + 5;
		wait 0.05;
	}
}

getWeaponTotalAmmo(ply) {
	return ply getweaponslotammo("primary") + ply getweaponslotclipammo("primary") + ply getweaponslotammo("primaryb") + ply getweaponslotclipammo("primaryb") + ply getweaponslotammo("pistol") + ply getweaponslotclipammo("pistol");
}