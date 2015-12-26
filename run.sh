#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# The directory containing the data
QWAZR_DATA=/var/lib/qwazr

# The hostname of IP address the server listen to
LISTEN_ADDR=0.0.0.0

# the public hostname or IP address uses for external and nodes communication
PUBLIC_ADDR=localhost

# The TCP port used by the web applications
WEBAPP_PORT=9090

# The TCP port used by the web services
WEBSERVICE_PORT=9091

EXPOSE_WEBAPP_PORT=9090
EXPOSE_WEBSERVICE_PORT=9091

# A list of masters separated by commas
#QWAZR_MASTERS="127.0.0.1:9091"

# A list of services separated by commas
#QWAZR_SERVICES="search,schedulers,webcrawler,webapps,extractor,store,scripts,graph,table"

# Any JAVA option. Often used to allocate more memory
JAVA_OPTS="-Xms1G -Xmx1G -Djava.net.preferIPv4Stack=true"

LOG4J_PROPERTIES=$QWAZR_DATA/log4j.properties

JAVA_OPTS="$JAVA_OPTS -Dfile.encoding=UTF-8 -Dlog4j.configuration=file:$LOG4J_PROPERTIES"
QWAZR_JAR=/usr/share/qwazr/qwazr.jar
QWAZR_OPTS="$JAVA_OPTS -jar $QWAZR_JAR -l $LISTEN_ADDR -a $PUBLIC_ADDR -wp $WEBAPP_PORT -sp $WEBSERVICE_PORT -d $QWAZR_DATA"
QWAZR_STDOUT_LOG=/var/log/qwazr/server.out
QWAZR_STDERR_LOG=/var/log/qwazr/server.err

CMD_SET_DEFAULT_LOG4J_PROPERTIES="if ! [ -e $LOG4J_PROPERTIES ]; then cp /root/default_log4j.properties $LOG4J_PROPERTIES; fi"

CMD_RUN_QWAZR="$CMD_SET_DEFAULT_LOG4J_PROPERTIES && cd $QWAZR_DATA && java $QWAZR_OPTS qwazr > >(tee $QWAZR_STDOUT_LOG) 2> >(tee $QWAZR_STDERR_LOG >&2)"

DOCKER_QWAZR_EXISTS=`docker inspect --format="{{ .Id }}" docker-qwazr 2> /dev/null`

if ! [ -z "$DOCKER_QWAZR_EXISTS" ]
then
  docker stop $DOCKER_QWAZR_EXISTS
  docker rm $DOCKER_QWAZR_EXISTS
fi

docker run \
-it \
-p $EXPOSE_WEBAPP_PORT:$WEBAPP_PORT \
-p $EXPOSE_WEBSERVICE_PORT:$WEBSERVICE_PORT \
-v $DIR/data:$QWAZR_DATA \
--name docker-qwazr \
bmichalski/docker-qwazr \
bash -c "$CMD_RUN_QWAZR" 

