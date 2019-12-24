sudo apt-get update
sudo apt-get install firefox
timedatectl set-timezone America/Los_Angeles 
sudo apt-get remove chromium-browser
sudo apt-get purge chromium-browser
sudo apt-get purge --auto-remove chromium-browser
sudo apt-get purge cups-daemon
sudo apt-get purge --auto-remove cups-daemon
sudo apt install i3 xss-lock lightdm
firefox -profile ~/.mozilla/firefox/default.Default
wget https://raw.githubusercontent.com/pyllyukko/user.js/master/user.js ~
firefox -profile ~/.mozilla/firefox/default.Default
