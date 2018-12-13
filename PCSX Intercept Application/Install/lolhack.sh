#   Script for the instllation of the intercept application
#   andshrew
#   v1.0    12/12/2018

#   A copy of /usr/sony/bin/pcsx is created at /usr/sony/bin/pcsx.old
#   /media/intercept then replaces /usr/sony/bin/pcsx

LOG_FILE="/media/intercept_install.log"
INTERCEPT_PATH="/media/intercept"
PCSX_SUM="fad3642f0e4cf9bca37ba1c6f4c3feb2f02618ce"
PCSX_PATH="/usr/sony/bin/pcsx"
PCSX_COPY_PATH="/usr/sony/bin/pcsx.old"
SONY_DIR="/usr/sony/bin"

echo "Starting Intercept Install Script" >> $LOG_FILE

#   Close ui_menu
sleep 2s
killall ui_menu
sleep 2s

#   Check Intercept application is on the USB stick
if [ ! -f $INTERCEPT_PATH ]; then

    echo "The intercept application is not on the USB stick" >> $LOG_FILE
    echo "Installation cannot continue" >> $LOG_FILE
    red_led "5" "0.3"
    echo "Exit Intercept Install Script" >> $LOG_FILE
    echo "" >> $LOG_FILE
    echo "" >> $LOG_FILE
    shutdown -h now
fi

#   Restore ui_menu cursor position to 1
sed -i "s/iUiUserSettingLastSelectGameCursorPos.*/iUiUserSettingLastSelectGameCursorPos=1/" /data/AppData/sony/ui/user.pre

#   Check that /usr/sony/bin/pcsx is the original file. This script will not attempt an installation if the original pcsx file has already been modified.
if echo "$PCSX_SUM  $PCSX_PATH" | sha1sum -c -; then

    echo "sha1sum of $PCSX_PATH matches the original" >> $LOG_FILE

    #   Check if /usr/sony/bin/pcsx.old already exists
    if [ ! -f $PCSX_COPY_PATH ]; then

        echo "$PCSX_COPY_PATH does not already exist, creating the file from $PCSX_PATH" >> $LOG_FILE
        mount -o remount,rw /
        cp -v $PCSX_PATH $PCSX_COPY_PATH >> $LOG_FILE
        mount -o remount,ro /
        echo "Directory listing of $SONY_DIR" >> $LOG_FILE
        ls -la $SONY_DIR >> $LOG_FILE

        #   Check if the copy has been successful
        if [ -f $PCSX_COPY_PATH ]; then

            echo "PCSX_COPY_PATH successfully created from $PCSX_PATH" >> $LOG_FILE
        fi
    else

        echo "$PCSX_COPY_PATH already exists. This may be a re-installation" >> $LOG_FILE
    fi

#   /usr/sony/bin/pcsx is not the original file so installation cannot continue
else
    echo "sha1sum of $PCSX_PATH DOES NOT MATCH the original" >> $LOG_FILE
    echo "Installation will not continue because system files have already been altered, and a successfull uninstall cannot be guaranteed." >> $LOG_FILE
    echo "Have you already installed the intercept application? If so run the uninstallation script before attempting a re-install."
    echo "Found:" >> $LOG_FILE
    sha1sum $PCSX_PATH >> $LOG_FILE
    echo "Expected:" >> $LOG_FILE
    echo "$PCSX_SUM  $PCSX_PATH" >> $LOG_FILE
    red_led "5" "0.3"
    echo "Exit Intercept Install Script" >> $LOG_FILE
    echo "" >> $LOG_FILE
    echo "" >> $LOG_FILE
    sleep 2s
    shutdown -h now   
fi

#   Begin installation of the Intercept application
if [ -f $PCSX_COPY_PATH ]; then

    if echo "$PCSX_SUM  $PCSX_COPY_PATH" | sha1sum -c -; then
        
        echo "$PCSX_COPY_PATH exists, and sha1sum confirms it matches the original $PCSX_PATH" >> $LOG_FILE
        mount -o remount,rw /
        
        if cp -v $INTERCEPT_PATH $PCSX_PATH >> $LOG_FILE; then
            echo "The intercept application has been successfully installed to the system" >> $LOG_FILE
        else
            echo "The intercept application has NOT BEEN installed to the system" >> $LOG_FILE
            red_led "5" "0.3"
        fi
        mount -o remount,ro /
        echo "Directory listing of $SONY_DIR" >> $LOG_FILE
        ls -la $SONY_DIR >> $LOG_FILE
    else

        echo "$PCSX_COPY_PATH already exists, but it DOES NOT MATCH the sha1sum of the original $PCSX_PATH" >> $LOG_FILE
        echo "Installation will not continue because system files have already been altered, and a successfull uninstall cannot be guaranteed." >> $LOG_FILE
        echo "Found:" >> $LOG_FILE
        sha1sum $PCSX_COPY_PATH >> $LOG_FILE
        echo "Expected:" >> $LOG_FILE
        echo "$PCSX_SUM  $PCSX_COPY_PATH" >> $LOG_FILE
        red_led "5" "0.3"
    fi
fi

echo "Exit Intercept Install Script" >> $LOG_FILE
echo "" >> $LOG_FILE
echo "" >> $LOG_FILE

sleep 2s
shutdown -h now












