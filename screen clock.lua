-------------------------
-- USER DEFINED DATA ----
-------------------------
local clock_name = "In Game"--export: clock name
local time_offset = 0--export: time offsset in hours
local in_game_time = true --export: select false if real time
local day_duration = in_game_time and 10 or 24
time_offset = in_game_time and time_offset*10/24 or time_offset

local turnScreen = false --export: turn screen to 90deg
local fontName = "FiraMono"
local fontSize = 120 --export: font size

local screen_day_color = "#F6F8FF" --export
local screen_night_color = "#012288" --export
local clock_day_color = "#012288" --export
local clock_night_color = "#F6F8FF" --export

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

local function getTime(t, timeOffset, dayDuration)
	if not timeOffset then timeOffset = 0 end
	if not dayDuration then dayDuration = 24 end
	
	t = (t + timeOffset * 3600) * 24 / dayDuration

	--local day = math.floor(t/86400)
	t = t%86400
	local hour = math.floor(t/3600)
	t = t%3600
	local minute = math.floor(t/60)
	t = t%60
	local second = math.floor(t)
	
	return hour, minute, second
end

local function processData(dataFromPB)
	if dataFromPB and dataFromPB~="" then
		local dataFromPbNumber = tonumber(dataFromPB)
		local deltaTime = getDeltaTime()
		
		if initialTime ~= dataFromPbNumber then
			initialTime = dataFromPbNumber
			currentTime = dataFromPbNumber
		else 
			currentTime = currentTime + deltaTime
		end
		
		if deltaTime == 0 then deltaTime = 1 end
		local factor = day_duration / 24 / deltaTime 
		
		if fps then
			fps = math.floor(fps * factor)
		else
			fps = 1
		end
		
		if fps < 5 then fps = 5 end

		requestAnimationFrame(fps)
		
		return getTime(currentTime, time_offset, day_duration)
	else
		return 0,0,0
	end
end

-------------------------
-- CODE -----------------
-------------------------
local dataFromPB = getInput()

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

local clockName = clock_name.." "
local timeToShow = getTextNumber(hour) .. ":" .. getTextNumber(minute) .. ":" .. getTextNumber(second)

setNextTextAlign (mainLayer, 1, 3)
addText(mainLayer, font, clockName, screenWidth/2, screenHeight/3)
setNextTextAlign (mainLayer, 1, 3)
