#/bin/sh

source /etc/openssl/functions

###############################
# Some checks                 #
###############################
headers
if [[ ! -d /etc/openssl/private ]];
then
        create_folders
else
        echo "OK - folder detected"
fi
if [ -r /etc/openssl/root.conf ]
then
        echo "OK - ROOT config file present"
else
        echo "KO - ROOT config file not available"
        exit 100
fi

if [ -r /etc/openssl/openssl.conf ]
then
        echo "OK - OpenSSL config file present"
else
        echo "KO - OpenSSL config file not available"
        exit 100
fi
if [ -r /etc/openssl/certs/ROOT.cert.pem ]
then
        echo "OK - ROOT certificat already present."
        echo "ABORTING process..."
        echo "Please cleanup your old ROOT entity (or NOT !!! )"
        exit 101
else
        echo "Start autoconfig of ROOT CA"
        sh /etc/openssl/root.sh
fi

