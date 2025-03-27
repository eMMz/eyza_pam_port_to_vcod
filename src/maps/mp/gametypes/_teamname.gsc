

Init()
{
	logprint("_teamname::init\n");
	
	// Team names
	level.teamname_allies = "";
	level.teamname_axis = "";

	level.teamname["allies"] = "";
	level.teamname["axis"] = "";

	// Team names are updated only if its needed for other functions (matchinfo, recording, ...)
/*
	// Testing
	names[0] = "UGNC | eyza UG";
	names[1] = "UGNC | aske";
	names[2] = "UGNC | tomik";
	names[3] = "UGNC | nostry";
	names[4] = "UGNC | lampy";
	println(getBestNameFromArray(names));

	names[0] = "FRUGO craven";
	names[1] = "FRUGO law";
	names[2] = "FRUGO pix";
	names[3] = "FRUGO crash";
	names[4] = "FRUGO Fakir";
	println(getBestNameFromArray(names));

	names[0] = "aaa TEAM NAME";
	names[1] = "bbb TEAM NAME";
	names[2] = "ccc TEAM NAME";
	names[3] = "ddd noclan";
	names[4] = "eee TEAM NAME";
	println(getBestNameFromArray(names));

	names[0] = "aaa TEAM NAME";
	names[1] = "bbb TEAM NAME";
	names[2] = "ccc 1111";
	names[3] = "ddd 2222";
	names[4] = "eee TEAM NAME";
	println(getBestNameFromArray(names));

	names[0] = "aaa TEAM NAME";
	names[1] = "bbb TEAM NAME";
	names[2] = "ccc TEAM NAME";
	names[3] = "dcc 111";
	names[4] = "eee TEAM NAME";
	println(getBestNameFromArray(names));

	names[0] = "ONLINEGAMERS | dymatize";
	names[1] = "ONLINEGAMERS | DudlajS";
	names[2] = "ONLINEGAMERS | C A A -";
	names[3] = "ONLINEGAMERS | VITY";
	names[4] = "ONLINEGAMERS | hurvajz";
	println(getBestNameFromArray(names));

	names[0] = "CITRO()NS ajxera";
	names[1] = "CITRO()NS network";
	names[2] = "CITRO()NS Za$$kodn1K__";
	names[3] = "CITRO()NS dur1el -";
	names[4] = "CITRO()NS CHACHARUS";
	println(getBestNameFromArray(names));

	names[0] = "Reanimation Sp1RiT";
	names[1] = "Reanimation pawadox-";
	names[2] = "Reanimation G4box(..!..)";
	names[3] = "Reanimation blavex";
	names[4] = "Reanimation Sk1lzZ<3";
	println(getBestNameFromArray(names));

	names[0] = "BoMbSQUad vioqor";
	names[1] = "BoMbSQUad mavalam";
	names[2] = "BoMbSQUad domz";
	names[3] = "BoMbSQUad iconz";
	names[4] = "BoMbSQUad SANTAN";
	println(getBestNameFromArray(names));

	names[0] = "[ < T N F > ] Blinde";
	names[1] = "[ < T N F > ] deb1lek";
	names[2] = "[ < T N F > ] CHARVIS";
	names[3] = "[ < T N F > ] Fazi";
	names[4] = "[ < T N F > ] inhox";
	println(getBestNameFromArray(names));

	names[0] = "(.Y.) seko";
	names[1] = "(.Y.) l e r i X";
	names[2] = "(.Y.) C E R K Y S";
	names[3] = "(.Y.) A N T O N I N";
	names[4] = "(.Y.)Mekgajver";
	println(getBestNameFromArray(names));

	names = [];

	names[0] = "";
	println(getBestNameFromArray(names));

	names[0] = "Single player";
	println(getBestNameFromArray(names));

	names[0] = "a|";
	names[1] = "b|";
	println(getBestNameFromArray(names));

	names[0] = "aa|";
	names[1] = "bb|";
	println(getBestNameFromArray(names));

	names[0] = "abc";
	names[1] = "cba";
	println(getBestNameFromArray(names));

	names[0] = ".";
	names[1] = "-";
	println(getBestNameFromArray(names));

	names[0] = "aa";
	names[1] = "bb";
	println(getBestNameFromArray(names));

	names[0] = "";
	names[1] = "";
	println(getBestNameFromArray(names));

	names[0] = " ";
	names[1] = " ";
	println(getBestNameFromArray(names));
*/
}


