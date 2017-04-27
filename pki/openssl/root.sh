#!/bin/sh

cd /etc/openssl
. functions

###############################
# Some variables              #
###############################

root_passphrase=""
commonname=ROOT
. root.conf


###############################
# Let the magic happend       #
###############################


clean_out "Start providing the password"
get_password
clean_out
yes_no "Would you like to generate the ROOT CA ?"
clean_out
openssl genrsa -aes256 -passout pass:${root_passphrase} -out private/${commonname}.key.pem 4096
clean_out
openssl req -config openssl.conf -passin pass:${root_passphrase} -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email" -key private/${commonname}.key.pem -new -x509 -days 7300 -sha256 -extensions v3_ca -out certs/${commonname}.cert.pem
clean_out "Look file permissions"
chmod 400  private/${commonname}.key.pem
chmod 400  certs/${commonname}.cert.pem

if [[ -r certs/${commonname}.cert.pem ]]
then
	gratz "ROOTCA"
else
	echo "KO - something was wrong ...."
fi

yes_no "Would you like to view ROOT certificate ?"

openssl x509 -noout -text -in certs/${commonname}.cert.pem

thanks
