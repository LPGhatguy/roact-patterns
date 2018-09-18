# Roact Theming Example
This is a demonstration of a standard theming system in Roact using *context*.

The `lib` folder can be dropped into any project and used as-is. The key APIs are:

* `createTheme`: Given a table of theme values, constructs a new `Theme` object
* `ThemeProvider`: Makes a theme available to all Roact components underneath it
* `ThemeConsumer`: Pulls out a theme put into the tree by `ThemeProvider`
* `withTheme`: A utility to make accessing the theme easier

To get started, load the library. Here, we'll call it `Theming` and load it from where the default Rojo configuration puts the library.

```lua
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Theming = require(ReplicatedStorage.Modules.Theming)
```

Make a new `Theme` object using `createTheme`. You can put any values in here as long as they're immutable. Instead of mutating values, we'll replace them later!

```lua
local theme = Theming.createTheme({
	textColor = Color3.new(128, 128, 128),
	backgroundColor = Color3.new(0, 0, 0),
	font = Enum.Font.SourceSansBold,
})
```

Next, we should make a component that's able to consume the theme. We can use `withTheme`, which is a handy utility, or you can directly use `ThemeConsumer`.

```lua
local function ThemedText(props)
	return withTheme(function(theme)
		-- Using a utility to merge props onto our theme values is a good idea.
		-- Take a look at `assign` in example/init.client.lua.

		return Roact.createElement("TextLabel", {
			TextColor3 = theme.textColor,
			BackgroundColor3 = theme.backgroundColor,
			Font = theme.font,
			Size = UDim2.new(0, 300, 0, 300),
			Text = "Hello, world!",
		})
	end)
end
```

Now we can make a component that injects our theme into the Roact tree and renders some `ThemedText`:

```lua
local function App(props)
	return Roact.createElement(Theming.ThemeProvider, {
		theme = props.theme,
	}, {
		UI = Roact.createElement("ScreenGui", nil, {
			Text = Roact.createElement(ThemedText),
		}),
	})
end
```

Finally, we can construct our actual UI and then issue theme updates dynamically. Everything will update automatically!

```lua
local PlayerGui = Players.LocalPlayer.PlayerGui
Roact.mount(Roact.createElement(App, { theme = theme }), PlayerGui)

wait(2)

-- Anything we specify here will update, anything we don't will stay the same!
theme:update({
	backgroundColor = Color3.new(1, 0, 0),
	font = Enum.Font.SourceSans,
})
```