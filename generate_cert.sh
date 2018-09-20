#! /bin/bash

if [ "$#" -ne 1 ];
then
  echo "This script generates self-signed certificates using OpenSSL"
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

  # call openssl and generate the self-signed cert
  openssl req -new -newkey rsa:2048 -sha256 -days 365 -nodes -x509 \
    -keyout server.key -out server.crt -subj "/CN=$1/ST=Ontario/L=Toronto/O=TMX Group/OU=Infrastructure/emailAddress=unix_administrators@tmx.com" \
    -reqexts SAN -extensions SAN -config <(cat $OPENSSL_CONFIG \
    <(printf "\n[SAN]\nsubjectAltName=DNS:$1\n"))


  # compress the cert and key into a zip file
  echo "Compressing cert and key into: $1-certs.zip"
  zip "$1-certs.zip" server.key server.crt && rm server.key server.crt
}


generateSelfSignedCert "$1"
