local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage.Modules

local Roact = require(Modules.Roact)
local Gamepad = require(Modules.Gamepad)

local SelectableButton = require(script.Parent.SelectableButton)

local function createWoof()
	local self = {}

	setmetatable(self, {
		__index = function(_, key)
			local newRef = Roact.createRef()
			self[key] = newRef

			return newRef
		end,
	})

	return self
end

local ButtonList = Roact.Component:extend("ButtonList")

function ButtonList:init()
	self.refs = createWoof()
	self.rootRef = Roact.createRef()

	self.props.selectionGroup.selectionRoot = self.rootRef
	self.props.selectionGroup.defaultSelection = self.refs[1]
end

function ButtonList:render()
	local buttons = self.props.buttons
	local selectionUp = self.props.selectionUp
	local selectionDown = self.props.selectionDown

	local children = {}

	children.Layout = Roact.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Horizontal,
	})

	for index, button in ipairs(buttons) do
		local previousSibling = ((index - 2) % #buttons) + 1
		local nextSibling = (index % #buttons) + 1

		children[index] = Roact.createElement(SelectableButton, {
			style = {
				Text = button.text,
				LayoutOrder = index,
				NextSelectionUp = selectionUp,
				NextSelectionDown = selectionDown,
				NextSelectionLeft = Gamepad.redirectToRef(self.refs[previousSibling]),
				NextSelectionRight = Gamepad.redirectToRef(self.refs[nextSibling]),
				[Roact.Ref] = self.refs[index],
			},
		})
	end

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		[Roact.Ref] = self.rootRef,
	}, children)
end

return ButtonList