#!/bin/sh

########################################################
## Script to check for and erase a CoreStorage volume ##
########################################################
##  Script by Timo Lemburg, kontakt@timo-lemburg.de   ##
##  https://github.com/TimoLemburg/DSRemoveCSVolume   ##
########################################################
##  Version 1.0 - 03. September 2013                  ##
########################################################

## Check CoreStorage list for devices
if [ `diskutil cd list | grep -c "No CoreStorage logical volume groups found"` -eq 0  ]
then
  echo "CoreStorage Volume found"

  ## Getting disk number of first CS Volume
  cs_vol=`diskutil cs list | grep Disk: | awk 'NR==1' | awk '{print $3}'`

  ## Getting LVG UUID of Parent Volume Group
  parent_lvg=`diskutil cs info $cs_vol | grep "Parent LVG UUID:" | awk '{print $4}'`

  ## Deleting CoreStorage Volume and erasing the re-created volume
  echo "Deleting CoreStorage Volume at $cs_vol"
  diskutil cs delete $parent_lvg
  diskutil eraseVolume JHFS+ "Macintosh HD" $cs_vol
  echo "Volume reformatted as Macintosh HD"

else
  echo "No CoreStorage Volume found"
fi

exit 0
