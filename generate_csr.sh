#! /bin/bash

if [ "$#" -ne 1 ];
then
  echo "This script generates a certificate CSR using OpenSSL"
  echo "usage: $0 <hostname>"
  exit 0
fi

generateSelfSignedCert()
{
  echo "Generating certs for $1"

  if [ -f "/etc/pki/tls/openssl.cnf" ];
  then
    OPENSSL_CONFIG="/etc/pki/tls/openssl.cnf"
  fi
  if [ -f "/System/Library/OpenSSL/openssl.cnf" ];
  then
    OPENSSL_CONFIG="/System/Library/OpenSSL/openssl.cnf"
  fi

  echo "Found: $OPENSSL_CONFIG"

  # call openssl and generate the cert request
  openssl req -new -newkey rsa:2048 -sha256 -days 365 -nodes \
    -keyout server.key -nodes -out server.csr -subj "/CN=$1/ST=Ontario/L=Toronto/O=TMX Group/OU=Infrastructure/emailAddress=unix_administrators@tmx.com" \
    -reqexts SAN -extensions SAN -config <(cat $OPENSSL_CONFIG \
    <(printf "\n[SAN]\nsubjectAltName=DNS:$1\n"))


  # compress the cert and key into a zip file
  echo "Compressing cert and key into: $1-certs.zip"
  zip "$1-cert_csr.zip" server.key server.csr && rm server.key server.csr
}


generateSelfSignedCert "$1"
