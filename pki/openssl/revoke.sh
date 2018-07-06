#!/bin/sh

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

clean_out "Choose a certificate to revoke "

ls -1 /etc/openssl/*/*crt.pem

clean_out "Type certificate name to revoke"
get_cert_name
commonname=${SCERT}

if [[ -w ${SCERT} ]]
then
	yes_no "Are you sure to revoke definitively ${SCERT} ?"
else
	echo "Not writable"
	exit 100 
fi

openssl ca -config /etc/openssl/openssl.conf -revoke ${SCERT}
openssl ca -config /etc/openssl/openssl.conf -gencrl -out /etc/openssl/crl/root.crl.pem



if [[ $? -eq 0 ]]
then
        gratz " Cert revoked " 
	echo "!!! Keep in mind to deliver crl/root.crl.pem to all services and restart them" 
else
        echo "KO - something was wrong ...."
fi

yes_no "Would you like to refresh the CRL on webserver ? "
./deploy_crl.sh

thanks





