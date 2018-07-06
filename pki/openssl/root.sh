#!/bin/sh

source /etc/openssl/functions

###############################
# Some variables              #
###############################

root_passphrase=""
commonname=ROOT
source /etc/openssl/root.conf


###############################
# Let the magic happend       #
###############################


clean_out "Start providing the password"
get_password
clean_out
yes_no "Would you like to generate the ROOT CA ?"
clean_out
openssl genrsa -aes256 -passout pass:${root_passphrase} -out /etc/openssl/private/${commonname}.key.pem 4096
clean_out
openssl req -config /etc/openssl/openssl.conf -passin pass:${root_passphrase} -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email" -key /etc/openssl/private/${commonname}.key.pem -new -x509 -days 7300 -sha256 -extensions v3_ca -out /etc/openssl/certs/${commonname}.cert.pem
clean_out "Look file permissions"
chmod 400  /etc/openssl/private/${commonname}.key.pem
chmod 400  /etc/openssl/certs/${commonname}.cert.pem

clean_out "Generate the CRL "
openssl ca -config /etc/openssl/openssl.conf -gencrl -keyfile /etc/openssl/private/${commonname}.key.pem -cert /etc/openssl/certs/${commonname}.cert.pem -out /etc/openssl/crl/root.crl.pem
openssl crl -inform PEM -in /etc/openssl/crl/root.crl.pem -outform DER -out /etc/openssl/crl/root.crl

if [[ -r /etc/openssl/certs/${commonname}.cert.pem ]]
then
	gratz "ROOTCA"
else
	echo "KO - something was wrong ...."
fi

yes_no "Would you like to view ROOT certificate ?"

openssl x509 -noout -text -in /etc/openssl/certs/${commonname}.cert.pem

thanks
