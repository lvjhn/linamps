#!/bin/bash

source ./.linamps/lib/@all.sh 

include_all_config 

set -e

echo 

cecho bright_green --bold "# [CONTAINER] Generating SSL certificates for project..." 

sudo echo

CA_NAME=linamps 

CA_KEY=./.linamps/host-shared/ca/private/LINAMPS.key
CA_CRT=./.linamps/host-shared/ca/public/LINAMPS.crt
CSR_FILE=./config/certificates/ssl.csr
EXT_FILE=./config/certificates/ssl.v3.ext
KEY_FILE=./config/certificates/ssl.key
CRT_FILE=./config/certificates/ssl.crt
PASSPHRASE=password

COMMON_NAME="$CONTAINER_NAME"
ON_NAME="$CONTAINER_NAME"
C="PH"
ST="Arbitrary"
L="Arbitrary"
O="$CONTAINER_NAME"
DNS1="$CONTAINER_NAME"
DNS2="$CONTAINER_NAME.lan"
DNS3="*.$CONTAINER_NAME.lan"

cecho yellow "Creating key file..."
openssl req -new -nodes \
    -out "$CSR_FILE" \
    -newkey rsa:4096 \
    -keyout "$KEY_FILE" \
    -subj "/CN=$COMMON_NAME/C=$C/ST=$ST/L=$L/O=$O" 

cecho yellow "Creating SAN extension config file..."
cat > "$EXT_FILE" <<EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = $DNS1
DNS.2 = $DNS2
DNS.3 = $DNS3
EOF


cecho yellow "Signing the certificate."


openssl x509 \
    -req \
    -in "$CSR_FILE" \
    -CA "$CA_CRT" \
    -CAkey "$CA_KEY" \
    -CAcreateserial \
    -out "$CRT_FILE" \
    -days 730 \
    -sha256 \
    -extfile "$EXT_FILE"

echo


