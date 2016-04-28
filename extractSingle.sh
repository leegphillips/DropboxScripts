openssl enc -d -aes-256-cbc -in Documents.tar.gz.enc | tar xvf - -C . Documents/invoices/Invoice1.xls
