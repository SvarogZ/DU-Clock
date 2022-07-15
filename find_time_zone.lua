-- Script helps to find the time offset on the surface of a planet
-- works with any dynamic construct
local worldWest = {0,1,0}
local worldVertical = core.getWorldVertical()

local worldVerticalVec = -vec3(worldVertical)
local worldWestVec = vec3(worldWest)

local function angle_between(vector1,vector2)
    return math.acos(utils.clamp(vector1:dot(vector2) / (vector1:len() * vector2:len()),-1,1))
end

local angle = angle_between(worldVerticalVec,worldWestVec)
local angleClock = angle / math.pi * 24

system.print(angleClock)
