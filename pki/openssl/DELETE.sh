#!/bin/sh

cd /etc/openssl
source /etc/openssl/functions


###############################
# Let the magic happend       #
###############################

headers

clean_out "You are going to DELETE every certificates and keys ...."
yes_no "Are you sure to DELETE every everything" 
yes_no "Have you drink enough coffe today ? " 
no_yes "Is it friday or 17:58 ? " 
 

rm -rfv /etc/openssl/db/ /etc/openssl/crl/ /etc/openssl/certs/ /etc/openssl/private/ /etc/openssl/csr/ /etc/openssl/users/

thanks





