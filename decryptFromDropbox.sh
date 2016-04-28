cp ~/Dropbox/Documents.tar.gz.enc ~/Documents.tar.gz.enc
openssl enc -d -aes-256-cbc -in Documents.tar.gz.enc | tar -zxvf -
