#! /bin/sh
### BEGIN INIT INFO
# Provides:          iptables
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Applies Iptable Rules
# Description:
### END INIT INFO

iptables -F

#Defaults

iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

#Rules for PSAD

# iptables -A INPUT -j LOG
# iptables -A FORWARD -j LOG

# INPUT

# Aceptar loopback input
iptables -A INPUT -i lo -p all -j LOG --log-prefix "iptables: loop-back input"
iptables -A INPUT -i lo -p all -j ACCEPT

# Allow three-way Handshake
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j LOG --log-prefix "iptables: 3-way handshake"
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
# Stop Masked Attackes
iptables -A INPUT -p icmp --icmp-type 13 -j LOG --log-prefix "iptables: iptables: icmp-13"
iptables -A INPUT -p icmp --icmp-type 13 -j DROP
iptables -A INPUT -p icmp --icmp-type 17 -j LOG --log-prefix "iptables: icmp-17"
iptables -A INPUT -p icmp --icmp-type 17 -j DROP
iptables -A INPUT -p icmp --icmp-type 14 -j LOG --log-prefix "iptables: icmp-14"
iptables -A INPUT -p icmp --icmp-type 14 -j DROP
# iptables -A INPUT -p icmp -m limit --limit 1/second -j ACCEPT
iptables -A INPUT -p icmp --icmp-type 0 -j LOG --log-prefix "iptables: icmp-0"
iptables -A INPUT -p icmp --icmp-type 0 -j DROP
# iptables -A INPUT -p icmp -m limit --limit  1/s --limit-burst 1 -j ACCEPT
# iptables -A INPUT -p icmp -m limit --limit 1/s --limit-burst 1 -j LOG --log-prefix PING-DROP:
iptables -A INPUT -p icmp -j LOG --log-prefix "iptables: icmp-input"
iptables -A INPUT -p icmp -j DROP
iptables -A OUTPUT -p icmp -j LOG --log-prefix "iptables: icmp-output"
iptables -A OUTPUT -p icmp -j ACCEPT

# Discard invalid Packets
iptables -A INPUT -m state --state INVALID -j LOG --log-prefix "iptables: invalid-input-drop"
iptables -A INPUT -m state --state INVALID -j DROP
iptables -A FORWARD -m state --state INVALID -j LOG --log-prefix "iptables: invalid-forward-drop"
iptables -A FORWARD -m state --state INVALID -j DROP
iptables -A OUTPUT -m state --state INVALID -j LOG --log-prefix "iptables: invalid-output-drop"
iptables -A OUTPUT -m state --state INVALID -j DROP

### Drop Spoofing attacks
iptables -A INPUT -s 10.0.0.0/8 -j LOG --log-prefix "iptables: DROP 10.0.0.0/18"
iptables -A INPUT -s 10.0.0.0/8 -j DROP
iptables -A INPUT -s 169.254.0.0/16 -j LOG --log-prefix "iptables: DROP 169.254.0.0/16"
iptables -A INPUT -s 169.254.0.0/16 -j DROP
iptables -A INPUT -s 172.16.0.0/12 -j LOG --log-prefix "iptables: DROP 172.16.0.0/12"
iptables -A INPUT -s 172.16.0.0/12 -j DROP
iptables -A INPUT -s 127.0.0.0/8 -j LOG --log-prefix "iptables: DROP 127.0.0.0/8"
iptables -A INPUT -s 127.0.0.0/8 -j DROP
iptables -A INPUT -s 192.168.0.0/24 -j LOG --log-prefix "iptables: DROP 192.168.0.0/24"
iptables -A INPUT -s 192.168.0.0/24 -j DROP

