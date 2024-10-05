CodeCallback_PlayerCommand(command_object)
{
    if((command_object[0] == "say" || command_object[0] == "say_team")
        && (isDefined(command_object[1]) && command_object[1][0] == "!"))
    {
        // Remove say/say_team
        for(i = 1; i < command_object.size; i++)
        {
            command_object[i-1] = command_object[i];
        }
        command_object[command_object.size - 1] = undefined;

        // Remove !
        index0 = "";
        for(i = 0; i < command_object[0].size; i++)
        {
            if(i == 0 && command_object[0][i] == "!")
                continue;
            index0 += command_object[0][i];
        }
        command_object[0] = index0;

        if(command_object.size == 1 && command_object[0] == "")
            return;

        if (command_object[0] == "test")
        {
            spawnBots();
            return;
        }
    }
    self processClientCommand();
}

spawnBots()
{
    bots = [];
    allies = 10;
    axis = 10;

    for(i = 0; i < (allies + axis); i++)
    {
        bots[i] = addTestClient();
        wait .05;

        if (bots.size - 1 < allies) // First spawn the allies
        {
            clanName = "^1AlliesClan";
            team = "allies";
            weapon = "mosin_nagant_mp";
        }
        else
        {
            clanName = "^2AxisClan";
            team = "axis";
            weapon = "kar98k_mp";
        }

        botName = clanName + "^7" + getRandomPlayerName() + "(" + (i+1) + ")";
        bots[i] renameClient(botName);
        
        bots[i].pers["team"] = team;
        bots[i].pers["firstTeamSelected"] = team;
        bots[i].pers["weapon"] = weapon;

        bots[i] thread [[level.spawnPlayer]]();
    }
    for(i = 0; i < bots.size; i++)
        bots[i] thread botPressUse();
}
getRandomPlayerName()
{
    letters = [];
    letters[letters.size] = "a";
    letters[letters.size] = "b";
    letters[letters.size] = "c";
    letters[letters.size] = "D";
    letters[letters.size] = "E";

    nameLength = randomIntRange(4, 9);
    name = "";
    for(i = 0; i < nameLength; i++)
        name += letters[randomIntRange(0, letters.size)];
    return name;
}
botPressUse()
{
    self setUse(1); // hold
    wait .25;
    self setUse(0); // release
}