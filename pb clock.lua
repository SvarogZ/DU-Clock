local screens = {}

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

-------------------------
-- START PROGRAMM--------
-------------------------
initiateSlots()

for _, screen in ipairs(screens) do
	--screen.setScriptInput(tostring(system.getTime()))
	screen.setScriptInput(tostring(system.getArkTime()))
end
