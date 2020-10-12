import os
import random
l=['0','1','2','3','4','5','6','7', '8','9','A','B','C','D','E','F']
l1=['00:03:93','00:05:02','00:0A:27','00:0A:95','00:0D:93','00:10:FA','00:11:24']
os.system("sudo protonvpn d")
os.system("sudo systemctl stop NetworkManager.service && sudo ip link set wlp0s20f3 down")
new=random.choice(l1)
i=0
while(i<3):
    #concantenate -
    end1=':'
    #chose 2 characters
    end1=end1+random.choice(l)+random.choice(l)
    new=new+end1
    i+=1
os.system("sudo ifconfig wlp0s20f3 hw ether " + new)
os.system("sudo systemctl start NetworkManager.service && sudo ip link set wlp0s20f3 up")
