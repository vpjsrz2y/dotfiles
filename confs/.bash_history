./start-tor-browser.desktop 
airdump-ng wlan0mon
airmon-ng check kill
airmon-ng start wlan0
bash ddos.sh 
cat /etc/resolv.conf 
cd .mozilla/firefox/
cd ~/Desktop/tor-browser_en-US/
cp \*.JoelUser/user.js k215v2x0.Default\ User/
find . -type f -name ".*log.*"
firefox &
firefox -P
git clone -b new https://github.com/Balzarine/dotfiles.git
git clone -b new https://github.com/Balzarine/dotfiles.git
git commit
git log -p
git push origin master
git rebase -i HEAD~3
ls -alhS
man nmcli
netstat -tulpn | grep "LISTEN"
nmcli device wifi connect "HD-Members" password hackerdojo
nmcli device wifi connect "SAFEWAY_FREE_WIFI"
nmcli device wifi connect "xfinitywifi"
nmcli device wifi list
nmcli device wifi rescan
pactl -- set-sink-volume 0 +100%
passwd
ping google.com
reboot
service --status-all | less
sudo apt-get install git
sudo bash dotfiles/Anti-DDOS/anti-ddos.sh 
sudo du -sh / | sort -n -r | head -n 100
sudo grep -rnw . -e 'iptables'
sudo ip link set wlp2s0 down
sudo ip link set wlp2s0 up
sudo iptables -L
sudo iwconfig wlp2s0 txpower off
sudo iwconfig wlp2s0 txpower on
sudo protonvpn c -r
sudo protonvpn configure
sudo protonvpn d
sudo protonvpn init
sudo protonvpn status
sudo psad -S | less
sudo reboot
sudo rfkill block bluetooth
sudo systemctl disable sendmail
sudo systemctl restart iptables.service 
sudo systemctl restart iptables.service && sudo systemctl restart psad.service && sudo systemctl restart procps.service
sudo ip link set wlp2s0 up && sudo systemctl restart NetworkManager.service
sudo systemctl restart NetworkManager.service 
sudo systemctl restart psad.service 
sudo wireshark
sudo zgrep -rnw . -e 'iptables' > ~/ztest.txt
systemctl --type=service --state=active
systemctl is-enabled iptables.service 
systemctl list-unit-files 
tmux
vi dotfiles/changes.sh 
xrandr --output eDP1 --brightness 0.2
sudo cp ~/dotfiles/confs/resolv.conf /etc/
cd ~/Desktop/tor-browser_en-US/ && ./start-tor-browser.desktop
cd ~/Desktop && git clone https://github.com/1tayH/noisy.git
cd ~/Desktop/noisy && python3 noisy.py --config config.json
openssl rand -base64 10
