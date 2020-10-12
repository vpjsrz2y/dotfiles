#!/bin/bash

#remove cups
sudo apt-get remove cups* -y

#iptables rules
sudo iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
sudo iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
sudo iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
sudo iptables -t mangle -A PREROUTING -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
sudo iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
sudo iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,ACK FIN -j DROP
sudo iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,URG URG -j DROP
sudo iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,FIN FIN -j DROP
sudo iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,PSH PSH -j DROP
sudo iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL ALL -j DROP
sudo iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL NONE -j DROP
sudo iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL FIN,PSH,URG -j DROP
sudo iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,FIN,PSH,URG -j DROP
sudo iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP

#block outgoing SMTP mail
sudo iptables -A OUTPUT -p tcp --dport 25 -j REJECT

#block outgoing connections to facebook
whois -h v4.whois.cymru.com " -v $(host facebook.com | grep "has address" | cut -d " " -f4)" | tail -n1 | awk '{print $1}'
for i in $(whois -h whois.radb.net -- '-i origin AS32934' | grep "^route:" | cut -d ":" -f2 | sed -e 's/^[ \t]*//' | sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4 | cut -d ":" -f2 | sed 's/$/;/') ; do
  sudo iptables -A OUTPUT -s "$i" -j REJECT
done

#protect against port scanning
sudo iptables -N port-scanning
sudo iptables -A port-scanning -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s --limit-burst 2 -j RETURN
sudo iptables -A port-scanning -j DROP

#ssh bruteforce protection
sudo iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --set
sudo iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --update --seconds 60 --hitcount 10 -j DROP

#synflood protection
sudo iptables -N syn_flood
sudo iptables -A INPUT -p tcp --syn -j syn_flood
sudo iptables -A syn_flood -m limit --limit 1/s --limit-burst 3 -j RETURN
sudo iptables -A syn_flood -j DROP
sudo iptables -A INPUT -p icmp -m limit --limit  1/s --limit-burst 1 -j ACCEPT
sudo iptables -A INPUT -p icmp -m limit --limit 1/s --limit-burst 1 -j LOG --log-prefix PING-DROP:
sudo iptables -A INPUT -p icmp -j DROP
sudo iptables -A OUTPUT -p icmp -j ACCEPT

#mitigating SYN floods with synproxy
sudo iptables -t raw -A PREROUTING -p tcp -m tcp --syn -j CT --notrack
sudo iptables -A INPUT -p tcp -m tcp -m conntrack --ctstate INVALID,UNTRACKED -j SYNPROXY --sack-perm --timestamp --wscale 7 --mss 1460
sudo iptables -A INPUT -m conntrack --ctstate INVALID -j DROP

##Block packets from private subnets
#_subnets=("224.0.0.0/3" "169.254.0.0/16" "172.16.0.0/12" "192.0.2.0/24" "192.168.0.0/16" "10.0.0.0/8" "0.0.0.0/8" "240.0.0.0/5")
#
#for _sub in "${_subnets[@]}" ; do
#  sudo iptables -t mangle -A PREROUTING -s "$_sub" -j DROP
#done
#sudo iptables -t mangle -A PREROUTING -s 127.0.0.0/8 ! -i lo -j DROP
#
#block uncommon MSS value
sudo iptables -t mangle -A PREROUTING -p tcp -m conntrack --ctstate NEW -m tcpmss ! --mss 536:65535 -j DROP

#drop all null packets
sudo iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP

#drop xmas packets
sudo iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP

#Block New Packets That Are Not SYN
sudo iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP

#install passphraseme
sudo apt-get install -y openvpn dialog python3-pip python3-setuptools
sudo pip3 install passphraseme

#install protonvpn
sudo pip3 install protonvpn-cli
#OpenVPN username: lJxWeohM1oFl-i3BocgphX-u
#OpenVPN password: DZCmmZDSV7XmOy86L8cen8px
sudo protonvpn init
sudo protonvpn c -r

#update system
sudo apt-get update -y
##declare variable
declare -a arrinstall=("terminator" "vim" "i3" "xss-lock" "lightdm" "firefox" "tmux" "git" "whois" "gedit" "psad" "tiger" "unhide" "clamav" "python3-venv" "hping3" "wireshark" "nmap")

declare -a arruninstall=("packagekit" "whoopsie" "gdm3" "gnome*" "xfce4*" "xfconf" "xfce4-utils" "xfwm4" "xfce4-session" "xfdesktop4" "exo-utils" "xfce4-panel" "xfce4-terminal"  "thunar" "compton" "gnome-screenshot" "gnome-screensaver" "vim-tiny" "scrot" "mousepad" "onboard" "gnome-themes-*" "atril*" "orage" "catfish*" "gnome-calculator" "speech-dispatcher" "hddtemp" "nano" "chromium*" "xfce4" "cups*" "bluez*" "obex-data-server" "libopenobex" "ufw")

