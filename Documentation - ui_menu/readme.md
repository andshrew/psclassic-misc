# ui_menu

## Configuration Files
**system.pre**

/usr/sony/share/data/preferences/system.pre

This file is empty by default. All of the below default values are built into the application. These are overriden if they exist in this file.

| Parameter | Default Value | Comment |
| - | :-: | - |
|sPcsxDataOriginPath=|/data/AppData/sony/pcsx/|*Base game save data directory. Each game has an individual sub-directory named after the integer {GAME_ID} field in regional.db eg. `/data/AppData/sony/pcsx/1`*|
|sPcsxGameImageOriginPath=|/gaadata/|*Base game data directory. Each game has an individual sub-directory named after the integer {GAME_ID} field in regional.db eg. `/gaadata/1`*|
|sPcsxExecPath=|/usr/sony/bin/pcsx|*Executable launched when starting a game or resuming a save point*|
|sPcsxDataLinkPath=|/data/AppData/sony/pcsx/.pcsx|*Symlink location. Links to `sPcsxDataOriginPath/{GAME_ID}/.pcsx`*|
|sPcsxGameImageLinkPath=|/data/AppData/sony/title|*Symlink location. Links to `sPcsxGameImageOriginPath/{GAME_ID}`*|

__*Note*__ values **must not** be enclosed within quotes " " as `ui_menu` will use them as part of the path.
