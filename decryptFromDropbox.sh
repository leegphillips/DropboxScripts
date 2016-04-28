rm -rf ~/tmp/*
cp ~/Dropbox/Documents.tar.gz.enc ~/tmp/Documents.tar.gz.enc
openssl enc -d -aes-256-cbc -in ~/tmp/Documents.tar.gz.enc -out /tmp/Documents.tar.gz
tar -zxvf ~/Documents.tar.gz
