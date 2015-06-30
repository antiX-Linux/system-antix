#!/bin/bash
# File Name: antix-system.sh
# Version: 1.5.2
# Purpose:  For setting locales, computer names, recovering space, and repairing 
#  			the grub legacy boot loader
# Authors: Dave and minor modifications by anticapitalista
# Acknowledgements: AntiX forum users for suggestions, testing, and input
# Special Acknowledgements: anticapitalista for testing, suggestions, input

# Copyright (C) Tuesday, Feb. 7, 2011  by Dave / david.dejong02@gmail.com
# License: gplv2
# This file is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
#################################################################################################################################################

TEXTDOMAINDIR=/usr/share/locale
TEXTDOMAIN=antix-system.sh

# Root check 
if [[ $UID != "0" ]]; then
 gksu antix-system.sh &
 exit 1 ;
fi

Locale=$"Locale" 
Disk_Management=$"Disk_Management" 
Grub=$"Grub"

export DIALOG=$(cat <<End_of_Text 

<window title="Antix System" window-position="1" >
<vbox>
<notebook labels="$Locale   |   $Disk_Management   |   $Grub Repair">

<vbox>
 <frame `gettext $"Locale options"`>
 <checkbox active="false">
 <label>"`gettext $"Enable locale options"`"</label>
 <variable>LOCALE</variable>
 <default>no</default>
 <action>if true enable:NAMES</action>
 <action>if false disable:NAMES</action>
 <action>if true enable:LOCALES</action>
 <action>if false disable:LOCALES</action>
 </checkbox>
  <hbox>
   <vbox>
    <frame `gettext $"Names"`>
     <checkbox>
      <label>"`gettext $"Enable name change"`"</label>
      <variable>NAMES</variable>
      <visible>disabled</visible>
      <default>no</default>
      <action>if true enable:NAME</action>
      <action>if false disable:NAME</action>
      <action>if true enable:DOMAIN</action>
      <action>if false disable:DOMAIN</action>
      <action>if true enable:SAMBAWORKGROUP</action>
      <action>if false disable:SAMBAWORKGROUP</action>
      <action>if true disable:LOCALES</action>
      <action>if false enable:LOCALES</action>     
     </checkbox>
     <text use-markup="true" width-chars="20">
	  <label>"`gettext $"Computer name"`"</label>
	 </text>
     <entry>
      <default>ANTIX1</default>
      <variable>NAME</variable>
      <visible>disabled</visible>
     </entry>
     <text use-markup="true" width-chars="20">
	  <label>"`gettext $"Computer domain"`"</label>
	 </text>
     <entry>
      <default>ANTIX1.local</default>
      <variable>DOMAIN</variable>
      <visible>disabled</visible>
     </entry>
     <text use-markup="true" width-chars="20">
	  <label>"`gettext $"Samba work group"`"</label>
	 </text>
     <entry>
      <default>ANTIXWORKGROUP1</default>
      <variable>SAMBAWORKGROUP</variable>
      <visible>disabled</visible>
     </entry>
    </frame>
   </vbox>
   <vbox>
    <frame `gettext $"Locales"`>
     <checkbox>
      <label>"`gettext $"Enable locale options"`"</label>
      <variable>LOCALES</variable>
      <visible>disabled</visible>
      <default>no</default>
      <action>if true enable:LANGUAGE</action>
      <action>if false disable:LANGUAGE</action>
      <action>if true enable:CONSOLELOCALE</action>
      <action>if false disable:CONSOLELOCALE</action>
      <action>if true enable:KEYBOARD</action>
      <action>if false disable:KEYBOARD</action>
      <action>if true enable:MOUSE</action>
      <action>if false disable:MOUSE</action>
      <action>if true disable:NAMES</action>
      <action>if false enable:NAMES</action>
     </checkbox>
     <text use-markup="true" width-chars="20">
	  <label>"`gettext $"Change language"`"</label>
	 </text>
     <checkbox active="false">
      <visible>disabled</visible>
      <label>"`gettext $"enable language select"`"</label>
      <variable>LANGUAGE</variable>
      <default>no</default>
     </checkbox>
     <checkbox active="false">
      <visible>disabled</visible>
      <label>"`gettext $"select console locale"`"</label>
      <variable>CONSOLELOCALE</variable>
      <default>no</default>
     </checkbox>
	 <checkbox active="false">
      <visible>disabled</visible>
      <label>"`gettext $"select keyboard map"`"</label>
      <variable>KEYBOARD</variable>
      <default>no</default>
     </checkbox>
     <text use-markup="true" width-chars="20">
	  <label>"`gettext $"Change mouse order"`"</label>
	 </text>
     <combobox>
	  <visible>disabled</visible>
      <variable>MOUSE</variable>
      <item>`gettext $"Leave default"`</item>
      <item>`gettext $"Left hand"`</item>
      <item>`gettext $"Right hand"`</item>
     </combobox>
    </frame>
   </vbox>
  </hbox>
 </frame>
</vbox>

<vbox>
 <frame `gettext $"Disk management"`>
  <checkbox>
   <label>"`gettext $"Enable Disk Management"`"</label>
   <variable>DISK</variable>
   <default>no</default>
   <action>if true enable:PACKAGE</action>
   <action>if false disable:PACKAGE</action>
   <action>if true enable:LOGS</action>
   <action>if false disable:LOGS</action>
   <action>if true enable:USAGE</action>
   <action>if false disable:USAGE</action>
   <action>if true enable:PARTITION</action>
   <action>if false disable:PARTITION</action>
   <action>if true enable:USB</action>
   <action>if false disable:USB</action>
  </checkbox>
  <frame `gettext $"Options"`>
   <checkbox>
    <label>"`gettext $"Clear Package Cache"`"</label>
    <visible>disabled</visible>
    <variable>PACKAGE</variable>
    <default>no</default>
   </checkbox>
   <checkbox>
    <label>"`gettext $"Clear Logs"`"</label>
    <visible>disabled</visible>
    <variable>LOGS</variable>
    <default>no</default>
   </checkbox>
   <radiobutton>
    <label>"`gettext $"Show basic disk usage"`"</label>
    <visible>disabled</visible>
    <variable>USAGE</variable>
    <default>no</default>
   </radiobutton>
   <radiobutton>
    <label>"`gettext $"Run partition manager"`"</label>
    <visible>disabled</visible>
    <variable>PARTITION</variable>
    <default>no</default>
   </radiobutton>
   <radiobutton>
    <label>"`gettext $"Run antiX to USB"`"</label>
    <visible>disabled</visible>
    <variable>USB</variable>
    <default>no</default>
   </radiobutton>
  </frame>
 </frame>  
</vbox>

<vbox>
 <frame `gettext $"Repair grub"`>
  <checkbox>
   <label>"`gettext $"Enable grub repair"`"</label>
   <variable>GRUB</variable>
   <default>no</default>
  </checkbox>
 </frame>
</vbox>

</notebook>
  <hbox>
 	<button ok></button>
 	<button cancel></button>
  </hbox>
  </vbox>
</window>
End_of_Text
)

