tar -czf - ~/Documents/ | openssl enc -aes-256-cbc -salt -out ~/Documents.tar.gz.enc
cp ~/Documents.tar.gz.enc ~/Dropbox
