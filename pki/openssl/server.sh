#!/bin/sh
########################################################################################################
#  https://www.jamescoyle.net/how-to/1073-bash-script-to-create-an-ssl-certificate-key-and-request-csr #
########################################################################################################


cd /etc/openssl
. functions
. root.conf

###############################
# Some variables              #
###############################

root_passphrase=""
SSERVER=""

###############################
# Let the magic happend       #
###############################

headers

clean_out "Start providing the server name"
get_server_name
commonname=${SSERVER}

clean_out "Start providing the server password"
get_password_server

clean_out
yes_no "Would you like to generate the Key for ${SSERVER} with password  [ ${server_passphrase} ]?"
clean_out

openssl genrsa -des -out private/${commonname}.key.pem -passout pass:${server_passphrase} 4096

clean_out
yes_no "Would you like to ask for sigin for ${SSERVER} ?"
clean_out

openssl req -config openssl.conf -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email" -new -passin pass:${server_passphrase} -key private/${commonname}.key.pem -out csr/${commonname}.csr

yes_no "Would you like to sign the Crt for ${SSERVER} ?"
clean_out

clean_out "Provide the ROOTCA password"
get_password
clean_out


openssl x509 -req -in csr/${commonname}.csr -passin pass:${root_passphrase} -CA certs/ROOT.cert.pem -CAkey private/ROOT.key.pem -CAcreateserial -out certs/${commonname}.crt.pem -days 500 -sha256



yes_no "Would you like to test the Crt for ${SSERVER} ?"
clean_out

openssl verify -CAfile certs/ROOT.cert.pem certs/${commonname}.crt.pem
if [[ $? -eq 0 ]]
then
        gratz "${commonname}" 
else
        echo "KO - something was wrong ...."
fi


thanks





