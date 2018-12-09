# Summary
This is a proof of concept development for intercepting calls from the ui_menu and the pcsx executables. This example extends the functionality of the built in menu by enabling you to launch any other executables from it, or to alter the parameters being sent to pcsx (eg. to enable the direct loading of games in formats other than .bin/.cue)

This is intended for use by the development community rather than an end-user.

## Technical Summary

### Interaction between ui_menu and pcsx

`ui_menu` is the Sony binary for the systems main games menu, located at `/usr/sony/bin/ui_menu`. In the case of launching games it appears to simply call `/usr/sony/bin/pcsx` passing to it parameters depending on whether it is starting a fresh game or resuming an existing save state.

An example of the process for launching Tekken 3
1. It creates a symbolic link from the games directory `/gaadata/17` to `/data/AppData/sony/title/`.
2. 1. If the game is started via `PLAY` it passes the following parameters:
`-lang 2 -region 2 -enter 1 -cdfile /data/AppData/sony/title/SCES-01237.cue`
2. 2. If the game is started from a saved state:

There's no security in place to verify it's loading the application it thinks it is, so it's possible to make a copy of pcsx and then replace the original with our own application. This application can become a man-in-the-middle and allow us to do something other than launch pcsx, or it could simply pass the original parameters through to PCSX and the system will (seemingly) be none the wiser to what has happened.

There may however be instances where the ui_menu will do something depending on the exit code of pcsx, so it may well be worth passing that value back from the intercept application.

### Replacing pcsx with our own application

From testing it appears it is not possible to simply replace pcsx with a shell script. This proof of concept is a C application compiled on Ubuntu using `arm-linux-gnueabihf-gcc`.

Taking advantage of the [gpghax/lolhack exploit](https://github.com/justMaku/gpghax), a script needs to be run to create a copy of pcsx on the system and to then copy the intercept executable over. 

**Note that `/` is mounted read-only for a reason, and this procedure will be altering system files. You should only be doing this if you know what you are doing. Do not run this script more than once or it will overwrite the copy of pcsx with the intercept application. Be aware that this example will prevent you from playing Rainbow Six.**

```shell
sleep 2s
export PCSX_ESC_KEY=2

#   Kill the main menu before making changes
killall ui_menu
sleep 2s

#   Remount / as RW so that we can modify the files
mount -o remount,rw /
cp /usr/sony/bin/pcsx /usr/sony/bin/pcsx.old
cp -f /media/intercept /usr/sony/bin/pcsx

#   Restore original PCSX
#cp -f /usr/sony/bin/pcsx.old /usr/sony/bin/pcsx

#   Remount / as RO
mount -o remount,ro /
sync

cd /data/AppData/sony/pcsx # It's important to ensure you are in this directory before launching the menu
/usr/sony/bin/ui_menu

## Optional - use the below to relaunch the menu and all standard output will be dumped to your USB stick - useful for debugging
#/usr/sony/bin/ui_menu > /media/ui_menu.txt
```
### What happens now?

This proof of concept can demonstrate two things:
#### Launching an application other than PCSX
The application checks what game the user is launching, and it does this by looking for the Game ID being passed from ui_menu. Launching Rainbow Six `SLES-01136` will, instead of launching PCSX, launch the Sony boot up screen twice `/usr/sony/bin/showLogo`. It will then exit back to the menu.

Using this approach it would be possible to (once developed) add other applications such as RetroArch as entries on the Sony menu in the same way you add regular games. You would just give it a unique ID which the intercept application is looking for and it would seemlessly launch whatever you want.

#### Launching a game from a PBP image file
When launching any game other than Rainbow Six, the application will check to see if a PBP file exists within the games directory and if it does will update the `cdfile` argument which is passed into pcsx to that of the path to the PBP file. 

If the PBP file does not exist it will just pass the original parameters into pcsx.

The PBP file must reside in the games data directory within `/gaadata/` and be named in the same convention as existing files. Using Tekken 3 as an example the file would be `/gaadata/17/SCES-01237.pbp`. If you're using PBP files you no longer need a `.bin` file in the directory. The only required file is the `.cue` file - although I have not tested that `ui_menu` specificially checks for the existance of a `.cue` it may be entirely possible to only have a PBP file. Given the insignificant size of the `.cue` it's probably best just to leave it there.

From initial testing everything appears to function as it originally did. Save states are still created when you hit reset, and they correctly resume. CD changing via the open button has not been tested but probably won't work with PBP or other formats as, I believe, pcsx is making calls back into ui_menu to determine if a game is allowed to change CD. In these cases a change would need to be made via the pcsx in-game menu.

### Potential future enhancments 
This is a barebones proof of concept, and any changes require re-compiling and re-uploading the executable to the system.

An odvious useful enhancement would be implementing an external way of configuring Game IDs and what applications they should launch. This could be done via a configuration file, or perhaps even calling a shell file which may be a bit more flexible and simple to configure more advanced options.

# Thanks
I hope the development community finds this proof of concept useful.





