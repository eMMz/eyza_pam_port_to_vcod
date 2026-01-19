Init()
{
	logprint("pb_system::init\n");
	
    maps\mp\gametypes\global\_global::addEventListener("onStartGameType", ::onStartGameType);
}

onStartGameType()
{
    logprint("pb_system::onStartGameType\n");
    
    _rPAM_rules\_rpam_pb_utils::Check_PB_Config();
}