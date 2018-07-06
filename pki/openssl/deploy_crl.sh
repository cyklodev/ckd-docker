#!/bin/bash

source /etc/openssl/functions

headers

yes_no "Deploy CRL ?"


TESTNGINXCRL=`grep -r root.crl.pem /etc/nginx/ | awk -F ':' '{print $1}'`
ROOTCRLFILE=`grep -r root.crl.pem /etc/nginx/ | awk -F ':' '{print $2}' | awk -F 'ssl_crl' '{print $2}' | sed 's/;//'` 

clean_out "Test crl presence"
echo $TESTNGINXCRL
if [[ -f $TESTNGINXCRL ]]
then
	clean_out "File detect in NGINX ... start copying"
	cp -v crl/root.crl.pem $ROOTCRLFILE
else
	clean_out "No crl file detected" 
	exit 
fi


yes_no "Restart the service"
nginx -c /etc/nginx/nginx.conf -t && systemctl reload nginx && systemctl status nginx 

thanks 
