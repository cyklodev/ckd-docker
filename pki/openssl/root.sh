#!/bin/sh

cd /etc/openssl
. functions

###############################
# Some variables              #
###############################

root_passphrase=""

###############################
# Let the magic happend       #
###############################


clean_out "Start providing the password"
get_password
clean_out
yes_no "Would you like to generate the ROOT CA ?"
clean_out
openssl genrsa -aes256 -passout pass:${root_passphrase} -out private/ca.key.pem 4096
clean_out
openssl req -config openssl.conf -passin pass:${root_passphrase} -key private/ca.key.pem -new -x509 -days 7300 -sha256 -extensions v3_ca -out certs/ca.cert.pem
clean_out "Look file permissions"
chmod 400  private/ca.key.pem
chmod 400  certs/ca.cert.pem

if [[ -r certs/ca.cert.pem ]]
then
	gratz
else
	echo "KO - something was wrong ...."
fi

yes_no "Would you like to view ROOT certificate ?"

openssl x509 -noout -text -in certs/ca.cert.pem

thanks
