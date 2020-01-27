https://github.com/drduh/YubiKey-Guide#master-key

## GPG
#generate full key along with public key, https://github.com/drduh/YubiKey-Guide#master-key
gpg --full-gen-key
#export keyid to $KEYID
export KEYID=0xFF3E7D88647EBCDB
#create subkeys, https://github.com/drduh/YubiKey-Guide#sub-keys
gpg --expert --edit-key $KEYID

#transfer key to card, https://github.com/drduh/YubiKey-Guide#transfer-keys
$ gpg --edit-key $KEYID
$ gpg> key 1
$ gpg> keytocard # select Signature key, enter the correspoinding passphrase and the admin key to yubikey. Transfer to yubikey
$ gpg> key 1 # to toggle selection of main key
$ gpg> key 2
$ gpg> keytocard # select Encryption key, enter the corresponding passphrae and the admin key to yubikey. Transfer to yubikey
#check pgp key has been correctly written to yubikey
gpg --card-status
#trasnfer public key to a file
gpg --armor --export $KEYID > /mnt/public-usb-key/pubkey.txt
#to use on a different machine, import
gpg --import < /mnt/public-usb-key/pubkey.txt
#trust masterkey
gpg --edit-key $KEYID
#import public key of recipient
gpg --import recipient.asc
#sign message with public key and generate signed message from mail.txt
gpg --armor --clearsign --default-key 0x9ASDFASDJF7BC299 mail.txt
#verify signature
gpg --verify mail.txt.asc
#encrypt message
gpg --encrypt --armor -r recipeient@test.com mail.txt.asc
#decrypt message from recipient
gpg --decrypt mail.txt.asc.asc


## connect to wifi using nmcli
#connect to wifi
nmcli device wifi rescan
#connect to different accesspoint
nmclie device wifi connect HD-Members password hackerdojo
