#!/bin/bash

source ./.linamps/lib/@all.sh 

include_all_config 

echo 

cecho bright_green --bold "# [CONTAINER] Generating CA files..." 

sudo echo

CA_NAME=LINAMPS
CA_DIR=/var/lib/ca


CA_KEY=$CA_DIR/private/$CA_NAME.key 
CA_CRT=$CA_DIR/public/$CA_NAME.crt 
CA_PEM=$CA_DIR/public/$CA_NAME.pem 
PASSPHRASE=password 

SITE_CERT=LINAMPS
COMMON_NAME=LINAMPS
C="PH"
ST="Arbitrary"
L="Arbitrary"
O="$CA_NAME"
OU="$CA_NAME"
CN="$CA_NAME"



CRT_FILE=/var/lib/project/.linamps/host-shared/ca/public/linamps.crt

if [ ! -f $CRT_FILE ]; then
    cecho yellow "Creating CA key (with passphrase)"

    rm -rf $CA_DIR 
    
    sudo mkdir -p $CA_DIR
    sudo mkdir -p $CA_DIR/private
    sudo mkdir -p $CA_DIR/public

    openssl genrsa -out "$CA_KEY" 4096

    cecho yellow "Creating CA certificate"
    openssl req \
        -x509 \
        -new \
        -key $CA_KEY \
        -sha256 \
        -days 10000 \
        -out "$CA_CRT" \
        -subj "/C=$C/ST=$ST/L=$L/O=$O/OU=$OU/CN=$CN" 

    openssl x509 \
        -in "$CA_CRT" \
        -out "$CA_PEM" \
        -outform PEM


else 
    cecho yellow "CA exists already, skipping."
fi
