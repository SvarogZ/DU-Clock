local update_time = 1 --export: update time in seconds

local screens = {}

-------------------------
-- FUNCTIONS ------------
-------------------------
local function initiateSlots()
	for _, slot in pairs(unit) do
		if type(slot) == "table" and type(slot.export) == "table" and slot.getClass then
			local elementClass = slot.getClass():lower()
			if elementClass == "screenunit" then
				table.insert(screens,slot)
			end
		end
	end

	if #screens < 1 then
		error("No screen connected!")
	end
	
	table.sort(screens, function (a, b) return (a.getLocalId() < b.getLocalId()) end)
end

-------------------------
-- START PROGRAMM--------
-------------------------
initiateSlots()

local worldNorth = {0,0,1}
local worldUtcZero = {1,0,0}
local worldNorthVec = vec3(worldNorth)
local worldUtcZeroVec = vec3(worldUtcZero)

function updateTime()
	
	local stringToSend = tostring(system.getArkTime())
	
	local worldVertical = core.getWorldVertical()
	local worldVerticalVec = -vec3(worldVertical)
	
	if worldVerticalVec:len() > 0.1 then
	
		local worldVerticalVecProj = worldVerticalVec:project_on_plane(worldNorthVec)

		local function angle_between(vector1,vector2)
			return math.acos(utils.clamp(vector1:dot(vector2) / (vector1:len() * vector2:len()),-1,1))
		end

		local angle = angle_between(worldVerticalVecProj,worldUtcZeroVec)
		local timeOffset = angle / math.pi * 12 - 2 -- 2 hour shift

		local sign = worldNorthVec:cross(worldUtcZeroVec):dot(worldVerticalVecProj)

		if sign < 0 then
			timeOffset = -timeOffset
		end
		
		stringToSend = stringToSend..","..tostring(timeOffset)
	end
	
	for _, screen in ipairs(screens) do
		screen.setScriptInput(stringToSend)
	end
end

-------------------------
-- UPDATE TIMER ------
-------------------------
unit.setTimer("update", update_time)












