# PCSX Intercept Application

Further to the proof of concept published [here](https://github.com/andshrew/psclassic-misc/tree/master/Proof%20of%20Concept%20for%20Intercepting%20menu_ui%20and%20PCSX).

This application is designed to replace the built in executable for pcsx (`/usr/sony/bin/pcsx`) for the purpose of enabling us to intercept all calls from the PlayStation Classic's front end (`/usr/sony/bin/ui_menu`) and the pcsx emulator. Once this application has been installed to the system it is possible to launch any application, or series of commands, directly from the systems built in front end. This is done by creating a `launch.txt` file in your custom applications folder, or by embedding the command in the `BASENAME` field of the `DISC` table in `/gaadata/databases/regional.db`. It is also possible to alter the parameters being sent to pcsx so we can, for example, launch games in `.pbp` format rather than `.bin/.cue`.

![alt text](http://andshrew.github.io/psc/intercept/main_menu.png "PlayStation Classic Menu with Custom Applications")

## Configuring Custom Application Commands

