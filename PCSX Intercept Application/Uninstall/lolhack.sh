#   Script for the uninstallation of 
#   andshrew
#   v1.0    12/12/2018

#   A copy of the original /usr/sony/bin/pcsx was created at /usr/sony/bin/pcsx.old during installation
#   /usr/sony/bin/pcsx.old will replace /usr/sony/bin/pcsx to restore the system


LOG_FILE="/media/intercept_uninstall.log"
PCSX_SUM="fad3642f0e4cf9bca37ba1c6f4c3feb2f02618ce"
PCSX_PATH="/usr/sony/bin/pcsx"
PCSX_COPY_PATH="/usr/sony/bin/pcsx.old"
SONY_DIR="/usr/sony/bin"

echo "Starting Intercept Uninstall Script" >> $LOG_FILE

#   Close ui_menu
sleep 2s
killall ui_menu
sleep 2s

#   Restore ui_menu cursor position to 1
sed -i "s/iUiUserSettingLastSelectGameCursorPos.*/iUiUserSettingLastSelectGameCursorPos=1/" /data/AppData/sony/ui/user.pre

#   Check that /usr/sony/bin/pcsx does not already match the sha1sum of the original file
if ! echo "$PCSX_SUM  $PCSX_PATH" | sha1sum -c -; then
    
    #   /usr/sony/bin/pcsx has been changed, attempt to restore it from /usr/sony/bin/pcsx.old
    echo "sha1sum of $PCSX_PATH does not match the original" >> $LOG_FILE

    #   Check that /usr/sony/bin/pcsx.old exists
    if [ -f $PCSX_COPY_PATH ]; then

        echo "$PCSX_COPY_PATH exists, checking that it matches the sha1sum of the original" >> $LOG_FILE

        if echo "$PCSX_SUM  $PCSX_COPY_PATH" | sha1sum -c -; then

            #   /usr/sony/bin/pcsx.old exists and it matches the sha1sum of the original pcsx
            #   Copy it back to /usr/sony/bin/pcsx
            echo "$PCSX_COPY_PATH matches the sha1sum of the original. Attempting to restore it" >> $LOG_FILE
            mount -o remount,rw /
            cp -v $PCSX_COPY_PATH $PCSX_PATH >> $LOG_FILE
            mount -o remount,ro /
            echo "Directory listing of $SONY_DIR" >> $LOG_FILE
            ls -la $SONY_DIR >> $LOG_FILE

                if echo "$PCSX_SUM  $PCSX_PATH" | sha1sum -c -; then

                    #   Successfull Uninstall
                    echo "$PCSX_PATH has been successfully restored to the original file." >> $LOG_FILE
                    echo "The intercept application has been uninstalled and the system will now function as it was originially intended" >> $LOG_FILE
                    echo "ui_menu will now directly launch pcsx again" >> $LOG_FILE
                else

                    #   Unsuccesfull Uninstall
                    echo "$PCSX_PATH has not been successfully restored from $PCSX_COPY_PATH" >> $LOG_FILE
                    echo "Found:" >> $LOG_FILE
                    sha1sum $PCSX_PATH >> $LOG_FILE
                    echo "Expected:" >> $LOG_FILE
                    echo "$PCSX_SUM  $PCSX_PATH" >> $LOG_FILE
                    echo "$PCSX_PATH will need to be manually restored from an alternate copy of the original file." >> $LOG_FILE
                    red_led "5" "0.3"
                fi
        else

            #   /usr/sony/bin/pcsx.old has been tampered with since the original install and it is no longer
            #   a copy of the original pcsx.
            #   pcsx will need to be manually restored from an alternate backup of the application
            echo "$PCSX_COPY_PATH DOES NOT MATCH the sha1sum of the original." >> $LOG_FILE
            echo "Uninstallation will not continue because system files have been altered since the original installation of the Intercept application." >> $LOG_FILE
            echo "$PCSX_PATH will need to be manually restored from an alternate copy of the original file." >> $LOG_FILE
            echo "Found:" >> $LOG_FILE
            sha1sum $PCSX_COPY_PATH >> $LOG_FILE
            echo "Expected:" >> $LOG_FILE
            echo "$PCSX_SUM  $PCSX_COPY_PATH" >> $LOG_FILE
            echo "Directory listing of $SONY_DIR" >> $LOG_FILE
            ls -la $SONY_DIR >> $LOG_FILE
            red_led "5" "0.3"
        fi
    else

        #   /usr/sony/bin/pcsx.old is no longer present on the system. Without this it is no possible to restore pcsx in an automated way
        #   pcsx will need to be manually restored from an alternate backup of the application
        echo "$PCSX_COPY_PATH DOES NOT EXIST on the system." >> $LOG_FILE
        echo "Uninstallation will not continue because system files have been altered since the original installation of the Intercept application." >> $LOG_FILE
        echo "$PCSX_PATH will need to be manually restored from an alternate copy of the original file." >> $LOG_FILE
        echo "Directory listing of $SONY_DIR" >> $LOG_FILE
        ls -la $SONY_DIR >> $LOG_FILE
        red_led "5" "0.3"
    fi
else

    #   /usr/sony/bin/pcsx is already the original version
    #   There is nothing to uninstall
    echo "$PCSX_PATH is already the original version. There is nothing to uninstall." >> $LOG_FILE
fi

echo "Exit Intercept Uninstall Script" >> $LOG_FILE
echo "" >> $LOG_FILE
echo "" >> $LOG_FILE
sleep 2s
shutdown -h now




