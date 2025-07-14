#!/bin/bash

source ./.linamps/lib/@all.sh 

include_all_config 

echo 

cecho bright_green --bold "# [CONTAINER] Generating CA files..." 

sudo echo

CA_NAME=linamps 
CA_DIR=/tmp/ca/ 

sudo mkdir -p $CA_DIR
sudo mkdir -p $CA_DIR/private
sudo mkdir -p $CA_DIR/public

CA_KEY=$CA_DIR/private/$CA_NAME.key 
CA_CRT=$CA_DIR/public/$CA_NAME.crt 
PASSPHRASE=password 

SITE_CERT="$CONTAINER_NAME"
COMMON_NAME="$CONTAINER_NAME"
C="PH"
ST="Arbitrary"
L="Arbitrary"
O="$CA_NAME"
OU="$CA_NAME"
CN="$CA_NAME"

if [ ! -f $CA_KEY ]; then
    cecho yellow "Creating CA key (with passphrase)"
    openssl genrsa -passout pass:$PASSPHRASE -out "$CA_KEY" 4096

    cecho yellow "Creating CA certificate"
    openssl req \
        -x509 \
        -new \
        -key $CA_KEY \
        -sha256 \
        -days 10000 \
        -out "$CA_CRT" \
        -subj "/C=$C/ST=$ST/L=$L/O=$O/OU=$OU/CN=$CN" \
        -passin pass:$PASSPHRASE
else 
    cecho yellow "CA exists already, skipping."
fi
