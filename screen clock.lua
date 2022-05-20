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

-------------------------
-- VARIABLES ------------
-------------------------
local day_duration = in_game_time and 10 or 24
time_offset = in_game_time and time_offset*day_duration/24 or time_offset

local screenWidth, screenHeight = getResolution()

local font = loadFont(fontName, fontSize)

local mainLayer = createLayer()

if turnScreen then
	local temp = screenWidth
	screenWidth = screenHeight
	screenHeight = temp
	setLayerRotation(mainLayer,math.pi/2)
	setLayerTranslation(mainLayer,screenHeight,0)
end

-------------------------
-- FUNCTIONS ------------
-------------------------
function hex2rgb(hex)
	local hex = hex:gsub("#","")
	if hex:len() == 3 then
		return {(tonumber("0x"..hex:sub(1,1))*17)/255, (tonumber("0x"..hex:sub(2,2))*17)/255, (tonumber("0x"..hex:sub(3,3))*17)/255,1}
	else
		return {tonumber("0x"..hex:sub(1,2))/255, tonumber("0x"..hex:sub(3,4))/255, tonumber("0x"..hex:sub(5,6))/255,1}
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

local screenColor, clockNumberColor, clockNameColor

if hour >= day_time and hour < night_time then
	screenColor = hex2rgb(screen_day_color)
	clockNameColor = hex2rgb(clock_name_day_color)
	clockNumberColor = hex2rgb(clock_number_day_color)
else
	screenColor = hex2rgb(screen_night_color)
	clockNameColor = hex2rgb(clock_name_night_color)
	clockNumberColor = hex2rgb(clock_number_night_color)
end

setBackgroundColor(screenColor[1], screenColor[2], screenColor[3])
setDefaultFillColor(mainLayer, 7, clockNameColor[1], clockNameColor[2], clockNameColor[3], clockNameColor[4])--text
setDefaultTextAlign(mainLayer, 1, 2)
local clockName = clock_name

