# DU-Clock
Dual Universe clock with real and in-game time

**How to install**
1. Connect up to 10 screens to the programming board (PB)
2. Copy content of the "pb clock.lua" to unit.start in the PB
3. Copy content of the "screen clockn.lua" to every screen
4. Adjust next parameters in the screen
```
-------------------------
-- USER DEFINED DATA ----
-------------------------
local clock_name = "In Game"--export: clock name
local time_offset = 0--export: time offsset in hours
local in_game_time = true --export: select false if real time

local turnScreen = false --export: turn screen to 90deg
local fontName = "FiraMono"
local fontSize = 140 --export: font size

local screen_day_color = "#F6F8FF" --export
local screen_night_color = "#012288" --export
local clock_day_color = "#012288" --export
local clock_night_color = "#F6F8FF" --export
```
5. connect "detection zone" to the PB
![image](https://user-images.githubusercontent.com/26741332/165934111-fb020628-881b-435a-985a-58a2c076a1b8.png)

