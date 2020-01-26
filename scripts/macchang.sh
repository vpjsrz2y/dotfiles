#!/bin/bash
/etc/init.d/network-manager stop
new=$(dd if=/dev/random bs=2 count=3 2>/dev/null | perl -e '$hex = <>; $hex = unpack("H*", $hex) ; $hex =~ s/(..)(?!.?$)/$1:/g; print "$hex\n";')
echo "$new"
ifconfig wlp2s0 hw ether $new
/etc/init.d/network-manager start
