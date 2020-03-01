vi dotfiles/changes.sh 
passwd
sudo apt-get install git
git clone https://github.com/wAsabi-007/dotfiles.git
sudo iptables -L
reboot
man nmcli
service --status-all | less
sudo systemctl disable sendmail
sudo bash dotfiles/Anti-DDOS/anti-ddos.sh 
netstat -tulpn | grep "LISTEN"
sudo protonvpn c -r
sudo protonvpn d
sudo protonvpn status
sudo protonvpn configure
pactl -- set-sink-volume 0 +100%
sudo iwconfig wlp2s0 txpower on
sudo iwconfig wlp2s0 txpower off
xrandr --output eDP1 --set BACKLIGHT 0.1
xrandr --output eDP1 --brightness 0.1
firefox -P
nmcli device wifi list
nmcli device wifi rescan
nmcli device wifi connect "HD-Members" password hackerdojo
sudo du -sh / | sort -n -r | head -n 100
git rebase -i HEAD~3
git push origin master
