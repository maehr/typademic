#!/bin/bash
if [ -f www.example.com.key ] && [ -f www.example.com.cert ]; then
    echo a key and a cert file already exists
else
    openssl req -new -newkey rsa:4096 -days 1825 -nodes -x509 \
    -subj "/C=CH/ST=Denial/L=Zurich/O=Dis/CN=www.example.com" \
    -keyout www.example.com.key  -out www.example.com.cert
fi
