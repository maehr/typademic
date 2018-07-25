#!/bin/bash
if [ -f key.pem ] && [ -f crt.pem ]; then
    echo a key and a cert file already exists
else
    openssl req -new -newkey rsa:4096 -days 1825 -nodes -x509 \
    -subj "/C=CH/ST=Denial/L=Zurich/O=Dis/CN=www.example.com" \
    -keyout ./key.pem  -out ./crt.pem
fi
