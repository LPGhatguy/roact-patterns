--[[
	Equivalent to JavaScript's Object.assign, useful for merging together tables
	without mutating them and without creating extra tables.
]]
local function assign(target, ...)
	for i = 1, select("#", ...) do
		local source = select(i, ...)

		for key, value in pairs(source) do
			target[key] = value
		end
	end

	return target
end

return assign