I=$IFS; IFS=""
for STATEMENTS in  $(gtkdialog --program DIALOG); do
  eval $STATEMENTS
done
IFS=$I

#Set terminal
TERM="x-terminal-emulator"

function name {
	OLDNAME=`cat /etc/hostname`;
	echo "$NAME" > /etc/hostname ;
	/etc/init.d/hostname.sh reload ;
}

function domain {
	OLDDOMAIN=`cat /etc/defaultdomain` ;
	echo "$DOMAIN" > /etc/defaultdomain ;
	/etc/init.d/hostname.sh reload ; 
}

function sambaworkgroup {
	OLDWORKGROUP=`cat /etc/samba/smb.conf | grep "workgroup ="`;
	NEWWORKGROUP="workgroup = $SAMBAWORKGROUP";
	sed "s/$OLDWORKGROUP/$NEWWORKGROUP/ig" /etc/samba/smb.conf > /tmp/smb.conf ;
	mv -f /tmp/smb.conf /etc/samba/smb.conf ;
	rm -r -f /tmp/smb.conf ;
	/etc/init.d/samba stop ;
	/etc/init.d/samba start ;
	
}
function language {
DIR="/usr/share/antiX/localisation"
ROXPB="config/rox.sourceforge.net/ROX-Filer"
MENU_WMs="fluxbox icewm jwm"

$TERM -e su -c "dpkg-reconfigure locales; " ;
LOCALE=`cat /etc/default/locale | grep "LANG="`;
echo "$LOCALE" > /tmp/locale.txt;
sed -i -e 's/LANG=//ig' /tmp/locale.txt;
ls $DIR > /tmp/antix-bin.txt;
ALOCALE=`cat /tmp/antix-bin.txt | yad --height=360 --text $"Choose your locale for antiX applications" --list --column="" --separator=""`;
if [ "$?" !="0" ]; then
yad --image "info" --text $"Locale chosen, antix application locale left default";
else
for wm in $MENU_WMs;  do 
mkdir /tmp/.$wm 
cp -r $DIR/$ALOCALE/$wm/* /tmp/.$wm ;
cat /tmp/.$wm/menu | grep -v "gksu minstall" |cat > /tmp/.$wm/menu1 && mv -f /tmp/.$wm/menu1 /tmp/.$wm/menu;
done
cp -r $DIR/$ALOCALE/jwmrc /tmp/.jwm/.jwmrc1 && mv -f /tmp/.jwm/.jwmrc1 /tmp/.jwm/.jwmrc;
for ULOCALE in `ls /home/`; do {
	mv -f /tmp/.icewm/* /home/$ULOCALE/.icewm/ ;
	mv -f /tmp/.fluxbox/* /home/$ULOCALE/.fluxbox/ ;
        mv -f /tmp/.jwm/.jwmrc /home/$ULOCALE/ ;
        mv -f /tmp/.jwm/* /home/$ULOCALE/.jwm/ ;
        cp -r $DIR/$ALOCALE/$ROXPB/* /home/$ULOCALE/.$ROXPB/ ;
	chown $ULOCALE:users /home/$ULOCALE/.fluxbox/menu
	chown $ULOCALE:users /home/$ULOCALE/.icewm/menu
	chown $ULOCALE:users /home/$ULOCALE/.icewm/toolbar
        chown $ULOCALE:users /home/$ULOCALE/.jwm/menu
        chown $ULOCALE:users /home/$ULOCALE/.jwm/tray
        chown $ULOCALE:users /home/$ULOCALE/.jwmrc
        chown $ULOCALE:users /home/$ULOCALE/.$ROXPB/pb_antiX-icewm
        chown $ULOCALE:users /home/$ULOCALE/.$ROXPB/pb_antiX-fluxbox
        chown $ULOCALE:users /home/$ULOCALE/.$ROXPB/pb_antiX-jwm 
}
done
yad --image "info" --title "antix-system" --text $"Language has changed to $LOCALE" ;
fi

}

function keyboard {
KEYMAP=`cat /usr/share/antiX/keymap.template |grep -v "#" |yad --height=360 --text $"Choose your locale for antiX applications" --list --column=""  --separator=""`;
if [ $? != 0 ]; then
yad --image "info" --text $"Keymap left default";
else
cat /usr/share/antiX/keymap.template |grep "$KEYMAP" > /tmp/selectedmap;
cat /tmp/selectedmap | sed 's/|[a-z]*//ig' /tmp/selectedmap > /tmp/map;
MAP=`cat /tmp/map`;
/usr/sbin/install-keymap $MAP;
cat /tmp/selectedmap |grep -o "|[a-z]*" > /tmp/default;
sed -i 's/|//ig' /tmp/default;
DEFAULT=`cat /tmp/default`;
KLOCALE=`cat /etc/default/keyboard | grep -m "1" "XKBLAYOUT="` ;
NEWKLOCALE="XKBLAYOUT=\"$DEFAULT,us\"" ;
sed -i -e "s/$KLOCALE/$NEWKLOCALE/ig" /etc/default/keyboard ;
KOPTIONS=`cat /etc/default/keyboard | grep -m "1" "XKBOPTIONS="` ;
NEWKOPTIONS="XKBOPTIONS=\"grp:alt_shift_toggle,terminate:ctrl_alt_bksp,grp_led:scroll\"" ;
sed -i -e "s/$KOPTIONS/$NEWKOPTIONS/ig" /etc/default/keyboard ;
 if [ "$MOUSE" = "Leave default" ] ; then
 yad --image "info" --title "antix-system" --width=480 --text $"Keyboard set to $KEYMAP, restart and use keymap by ALT + SHIFT + (LEFT / RIGHT)" ;
 antix-system.sh ;
 else
 mouse ; 
 yad --image "info" --title "antix-system" --width=480 --text $"Keyboard set to $KEYMAP, restart and use keymap by ALT + SHIFT + (LEFT / RIGHT). Mouse layout set to $MOUSE" ;
 fi
fi

}