iptables -A INPUT -s 224.0.0.0/4 -j LOG --log-prefix "iptables: DROP 224.0.0.0/4"
iptables -A INPUT -s 224.0.0.0/4 -j DROP
iptables -A INPUT -d 224.0.0.0/4 -j LOG --log-prefix "iptables: DROP 224.0.0.0/4"
iptables -A INPUT -d 224.0.0.0/4 -j DROP
iptables -A INPUT -s 240.0.0.0/5 -j LOG --log-prefix "iptables: DROP 240.0.0.0/5"
iptables -A INPUT -s 240.0.0.0/5 -j DROP
iptables -A INPUT -d 240.0.0.0/5 -j LOG --log-prefix "iptables: DROP 240.0.0.0/5"
iptables -A INPUT -d 240.0.0.0/5 -j DROP
iptables -A INPUT -s 0.0.0.0/8 -j DROP
iptables -A INPUT -d 0.0.0.0/8 -j LOG --log-prefix "iptables: DROP 0.0.0.0/5"
iptables -A INPUT -d 0.0.0.0/8 -j DROP
iptables -A INPUT -d 239.255.255.0/24 -j LOG --log-prefix "iptables: DROP 239.255.255.0/24"
iptables -A INPUT -d 239.255.255.0/24 -j DROP
iptables -A INPUT -d 255.255.255.255 -j LOG --log-prefix "iptables: DROP 255.255.255.255"
iptables -A INPUT -d 255.255.255.255 -j DROP

# Drop packets with excessive RST to avoid Masked attacks

iptables -A INPUT -p tcp -m tcp --tcp-flags RST RST -m limit --limit 2/second --limit-burst 2 -j LOG --log-prefix "iptables: RST-stop"
iptables -A INPUT -p tcp -m tcp --tcp-flags RST RST -m limit --limit 2/second --limit-burst 2 -j ACCEPT

# Any IP that performs a PortScan will be blocked for 24 hours
iptables -A INPUT   -m recent --name portscan --rcheck --seconds 86400 -j LOG --log-prefix "iptables: stop portscan input"
iptables -A INPUT   -m recent --name portscan --rcheck --seconds 86400 -j DROP
iptables -A FORWARD -m recent --name portscan --rcheck --seconds 86400 -j LOG --log-prefix "iptables: stop portscan forward"
iptables -A FORWARD -m recent --name portscan --rcheck --seconds 86400 -j DROP

# After 24 hours remove IP from block list
iptables -A INPUT   -m recent --name portscan --remove
iptables -A FORWARD -m recent --name portscan --remove

# This rule logs the port scan attempt
iptables -A INPUT   -p tcp -m tcp --dport 139 -m recent --name portscan --set -j LOG --log-prefix "iptables: Portscan:"
iptables -A INPUT   -p tcp -m tcp --dport 139 -m recent --name portscan --set -j DROP
iptables -A FORWARD -p tcp -m tcp --dport 139 -m recent --name portscan --set -j LOG --log-prefix "iptables: Portscan:"
iptables -A FORWARD -p tcp -m tcp --dport 139 -m recent --name portscan --set -j DROP

# Inbound Rules

# smtp
iptables -A INPUT -p tcp -m tcp --dport 25 -j LOG --log-prefix "iptables: DROP smtp"
iptables -A INPUT -p tcp -m tcp --dport 25 -j DROP
# http
iptables -A INPUT -p tcp -m tcp --dport 80 -j LOG --log-preix "ACCEPT http"
iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
# https
iptables -A INPUT -p tcp -m tcp --dport 443 -j LOG --log-prefix "iptables: ACCEPT https"
iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
# ssh & sftp
iptables -A INPUT -p tcp -m tcp --dport 372 -j LOG --log-prefix "iptables: DROP ssh and sftp"
iptables -A INPUT -p tcp -m tcp --dport 372 -j DROP



# Limit SSH connection from a single IP
iptables -A INPUT -p tcp --syn --dport 372 -m connlimit --connlimit-above 2 -j LOG --log-prefix "iptables: limit ssh"
iptables -A INPUT -p tcp --syn --dport 372 -m connlimit --connlimit-above 2 -j REJECT

#iptables rules
iptables -A INPUT -m conntrack --ctstate INVALID -j LOG --log-prefix "iptables: conntract_INVALID"
iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j LOG --log-prefix "iptables: pre_fin_syn_rst_psh_ack_urg_none"
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN FIN,SYN -j LOG --log-prefix "iptables: pre_fin_syn_fin_syn"
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags SYN,RST SYN,RST -j LOG --log-prefix "iptables: pre_syn_rst_syn_rst"
iptables -t mangle -A PREROUTING -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,RST FIN,RST -j LOG --log-prefix "iptables: pre_fin_rst_fin_rst"
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,ACK FIN -j LOG --log-prefix "iptables: pre_fin_ack_fin"
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,ACK FIN -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,URG URG -j LOG --log-prefix "iptables: pre_ack_urg_urg"
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,URG URG -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,FIN FIN -j LOG --log-prefix "iptables: pre_ack_fin_fin"
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,FIN FIN -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,PSH PSH -j LOG --log-prefix "iptables: pre_ack_psh_psh"
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,PSH PSH -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL ALL -j LOG --log-prefix "iptables: pre_all_all"
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL ALL -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL NONE -j LOG --log-prefix "iptables: pre_all_none"
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL NONE -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL FIN,PSH,URG -j LOG --log-prefix "iptables: pre_all_fin_psh_urg"
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL FIN,PSH,URG -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,FIN,PSH,URG -j LOG --log-prefix "iptables: pre_all_syn_fin_psh_urg"
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,FIN,PSH,URG -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP -j LOG --log-prefix "iptables: pre_syn_rst_ack_fin_urg"
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP

