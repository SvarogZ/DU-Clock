-------------------------
-- USER DEFINED DATA ----
-------------------------
local font_family = "Verdana" --export: the font of the text
local font_color = "#000000" --export: the color of the text
local font_size = 10 --export: the size of the text in vh
local screen_color = "#979A9A" --export: background color

local text_time_1 = "Real GTM" --export: leave empty "" to miss this time
local day_duration_1 = 24 --export: day duration in hours, set 10h for in game time
local time_shift_1 = 12 --export: time shift in relative hours

local text_time_2 = "Real KZ" --export: leave empty "" to miss this time
local day_duration_2 = 24 --export: day duration in hours, set 10h for in game time
local time_shift_2 = 18 --export: time shift in relative hours

local text_time_3 = "Real NZ" --export: leave empty "" to miss this time
local day_duration_3 = 24 --export: day duration in hours, set 10h for in game time
local time_shift_3 = 1 --export: time shift in relative hours

local text_time_4 = "In Game" --export: leave empty "" to miss this time
local day_duration_4 = 10 --export: day duration in hours, set 10h for in game time
local time_shift_4 = 1 --export: time shift in relative hours

-------------------------
-- VARIABLES ------------
-------------------------	
local timesToShow = {}
timesToShow{1] = {
	text = text_time_1,
	dayDuration = day_duration_1,
	timeShift = time_shift_1
}
timesToShow{2] = {
	text = text_time_2,
	dayDuration = day_duration_2,
	timeShift = time_shift_2
}
timesToShow{3] = {
	text = text_time_3,
	dayDuration = day_duration_3,
	timeShift = time_shift_3
}
timesToShow{4] = {
	text = text_time_4,
	dayDuration = day_duration_4,
	timeShift = time_shift_4
}

local screens = {}
local minDayDuration = 24

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

local function getTime(dayDuration,timeShift)
	local t = system.getTime() / (dayDuration / 24) + timeShift * 3600

	local function getTextNumber(n)
		local n = tostring(n)
		if #n == 1 then n = "0"..n end
		return n
	end

	local day = getTextNumber(math.floor(t/86400))
	t = t%(24*3600)
	local hour = getTextNumber(math.floor(t/3600))
	t = t%3600
	local minute = getTextNumber(math.floor(t/60))
	t = t%60
	local second = getTextNumber(math.floor(t))
	return day,hour,minute,second
end

local function validateData()
	for key, timeToShow in ipairs(timesToShow) do
		local text = timeToShow.text
		local dayDuration = timeToShow.dayDuration
		local timeShift = timeToShow.timeShift

		if text and text ~= "" and dayDuration and dayDuration > 0 and timeShift and timeShift > 0 then
			--data validated
			if minDayDuration > dayDuration then minDayDuration = dayDuration end
			if minDayDuration < 0.5 then minDayDuration = 0.5 end
		else
			timesToShow[key].text = "" -- disable this time
		end	
	end
end

function update()
	local htmlRows = {}
	
	for _, timeToShow in ipairs(timesToShow) do
		local text = timeToShow.text or ""
		local dayDuration = timeToShow.dayDuration
		local timeShift = timeToShow.timeShift

		if timeToShow.text ~= "" then 
			local day,hour,minute,second = getTime(dayDuration,timeShift)
			table.insert(htmlRows,string.format(htmlRowTemplate,text,hour,minute,second))
		end
	end
	
	local html = string.format(htmlTemplate,table.concat(htmlRows,htmlSplitRows)
	
	for _, screen in ipairs(screens) do
		screen.setHTML(html))
	end
end

-------------------------
-- START PROGRAMM--------
-------------------------
initiateSlots()
validateData()
update()

-------------------------
-- UPDATE TIMER ---------
-------------------------
unit.setTimer("update",minDayDuration/24)


-------------------------
-- FILTER UPDATE --------
-------------------------
update()
