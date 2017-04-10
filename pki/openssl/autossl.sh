#/bin/sh

cd /etc/openssl
. functions

###############################
# Some checks                 #
###############################
headers
if [[ ! -d private ]];
then
        create_folders
else
        echo "OK - folder detected"
fi
if [ -r openssl.conf ]
then
        echo "OK - config file present"
else
        echo "KO - config file not available"
        ecit 100
fi
if [ -r certs/ca.cert.pem ]
then
        echo "OK - ROOT certificat already present."
        echo "ABORTING process..."
        echo "Please cleanup your old ROOT entity"
        exit 101
else
        echo "Start autoconfig of ROOT CA"
        sh root.sh
fi

