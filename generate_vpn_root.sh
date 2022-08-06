#!/bin/sh
set -e

if [ $# -ne 1 ]; then
	echo "Usage: $0 <CA Common Name>"
	exit 1
fi

CN="$1"

# https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-certificates-point-to-site-linux
ipsec pki --gen --outform pem > "$CA.cakey.pem"
ipsec pki --self --in "$CA.cakey.pem" --dn "CN=$CN" --ca --outform pem > "$CA.cacert.pem"
openssl x509 -in "$CA.cacert.pem" -outform der | base64 -w0 ; echo
