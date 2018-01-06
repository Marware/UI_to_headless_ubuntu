#!/bin/bash

USERNAME="YOUR_USERNAME"
PASSWORD="YOURPASSWORD"

lnver=`uname -r`
echo 'Acquire::ForceIPv4 "true";' | sudo tee /etc/apt/apt.conf.d/99force-ipv4
apt-add-repository -y ppa:eugenesan/ppa
wget -4 -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
apt update
apt -y dist-upgrade
apt install -y ubuntu-desktop htop gnome-session-flashback x11vnc linux-headers-$lnver #virtualbox 
apt install -y -f

#I like `gnome-session-flashback` you can replace it with your favorite

############# VNC ################
x11vnc -storepasswd "$PASSWORD" /etc/x11vnc.pass
cat >/etc/init/x11vnc.conf <<EOL
start on login-session-start

script

/usr/bin/x11vnc -xkb -forever -auth /var/run/lightdm/root/:0 -display :0 -rfbauth /etc/x11vnc.pass -rfbport 5900 -bg -o /var/log/x11vnc.log

end script
EOL
############# Teamviewer and Anydesk ###############
############# Login screen ##############
mkdir -p /etc/lightdm/lightdm.conf.d
cat >/etc/lightdm/lightdm.conf.d/50-ubuntu.conf <<EOL
[SeatDefaults]
greeter-show-manual-login=true
EOL
#########################################

############ New user ###################
useradd -m "$USERNAME"
usermod "$USERNAME" -G sudo
echo ' '$USERNAME' ALL=(ALL)   ALL' >> /etc/sudoers
#########################################

#VNC should be installed by now..if you want Anydesk and/or Teamviewer run these commands
exit 

wget -4 https://download.teamviewer.com/download/version_12x/teamviewer_i386.deb
wget -4 http://download.anydesk.com/linux/anydesk_2.5.0-1_amd64.deb

dpkg -i teamviewer_i386.deb
dpkg -i anydesk_2.5.0-1_amd64.deb
apt install -y -f
############# Login screen ##############
mkdir -p /etc/lightdm/lightdm.conf.d
cat >/etc/lightdm/lightdm.conf.d/50-ubuntu.conf <<EOL
[SeatDefaults]
greeter-show-manual-login=true
EOL
#########################################

echo ""
echo ""
echo " REBOOT "
