--local core = slot1

-- Script helps to find the time offset on the surface of a planet
-- works with any dynamic construct
local worldNorth = {0,0,1}
local worldUtcZero = {1,0,0}
local worldVertical = core.getWorldVertical()

local worldNorthVec = vec3(worldNorth)
local worldUtcZeroVec = vec3(worldUtcZero)
local worldVerticalVec = -vec3(worldVertical)


local worldVerticalVecProj = worldVerticalVec:project_on_plane(worldNorthVec)

local function angle_between(vector1,vector2)
    return math.acos(utils.clamp(vector1:dot(vector2) / (vector1:len() * vector2:len()),-1,1))
end

local angle = angle_between(worldVerticalVecProj,worldUtcZeroVec)
local angleClock = angle / math.pi * 12 - 2 -- 2 hour shift

local sign = worldNorthVec:cross(worldUtcZeroVec):dot(worldVerticalVecProj)

if sign > 0 then
	system.print(angleClock)
else
	system.print(-angleClock)
end

-- code below requires a cycle
--[[
local corePosition = construct.getWorldPosition()
local corePositionVec = vec3(corePosition)

local relativeNorth = corePositionVec + worldNorthVec * 1000000
local relativeUtcZero = corePositionVec + worldUtcZeroVec * 1000000
local relativeVertical = corePositionVec + worldVerticalVec * 1000000
local relativeVerticalProj = corePositionVec + worldVerticalVecProj * 1000000

local screenNorth = library.getPointOnScreen({relativeNorth.x,relativeNorth.y,relativeNorth.z})
local screenUtcZero = library.getPointOnScreen({relativeUtcZero.x,relativeUtcZero.y,relativeUtcZero.z})
local screenVertical = library.getPointOnScreen({relativeVertical.x,relativeVertical.y,relativeVertical.z})
local screenVerticalProj = library.getPointOnScreen({relativeVerticalProj.x,relativeVerticalProj.y,relativeVerticalProj.z})

local height = system.getScreenHeight()
local width = system.getScreenWidth()

local xn = screenNorth[1]*width
local yn = screenNorth[2]*height

local xz = screenUtcZero[1]*width
local yz = screenUtcZero[2]*height

local xv = screenVertical[1]*width
local yv = screenVertical[2]*height

local xvp = screenVerticalProj[1]*width
local yvp = screenVerticalProj[2]*height

local html = [[
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" viewBox="0 0 ]]..width..[[ ]]..height..[[">
	<circle cx="]].. xn ..[[" cy="]].. yn ..[[" r="]].. width/50 ..[[" stroke="black" stroke-width="3" fill="red" />
	<circle cx="]].. xz ..[[" cy="]].. yz ..[[" r="]].. width/50 ..[[" stroke="black" stroke-width="3" fill="yellow" />
	<circle cx="]].. xv ..[[" cy="]].. yv ..[[" r="]].. width/50 ..[[" stroke="black" stroke-width="3" fill="green" />
	<circle cx="]].. xvp ..[[" cy="]].. yvp ..[[" r="]].. width/50 ..[[" stroke="black" stroke-width="3" fill="blue" />
</svg>
]]
system.setScreen(html)
system.showScreen(1)
--]]
