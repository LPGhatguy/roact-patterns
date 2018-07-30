local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")

local SelectionGroup = {}
SelectionGroup.__index = SelectionGroup

local gui = Instance.new("ScreenGui")
gui.Name = "bad hack selection group things"
gui.Parent = Players.LocalPlayer.PlayerGui

local function createSelectionGroup()
	local self = setmetatable({
		defaultSelection = nil,
		selectionRoot = nil,
	}, SelectionGroup)

	self.target = Instance.new("Frame")

	self.target.SelectionGained:Connect(function()
		if not self.defaultSelection then
			warn("no defaultSelection")
			return
		end

		if not self.defaultSelection.current then
			warn("defaultSelection has no current value")
			return
		end

		GuiService.SelectedObject = self.defaultSelection.current
	end)

	self.target.Parent = gui

	return self
end

return createSelectionGroup