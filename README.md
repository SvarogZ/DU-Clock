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
local clock_name = "UTC"--export: clock name
local time_offset = 0 --export: time offsset in hours
local in_game_time = false --export: select false if real time

local show_analogue_clock = true --export: select to show analogue 12 hour clock

local turnScreen = true --export: turn screen to 90deg
local fontName = "FiraMono"
local fontSize = 80 --export: font size

local day_time = 6
local night_time = 18
local screen_day_color = "#EAEBFF" --export
local screen_night_color = "#4D54BC" --export
local clock_name_day_color = "#4D54BC" --export
local clock_name_night_color = "#EAEBFF" --export
local clock_number_day_color = "#000" --export
local clock_number_night_color = "#fff" --export

local analogue_clock_circle_day_color = "#DCDCDC"
local analogue_clock_circle_night_color = "#838383"
local analogue_clock_mark_day_color = "#000"
local analogue_clock_mark_night_color = "#fff"
local analogue_clock_arrow_day_color = "#000"
local analogue_clock_arrow_night_color = "#fff"
local analogue_clock_font_size = 50
```
5. connect "detection zone" to the PB
![image](https://user-images.githubusercontent.com/26741332/166213655-f7bd5106-3c06-4407-bad6-93bf36bbd159.png)


