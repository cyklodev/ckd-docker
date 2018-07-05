#!/bin/sh
########################################################################################################
#  https://www.jamescoyle.net/how-to/1073-bash-script-to-create-an-ssl-certificate-key-and-request-csr #
########################################################################################################


cd /etc/openssl
. /etc/openssl/functions
. /etc/openssl/root.conf

###############################
# Some variables              #
###############################

root_passphrase=""
SUSER=""

###############################
# Let the magic happend       #
###############################

headers

clean_out "Start providing the user name"
get_user_name
commonname=${SUSER}

clean_out "Start providing the user password"
get_password_user

clean_out
yes_no "Would you like to generate the Key for ${SUSER} with password  [ ${server_passphrase} ]?"
clean_out

openssl genrsa -des -out /etc/openssl/private/${commonname}.key.pem -passout pass:${server_passphrase} 4096

clean_out
yes_no "Would you like to ask for sigin for ${SUSER} ?"
clean_out

openssl req -config /etc/openssl/openssl.conf -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email" -new -passin pass:${server_passphrase} -key /etc/openssl/private/${commonname}.key.pem -out /etc/openssl/csr/${commonname}.csr

yes_no "Would you like to sign the Crt for ${SUSER} ?"
clean_out

clean_out "Provide the ROOTCA password"
get_password
clean_out


openssl x509 -req -in csr/${commonname}.csr -passin pass:${root_passphrase} -CA /etc/openssl/certs/ROOT.cert.pem -CAkey /etc/openssl/private/ROOT.key.pem -CAcreateserial -out /etc/openssl/users/${commonname}.crt.pem -days 500 -sha256



yes_no "Would you like to test the Crt for ${SUSER} ?"
clean_out

openssl verify -CAfile /etc/openssl/certs/ROOT.cert.pem /etc/openssl/users/${commonname}.crt.pem


yes_no "Would you like to export the Crt for in P12 ${SUSER} ?"
clean_out

openssl pkcs12 -export -inkey /etc/openssl/private/${commonname}.key.pem  -in /etc/openssl/users/${commonname}.crt.pem -name ${commonname} -out /etc/openssl/users/${commonname}.pfx

if [[ $? -eq 0 ]]
then
        gratz "${commonname}" 
else
        echo "KO - something was wrong ...."
fi

thanks