if show_analogue_clock then
	addText(mainLayer, font, clockName, screenWidth/2, screenHeight*0.1)

	if turnScreen then
		local timeToShow = getTextNumber(hour) .. ":" .. getTextNumber(minute) .. ":" .. getTextNumber(second)
		addText(mainLayer, font, timeToShow, screenWidth/2, screenHeight*0.3)
	end

	local clockCircleColor, clockMarkColor, clockArrowColor
	
	if hour >= day_time and hour < night_time then
		clockCircleColor = hex2rgb(analogue_clock_circle_day_color)
		clockMarkColor = hex2rgb(analogue_clock_mark_day_color)
		clockArrowColor = hex2rgb(analogue_clock_arrow_day_color)
	else
		clockCircleColor = hex2rgb(analogue_clock_circle_night_color)
		clockMarkColor = hex2rgb(analogue_clock_mark_night_color)
		clockArrowColor = hex2rgb(analogue_clock_arrow_night_color)
	end

	local fontSize = analogue_clock_font_size
	setFontSize(font, fontSize)
	
	local function drawClockMark(layer, minutes, font, markColor, textColor, textRadius, radius, bezel, markScaleH, markScaleW, textScale)
		if not layer then return end
		if not minutes then return end
		local radius = radius or 1
		local bezel = bezel or 1
		local markScaleH = markScaleH or 1
		local markScaleW = markScaleW or 1
		local textScale = textScale or 1

		local angle = - minutes / 30 * math.pi + math.pi

		local deg1 = 1 / 180 * math.pi
		local angleMark = deg1*markScaleW / 2
		local radius1 = radius * (1 - 0.05*bezel)
		local radius2 = radius1 * (1 - 0.1*markScaleH)

		local x1 = radius1 * math.sin(-angleMark + angle)
		local y1 = radius1 * math.cos(-angleMark + angle)
		local x2 = radius1 * math.sin(angleMark + angle)
		local y2 = radius1 * math.cos(angleMark + angle)
		local x3 = radius2 * math.sin(angleMark + angle)
		local y3 = radius2 * math.cos(angleMark + angle)
		local x4 = radius2 * math.sin(-angleMark + angle)
		local y4 = radius2 * math.cos(-angleMark + angle)

		if markColor then
			setNextFillColor(layer, markColor[1], markColor[2], markColor[3], markColor[4])
		end
		addQuad(layer, x1, y1, x2, y2, x3, y3, x4, y4)
		
		if font then
			local text = tostring(math.floor(minutes/5))
			local textRadius = textRadius or radius2 * 0.8
			
			if textColor then
				setNextFillColor(layer, textColor[1], textColor[2], textColor[3], textColor[4])
			end
			
			local fontSize = getFontSize(font)
			if textScale then
				setFontSize(font, fontSize*textScale)
			end
			
			addText(layer, font, text, textRadius*math.sin(angle), textRadius*math.cos(angle))
			
			if textScale then
				setFontSize(font, fontSize)
			end
		end
	end

	local horizontalShift = screenWidth/2
	local verticalShift = screenHeight*0.6

	local layer = createLayer()
	setDefaultTextAlign(layer, 1, 2)
	
	local clockRadius
	local turnAngle = 0
	if turnScreen then
		turnAngle = math.pi/2
		setLayerRotation(layer,turnAngle)
		setLayerTranslation(layer,horizontalShift,horizontalShift)
		clockRadius = screenWidth/2*0.9
	else
		setLayerTranslation(layer,horizontalShift,verticalShift)
		clockRadius = screenHeight/2*0.7
	end

	--circle color
	setDefaultFillColor(layer, 3, clockCircleColor[1], clockCircleColor[2], clockCircleColor[3], clockCircleColor[4])
	--polygon color
	setDefaultFillColor(layer, 6, clockMarkColor[1], clockMarkColor[2], clockMarkColor[3], clockMarkColor[4])
	--text color
	setDefaultFillColor(layer, 7, clockNumberColor[1], clockNumberColor[2], clockNumberColor[3], clockNumberColor[4])

	-- draw the clock
	addCircle (layer, 0, 0, clockRadius)

	for minutes = 1, 60, 1 do
		local a,b = math.modf(minutes/5)
		if b == 0 then
			--drawClockMark(layer, minutes, font, markColor, textColor, textRadius, radius, bezel, markScaleH, markScaleW, textScale)
			drawClockMark(layer, minutes, font, nil, nil, nil, clockRadius, nil, 1.5, 1.5, nil)
		else
			drawClockMark(layer, minutes, nil, nil, nil, nil, clockRadius, nil, nil, nil, nil)
		end
	end

	--draw hour arrow
	local hourLayer = createLayer()
	if turnScreen then
		setLayerTranslation(hourLayer,horizontalShift,horizontalShift)
	else
		setLayerTranslation(hourLayer,horizontalShift,verticalShift)
	end
	setDefaultFillColor(hourLayer, 6, clockArrowColor[1], clockArrowColor[2], clockArrowColor[3], clockArrowColor[4])
	setLayerRotation(hourLayer, (hour + minute / 60) / 6 * math.pi + turnAngle)
	local arrowLength = clockRadius*0.55
	local arrowHalfWidth = clockRadius*0.05
	addQuad(hourLayer, -arrowHalfWidth, arrowLength/10, arrowHalfWidth, arrowLength/10, arrowHalfWidth/2, -arrowLength, -arrowHalfWidth/2, -arrowLength)
	--draw minute arrow
	local minuteLayer = createLayer()
	if turnScreen then
		setLayerTranslation(minuteLayer,horizontalShift,horizontalShift)
	else
		setLayerTranslation(minuteLayer,horizontalShift,verticalShift)
	end
	setDefaultFillColor(minuteLayer, 6, clockArrowColor[1], clockArrowColor[2], clockArrowColor[3], clockArrowColor[4])
	setLayerRotation(minuteLayer, (minute + second / 60) / 30 * math.pi + turnAngle)
	local arrowLength = clockRadius*0.8
	local arrowHalfWidth = clockRadius*0.03
	addQuad(minuteLayer, -arrowHalfWidth, arrowLength/10, arrowHalfWidth, arrowLength/10, arrowHalfWidth/2, -arrowLength, -arrowHalfWidth/2, -arrowLength)
	--draw second arrow
	local secondLayer = createLayer()
	if turnScreen then
		setLayerTranslation(secondLayer,horizontalShift,horizontalShift)
	else
		setLayerTranslation(secondLayer,horizontalShift,verticalShift)
	end
	setDefaultFillColor(secondLayer, 6, clockArrowColor[1], clockArrowColor[2], clockArrowColor[3], clockArrowColor[4])
	setLayerRotation(secondLayer, second / 30 * math.pi + turnAngle)
	local arrowLength = clockRadius*0.9
	local arrowHalfWidth = clockRadius*0.02
	addQuad(secondLayer, -arrowHalfWidth, arrowLength/10, arrowHalfWidth, arrowLength/10, arrowHalfWidth, -arrowLength, -arrowHalfWidth, -arrowLength)
	
else
	local timeToShow = getTextNumber(hour) .. ":" .. getTextNumber(minute) .. ":" .. getTextNumber(second)
	addText(mainLayer, font, clockName, screenWidth/2, screenHeight/3)
	setNextFillColor(clockNumberColor[1],clockNumberColor[2],clockNumberColor[3],1)
	addText(mainLayer, font, timeToShow, screenWidth/2, screenHeight*2/3)
end
