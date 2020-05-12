sudo cat network.sh >> /etc/NetworkManager/NetworkManager.conf
sudo service network-manager stop
sudo service network-manager disable
sudo ip link set wlan0 down
sudo macchanger -r wlan0
sudo ip link set wlan0 up
sudo service network-manager enable
sudo service network-manager start
