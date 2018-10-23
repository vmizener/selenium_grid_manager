#!/bin/bash
source config.env

if [ ! -f ${SELENIUM_GRID_JAR_LOCATION}/selenium-server-standalone-${SELENIUM_SERVER_VERSION}.jar ]; then
    echo "Couldn't find server versioned: ${SELENIUM_SERVER_VERSION}"
    exit 1
else
    echo "Starting server versioned: ${SELENIUM_SERVER_VERSION}"
    java -jar ${SELENIUM_GRID_JAR_LOCATION}/selenium-server-standalone-${SELENIUM_SERVER_VERSION}.jar -role hub -port 4441 &> ${GRID_HUB_LOGFILE} &
    sleep 3
    register_address=`head ${GRID_HUB_LOGFILE} | grep -o 'http://[0-9a-z.:/]\+register/'`
    java -jar ${SELENIUM_GRID_JAR_LOCATION}/selenium-server-standalone-${SELENIUM_SERVER_VERSION}.jar -role node -hub $register_address -port 3456 &> ${GRID_NODE_LOGFILE1} &
    java -jar ${SELENIUM_GRID_JAR_LOCATION}/selenium-server-standalone-${SELENIUM_SERVER_VERSION}.jar -role node -hub $register_address -port 4567 &> ${GRID_NODE_LOGFILE2} &
    hub_address=`head ${GRID_HUB_LOGFILE} | grep -o 'http://[0-9a-z.:/]\+hub'`
    echo $hub_address > ${HUB_ADDR_OUTFILE}
    echo $hub_address
fi
