#ckd-alpine
FROM cyklodev/alpine
MAINTAINER Cyklodev <support@cyklodev.com>

ADD pimpage/alias.sh /etc/profile.d/alias.sh
ADD openssl /etc/openssl
RUN /etc/profile.d/alias.sh 
RUN apk update
RUN apk add openssl


