local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Modules = ReplicatedStorage.Modules

local Roact = require(Modules.Roact)
local Gamepad = require(Modules.Gamepad)

local ButtonList = require(script.ButtonList)

local e = Roact.createElement

local topButtons = {
	{
		text = "Foo",
	},
	{
		text = "Bar",
	},
	{
		text = "Baz",
	},
}

local bottomButtons = {
	{
		text = "Hey",
	},
	{
		text = "Boo",
	},
}

local TabNavigation = Roact.Component:extend("TabNavigation")

function TabNavigation:init()
	self.group = Gamepad.createSelectionItem(self)
end

function TabNavigation:render()
	-- Gotcha: selectionGroupId passed to ButtonList has an implicit connection
	-- to `self.group` via context. If a component is created by TabNavigation
	-- that ALSO specifies a selection item, however, the IDs will be assigned
	-- to that object instead, which is confusing!
	--
	-- This is similar to the issues that React used to have with string refs.
	return e("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.new(0.2, 0.2, 0.2),
	}, {
		Navigation = e("Frame", {
			Size = UDim2.new(1, 0, 0, 60),
			BackgroundColor3 = Color3.new(0.1, 0.1, 0.1),
		}, {
			Buttons = e(ButtonList, {
				selectionGroupId = "Top",
				buttons = topButtons,
				selectionUp = self.group:getRedirectObject("Bottom"),
				selectionDown = self.group:getRedirectObject("Bottom"),
			}),
		}),
		Body = e("Frame", {
			Size = UDim2.new(1, 0, 1, -60),
			Position = UDim2.new(0, 0, 0, 60),
			BackgroundColor3 = Color3.new(0.3, 0.3, 0.3),
		}, {
			Buttons = e(ButtonList, {
				selectionGroupId = "Bottom",
				buttons = bottomButtons,
				selectionUp = self.group:getRedirectObject("Top"),
				selectionDown = self.group:getRedirectObject("Top"),
			}),
		})
	})
end

local function App(props)
	return e("ScreenGui", nil, {
		Nav = e(TabNavigation),
	})
end

Roact.mount(Roact.createElement(App), Players.LocalPlayer.PlayerGui, "Gamepad")