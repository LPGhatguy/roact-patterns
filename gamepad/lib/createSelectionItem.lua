local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local contextKey = newproxy(true)

local redirectContainer = Instance.new("ScreenGui")
redirectContainer.Name = "GamepadRedirectors"
redirectContainer.Parent = Players.LocalPlayer.PlayerGui

local SelectionItem = {}
SelectionItem.__index = SelectionItem

function SelectionItem:addChild(child, childName)
	if childName == nil then
		childName = HttpService:GenerateGUID(false)
	end

	self.__children[childName] = child
end

function SelectionItem:setDefaultSelection(refOrId)
	self.__defaultSelection = refOrId

	-- TODO: handle case where redirect is already selected?
end

function SelectionItem:getDefaultSelectionObject()
	if self.__defaultSelection == nil then
		warn("defaultSelection is nil for this item")
		return nil
	end

	if typeof(self.__defaultSelection) == "table" then
		-- It's a ref!
		return self.__defaultSelection.current
	else
		-- It's an ID to a child!
		return self:getRedirectObject(self.__defaultSelection)
	end
end

function SelectionItem:getRedirectObject(childName)
	local redirectObject = self.__redirects[childName]

	if redirectObject ~= nil then
		return redirectObject
	end

	redirectObject = Instance.new("Frame")
	redirectObject.Name = childName
	redirectObject.Parent = redirectContainer

	redirectObject.SelectionGained:Connect(function()
		local child = self.__children[childName]

		if child == nil then
			warn("Can't select a child that doesn't exist yet!")
			return
		end

		local object = child:getDefaultSelectionObject()

		if object == nil then
			warn("There wasn't a default selection object to select!")
		end

		GuiService.SelectedObject = object
	end)

	self.__redirects[childName] = redirectObject

	return redirectObject
end

local function createSelectionItem(componentInstance, name)
	local self = setmetatable({
		__defaultSelection = nil,
		__children = {},
		__redirects = {},
	}, SelectionItem)

	local parent = componentInstance._context[contextKey]

	if parent ~= nil then
		parent:addChild(self, name)
	end

	componentInstance._context[contextKey] = self

	return self
end

return createSelectionItem