#!/bin/sh
set -e

if [ $# -ne 2 ]; then
	echo "Usage: $0 <Client name> <Root CA>"
	exit 1
fi

PASSWORD="password"
USERNAME="$1"
ROOT_FILENAME="$2"

# https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-certificates-point-to-site-linux
ipsec pki --gen --outform pem > "$USERNAME.key.pem"
ipsec pki --pub --in "$USERNAME.key.pem" | ipsec pki --issue --cacert "$ROOT_FILENAME.cacert.pem" --cakey "$ROOT_FILENAME.cakey.pem" --dn "CN=CloudERP $USERNAME" --san "$USERNAME" --flag clientAuth --outform pem > "$USERNAME.cert.pem"
openssl pkcs12 -in "$USERNAME.cert.pem" -inkey "$USERNAME.key.pem" -certfile "$ROOT_FILENAME.cacert.pem" -export -out "$USERNAME.p12" -password "pass:$PASSWORD"
