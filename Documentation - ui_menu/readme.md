# ui_menu

## Configuration Files
**system.pre**

/usr/sony/share/data/preferences/system.pre

This file is empty by default. All of the below default values are built into the application. These are overriden if they exist in this file.

| Parameter | Default Value | Comment |
| - | :-: | - |
|sPcsxGameImageOriginPath=|/gaadata/|*Root directory for the integer based game directories*|
|sPcsxExecPath=|/usr/sony/bin/pcsx|*Executable launched when starting a game or resuming a save point*|
|sPcsxGameImageLinkPath=|/data/AppData/sony/title|*Symlink location. Links to `sPcsxGameImageOriginPath/{GAME_ID}`*|


__*Note*__ values must not be enclosed within quotes " " as `ui_menu` will use them as part of the path.
