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

local stringToSend = tostring(system.getArkTime())

for _, screen in ipairs(screens) do
	screen.setScriptInput(stringToSend)
end
