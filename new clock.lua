-------------------------
-- USER DEFINED DATA ----
-------------------------
local font_family = "Verdana" --export: the font of the text
local font_color = "#000000" --export: the color of the text
local font_size = 10 --export: the size of the text in vh
local screen_color = "#979A9A" --export: background color

local in_game_time_offset = 1--export: in game time offsset in hours (24h)
local in_game_day_duration = 10
in_game_time_offset = in_game_time_offset*10/24

local text_time_1 = "Real KZ" --export: leave empty "" to miss this time
local time_offset_1 = 18 --export: time offsset in hours

local text_time_2 = "Real NZ" --export: leave empty "" to miss this time
local time_offset_2 = 1 --export: time offsset in hours


-------------------------
-- VARIABLES ------------
-------------------------	
local timesToShow = {}
table.insert(timesToShow,{text = "In Game",dayDuration = in_game_day_duration_1,timeOffset = in_game_time_offset})
table.insert(timesToShow,{text = "Real GTM"})
table.insert(timesToShow,{text = "Your Time", timeOffset = system.getUtcOffSet()/3600})
table.insert(timesToShow,{text = text_time_1,timeOffset = time_offset_1})
table.insert(timesToShow,{text = text_time_2,timeOffset = time_offset_2})


local screens = {}

-------------------------
-- HTML -----------------
-------------------------
local htmlTemplate = [[<div style="height: 100vh;width: 100vw;font-family:']]..font_family..[[';color:]]..font_color..[[;font-size:]]..font_size..[[vh;display:flex;justify-content:center;align-items:center;background-color:]]..screen_color..[[;">%s</div>]]
local htmlRowTemplate = [[%s	:	%s:%s:%s]]
local htmlSplitRows = [[<br>]]

-------------------------
-- FUNCTIONS ------------
-------------------------
local function initiateSlots()
	for _, slot in pairs(unit) do
		if type(slot) == "table" and type(slot.export) == "table" and slot.getElementClass then
			local elementClass = slot.getElementClass():lower()
			if elementClass == "screenunit" then
				table.insert(screens,slot)
			end
		end
	end

	if #screens < 1 then
		error("No screen connected!")
	end
	
	table.sort(screens, function (a, b) return (a.getId() < b.getId()) end)
end

local function getTime(timeOffset, dayDuration)
	if not timeOffset then timeOffset = 0 end
	if not dayDuration then dayDuration = 24 end
	
	--local t = system.getArkTime() + timeOffset * 3600
	local t = system.getTime() + timeOffset * 3600

	local function getTextNumber(n)
		local n = tostring(n)
		if #n == 1 then n = "0"..n end
		return n
	end

	local day = getTextNumber(math.floor(t/(dayDuration*3600)))
	t = t%(dayDuration*3600)
	local hour = getTextNumber(math.floor(t/3600))
	t = t%3600
	local minute = getTextNumber(math.floor(t/60))
	t = t%60
	local second = getTextNumber(math.floor(t))
	return day,hour,minute,second
end

function update()
	local htmlRows = {}
	
	for _, timeToShow in ipairs(timesToShow) do
		local text = timeToShow.text or ""
		local dayDuration = timeToShow.dayDuration
		local timeOffset = timeToShow.timeOffset

		if timeToShow.text ~= "" then 
			local day,hour,minute,second = getTime(timeOffset,dayDuration)
			table.insert(htmlRows,string.format(htmlRowTemplate,text,hour,minute,second))
		end
	end
	
	local html = string.format(htmlTemplate,table.concat(htmlRows,htmlSplitRows))
	
	for _, screen in ipairs(screens) do
		screen.setHTML(html)
	end
end

-------------------------
-- START PROGRAMM--------
-------------------------
initiateSlots()

-------------------------
-- UPDATE TIMER ---------
-------------------------
unit.setTimer("update",0.2)


-------------------------
-- FILTER UPDATE --------
-------------------------
update()
