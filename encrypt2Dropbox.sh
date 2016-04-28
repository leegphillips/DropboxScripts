rm -rf ~/tmp/*
tar -zcvf ~/tmp/Documents.tar.gz -C ~ Documents
openssl enc -aes-256-cbc -salt -in ~/tmp/Documents.tar.gz -out ~/tmp/Documents.tar.gz.enc
cp ~/tmp/Documents.tar.gz.enc ~/Dropbox
