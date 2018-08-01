#!/bin/bash
# 2017 - Gordon Young : gjyoung1974@gmail.com

# Bash shell script for generating self-signed certs.
# Script accepts a single argument, the fqdn (DNS name) for the cert
# ./gencert.sh fleet.prod.example.com

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac

DOMAIN="$1"
FNAME="$2"
if [[ -z "$DOMAIN" || -z "$FNAME" ]]; then
  echo "Usage: $(basename $0) <domain> <friendly_name>"
  exit 11
fi

# write a file to load the x.509 Extentions
FILE="./xtns.cnf"

cat <<EOM >$FILE
[ v3_req ]
# Extensions to add to a certificate request
subjectKeyIdentifier = hash
basicConstraints = critical,CA:TRUE
keyUsage = digitalSignature, keyEncipherment, dataEncipherment, keyCertSign, cRLSign
extendedKeyUsage = serverAuth, clientAuth, anyExtendedKeyUsage
EOM

# For RSA set the validity period to the year 2030
# See the date table here for RSA modulus: https://www.keylength.com/en/4/

# Mac BSD and GNU date commands are different
if [ "${machine}" == "Mac" ]; then
    validity=$(expr '(' $(date -jf %m%d%Y 01012030 +%s) - $(date +%s) + 86399 ')' / 86400)
fi

# Linux BSD and GNU date commands are different
if [ "${machine}" == "Linux" ]; then
    validity=$(expr '(' $(date -d 2030/01/01 +%s) - $(date +%s) + 86399 ')' / 86400)
fi

# use a UUID as a passphrase
PASSPHRASE=$(uuidgen)
# echo "P12 Password is: " $PASSPHRASE
echo $PASSPHRASE > $FNAME.password

# Certificate details; replace items in angle brackets with your own info
subj="
O=ACME Evil Anvil Corporation
organizationalUnitName=ACME Security Operations Team
commonName=$DOMAIN
"

# Generate the server private key
openssl genrsa -aes256 -passout pass:$PASSPHRASE -out $FNAME.key 2048 > /dev/null 2> /dev/null
# openssl req -x509 -newkey rsa:2048 -keyout fleet.prod.example.com.key.pem -out fleet.prod.example.com.req.pem -days 4533

# Generate the CSR
openssl req \
    -new \
    -batch \
    -subj "$(echo -n "$subj" | tr "\n" "/")" \
    -key $FNAME.key \
    -passin pass:$PASSPHRASE \
    -out $FNAME.csr  \

cp $FNAME.key $FNAME.key.org

# Generate the cert (good for until 2030 years)
openssl x509 -req -sha512 -days $validity -in $FNAME.csr -extensions v3_req -extfile ./xtns.cnf -signkey $FNAME.key -passin pass:$PASSPHRASE -out $FNAME.pem > /dev/null 2> /dev/null

# Package as PCKS#12 and clean up
openssl pkcs12 -export -out $FNAME.p12 -passout pass:$PASSPHRASE -inkey $FNAME.key -passin pass:$PASSPHRASE -in $FNAME.pem -name $FNAME > /dev/null 2> /dev/null

# unrwap the RSA key
openssl rsa -in $FNAME.key -passin pass:$PASSPHRASE > $FNAME.rsa.key

# clean up
# rm $FNAME.key $FNAME.csr $FNAME.key.org $FNAME.password xtns.cnf
rm $FNAME.key rm $FNAME.csr $FNAME.key.org $FNAME.password xtns.cnf $FNAME.p12

# EOF