function mouse {
     if [ "$MOUSE" = "Left hand" ] ; then
    xmodmap -e 'pointer = 3 2 1 4 5'
    `/usr/local/bin/antixmousexmodmap.pl "3 2 1 4 5"`
    else 
     if [ "$MOUSE" = "Right hand" ] ; then
     xmodmap -e 'pointer = 1 2 3 4 5'
     `/usr/local/bin/antixmousexmodmap.pl "1 2 3 4 5"`
     fi
    fi
}
		
if [ "$EXIT" = "OK" ] ; then
 if [ "$LOCALE" = "true" ] ; then
  if [ "$NAMES" = "true" ] ; then
   if [ "$NAME" = "ANTIX1" ] ; then
    if [ "$DOMAIN" = "ANTIX1.local" ] ; then
     if [ "$SAMBAWORKGROUP" = "ANTIXWORKGROUP1" ] ; then
      yad --image "error" --title "antix-system" --width=480 --text $"Need to add some valid information to change names" ;
      antix-system.sh ;
     else
      sambaworkgroup ;
      yad --image "info" --width=480 --text $"Samba workgroup has been changed from $OLDWORKGROUP to $NEWWORKGROUP" ;
     fi
    else
    domain ; 
     if [ "$SAMBAWORKGROUP" = "ANTIXWORKGROUP1" ] ; then
      yad --image "info" --title "antix-system" --width=480 --text $"Domain name has been changed from $OLDDOMAIN to $DOMAIN" ;
     else
      sambaworkgroup ;
      yad --image "info" --title "antix-system" --width=480 --text $"Domain name has been changed from $OLDDOMAIN to $DOMAIN and Samba workgroup from $OLDWORKGROUP to $NEWWORKGROUP" ;
     fi
    fi
   else
   name ;
    if [ "$DOMAIN" = "ANTIX1.local" ] ; then
     if [ "$SAMBAWORKGROUP" = "ANTIXWORKGROUP1" ] ; then
      yad --image "error" --title "antix-system" --width=480 --text $"Need to add some valid information to change names" ;
      antix-system.sh ;
     else
      sambaworkgroup ;
      yad --image "info" --width=480 --text $"Computer name has been changed from $OLDNAME to $NAME and Samba workgroup from $OLDWORKGROUP to $NEWWORKGROUP" ;
     fi
    else
    domain ; 
     if [ "$SAMBAWORKGROUP" = "ANTIXWORKGROUP1" ] ; then
      yad --image "info" --width=480 --title "antix-system" --text $"Computer name has been changed from $OLDNAME to $NAME and Domain name from $OLDDOMAIN to $DOMAIN" ;
     else
      sambaworkgroup ;
      yad --image "info" --width=480 --title "antix-system" --text $"Computer name name has been changed from $OLDNAME to $NAME, Domain name from $OLDDOMAIN to $DOMAIN and Samba workgroup from $OLDWORKGROUP to $NEWWORKGROUP" ;
     fi
    fi
   fi
  fi
  if [ "$LOCALES" = "true" ] ; then
   if [ "$LANGUAGE" = "false" ] ; then
   if [ "$CONSOLELOCALE" = "false" ] ; then
    if [ "$KEYBOARD" = "false" ] ; then
     if [ "$MOUSE" = "Leave default" ] ; then
      yad --image "error" --title "antix-system" --width=480 --text $"Need to add some valid information to change locale options" ;
      antix-system.sh ;
     else
      mouse;
      yad --image "info" --title "antix-system" --width=480 --text $"Mouse Layout set to $MOUSE" ;
     fi
    else
     keyboard;
    fi
   else
    $TERM -e su -c "dpkg-reconfigure console-setup;";
    if [ "$KEYBOARD" = "Leave default" ] ; then
     if [ "$MOUSE" = "Leave default" ] ; then
      antix-system.sh ;
     else
      mouse;
      yad --image "info" --title "antix-system" --width=480 --text $"Mouse Layout set to $MOUSE" ;
     fi
    else
     keyboard;
    fi
    fi
   else
    language;
    if [ "$CONSOLELOCALE" = "false" ] ;then
     if [ "$KEYBOARD" = "false" ] ; then
     if [ "$MOUSE" = "Leave default" ] ; then
      antix-system.sh ;
     else
      mouse;
      yad --image "info" --title "antix-system" --width=480 --text $"Mouse Layout set to $MOUSE" ;
     fi
    else
     keyboard;
    fi
    else
    $TERM -e su -c "dpkg-reconfigure console-setup;";
    if [ "$KEYBOARD" = "false" ] ; then
     if [ "$MOUSE" = "Leave default" ] ; then
      antix-system.sh ;
     else
      mouse;
      yad --image "info" --title "antix-system" --width=480 --text $"Mouse Layout set to $MOUSE" ;
     fi
    else
     keyboard;
    fi
    fi
   fi
  fi
 fi
 if [ "$DISK" = "true" ] ; then
  if [ "$PACKAGE" = "false" ] ; then
   if [ "$LOGS" = "false" ] ; then 
    if [ "$USAGE" = "false" ] ; then
     if [ "$PARTITION" = "false" ] ; then
      if [ "$USB" = "false" ] ; then
       yad --image "error" --title "antix-system" --width=480 --text $"Impossible error, radio buttons require at least one choice";
      else
       antix2usb.py ;
      fi
     else
      gparted ;
     fi
    else
     $TERM -e bash -c "diskusage ; bash";
    fi
   else
    rm -r -f /var/log/* ;
   fi
  else
   apt-get clean
   apt-get autoremove
  fi
 fi
 if [ "$GRUB" = "true" ] ; then
  /usr/local/bin/grub-repair-antix
  fi
fi

