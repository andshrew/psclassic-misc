# Enabling the PCSX Debug Menu

## TL;DR
This is a script for use with the [lolhack exploit](https://github.com/justMaku/gpghax). Follow the instructions there to prepare your USB drive, and then copy the lolhack.sh script from this folder to it.

Once the system has booted to the main menu, insert your USB stick and the script will begin within a couple of seconds. The menu will exit and restart.

Start any game, and once in-game you can press `SELECT` + `TRIANGLE` on your controller to open the PCSX menu.

**Note this will remain in-effect until you power of the console (soft or hard)**.

## What is this?

In addition to being able to access the PCSX menu via the default `ESCAPE` key binding on certain keyboards, Sony added functionality to PCSX to enable access to the menu via a controller (without having to change the controller mappings in `pcsx.ini`). This debug mode is disabled in the final release.

The debug menu code is implemented in *pcsx_rearmed\frontend\libpicofe\in_sdl.c* and checks for two things. Whether PCSX was compiled with `CONFIG_ENABLE_MENU` enabled, or whether the system environment variable `PCSX_ESC_KEY` is set to 2. 

When the system boots it automatically runs the `sonyapp` shell script, and this sets the environment variable `PCSX_ESC_KEY` to 0 ensuring that the menu is not accessible from a controller.

Thanks to the [lolhack exploit](https://github.com/justMaku/gpghax) we can change whatever we want, and so this script simply sets `PCSX_ESC_KEY` to 2 and restarts the `ui_menu` process. This restart is required for the process to realise the environment variable has been updated.

The PCSX menu is now accessible by pressing `SELECT` + `TRIANGLE` in game, and will remain in-effect until the console is power cycled (at which point `sonyapp` will reset it to 0).

This change could be made permanent by modifying the value in `sonyapp` and uploading the amended file to the system.
