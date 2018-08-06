--[[
	This is a (bad) workaround for a feature that we've been talking about
	adding to Roact for a little while named 'unidirectional bindings'.

	The current feature status is a hacked-together PR:

		https://github.com/Roblox/roact/pull/134

	The hope is that Roact will grow support for bindings, as well as using them
	in props, and first apply them to its ref system. Once that happens, props
	that are expected to be Instance references can be set to bindings, and will
	be lazily assigned once the ref is updated.

	Until this, this object makes a temporary Frame object that fills in for
	that feature in one specific case: selections.

	Pass a ref object to `redirectToRef` and you'll get back an instance that
	can be used in `NextSelection*` properties. It never gets destroyed, so this
	isn't a real solution, but it lets us move forward and experiment with this
	idea.
]]

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")

local gui = Instance.new("ScreenGui")
gui.Name = "redirectToRef Frames"
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