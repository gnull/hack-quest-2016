FROM ubuntu

RUN apt-get update
RUN apt-get install -y ghc nmap

RUN mkdir /task/
ADD main.hs /task/ 
ADD run.sh /task/

RUN cd /task/ && ghc main.hs

WORKDIR /task/
ENTRYPOINT /task/run.sh
EXPOSE 1025

