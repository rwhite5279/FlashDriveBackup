#!/bin/sh

# backup - This script checks every 20 seconds or so to see
#          if a drive MRBCKP has been plugged in and mounted.
#          If it is mounted, an rsync -a (archive) of the
#          indicated folder is run. Once the archive has been
#          run, the drive is unmounted automatically.
#
#          This initial version of the script must be run manually
#          from the command line, but once running, it continues,
#          checking for the insertion of the thumb drive every 20
#          seconds.
#
#          TODO:
#          * Launch utility automatically on log-in (Apple's launchd)
#          * Provide dialog box indications of status
#          * Use OS X Disk Arbitration to monitor status of flash drive
#          
#          @author Richard White
#          @version 2014-04-27-1500


drivename=MBPBCKUP
directory=/Users/userName/Desktop/folder_to_backup
while x=0
    do if mount | grep -q $drivename;
    then 
        memneeded=$(du -s $directory | cut -f 1)
        memavailable=$(du -s /Volumes/$drivename | cut -f 1)
        if [ "$memneeded" -gt "$memavailable" ]
        then
            echo "Insufficient memory on flashdrive"
        else
            echo "Backing up to USB"
            sleep 10 
            rsync -ax $directory /Volumes/$drivename
        fi 
        diskutil unmount /Volumes/$drivename
        echo "Drive is safe to remove"
    fi
    sleep 20
done

