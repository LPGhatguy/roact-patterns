local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage.Modules

local Roact = require(Modules.Roact)
local Gamepad = require(Modules.Gamepad)

local SelectableButton = require(script.Parent.SelectableButton)

-- This is a handy trick to allow us to reference refs before we've actually
-- rendered anything, and without duplicating rendering logic!
local function createRefCache()
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
	self.buttonRefs = createRefCache()

	self.group = Gamepad.createSelectionItem(self, self.props.selectionGroupId)
	self.group:setDefaultSelection(1)
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
		-- 1-based indexing makes math gross
		local previousSibling = ((index - 2) % #buttons) + 1
		local nextSibling = (index % #buttons) + 1

		children[index] = Roact.createElement(SelectableButton, {
			selectionId = index,
			style = {
				Text = button.text,
				LayoutOrder = index,
				NextSelectionUp = selectionUp,
				NextSelectionDown = selectionDown,

				-- Once Roact has support for unidirectional bindings for refs,
				-- we can change these lines to:
				-- NextSelectionLeft = self.buttonRefs[previousSibling],
				-- NextSelectionRight = self.buttonRefs[nextSibling],

				NextSelectionLeft = Gamepad.redirectToRef(self.buttonRefs[previousSibling]),
				NextSelectionRight = Gamepad.redirectToRef(self.buttonRefs[nextSibling]),

				[Roact.Ref] = self.buttonRefs[index],
			},
			selectedStyle = {
				BackgroundColor3 = Color3.new(1, 0, 0),
			},
		})
	end

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
	}, children)
end

return ButtonList