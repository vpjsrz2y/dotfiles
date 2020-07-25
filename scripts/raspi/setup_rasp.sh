mkdir ~/test
sudo mount /dev/mmcblk1p1 test
cd test
sodo touch ssh
sudo cp /etc/wpa_supplicant/wpa_supplicant.conf ~/test
sudo umount test

#install and configure raspberry pi
sudo apt update
sudo apt install realvnc-vnc-server realvnc-vnc-viewer
sudo apt-get install lxsession
sudo apt-get install firefox-esr
