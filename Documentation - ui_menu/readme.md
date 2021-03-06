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

## Save States - Creation
On launching a game `pcsx` creates `filename.txt`. The first line of this file contains the path to the file used to launch the game, and the second line contains the name of the game as determined by `pcsx`. This name is used by 'pcsx' as the base name for files created specifically for this game (eg. save states, screenshots, configuration files)

| Actual Path | Parameter Path |
| - | - |
|`/data/AppData/sony/pcsx/.pcsx/filename.txt`|`{Current Working Directory}/.pcsx/filename.txt` |

**Contents**
```
/data/AppData/sony/title/SCES-00002.cue
BATTLEARENATOSHINDEN-SCES00002
```

### Pressing the RESET button **with no existing save state**
`pcsx` regenerates `filename.txt`. The contents of this file will be unchanged except in cases where the game disc has subsequently been changed. It then creates a save state file, named after the second line of `filename.txt`. `BATTLEARENATOSHINDEN-SCES00002.000`. The `000` indicates save state slot 0. It also creates a screenshot `BATTLEARENATOSHINDEN-SCES00002.png`.

| Actual Path | Parameter Path |
| - | - |
|`/data/AppData/sony/pcsx/.pcsx/filename.txt`|`{Current Working Directory}/.pcsx/filename.txt` |
|`/data/AppData/sony/pcsx/.pcsx/sstates/BATTLEARENATOSHINDEN-SCES00002.000`|`{Current Working Directory}/.pcsx/sstates/{2nd line of filename.txt}.000` |
|`/data/AppData/sony/pcsx/.pcsx/screenshots/BATTLEARENATOSHINDEN-SCES00002.png`|`{Current Working Directory}/.pcsx/screenshots/{2nd line of filename.txt}.png` |

`ui_menu` now appends `.res` to all of these files.

| Actual Path | Parameter Path |
| - | - |
|`/data/AppData/sony/pcsx/1/.pcsx/filename.txt.res`|`{sPcsxDataOriginPath}/{GAME_ID}/.pcsx/filename.txt.res` |
|`/data/AppData/sony/pcsx/1/.pcsx/sstates/BATTLEARENATOSHINDEN-SCES00002.000.res`|`{sPcsxDataOriginPath}/{GAME_ID}/.pcsx/sstates/{2nd line of filename.txt}.000.res` |
|`/data/AppData/sony/pcsx/1/.pcsx/screenshots/BATTLEARENATOSHINDEN-SCES00002.png.res`|`{sPcsxDataOriginPath}/{GAME_ID}/.pcsx/screenshots/{2nd line of filename.txt}.png.res` |



### Pressing the RESET button with an existing save state
`pcsx` regenerates `filename.txt`. The contents of this file will be unchanged except in cases where the game disc has subsequently been changed. It then creates a save state file, named after the second line of `filename.txt`. `BATTLEARENATOSHINDEN-SCES00002.000`. The `000` indicates save state slot 0. It also creates a screenshot `BATTLEARENATOSHINDEN-SCES00002.png`.

| Actual Path | Parameter Path |
| - | - |
|`/data/AppData/sony/pcsx/.pcsx/filename.txt`|`{Current Working Directory}/.pcsx/filename.txt` |
|`/data/AppData/sony/pcsx/.pcsx/sstates/BATTLEARENATOSHINDEN-SCES00002.000`|`{Current Working Directory}/.pcsx/sstates/{2nd line of filename.txt}.000` |
|`/data/AppData/sony/pcsx/.pcsx/screenshots/BATTLEARENATOSHINDEN-SCES00002.png`|`{Current Working Directory}/.pcsx/screenshots/{2nd line of filename.txt}.png` |

`ui_menu` checks if `BATTLEARENATOSHINDEN-SCES00002.000.res` exists, and as it does it knows this is a new save state. It prompts the user to keep the existing save state, or keep the new one.

![alt text](http://andshrew.github.io/psc/ui_menu/delete_save_state.png "PlayStation Classic Menu keep or new save point")

If the user selects YES to keep the new save point.

`ui_menu` creates a backup of the existing save state by moving the existing save state files suffixed with `.res` to files suffixed with `.bak`. It does not create a backup of the screenshot.

| Actual Path | Parameter Path |
| - | - |
|`/data/AppData/sony/pcsx/1/.pcsx/filename.txt.bak`|`{sPcsxDataOriginPath}/{GAME_ID}/.pcsx/filename.txt.bak` |
|`/data/AppData/sony/pcsx/1/.pcsx/sstates/BATTLEARENATOSHINDEN-SCES00002.000.bak`|`{sPcsxDataOriginPath}/{GAME_ID}/.pcsx/sstates/{2nd line of filename.txt}.000.bak` |

`ui_menu` appends the new save state files with `.res`

| Actual Path | Parameter Path |
| - | - |
|`/data/AppData/sony/pcsx/1/.pcsx/filename.txt.res`|`{sPcsxDataOriginPath}/{GAME_ID}/.pcsx/filename.txt.res` |
|`/data/AppData/sony/pcsx/1/.pcsx/sstates/BATTLEARENATOSHINDEN-SCES00002.000.res`|`{sPcsxDataOriginPath}/{GAME_ID}/.pcsx/sstates/{2nd line of filename.txt}.000.res` |
|`/data/AppData/sony/pcsx/1/.pcsx/screenshots/BATTLEARENATOSHINDEN-SCES00002.png.res`|`{sPcsxDataOriginPath}/{GAME_ID}/.pcsx/screenshots/{2nd line of filename.txt}.png.res` |

If the user selects NO to keep the existing save point then the files created by `pcsx` are deleted.


You can see from this process that `ui_menu` is creating a backup of the original save state, even though there is seemingly no user accessible way to restore this backup.

If you intentionally damage the save state after the backup has been made (ie. delete `BATTLEARENATOSHINDEN-SCES00002.000.res`) then `ui_menu` automatically restores the previous save state from the `.bak` files. The screenshot however is not restored to the original version as no backup is created of it, instead this remains as the deleted save states screenshot.
![alt text](http://andshrew.github.io/psc/ui_menu/cannot_resume.PNG "PlayStation Classic Menu automatic save state repair")


### Caution on differing pcsx and ui_menu data paths
You will note from the above that there is the potential for conflict in the directory being used by `ui_menu` and `pcsx`.

Whenever `pcsx` is interacting with the file system it is doing so from the **`{Current Working Directory}`**. This is the directory from which `ui_menu` was launched. By default this location is `/data/AppData/sony/pcsx/`.

Whenever `ui_menu` is interacting with the file system it is doing from from the configuration variable **`{sPcsxDataOriginPath}`**. By default this location is `/data/AppData/sony/pcsx/`

**These paths must always match.** If either of these have been changed from default then there is the potential for `pcsx` to be writing save states into a directory which differs to the directory that `ui_menu` is checking to determine if a save state actually exists, therfore breaking the save state functionality within `ui_menu`.

## Save States - Loading
`ui_menu` checks if a save state exists for a game each time it is selected on the games carousel. It does this by looking for `filename.txt.res`. It reads the second line of this file to determine the name of the files related to this save state, specifically the name of the screenshot which is then loaded into the interface.

| Actual Path | Parameter Path |
| - | - |
|`/data/AppData/sony/pcsx/1/.pcsx/filename.txt.res`|`{sPcsxDataOriginPath}/{GAME_ID}/.pcsx/filename.txt.res` |

**Contents**
```
/data/AppData/sony/title/SCES-00002.cue
BATTLEARENATOSHINDEN-SCES00002
```

`ui_menu` checks that the save state file is not zero length, or missing.

