# eyza_pam_port_to_vcod
An attempt to port eyza's https://github.com/eyza-cod2/zpam3 CoD2 zpam to vCoD.<br>
It requires libcod extension for 1.5 (https://github.com/cod1dev/libcod1/releases/tag/release) for the ported version to work with vCoD 1.5.<br>
<br>
What seems to be working (<b>not tested thoroughly!!!!</b>):
- new scoreboard
- streamer mode with CoD2 streamer features
<br>
Contributors:<br>
Maggot
<br>
<br>
<br>
Entering streamer mode is slightly different from CoD2 version.
1. Select streamer.
2. Open quickmessages ('V' key by default in multiplayer options)
3. Press '0' to enable streamer mode.<br>

To get back to streamer mode once 'ESC' is pressed in streamer mode repeat from 2nd point.
<br>
<br>
<br>
To do list:
<br>
- import weapon menu from CoD2 pam
- import server settings menu from CoD2 pam
- ~~fix bomb explosion crashing the server (Stalingrad underground bombzone explosion) (set developer 1/2 was causing the issue)~~
- code cleanup ie. logging<br>
- fix bomb explosion hit radius
- bomb defuse countdown seems to be off by 1 sec (60th second at countdown start takes 1sec instead go down to 59 immediately)
- sort out menus introduced in this PAM port - I have low knowledge of menus and I think it's not properly done by me<br>
- ~~mp_depot is causing the server to crash<br>~~
- ~~german_town and xp_hanoi are not loading (doens't crash server though)<br>~~
- refactor player HUD (like round timer) to be the same as in current vCoD pam<br>
- fix fonts sizes in all HUD elements for all modes (player, streamer)<br>
- ~~fix strat time player hold in spawn spot until round starts<br>~~
- replace nade follow to be the same as in current vCoD pam<br>
- fix autorecord (when autorecord is working then, scoreboard_sd at the end of the map is not showing)<br>
- improve new scoreboard:<br>
	- fix hit count logic<br>
	- fix assists count logic - implemenet CS2 assists counting logic because vCoD has no health recovery system as well<br>
	- fix points count logic<br>
	- add some additional statistics<br>
- add UO smoke to be available in vCoD and pickable via menu by X players (configurable)<br>
- <b>... to be continued</b>
<br>
<br>
Screenshots:<br>
![shot0035](https://github.com/user-attachments/assets/f934c8c1-59f3-413b-b285-e042299bed5b)<br>
![shot0036](https://github.com/user-attachments/assets/237c4638-60f0-4f1f-b756-e73f3ca77b84)<br>
![shot0037](https://github.com/user-attachments/assets/7c92d949-fc03-426f-a9e5-f5cdbc40d434)<br>
