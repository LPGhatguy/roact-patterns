# Roact Theming Example
This is a demonstration of how I'd build theming into a Roact project.

```lua
local function ThemedText(props)
	return withTheme(function(theme)
		return Roact.createElement("Frame", {
			BackgroundColor3 = theme.backgroundColor,
		})
	end)
end
```