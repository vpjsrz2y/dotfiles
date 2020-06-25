# https://hackernoon.com/cracking-linux-full-disc-encryption-luks-with-hashcat-832d5543101f
dd if=/dev/urandom of=test bs=1M count=100
cryptsetup luksFormat test  #use password password
cryptsetup luksOpen test tmp
xxd -l 512 /dev/mapper/tmp # is random data at this point
mkfs.ext4 /dev/mapper/tmp  # use the same file system that is used by your system/device
xxd -l 512 /dev/mapper/tmp # should no longer be random data
cryptsetup luksClose tmp
cryptsetup luksDump test | grep "Payload offset" # add 1 to the offset value that comes back
dd if=test of=luks-header bs=512 count=4097 # grabs header
echo "password" >>list
hashcat -m 14600 -a 0 -w 3 luks-header list -o found
