stds.roblox = {
	globals = {
		"game"
	},
	read_globals = {
		-- Roblox globals
		"script",

		-- Extra functions
		"typeof", "wait", "tick",

		-- Types
		"Enum",
		"Vector2", "Color3", "UDim2",
	}
}

stds.testez = {
	read_globals = {
		"describe",
		"it", "itFOCUS", "itSKIP",
		"FOCUS", "SKIP", "HACK_NO_XPCALL",
		"expect",
	}
}

ignore = {
	"212", -- unused arguments
}

std = "lua51+roblox"

files["**/*.spec.lua"] = {
	std = "+testez",
}