#loop over all programs
for i in "${arrinstall[@]}"
do
    echo "$i"
    sudo apt-get install "$i" -y
done

for i in "${arruninstall[@]}"
do
    echo "$i"
    sudo apt-get remove --auto-remove "$i" -y
    sudo apt-get purge --auto-remove "$i" -y
    sudo apt-get autoremove
done

sudo apt-get autoremove
sudo apt-get -f install
sudo apt-get clean
sudo apt-get autoclean

#disable and stop services
sudo systemctl stop sendmail apport bluetooth
sudo systemctl disable sendmail apport bluetooth

sudo update-alternatives --install /usr/bin/x-session-manager x-session-manager /usr/bin/i3 60
sudo update-alternatives --config x-terminal-emulator

timedatectl set-timezone America/Los_Angeles

#install vim and its libraries
git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh

#create firefox profile
firefox -CreateProfile JoelUser
wget -P ~/.mozilla/firefox/*.JoelUser https://raw.githubusercontent.com/pyllyukko/user.js/master/user.js

#configure git
git config --global user.email "test1@test1.test1"
git config --global user.name "test1"
git config --global core.editor "vim"

#protections to run rkhuter, chkrootkit, psad, iptables
sudo cp ~/dotfiles/confs/rkhunter.sh /etc/cron.daily/
sudo cp ~/dotfiles/confs/chkrootkit.conf /etc
sudo cp ~/dotfiles/confs/00-default.link /etc/systemd/network
sudo cp ~/dotfiles/confs/rc.local /etc
sudo cp ~/dotfiles/confs/iptables.sh /etc/init.d/
sudo cp ~/dotfiles/confs/psad.conf /etc/psad/
sudo cp ~/dotfiles/confs/iptables.service /etc/systemd/system/
sudo cp ~/dotfiles/confs/hosts /etc/
sudo cp ~/dotfiles/confs/hostname /etc
sudo cp ~/dotfiles/confs/resolv.conf /usr/bin
sudo cp ~/dotfiles/confs/bootup.* /etc/systemd/system
sudo cp ~/dotfiles/confs/logrotate.conf /etc/
sudo cp ~/dotfiles/confs/grub /etc/default/grub
sudo cp ~/dotfiles/confs/logrotate /etc/cron.hourly/
sudo cp ~/dotfiles/confs/NetworkManager-inter.conf /var/lib/NetworkManager/NetworkManager-inter.conf

# enable services
sudo systemctl enable iptables.service
sudo systemctl enable bootup.service

# disable services
sudo /etc/init.d/postfix stop
sudo systemctl disable postfix.service

# update grub
sudo update-grub

#install signal
curl -s https://updates.signal.org/desktop/apt/keys.asc | sudo apt-key add -
echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" | sudo tee -a /etc/apt/sources.list.d/signal-xenial.list
sudo apt update && sudo apt install signal-desktop

#install torbrowser
cd ~/Desktop && wget https://www.torproject.org/dist/torbrowser/9.5/tor-browser-linux64-9.5_en-US.tar.xz
tar xf tor-browser-linux64-9.5_en-US.tar.xz

# configuration files for gpg and bash
cp ~/dotfiles/confs/gpg.conf ~/.gnupg
cp ~/dotfiles/confs/.bash_history ~/

# settings for gnome terminal
gsettings set org.gnome.Terminal.Legacy.Settings headerbar false

# set terminal colors
mkdir -p "$HOME/src"
cd "$HOME/src"
git clone https://github.com/Mayccoll/Gogh.git gogh
cd gogh/themes
export TERMINAL=gnome-terminal
./gruvbox-dark.sh

# remove linux modules
sudo rmmod btusb btrtl btbcm btintel bluetooth ecdh_generic
sudo rmmod joydev
sudo rmmod ip6table_filter ip6_tables
sudo rmmod uvcvideo

# configure clamav
# mkdir -m 0770 -p /var/lib/fangfrisch
# chgrp clamav /var/lib/fangfrisch
# cd /var/lib/fangfrisch
# python3 -m venv venv
# source venv/bin/activate
# pip install fangfrisch
# sudo -u clamav -- fangfrisch --conf /etc/fangfrisch.conf initdb

#clone scripts
cd /tmp && git clone https://github.com/ismailtasdelen/Anti-DDOS.git
cd /tmp && git clone https://github.com/Jsitech/JShielder.git
cd /tmp && git clone https://github.com/konstruktoid/hardening.git
cd /tmp && git clone https://github.com/CISOfy/lynis

#linux hardening script
cd /tmp/Anti-DDOS && sudo bash ./anti-ddos.sh
cd /tmp/JShielder && sudo ./jshielder.sh
cd /tmp/hardening && cd tests && sudo bats .
cd /tmp/lynis/
sudo chown -R 0:0 /tmp/lynis
./lynis audit system > tmp/lynis/audit.txt
