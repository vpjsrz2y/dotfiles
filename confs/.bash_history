./start-tor-browser.desktop 
TZ=UTC gpg --no-options --keyid-format long --verify tails-amd64-4.18.img.sig tails-amd64-4.18.img 
airdump-ng wlan0mon
airmon-ng check kill
airmon-ng start wlan0
aria2c -x 16 https://cdimage.kali.org/kali-2020.3/kali-linux-2020.3-live-amd64.iso
bash ddos.sh 
cat /etc/resolv.conf 
cat /proc/sys/kernel/random/entropy_avail 
cd .mozilla/firefox/
cd ~/Desktop && git clone https://github.com/1tayH/noisy.git
cd ~/Desktop/noisy && python3 noisy.py --config config.json
cd ~/Desktop/tor-browser_en-US/ && ./start-tor-browser.desktop
cd ~/dotfiles/scripts/ && sudo python3 macchang.py &&  sudo ip link set wlp2s0 up && sudo systemctl restart NetworkManager.service && sudo cp ~/dotfiles/confs/resolv.conf /etc/ && sleep 15s && nmcli device wifi connect "xxxxxx" password "xxxxxxxx" && sleep 15s && sudo cp ~/dotfiles/confs/resolv.conf /etc/ && sudo protonvpn c -r && sleep 15s && sudo systemctl start iptables.service && sleep 10s && sudo systemctl restart procps.service 
cd ~/dotfiles/scripts/ && sudo python3 macchang.py && sudo ip link set wlp2s0 up && sudo systemctl restart NetworkManager.service && sudo cp ~/dotfiles/confs/resolv.conf /etc/
cp \*.JoelUser/user.js k215v2x0.Default\ User/
display -resize 50% -monochrome thing.jpg
du -a / | sort -n -r | head -n 10
echo "obase=10; ibase=16; $hexNum" | bc
exiftool -all= thing.jpg 
find . -type f -name ".*log.*"
firefox &
firefox -P
git checkout HEAD -- scripts/macchang.py
git clone -b new https://github.com/Balzarine/dotfiles.git
git clone -b new https://github.com/Balzarine/dotfiles.git
git commit
git diff --cached
git diff new origin/new
git log -p
git push origin master
git rebase -i HEAD~5
gpg --import tails-signing.key 
gpg --verify tails-amd64-4.8.img.sig tails-amd64-4.8.img
gunzip syslog.7.gz 
hexNum=02900000
ip route | grep default | awk '{print $3}'
ls -alhS
lsmod | less
man nmcli
netstat -tulpn | grep "LISTEN"
nmcli device wifi connect "HD-Members" password hackerdojo
nmcli device wifi connect "Jacks_Guest"
nmcli device wifi connect "PEETS"
nmcli device wifi connect "SAFEWAY_FREE_WIFI"
nmcli device wifi connect "Starbucks WiFi"
nmcli device wifi connect "Taco Bell WiFi"
nmcli device wifi connect "xfinitywifi"
nmcli device wifi list | grep "xfinitywifi"
nmcli device wifi rescan && nmcli device wifi list
openssl rand -base64 10
pactl -- set-sink-volume 0 +100%
passwd
ping -I enx3c8cf8ea198a google.com
ping google.com
reboot
rmmod bluetooth
scp pi@192.168.2.24:/home/pi/ip_forward.sh .
service --status-all | less
shuf -i 1-30 -n1
ssh pi@192.168.2.24
ssh-keygen -f "/home/discuss/.ssh/known_hosts" -R "192.168.1.221"
sudo apt-get install git
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 241FE6973B765FAE
sudo aria2c -x 10 https://downloads.ipfire.org/releases/ipfire-2.x/2.25-core147/ipfire-2.25.2gb-ext4.x86_64-full-core147.img.xz
sudo bash dotfiles/Anti-DDOS/anti-ddos.sh 
sudo cp ip_forward /proc/sys/net/ipv4/ip_forward
sudo cp ~/dotfiles/confs/resolv.conf /etc/
sudo cp ~/dotfiles/confs/resolv.conf /etc/ && sudo protonvpn c -r && sudo cp ~/dotfiles/confs/resolv.conf /etc/
sudo dd if=kali-linux-2020.3-live-amd64.iso of=/dev/sda bs=1M status=progress && sync
sudo du -sh / | sort -n -r | head -n 100
sudo find / -printf '%s %p\n' | sort -nr | head -10
sudo grep -rnw . -e 'iptables'
sudo hexdump -C /dev/loop0 | grep LUKS
sudo ip addr add 192.168.2.25/24 dev enx3c8cf8ea198a
sudo ip link set enx3c8cf8ea198a up
sudo ip link set wlp2s0 down
sudo ip link set wlp2s0 up
sudo iptables -L
sudo iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -j MASQUERADE
sudo iw dev wlp2s0 interface add wlan0_sta type managed addr 00:11:24:DE:F5:F8
sudo iwconfig wlp2s0 txpower off
sudo iwconfig wlp2s0 txpower on
sudo ln -s /lib/systemd/system/ssh.service /etc/systemd/system/sshd.service
sudo losetup -fP test_loop 
sudo protonvpn configure
sudo protonvpn d
sudo protonvpn d && sudo ip link set wlp2s0 down
sudo protonvpn init
sudo protonvpn status
sudo psad -S | less
sudo reboot
sudo rfkill block bluetooth
sudo route add -net 0.0.0.0 netmask 255.255.255.0 gw 192.168.2.254 dev enx3c8cf8ea198a 
sudo route add default gw 192.168.2.24 enx3c8cf8ea198a
sudo route del -net 0.0.0.0 netmask 255.255.255.0 gw 192.168.2.254 dev enx3c8cf8ea198a 
sudo systemctl disable sendmail
sudo systemctl restart NetworkManager.service 
sudo systemctl restart iptables.service 
sudo systemctl restart iptables.service && sudo systemctl restart psad.service && sudo systemctl restart procps.service
sudo systemctl restart psad.service 
sudo tcpdump -i enx3c8cf8ea198a icmp | grep "reply"
sudo unxz ipfire-2.25.2gb-ext4.x86_64-full-core147.img.xz 
sudo wireshark
sudo zgrep -rnw . -e 'iptables' > ~/ztest.txt
systemctl --type=service --state=active
systemctl is-enabled iptables.service 
systemctl list-unit-files 
tmux
vi dotfiles/changes.sh 
xrandr --output eDP1 --brightness 0.2