#block outgoing SMTP mail
iptables -A OUTPUT -p tcp --dport 25 -j REJECT -j LOG --log-prefix "iptables: output_tcp_reject"

iptables -A OUTPUT -p tcp --dport 25 -j REJECT

# #block outgoing connections to facebook
# whois -h v4.whois.cymru.com " -v $(host facebook.com | grep "has address" | cut -d " " -f4)" | tail -n1 | awk '{print $1}'
# for i in $(whois -h whois.radb.net -- '-i origin AS32934' | grep "^route:" | cut -d ":" -f2 | sed -e 's/^[ \t]*//' | sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4 | cut -d ":" -f2 | sed 's/$/;/') ; do
#   sudo iptables -A OUTPUT -s "$i" -j REJECT
# done
#
#protect against port scanning
iptables -N port-scanning
iptables -A port-scanning -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s --limit-burst 2 -j RETURN -j LOG --log-prefix "iptables: port-scanning_syn_ack_fin_rst_rst"
iptables -A port-scanning -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s --limit-burst 2 -j RETURN
iptables -A port-scanning -j DROP -j LOG --log-prefix "iptables: port-scanning_drop"
iptables -A port-scanning -j DROP

#ssh bruteforce protection
iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --set -j LOG --log-prefix "iptables: input_conntrack"
iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --set
iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --update --seconds 60 --hitcount 10 -j DROP

#synflood protection
iptables -N syn_flood
iptables -A INPUT -p tcp --syn -j syn_flood -j LOG --log-prefix "iptables: input_tcp"
iptables -A INPUT -p tcp --syn -j syn_flood
iptables -A syn_flood -m limit --limit 1/s --limit-burst 3 -j RETURN -j LOG --log-prefix "iptables: syn_flood_limit_burst"
iptables -A syn_flood -m limit --limit 1/s --limit-burst 3 -j RETURN
iptables -A syn_flood -j DROP -j LOG --log-prefix "iptables: syn_flood_drop"
iptables -A syn_flood -j DROP

#mitigating SYN floods with synproxy
iptables -t raw -A PREROUTING -p tcp -m tcp --syn -j CT --notrack
iptables -A INPUT -p tcp -m tcp -m conntrack --ctstate INVALID,UNTRACKED -j SYNPROXY --sack-perm --timestamp --wscale 7 --mss 1460
iptables -A INPUT -m conntrack --ctstate INVALID -j DROP

##Block packets from private subnets
#_subnets=("224.0.0.0/3" "169.254.0.0/16" "172.16.0.0/12" "192.0.2.0/24" "192.168.0.0/16" "10.0.0.0/8" "0.0.0.0/8" "240.0.0.0/5")
#
#for _sub in "${_subnets[@]}" ; do
#  sudo iptables -t mangle -A PREROUTING -s "$_sub" -j DROP
#done
#sudo iptables -t mangle -A PREROUTING -s 127.0.0.0/8 ! -i lo -j DROP
#
#block uncommon MSS value
iptables -t mangle -A PREROUTING -p tcp -m conntrack --ctstate NEW -m tcpmss ! --mss 536:65535 -j DROP

#drop all null packets
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP

#drop xmas packets
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP

#Block New Packets That Are Not SYN
iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP
iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP

#Block connection to BSSID
iptables -A INPUT -m mac --mac-source 66:23:AE:2D:F6:83 -j DROP

#whitelist ips
iptables -A INPUT -s 89.39.107.190 -j ACCEPT

#blacklist ips
iptables -A INPUT -s 192.168.1.98 -j DROP
iptables -A INPUT -s 192.168.1.227 -j DROP
iptables -A INPUT -s 192.168.1.142 -j DROP