// Generate team names for specified team
// Called from multiple places
refreshTeamName(team)
{
	//logprint("refreshteamname for teamname=" + team + "\n");
  if (team == "allies")
  {
    level.teamname_allies = getTeamName(team);
    level.teamname["allies"] = level.teamname_allies;
    return level.teamname_allies;
  }
  else if (team == "axis")
  {
    level.teamname_axis = getTeamName(team);
    level.teamname["axis"] = level.teamname_axis;
    return level.teamname_axis;
  }
  return "";
}


getTeamName(team)
{
	names = [];

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		// If team is not set, generate team name from all players
		if (isDefined(player) && isDefined(player.pers["team"]) && (player.pers["team"] == team || team == ""))
		{
			name_clean = maps\mp\gametypes\global\_global::removeColorsFromString(player.name);
			names[names.size] = name_clean;
		}
	}

	return getBestNameFromArray(names);
}

getBestNameFromArray(names)
{
    if (names.size == 0)
    {
        return ""; // EMPTYTEAM
    }
    else if (names.size == 1)
    {
        return names[0];
    }

	perc = 0.9;

	// Save length of the longest name
	maxLength = 0;
	for (i = 0; i < names.size; i++)
	{
		if (names[i].size > maxLength)
			maxLength = names[i].size;
	}


	// Create arrays of substrings from name
	separes = [];
	for(i = 0; i < names.size; i++)
	{
		name = names[i];
		separes[i] = [];

		for (j = 0; j < name.size; j++)
		{
			index = name.size - 1 - j;
			separes[i][index] = [];

			for (k = 0; k < j+1; k++)
			{
				substring = maps\mp\gametypes\global\_global::getsubstr(name, k, name.size - j + k);
				separes[i][index][k] = substring;
			}
		}
	}

/*
	// Debug name separes
	println("-------------------");
	for(i = 0; i < separes.size; i++)
	{
		println("-------------------");
		for (j = 0; j < separes[i].size; j++)
		{
			print("separes["+i+"]["+j+"] = [\"");
			for (k = 0; k < separes[i][j].size; k++)
			{
				if (k!=0)
					print(", \"");
				print(separes[i][j][k] + "\"");
			}
			println("]");
		}
	}
*/

	// Marge name separes
	separes_marged = [];
	separes_marged_count = [];
	for(i = 0; i < maxLength; i++)
	{
		separes_marged[i] = [];
		separes_marged_count[i] = [];

		for (j = 0; j < separes.size; j++)
		{
			// If there is no more substrings for this player-name, break
			if (!isDefined(separes[j]) || !isDefined(separes[j][i]))
				continue;

			// Remove already defined items
			separes_clean = removeSameItems(separes[j][i]);

			for (k = 0; k < separes_clean.size; k++)
			{
				exists_in_array = false;
				for (l = 0; l < separes_marged[i].size; l++)
				{
					if (maps\mp\gametypes\global\_global::toLower(separes_marged[i][l]) == maps\mp\gametypes\global\_global::toLower(separes_clean[k]))
					{
						// We found word already in "separes_marged[i]" array - so count up
						separes_marged_count[i][l]++;
						exists_in_array = true;
						break;
					}
				}
				if (!exists_in_array)
				{
					// If this word does not exist in array, add it
					separes_marged[i][separes_marged[i].size] = separes_clean[k];
					separes_marged_count[i][separes_marged_count[i].size] = 1;
				}
			}
		}
	}

/*
	// Debuging
	for (i = 0; i < separes_marged.size; i++)
	{
		println("Most used words of length " + (i+1) + " are: ");
		for (l = 0; l < separes_marged[i].size; l++)
		{
			if (l != 0)
				print(", ");
			print(separes_marged_count[i][l] + ":\"" + separes_marged[i][l] + "\"");
		}
		println("\n");
	}
*/


	// Find the most used word in marged separes and save it
	most_used_word = [];
	most_used_count = [];
	for (i = 0; i < separes_marged.size; i++)
	{
		last_word = "";
		last_count = 0;
		for(j = 0; j < separes_marged[i].size; j++)
		{
			if (separes_marged_count[i][j] > last_count)
			{
				last_count = separes_marged_count[i][j];
				last_word = separes_marged[i][j];
			}
		}

		most_used_word[i] = last_word;
		most_used_count[i] = last_count;
	}

/*
	// Debuging
	println("");
	for (i = 0; i < most_used_word.size; i++)
	{
		println("Most used word of length " + (i+1) + " is \"" + most_used_word[i] + "\" ("+most_used_count[i]+")");
	}
*/

	table_array = [];
	final_word = "";
	for (i = names.size-1;   i >= 0 && final_word == "";   i--)
	{
		// Find words with exact usage as there is players
		for (j = most_used_count.size-1; j >= 0; j--)
		{
			if (most_used_count[j] == i+1)
			{
				value = most_used_count[j] * most_used_word[j].size;

				for (k = 0; k < value; k++)
				{
					table_array[table_array.size] = most_used_word[j];
				}
				break;
			}
		}
	}

	if (table_array.size == 0)
	{
		table_array[0] = "";
	}

/*
	// Debuging
	println("");
	for (i = 0; i < table_array.size; i++)
	{
		println("i " + (i+1) + " is \"" + table_array[i] + "\"");
	}
*/
	// Find the final most used word by percentage
	index = (int)(table_array.size * 0.3);
	final_word = table_array[index];

	// Remove unallowed chars
	final_word = getSecureString(final_word);
	final_word = removeEndSymbols(final_word);

    return final_word;
}

