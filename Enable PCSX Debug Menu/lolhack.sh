#   gpghax / lolhack script to enable debug menu access
#		Insert USB stick once the system has booted to the menu. The interface will restart.
#   Press Select + Triangle in-game to access the PCSX menu

#   Set the PCSX_ESC_KEY environment variable
sleep 2s
export PCSX_ESC_KEY=2

#   Restart the Main Menu so that it detects the change
killall ui_menu
sleep 2s
cd /data/AppData/sony/pcsx # It's important to ensure you are in this directory before launching the menu
/usr/sony/bin/ui_menu --power-off-enable

#   Remove USB
sync
