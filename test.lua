local backgroundColor = {1,1,1}
local clockCircleColor = {0.0.0,1}
local clockMarkColor = {0.0.0,1}
local clockNumberkColor = {0.0.0,1}
local clockArrowkColor = {0.0.0,1}
local fontSize = 10


local function drawClockMark(layer, minutes, font, markColor, textColor, textRadius, radius, bezel, markScaleH, markScaleW, textScale)
	local layer = layer or return
	local minutes = minutes or return
	local radius = radius or 1
	local bezel = bezel or 1
	local markScaleH = markScaleH or 1
	local markScaleW = markScaleW or 1
	local textScale = textScale or 1

	local angle = minutes / 30 * math.pi

	local deg1 = 1 / 180 * math.pi
	local angleMark = 2*deg1*markScaleW
	local radius1 = radius * (1 - 0.1*bezel)
	local radius2 = radius1 * (1 - 0.2*markScaleH)

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
		local text = tostring(minutes/5)
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


local screenWidth, screenHeight = getResolution ()

local layer = createLayer()
setLayerOrigin(layer,screenWidth/2,screenHeight/2)

--backgroung color
setBackgroundColor(backgroundColor[1], backgroundColor[2], backgroundColor[3])
--circle color
setDefaultFillColor(layer, 2, clockCircleColor[1], clockCircleColor[2], clockCircleColor[3], clockCircleColor[4])
--polygon color
setDefaultFillColor(layer, 5, clockMarkColor[1], clockMarkColor[2], clockMarkColor[3], clockMarkColor[4])
--text color
setDefaultFillColor(layer, 6, clockNumberkColor[1], clockNumberkColor[2], clockNumberkColor[3], clockNumberkColor[4])

local font = loadFont("FiraMono",fontSize)
setDefaultTextAlign(layer, 1, 2)

-- draw the clock
local clockRadius = screenHeight/2*0.9
addCircle (layer, 0, 0, clockRadius)

for minutes = 1, 60, 1 do
	if minutes//5 == 0 then
		--drawClockMark(layer, minutes, font, markColor, textColor, textRadius, radius, bezel, markScaleH, markScaleW, textScale)
		drawClockMark(layer, minutes, font, nil, nil, nil, clockRadius, nil, 1.5, 1.5, nil)
	else
		drawClockMark(layer, minutes, nil, nil, nil, nil, clockRadius, nil, nil, nil, nil)
	end
end

--draw arrows
local hourLayer = createLayer()
setLayerOrigin(hourLayer,screenWidth/2,screenHeight/2)
local minuteLayer = createLayer()
setLayerOrigin(minuteLayer,screenWidth/2,screenHeight/2)
local secondLayer = createLayer()
setLayerOrigin(secondLayer,screenWidth/2,screenHeight/2)


setNextFillColor(hourLayer, clockArrowkColor[1], clockArrowkColor[2], clockArrowkColor[3], clockArrowkColor[4])
addQuad(hourLayer, -5, 0, 5, 0, -5, clockRadius, 5, clockRadius)
setLayerRotation(hourLayer, 1)
