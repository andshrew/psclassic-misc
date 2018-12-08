# Summary
This is a proof of concept development for intercepting calls from the ui_menu and the pcsx executables. This example extends the functionality of the built in menu by enabling you to launch any other executable from the menu, or alter the parameters being sent to pcsx (eg. to enable the direct loading of games in formats other than .bin/.cue)

This is intended for use by the development community.

## Technical Summary

### Interaction between ui_menu and pcsx

The ui_menu is the Sony binary for the main games menu. `/usr/sony/bin/ui_menu` In the case of launching games it appears to simply call `/usr/sony/bin/pcsx` passing to it parameters depending on whether it is starting a fresh game or resuming an existing save state.

An example of the process for launching Tekken 3
1. It creates a symbolic link from the games directory `/gaadata/17` to `/data/AppData/sony/title/`.
2. 1. If the game is started via `PLAY` it passes the following parameters:
`-lang 2 -region 2 -enter 1 -cdfile /data/AppData/sony/title/SCES-01237.cue`
2. 2. If the game is started from a saved state:

There's no security in place to verify it's loading the application it thinks it is, so it's possible to make a copy of pcsx and then replace the original with our own application. This application can decide to do something other than launch pcsx, or it could simply pass the original parameters through to PCSX and the system will (seemingly) be none the wiser.

There may however be instances where the ui_menu will do something depending on the exit code of pcsx, so it may well be worth passing that value back from our intercept application.

### Replacing pcsx with our own application

From testing it appears it is not possibly to simply replace pcsx with a shell script. This proof of concept is a C application.

Taking advantage of 
