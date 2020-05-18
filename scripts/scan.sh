ip="-e wlp2s0 192.168.1.110"

## Nmap Port Selection
# Scan a single Port
nmap -p 22 $ip
# Scan a range of ports
nmap -p 1-100 $ip
# Scan 100 most common ports (Fast)
nmap -F $ip
# Scan all 65535 ports
nmap -p- $ip

## Nmap Port Scan types
# Scan using TCP connect
nmap -sT $ip
# Scan using TCP SYN scan (default)
nmap -sS $ip
# Scan UDP ports
nmap -sU -p 123,161,162 $ip
# Scan selected ports - ignore discovery
nmap -Pn -F $ip

## Service and OS Detection
# Detect OS and Services
nmap -A $ip
# Standard service detection
nmap -sV $ip
# More aggressive Service Detection
nmap -sV --version-intensity 5 $ip
# Lighter banner grabbing detection
nmap -sV --version-intensity 0 $ip

## Nmap Output Formats
# Save default output to file
nmap -oN outputfile.txt $ip
# Save results as XML
nmap -oX outputfile.xml $ip
# Save results in a format for grep
nmap -oG outputfile.txt $ip
# Save in all formats
nmap -oA outputfile $ip

## Digging deeper with NSE Scripts
# Scan using default safe scripts
nmap -sV -sC $ip
# Get help for a script
nmap --script-help=ssl-heartbleed
# Scan using a specific NSE script
nmap -sV -p 443 –script=ssl-heartbleed.nse $ip
# Scan with a set of scripts
nmap -sV --script=smb* $ip

# Scan for UDP DDOS reflectors
nmap –sU –A –PN –n –pU:19,53,123,161 –script=ntp-monlist,dns-recursion,snmp-sysdescr $ip


nm="nmap -p- "

## Nmap Port Scan types
# Scan using TCP connect
$nm -sT $ip
# Scan using TCP SYN scan (default)
$nm -sS $ip
# Scan UDP ports
$nm -sU -p 123,161,162 $ip
# Scan selected ports - ignore discovery
$nm -Pn -F $ip

## Service and OS Detection
# Detect OS and Services
$nm -A $ip
# Standard service detection
$nm -sV $ip
# More aggressive Service Detection
$nm -sV --version-intensity 5 $ip
# Lighter banner grabbing detection
$nm -sV --version-intensity 0 $ip

## Nmap Output Formats
# Save default output to file
$nm -oN outputfile.txt $ip
# Save results as XML
$nm -oX outputfile.xml $ip
# Save results in a format for grep
$nm -oG outputfile.txt $ip
# Save in all formats
$nm -oA outputfile $ip

## Digging deeper with NSE Scripts
# Scan using default safe scripts
$nm -sV -sC $ip
# Get help for a script
$nm --script-help=ssl-heartbleed
# Scan using a specific NSE script
$nm -sV -p 443 –script=ssl-heartbleed.nse $ip
# Scan with a set of scripts
$nm -sV --script=smb* $ip

# Scan for UDP DDOS reflectors
nmap –sU –A –PN –n –pU:19,53,123,161 –script=ntp-monlist,dns-recursion,snmp-sysdescr $ip
