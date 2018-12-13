# PCSX Intercept Application

Further to the proof of concept published [here](https://github.com/andshrew/psclassic-misc/tree/master/Proof%20of%20Concept%20for%20Intercepting%20menu_ui%20and%20PCSX).

This application is designed to replace the built in executable for pcsx (`/usr/sony/bin/pcsx`) for the purpose of enabling us to intercept all calls from the PlayStation Classic's front end (`/usr/sony/bin/ui_menu`) and the pcsx emulator. Once this application has been installed to the system it is possible to launch any application, or series of commands, directly from the systems built in front end. This is done by creating a `launch.txt` file in your custom applications folder, or by embedding the command in the `BASENAME` field of the `DISC` table in `/gaadata/databases/regional.db`. It is also possible to alter the parameters being sent to pcsx so we can, for example, launch games in `.pbp` format rather than `.bin/.cue`.

![alt text](http://andshrew.github.io/psc/intercept/main_menu.png "PlayStation Classic Menu with Custom Applications")

## Configuring Custom Application Commands

The applicaiton is designed to be installed once, and then all custom application configuration is done through one of two approaches.

### Creating a `launch.txt` in your applications directory
When `ui_menu` launches a game it creates a symbolic link from the games directory in `/gaadata/` to `/data/AppData/sony/title/`. The intercept application is hardcoded to look to see if `launch.txt` exists at `/data/AppData/sony/title/launch.txt` and, if it does, it will execute whatever is the first line of this file.

There are two steps to preparing your custom application to be launched via this.

**1. Create a new entry for your application in the `regional.db` database.**

In the `DISC` table, the `GAME_ID` field must be unique. The numbers do not need to be seqeuential, so I would suggest avoiding using ID's that the system is aware of (internal scripts look for up to 25 games) by using a high number. `BASENAME` can be whatever you want but be aware this is the field which `ui_menu` uses to build its resource file requests.

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

**Example launch.txt for enabling the PCSX Debug Menu**

```(killall ui_menu; export PCSX_ESC_KEY=2; sleep 2s; cd /data/AppData/sony/pcsx; /usr/sony/bin/ui_menu --power-off-enable &)```

**Example to launch a single executable**

```/usr/sony/bin/showLogo```
