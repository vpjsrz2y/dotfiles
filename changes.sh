#remove cups
sudo apt-get remove cups*

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

#save rules
sudo netfilter-persistent save

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
sudo apt-get install i3 xss-lock lightdm firefox tmux git netfilter-persistent whois gedit -y
timedatectl set-timezone America/Los_Angeles
sudo apt-get remove speech-dispatcher hddtemp nano chromium* xfce4 cups* bluez* obex-data-server libopenobex -y
sudo apt-get purge speech-dispatcher hddtemp nano chromium* xfce4 cups* bluez* obex-data-server libopenobex -y
sudo apt-get purge --auto-remove speech-dispatcher hddtemp nano chromium* xfce4 cups* bluez* obex-data-server libopenobex -y

#create firefox profile
firefox -CreateProfile JoelUser
wget -P ~/.mozilla/firefox/*.JoelUser https://raw.githubusercontent.com/pyllyukko/user.js/master/user.js

#configure git
git config --global user.email "test1@test1.test1"
git config --global user.name "test1"
git config --global core.editor "vi"

sudo cp ~/dotfiles/rkhunter.sh /etc/cron.daily/
sudo cp ~/dotfiles/chkrootkit.conf /etc
sudo service apport stop
#sudo service bluetooth stop
sudo /etc/init.d/sendmail stop
sudo cp ~/dotfiles/00-default.link /etc/systemd/network

#install signal
curl -s https://updates.signal.org/desktop/apt/keys.asc | sudo apt-key add -
echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" | sudo tee -a /etc/apt/sources.list.d/signal-xenial.list
sudo apt update && sudo apt install signal-desktop

#Linux hardening script
cd /tmp && git clone https://github.com/Jsitech/JShielder.git
cd /tmp/JShielder && sudo ./jshielder.sh 

#linux hardening script
cd /tmp && git clone https://github.com/ismailtasdelen/Anti-DDOS.git
cd /tmp/Anti-DDOS && bash ./anti-ddos.sh 

#linux hardening script
cd /tmp && git clone https://github.com/konstruktoid/hardening.git
cd /tmp/hardening && cd tests && sudo bats .

#audit linux system
cd /tmp && git clone https://github.com/CISOfy/lynis
cd /tmp/lynis/
sudo chown -R 0:0 /tmp/lynis
./lynis audit system > /tmp/lynis/audit.txt

#save rules
sudo netfilter-persistent save
