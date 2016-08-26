FROM ubuntu

RUN apt-get update
RUN apt-get install -y nmap perl gcc build-essential

RUN mkdir /task/
ADD input /task/
ADD main.pl /task/ 
ADD run.sh /task/

ADD http://rakudo.org/downloads/star/rakudo-star-2016.07.tar.gz /tmp/
RUN cd /tmp/ && tar xvf rakudo-star-2016.07.tar.gz
RUN cd /tmp/rakudo-star-2016.07/ && perl ./Configure.pl --prefix=/usr/ --gen-moar
RUN make -C /tmp/rakudo-star-2016.07/
RUN make -C /tmp/rakudo-star-2016.07/ install

WORKDIR /task/
ENTRYPOINT /task/run.sh
EXPOSE 1024

