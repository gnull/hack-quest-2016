FROM ubuntu

RUN apt-get update
RUN apt-get install -y nmap perl gcc build-essential

RUN mkdir /task/
ADD FLAG.random_string /task/
ADD moonlight.mp3 /task/
ADD main.pl /task/ 
ADD run.sh /task/

WORKDIR /task/
ENTRYPOINT /task/run.sh

