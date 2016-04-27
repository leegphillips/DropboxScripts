tar -zcvf Documents.tar.gz ~/Documents
openssl enc -aes-256-cbc -salt -in Documents.tar.gz -out Documents.tar.gz.enc
cp Documents.tar.gz.enc ~/Dropbox
