local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")

local gui = Instance.new("ScreenGui")
gui.Name = "bad hack redirect things"
gui.Parent = Players.LocalPlayer.PlayerGui

local function redirectToRef(ref)
	local redirect = Instance.new("Frame")

	redirect.SelectionGained:Connect(function()
		if not ref.current then
			warn("Couldn't redirect to nil ref")
			return
		end

		GuiService.SelectedObject = ref.current
	end)

	redirect.Parent = gui

	return redirect
end

return redirectToRef