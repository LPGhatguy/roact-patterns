local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Modules = ReplicatedStorage.Modules

local Roact = require(Modules.Roact)
local Theming = require(Modules.Theming)

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

-- We can put whatever values we want into our theme and they'll be accessible
-- in all sorts of places!
local theTheme = Theming.createTheme({
	textColor = Color3.new(128, 128, 128),
	backgroundColor = Color3.new(0, 0, 0),
	textSize = 30,
	font = Enum.Font.SourceSansBold,
})

-- Here's a version of TextLabel that pulls values from our theme by default.
local function ThemedLabel(props)
	return Theming.withTheme(function(theme)
		local fullProps = assign({
			BackgroundColor3 = theme.backgroundColor,
			TextColor3 = theme.textColor,
			TextSize = theme.textSize,
			Font = theme.font,
		}, props)

		return Roact.createElement("TextLabel", fullProps)
	end)
end

local function App(props)
	local children = {}

	children.Layout = Roact.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
	})

	for i = 1, 20 do
		local label = Roact.createElement(ThemedLabel, {
			Text = ("Number %d!"):format(i),

			-- Here, we could also pull from the theme to make sure our
			-- container is large enough to hold the text.
			Size = UDim2.new(0, 400, 0, 36),
			LayoutOrder = i,
		})

		children[i] = label
	end

	return Roact.createElement("ScreenGui", nil, children)
end

local tree = Roact.createElement(Theming.ThemeProvider, {
	theme = theTheme,
}, {
	App = Roact.createElement(App),
})

Roact.mount(tree, Players.LocalPlayer.PlayerGui, "Theming")

-- We'll update our theme every frame.
-- That's kind of a weird thing to do, but it's cool!
RunService.RenderStepped:Connect(function()
	local t = tick()
	local color = Color3.fromHSV((t / 5) % 1, 1, 0.5)

	local font = Enum.Font.SourceSans
	if t % 1 > 0.5 then
		font = Enum.Font.SourceSansBold
	end

	-- Any values we don't specify will be left alone.
	theTheme:update({
		backgroundColor = color,
		font = font,
	})
end)