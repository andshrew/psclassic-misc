# ui_menu

## Configuration Files
**system.pre**

/usr/sony/share/data/preferences/system.pre

This file is empty by default. All of the below default values are built into the application. These are overriden if they exist in this file.

| Parameter | Default Value | Comment |
| - | :-: | - |
|sPcsxDataOriginPath=|/data/AppData/sony/pcsx/|*Base game save data directory. Each game has an individual sub-directory named after the integer {GAME_ID} field in regional.db eg. `/data/AppData/sony/pcsx/1`. This is the directory `ui_menu` __must__ be launched from.*|
|sPcsxGameImageOriginPath=|/gaadata/|*Base game data directory. Each game has an individual sub-directory named after the integer {GAME_ID} field in regional.db eg. `/gaadata/1`*|
|sPcsxExecPath=|/usr/sony/bin/pcsx|*Executable launched when starting a game or resuming a save point*|
|sPcsxDataLinkPath=|/data/AppData/sony/pcsx/.pcsx|*Symlink location. Links to `sPcsxDataOriginPath/{GAME_ID}/.pcsx`. This __must__ be named `.pcsx` and it __must__ be a subdirectory of `sPcsxDataOriginPath`*|
|sPcsxGameImageLinkPath=|/data/AppData/sony/title|*Symlink location. Links to `sPcsxGameImageOriginPath/{GAME_ID}`*|

__*Note*__ values **must not** be enclosed within quotes " " as `ui_menu` will use them as part of the path.

## Save States
On launching a game `pcsx` creates `filename.txt`

| Actual Path | Parameter Path |
| - | - |
|`/data/AppData/sony/pcsx/.pcsx/filename.txt`|`{Current Working Directory}/.pcsx/filename.txt` |

**Contents**
```
/data/AppData/sony/title/SCES-00002.cue
BATTLEARENATOSHINDEN-SCES00002
```

### Pressing the RESET button **with no existing save state**
`pcsx` creates a save state file, named after the second line of `filename.txt`. `BATTLEARENATOSHINDEN-SCES00002.000`. `000` indicates save state 0.

| Actual Path | Parameter Path |
| - | - |
|`/data/AppData/sony/pcsx/.pcsx/sstates/BATTLEARENATOSHINDEN-SCES00002.000`|`{Current Working Directory}/.pcsx/sstates/{2nd line of filename.txt}.000` |

`ui_menu` moves the save state file from `BATTLEARENATOSHINDEN-SCES00002.000` to `BATTLEARENATOSHINDEN-SCES00002.000.res`

| Actual Path | Parameter Path |
| - | - |
|`/data/AppData/sony/pcsx/.pcsx/sstates/BATTLEARENATOSHINDEN-SCES00002.000.res`|`{sPcsxDataOriginPath}/.pcsx/sstates/{2nd line of filename.txt}.000.res` |

`ui_menu` moves `filename.txt` to `filename.txt.res`. The contents is unchanged from the above.

| Actual Path | Parameter Path |
| - | - |
|`/data/AppData/sony/pcsx/.pcsx/filename.txt.res`|`{sPcsxDataOriginPath}/.pcsx/filename.txt.res` |

### Resuming

### Pressing the RESET button with an existing save state
`pcsx` creates a save state file, named after the second line of `filename.txt`. `BATTLEARENATOSHINDEN-SCES00002.000`.

`ui_menu` checks if `BATTLEARENATOSHINDEN-SCES00002.000.res` exists and as it does it knows this is a new save state. It prompts the user to keep the existing save state, or keep the new one.

![alt text](http://andshrew.github.io/psc/ui_menu/delete_save_state.png "PlayStation Classic Menu keep or new save point")

If the user selects YES to keep the new save point.

`ui_menu` moves the existing save state file from `BATTLEARENATOSHINDEN-SCES00002.000.res` to `BATTLEARENATOSHINDEN-SCES00002.000.bak`

`ui_menu` moves the new save state file from `BATTLEARENATOSHINDEN-SCES00002.000` to `BATTLEARENATOSHINDEN-SCES00002.000.res`

`ui_menu` moves `filename.txt.res` to `filename.txt.res.bak`.

`ui_menu` moves `filename.txt` to `filename.txt.res`. The contents is unchanged from the above.

You can see from this process that `ui_menu` is creating a backup of the original save state, even though there is no user accessible way to restore this backup.



