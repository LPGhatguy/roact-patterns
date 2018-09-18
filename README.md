# Roact Patterns
This is a repository containing a set of features that people commonly want to implement with Roact, and the way that I'd build them.

## Pattern Overview
* [`theming`](theming/README.md) - Dynamic theming based on Roact's *context* feature
* [`gamepad`](gamepad/README.md) - Exploring gamepad development in Roact
	* This example is a prototype and needs a new Roact feature to be production-ready

## Running Projects
Make sure that:

* You have all Git submodules pulled down.
	* If you clone this repository with `git clone --recurse-submodules`, you're good to go.
	* If you've already cloned the repository, use `git submodule update --init` to get them.
* You have Rojo 0.4.10 or newer installed, used to sync examples into Roblox Studio.

1. Run `rojo serve` in one of the pattern folders, like `theming`
2. Open a new Roblox Studio place
3. Enable HTTP in Game Settings
4. Press 'Sync In' in the Rojo toolbar
5. Run the game

## License
This project is available under the CC0 1.0 Universal license.

Details are in [LICENSE](LICENSE).