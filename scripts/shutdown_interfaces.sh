sudo rfkill block bluetooth wifi
sudo systemctl disable NetworkManager.service
sudo systemctl stop NetworkManager.service
sudo systemctl disable bluetooth.service
sudo systemctl stop bluetooth.service
sudo /etc/init.d/network-manager stop
sudo /etc/init.d/networking stop
sudo /etc/init.d/bluetooth stop
