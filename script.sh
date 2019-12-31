## GPG
#generate full key along with public key
gpg --full-gen-key 
#import public key of recipient
gpg --import recipient.asc
#sign message with public key and generate signed message from mail.txt
gpg --armor --clearsign --default-key 0x9ASDFASDJF7BC299 mail.txt 
#encrypt message
gpg --encrypt --armor -r recipeient@test.com mail.txt.asc 
#decrypt message from recipient
gpg --decrypt mail.txt.asc.asc
