FROM httpd:alpine

RUN apk update
RUN apk add curl perl

RUN echo "flag:CCHQ#shell_scripts_have_been_sucking_f0r_t00_long#:1004:1004::/tmp/:/bin/cat" >> /etc/passwd 

RUN sed -i -e 's:#LoadModule cgid_module:LoadModule cgid_module:' /usr/local/apache2/conf/httpd.conf

ADD main.sh /usr/local/apache2/cgi-bin
ADD proxy_homepage.html /usr/local/apache2/cgi-bin

EXPOSE 80

