sudo cp ~/ip_forward /proc/sys/net/ipv4/ip_forward
sudo cp ~/sysctl.conf /etc/
sudo iptables -F
sudo iptables -t nat -F
sudo iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
sudo iptables -t nat -A POSTROUTING -o wlan0 -j LOG --log-prefix masq
sudo iptables -A FORWARD -i wlan0 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i wlan0 -o eth0 -m state --state RELATED,ESTABLISHED -j LOG --log-prefix rel_est_for
sudo iptables -A FORWARD -i eth0 -o wlan0 -j ACCEPT
sudo iptables -A FORWARD -i eth0 -o wlan0 -j LOG --log-prefix eth0_wlan0_for
sudo route del -net 0.0.0.0 netmask 0.0.0.0 gw 10.0.0.1 dev eth0
sudo route add -net 192.168.2.0 netmask 255.255.255.0 gw 192.168.2.24 dev eth0
