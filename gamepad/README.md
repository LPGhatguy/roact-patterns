# Roact Gamepad Example
This is an example of using gamepads in Roact. Right now, this example is incredibly convoluted, and waiting for a new Roact feature called **First-class refs**, which should ship later this year.

First-class refs enable the use of refs to lazily bind object references, which is useful for interfacing with Roblox's gamepad API.

In the meantime, a gamepad-specific workaround is implemented in this example called `redirectToRef`, which constructs a temporary `Frame` with an event to redirect to the real target when it's selected.

**It does not have correct collection semantics in this codebase, but demonstrates a pattern that will work well in the future.**

Once we have first-class refs, selection management in Roact will look like this:

```lua
local function TwoHalves()
	local leftRef = Roact.createRef()
	local rightRef = Roact.createRef()

	return Roact.createElement("Frame", nil, {
		Left = Roact.createElement("TextButton", {
			Text = "Left",
			SelectionRight = rightRef,
		}),

		Right = Roact.createElement("TextButton", {
			Text = "Right",
			SelectionLeft = leftRef,
		}),
	})
end
```

The `SelectionLeft` and `SelectionRight` properties of each value will be lazily populated when the other control is constructed!

For more complicated selection trees, libraries and patterns like `createRefCache()` and `createSelectionItem` will probably still be relevant, but should be much simpler to build.