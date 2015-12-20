FROM ubuntu:14.04

RUN \
apt-get install -y software-properties-common

RUN \
add-apt-repository -y ppa:openjdk-r/ppa && \
apt-get update && \
apt-get install -y openjdk-8-jdk

RUN \
apt-get install wget

WORKDIR /root

RUN \
wget http://download.qwazr.com/build-4deef66/qwazr-server-1.0.0-SNAPSHOT.deb

RUN \
dpkg -i qwazr-server-1.0.0-SNAPSHOT.deb

RUN \
rm qwazr-server-1.0.0-SNAPSHOT.deb

CMD \
service qwazr start && tail -f /var/log/qwazr/*
