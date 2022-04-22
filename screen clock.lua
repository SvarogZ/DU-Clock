local json = require "dkjson"

-------------------------
-- USER DEFINED DATA ----
-------------------------
local clock_name = "In Game"--export: clock name
local time_offset = 1--export: time offsset in hours
local day_duration = 10--export: day duration in hours, def=24, in_game=10

local screenData = {
	text = clock_name,
	dayDuration = time_offset,
	timeOffset = day_duration
}

local turnScreen = false--export: turn screen to 90deg
local fontName = "FiraMono"
local fontSize = 25

local screen_day_color = "#979A9A" --export
local screen_night_color = "#979A9A" --export
local clock_day_color = "#000" --export
local clock_night_color = "#fff" --export

-------------------------
-- VARIABLES ------------
-------------------------
local screenWidth, screenHeight = getResolution()

local font = loadFont(fontName, fontSize)

local mainLayer = createLayer()

if turnScreen then
	setLayerRotation(mainLayer,(6.285*0.75))
	setLayerTranslation(mainLayer,25,600)
	local temp = screenWidth
	screenWidth = screenHeight
	screenHeight = temp
end

-------------------------
-- FUNCTIONS ------------
-------------------------
function hex2rgb(hex)
	local hex = hex:gsub("#","")
	if hex:len() == 3 then
		return (tonumber("0x"..hex:sub(1,1))*17)/255, (tonumber("0x"..hex:sub(2,2))*17)/255, (tonumber("0x"..hex:sub(3,3))*17)/255
	else
		return tonumber("0x"..hex:sub(1,2))/255, tonumber("0x"..hex:sub(3,4))/255, tonumber("0x"..hex:sub(5,6))/255
	end
end

local function getTextNumber(n)
	local n = tostring(n)
	if #n == 1 then n = "0"..n end
	return n
end

local function sendToPB(screenData)
	local dataOutput = {
		dayDuration = screenData.dayDuration,
		timeOffset = screenData.timeOffset
	}

	setOutput(json.encode(dataOutput))
end

local function processData(dataFromPB)
	if dataFromPB then
		return dataFromPB.h, dataFromPB.m, dataFromPB.s
	else
		return 0,0,0
	end
end

-------------------------
-- CODE -----------------
-------------------------
sendToPB(screenData)

local dataFromPB = json.decode(getInput())
local hour, minute, second = processData(dataFromPB)

local screenColor, clockColor

if hour > 6 and hour < 18 then
	screenColor = screen_day_color
	clockColor = clock_day_color
else
	screenColor = screen_night_color
	clockColor = clock_night_color
end

local r,g,b = hex2rgb(screenColor)
setBackgroundColor (r, g, b)
r,g,b = hex2rgb(clockColor)
setDefaultFillColor (mainLayer, 6, r, g, b, 1)--text

local clockName = screenData.text
local timeToShow = getTextNumber(hour) .. ":" .. getTextNumber(minute) .. ":" .. getTextNumber(second)

setNextTextAlign (mainLayer, 1, 3)
addText(mainLayer, font, clockName, screenWidth/2, screenHeight/3)
setNextTextAlign (mainLayer, 1, 3)
addText(mainLayer, font, timeToShow, screenWidth/2, screenHeight*2/3)
