# PCSX Intercept Application

Further to the proof of concept published [here](https://github.com/andshrew/psclassic-misc/tree/master/Proof%20of%20Concept%20for%20Intercepting%20menu_ui%20and%20PCSX).

This application is designed to replace the built in executable for pcsx (`/usr/sony/bin/pcsx`) for the purpose of enabling us to intercept all calls from the PlayStation Classic's front end (`/usr/sony/bin/ui_menu`) to the pcsx emulator. Once this application has been installed to the system it is possible to launch any application, or series of commands, directly from the systems front end. This is done by creating a `launch.txt` file in your custom applications folder, or by embedding the command in the `BASENAME` field of the `DISC` table in `/gaadata/databases/regional.db`. It is also possible to alter the parameters being sent to pcsx so we can, for example, launch games in `.pbp` format rather than `.bin/.cue`.

![alt text](http://andshrew.github.io/psc/intercept/main_menu.png "PlayStation Classic Menu with Custom Applications")

## Configuring Custom Application Commands

The application is designed to be installed once, and then all custom application configuration is done through one of two approaches.

### Method 1: Creating a `launch.txt` in your applications directory
When `ui_menu` launches a game it creates a symbolic link from the games directory in `/gaadata/` to `/data/AppData/sony/title/`. The intercept application is hardcoded to look to see if `launch.txt` exists at `/data/AppData/sony/title/launch.txt` and, if it does, it will execute whatever is the first line of this file.

There are two steps to preparing your custom application to be launched via this.

**1. Create a new entry for your application in the `regional.db` database.**

In the `DISC` table, the `GAME_ID` field must be unique. The numbers do not need to be sequential, so I would suggest avoiding using ID's that the system is aware of (internal scripts look for up to 25 games) by using a high number. `BASENAME` can be whatever you want but be aware this is the field which `ui_menu` uses to build its resource file requests.

![alt test](http://andshrew.github.io/psc/intercept/launch_db_disc.png "DISC table example for custom application")

In this example I have used `GAME_ID` 100 and `BASENAME` 100. This means that the games directory structure will be:

Game Path: `/gaadata/100`

Game Logo Path: `/gaadata/100/100.png`

launch.txt: `/gaadata/100/launch.txt`


In the `GAME` table, the `GAME_ID` must match what you use above. Complete the remaining fields as desired, in-line with the built in entries.

![alt test](http://andshrew.github.io/psc/intercept/launch_db_game.png "DISC table example for custom application")

The entry in the `ui_menu` database has now been prepared.

**2. Create `launch.txt`**
This is a simple text file which will contain the command, or commands, you want to execute when your custom application is started.

Note that only the first line is read, and that file format should not matter. Both LF (UNIX) and CRLF (Windows) should work.

See [below](#example-commands-for-custom-applications) for example commands.

### Method 2: Embedding the command directly in the regional.db

An alternative approach to using the `launch.txt` file is to embed the command you want to execute directly within the `ui_menu` database file. __**Note it is not possible to set a custom game icon if you use this approach, as the field we embed the command into is also the field `ui_menu` uses to build the list of resources it needs for a game.**__

When `ui_menu` launches a game it builds a path to where it expects the games `.cue` file to reside. It doesn't actually care if this file actually exists, and so we can take advantage of this to pass messages into the intercept application.

This path is built from the `BASENAME` field in the `DISC` table of `/gaadata/databases/regional.db`. `ui_menu` prefixes `/data/AppData/sony/title/` and appends `.cue` to this field, and it is passed to pcsx.

The intercept application looks for a game which has `+` as the first character of its `BASENAME` and if it does, it executes the command that follows it.

**1. Create a new entry for your application in the `regional.db` database.**

In the `DISC` table, the `GAME_ID` field must be unique. The numbers do not need to be sequential, so I would suggest avoiding using ID's that the system is aware of (internal scripts look for up to 25 games) by using a high number. `BASENAME` is where the command to execute will be stored. You must prefix your command with `+`.

![alt test](http://andshrew.github.io/psc/intercept/db_disc.png "DISC table example for custom application")

In this example I have used `GAME_ID` 100 and `BASENAME` `+/usr/sony/bin/showLogo`. This will execute `/usr/sony/bin/showLogo` and on exit return to the game menu.

In the `GAME` table, the `GAME_ID` must match what you use above. Complete the remaining fields as desired, in-line with the built in entries.

### Example Commands for Custom Applications
The syntax for executing the command is the same for whichever method you have used with the exception that applications launched via being embedded into `regional.db` **must** have the command prefixed with a `+`. 

**Example to launch a single executable**

```/usr/sony/bin/showLogo```

**Example for executing multiple commands to enable the PCSX Debug Menu**

```(killall ui_menu; export PCSX_ESC_KEY=2; sleep 2s; cd /data/AppData/sony/pcsx; /usr/sony/bin/ui_menu --power-off-enable &)```

### Launching games in PBP format

As described in the [proof of concept](https://github.com/andshrew/psclassic-misc/tree/master/Proof%20of%20Concept%20for%20Intercepting%20menu_ui%20and%20PCSX), it is possible to alter the commands that `ui_menu` is passing on to `pcsx` and therfore it is possible to get the system to launch games in PBP format.

For this to work the PBP file must reside in the games directory, and be named `[BASENAME].pbp`.

An example using Tekken 3. The games directory is `/gaadata/17/`. It's `BASENAME` is `SCES-01237` therefore the PBP format file must be stored at `/gaadata/17/SCES-01237.pbp`.

The intercept application simply checks on launch if this file exists, and if it does it changes the parameter being passed to pcsx.

A `.pbp` game will always take precedence over a `.bin/.cue` once the intercept application has been installed.

## Installation / Uninstallation

I have published what I consider to be relatively safe to use installation and uninstallation scripts which would allow you to install the intercept application onto your system. These scripts contain a number of failsafes which would try to prevent anything going wrong. They will not install on a system which has already been modified.

**This release is primarily intended for the development community for information and possible integration into future user friendly releases**

The installation process involves creating a copy of `/usr/sony/bin/pcsx` at `/usr/sony/bin/pcsx.old`, and then copying `/media/intercept` over the original `/usr/sony/bin/pcsx`. Detailed log files are created at `/media/intercept_install.log` or `/media/intercept_uninstall.log`.

The files in the Install and Uninstall folders should be copied to a USB drive prepared for the gpghax/lolhack exploit. Only one should be on the drive at a time. The intercept executable should be on the root of the drive.

The USB drive should be inserted **only** when the system has booted to the main menu. If something goes wrong during the script the LED will flash red 5 times and the system will shut down. If everything has worked as intended the LED will remain solid green until the system shuts down. Remove the USB drive and boot the system again. Consult the log files for more detail.

This installation process utilises the [gpghax/lolhack](https://github.com/justMaku/gpghax) exploit.

### Example Successful Installation Log `/media/intercept_install.log`
```shell
Starting Intercept Install Script
sha1sum of /usr/sony/bin/pcsx matches the original
/usr/sony/bin/pcsx.old already exists. This may be a re-installation
/usr/sony/bin/pcsx.old exists, and sha1sum confirms it matches the original /usr/sony/bin/pcsx
`/media/intercept' -> `/usr/sony/bin/pcsx'
The intercept application has been successfully installed to the system
Directory listing of /usr/sony/bin
total 3704
drwxr-xr-x 3 root root    1024 Sep  1 14:57 .
drwxr-xr-x 5 root root    1024 Sep  9  2018 ..
-rwxr-xr-x 1 root root   16276 Sep  9  2018 auto_dimmer
-rwxr-xr-x 1 root root    1326 Sep  9  2018 checkcurrentlog.sh
-rwxr-xr-x 1 root root     452 Sep  9  2018 killp
-rwxr-xr-x 1 root root   12768 Sep  1 14:58 pcsx
-rwxr-xr-x 1 root root 1034476 Sep  1 14:57 pcsx.old
drwxr-xr-x 2 root root    1024 Sep  9  2018 plugins
-rwxr-xr-x 1 root root     454 Sep  9  2018 recovery.sh
-rwxr-xr-x 1 root root     156 Sep  9  2018 recovery2.sh
-rwxr-xr-x 1 root root      67 Sep  9  2018 showCopyright.sh
-rwxr-xr-x 1 root root 1753540 Sep  9  2018 showLogo
-rwxr-xr-x 1 root root    3269 Sep  9  2018 showVersion.sh
-rwxr-xr-x 1 root root    3991 Sep  9  2018 sonyapp
-rwxr-xr-x 1 root root    3109 Sep  9  2018 sonyapp-copy
-rwxr-xr-x 1 root root    2372 Sep  9  2018 sonyapp-copylink
-rwxr-xr-x 1 root root  949104 Sep  9  2018 ui_menu
Exit Intercept Install Script
```

### Example Successful Uninstallation Log `/media/intercept_uninstall.log`
```
Starting Intercept Uninstall Script
sha1sum of /usr/sony/bin/pcsx does not match the original
/usr/sony/bin/pcsx.old exists, checking that it matches the sha1sum of the original
/usr/sony/bin/pcsx.old matches the sha1sum of the original. Attempting to restore it
`/usr/sony/bin/pcsx.old' -> `/usr/sony/bin/pcsx'
Directory listing of /usr/sony/bin
total 4702
drwxr-xr-x 3 root root    1024 Sep  1 14:57 .
drwxr-xr-x 5 root root    1024 Sep  9  2018 ..
-rwxr-xr-x 1 root root   16276 Sep  9  2018 auto_dimmer
-rwxr-xr-x 1 root root    1326 Sep  9  2018 checkcurrentlog.sh
-rwxr-xr-x 1 root root     452 Sep  9  2018 killp
-rwxr-xr-x 1 root root 1034476 Sep  1 15:00 pcsx
-rwxr-xr-x 1 root root 1034476 Sep  1 14:57 pcsx.old
drwxr-xr-x 2 root root    1024 Sep  9  2018 plugins
-rwxr-xr-x 1 root root     454 Sep  9  2018 recovery.sh
-rwxr-xr-x 1 root root     156 Sep  9  2018 recovery2.sh
-rwxr-xr-x 1 root root      67 Sep  9  2018 showCopyright.sh
-rwxr-xr-x 1 root root 1753540 Sep  9  2018 showLogo
-rwxr-xr-x 1 root root    3269 Sep  9  2018 showVersion.sh
-rwxr-xr-x 1 root root    3991 Sep  9  2018 sonyapp
-rwxr-xr-x 1 root root    3109 Sep  9  2018 sonyapp-copy
-rwxr-xr-x 1 root root    2372 Sep  9  2018 sonyapp-copylink
-rwxr-xr-x 1 root root  949104 Sep  9  2018 ui_menu
/usr/sony/bin/pcsx has been successfully restored to the original file.
The intercept application has been uninstalled and the system will now function as it was originially intended
ui_menu will now directly launch pcsx again
Exit Intercept Uninstall Script
```
## Demonstration regional.db / Custom Applications

There is an inherent amount of risk associated with changing the `regional.db` and so I will not be publishing an example demonstration version until a script with fail safes has been developed.

There is sufficient information in this document for a developer to be able to experiment with this solution.