getSecureString(strValue)
{
	// Remove chars that cannot be used in team name
	string_secure = "";
	allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789=-+_#!.|?<>()[]{}:/\\";

	for (j = 0; j < strValue.size; j++)
	{
		saveChar = false;
		for (i = 0; i < allowedChars.size; i++)
		{
			if (allowedChars[i] == strValue[j])
				saveChar = true;
		}

		if (saveChar)
			string_secure += strValue[j];
	}

	return string_secure;
}

removeEndSymbols(strValue)
{
	// Remove chars that cannot be used in team name
	alfanumericChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

	if (strValue.size <= 2) return strValue;

	charLast = strValue[strValue.size - 1];
	charLast2 = strValue[strValue.size - 2];

	charLast_alfanumeric = false;
	for (i = 0; i < alfanumericChars.size; i++)
	{
		if (alfanumericChars[i] == charLast)
		{
			charLast_alfanumeric = true;
			break;
		}
	}

	charLast2_alfanumeric = false;
	for (i = 0; i < alfanumericChars.size; i++)
	{
		if (alfanumericChars[i] == charLast2)
		{
			charLast2_alfanumeric = true;
			break;
		}
	}

	// Remove last non-alfanumeric char
	if (charLast_alfanumeric == false && charLast2_alfanumeric)
	{
		return maps\mp\gametypes\global\_global::getsubstr(strValue, 0, strValue.size - 1);
	}

	return strValue;
}

removeSameItems(array)
{
    array_to_return = [];
    index = 0;

    for (i = 0; i < array.size; i++)
    {
        // Loop array to check if word already exists
        item_already_exists = false;
        for (j = 0; j < array_to_return.size; j++)
        {
            if (array_to_return[j] == array[i])
            {
                item_already_exists = true;
                break;
            }
        }

        if (item_already_exists)
            continue;

        array_to_return[index] = array[i];
        index++;
    }

    return array_to_return;
}