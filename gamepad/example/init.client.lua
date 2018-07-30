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
	}
}

local TabNavigation = Roact.Component:extend("TabNavigation")

function TabNavigation:init()
	self.topGroup = Gamepad.createSelectionGroup()
	self.bottomGroup = Gamepad.createSelectionGroup()
end

function TabNavigation:render()
	return e("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.new(0.2, 0.2, 0.2),
	}, {
		Navigation = e("Frame", {
			Size = UDim2.new(1, 0, 0, 60),
			BackgroundColor3 = Color3.new(0.1, 0.1, 0.1),
		}, {
			Buttons = e(ButtonList, {
				buttons = topButtons,
				selectionGroup = self.topGroup,
				selectionUp = self.bottomGroup.target,
				selectionDown = self.bottomGroup.target,
			}),
		}),
		Body = e("Frame", {
			Size = UDim2.new(1, 0, 1, -60),
			Position = UDim2.new(0, 0, 0, 60),
			BackgroundColor3 = Color3.new(0.3, 0.3, 0.3),
		}, {
			Buttons = e(ButtonList, {
				buttons = bottomButtons,
				selectionGroup = self.bottomGroup,
				selectionUp = self.topGroup.target,
				selectionDown = self.topGroup.target,
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