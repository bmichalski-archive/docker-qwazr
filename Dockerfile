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
wget http://download.qwazr.com/build-5e73bb6/qwazr-server-1.0.1-SNAPSHOT.deb

RUN \
dpkg -i qwazr-server-1.0.1-SNAPSHOT.deb

RUN \
rm qwazr-server-1.0.1-SNAPSHOT.deb

RUN \
cp /var/lib/qwazr/log4j.properties /root/default_log4j.properties

COPY \
docker-entrypoint.sh /root/docker-entrypoint.sh

RUN \
chmod u+x /root/docker-entrypoint.sh

ENTRYPOINT ["/root/docker-entrypoint.sh"]

EXPOSE 9090 9091

