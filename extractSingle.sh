openssl enc -d -aes-256-cbc -in Documents.tar.gz.enc | tar xvf - --strip-components 2 -C . Documents/invoices/Invoice1.xls
