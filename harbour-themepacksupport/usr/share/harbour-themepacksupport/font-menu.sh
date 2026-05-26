#!/bin/bash

# Make sure only root can run the script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root. Please gain root privileges and try again." 1>&2
   exit 1
fi

# Set directory variables
main=/usr/share/harbour-themepacksupport

# Generate menu
find -L /usr/share/harbour-themepack-* -type d -maxdepth 1 -iname "font" -print0 | xargs -0 -n1 dirname | sort -u | cut -c30- > $main/tmp/font-tmp1
find -L /usr/share/harbour-themepack-* -type d -maxdepth 1 -iname "font-nonlatin" -print0 | xargs -0 -n1 dirname | sort -u | cut -c30- > $main/tmp/font-tmp2
cat $main/tmp/font-tmp* | sort | uniq > $main/tmp/font.menu

function font-changer {

if [ -d /usr/share/harbour-themepack-$choice/font ]; then
	while [ ! -s /usr/share/harbour-themepack-$choice/font/$w1.ttf ]; do
		echo " "
		ls /usr/share/harbour-themepack-$choice/font | sed 's/\(.*\)\..*/\1/'
		read -p "Please enter the default font weight for Sailfish OS and press enter: " w1
	done
	$main/font-run.sh -f $choice -s $w1
	echo "done!"; sleep 1
fi
# If Android support is installed
if [ -d /opt/alien/system/fonts ]; then
if [ -d /usr/share/harbour-themepack-$choice/font ]; then
	if [ -s /usr/share/harbour-themepack-$choice/font/Regular.ttf ]; then
		if [ -s /usr/share/harbour-themepack-$choice/font/Light.ttf ]; then
			$main/font-run.sh -f $choice -a Regular -d Light
		else
			$main/font-run.sh -f $choice -a Regular -d Regular
		fi
	elif [ -s /usr/share/harbour-themepack-$choice/font/Light.ttf ]; then
		$main/font-run.sh -f $choice -a Light -d Light
	else
		echo "No fonts suitable for Android found"
	fi
fi
fi

}

while :
do
    clear
    cat<<EOF
 Theme pack support for Sailfish OS
 ==================================

 Please enter your choice:
 ----------------------------------
   (A)pply font theme
   (F)ont size
   Restore font (T)heme
   Restore font (S)ize
   (B)ack
 ----------------------------------
 Current font pack: $(<$main/font-current)

EOF
    read -n1 -s
    case "$REPLY" in
    "A"|"a")  	cat $main/tmp/font.menu
		echo " "
		read -p "Please enter the font pack name or 'q' to exit and press enter: " choice
		case "$choice" in 
		q|Q ) echo "ok"; sleep 1;;
		* ) echo "applying $choice"
		# Check if a backup has been performed
		if [ "$(ls $main/backup/font)" -o "$(ls $main/backup/font-droid)" ]; then
			$main/font-restore.sh
			$main/font-backup.sh
			font-changer
			if [ -d /usr/share/sailfishos-uithemer ]; then
			dconf write /desktop/lipstick/sailfishos-uithemer/activeFontPack "'$choice'"
			fi
		else
			$main/font-backup.sh
			font-changer
			if [ -d /usr/share/sailfishos-uithemer ]; then
			dconf write /desktop/lipstick/sailfishos-uithemer/activeFontPack "'$choice'"
			fi
		fi
		esac ;;
    "F"|"f")  read -p "Please enter font size multiplier or 'q' to exit and press enter. Suggested size is 1.1 or 1.2: " f1
		case "$f1" in 
		[0-3]* ) su - defaultuser -c "dconf write /desktop/jolla/theme/font/sizeMultiplier $f1"
		echo "done!"; sleep 1 ;;
		q|Q ) echo "quit"; sleep 1 ;;
		esac
		read -p "Please enter font size threshold (max font size) or 'q' to exit and press enter. Suggested size is 60: " f2
		case "$f2" in 
		[0-3]* ) su - defaultuser -c "dconf write /desktop/jolla/theme/font/sizeThreshold $f2"
		echo "done!"; sleep 1 ;;
		q|Q ) echo "quit"; sleep 1 ;;
		esac ;;
    "T"|"t")  echo "This will restore your default font pack. Continue y/N? "
		read -n1 -s choice
		case "$choice" in 
		y|Y ) $main/font-restore.sh
		if [ -d /usr/share/sailfishos-uithemer ]; then
		dconf write /desktop/lipstick/sailfishos-uithemer/activeFontPack "'default'"
		fi
		echo "done!"; sleep 1 ;;
		* ) echo "aborted"; sleep 1 ;;
		esac ;;
    "S"|"s")  echo "This will restore your default font size. Continue y/N? "
		read -n1 -s choice
		case "$choice" in 
		y|Y ) su - defaultuser -c "dconf reset /desktop/jolla/theme/font/sizeMultiplier"
		su - defaultuser -c "dconf reset /desktop/jolla/theme/font/sizeThreshold"
		echo "done!"; sleep 1 ;;
		* ) echo "aborted"; sleep 1 ;;
		esac ;;
     "B"|"b")  rm -r $main/tmp/*; exit ;;
     * )  echo "invalid option"; sleep 1 ;;
    esac
    sleep 1
done
