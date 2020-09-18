#!/bin/bash
source config.env

if ! $(command -v java &> /dev/null); then
    >&2 echo "This script relies on java!  Install it first."
    exit 1
fi

if [[ ! -f ${SELENIUM_GRID_JAR_LOCATION}/selenium-server-standalone-${SELENIUM_SERVER_VERSION}.jar ]]; then
    >&2 echo "Couldn't find server versioned: ${SELENIUM_SERVER_VERSION}"
    >&2 echo "Try running the get_selenium_grid.sh script to download this version"
    exit 1
else
    if (( ${GRID_NODE_COUNT} > ${#GRID_NODE_PORT_OPTIONS[@]} )); then
        >&2 echo "Not enough grid node port options defined in config (got ${#GRID_NODE_PORT_OPTIONS[@]}, need at least ${GRID_NODE_COUNT})"
        exit 1
    fi
    java -jar ${SELENIUM_GRID_JAR_LOCATION}/selenium-server-standalone-${SELENIUM_SERVER_VERSION}.jar -role hub -port ${GRID_HUB_PORT} &> ${GRID_HUB_LOGFILE} &
    sleep 3
    >&2 echo "Started server versioned: ${SELENIUM_SERVER_VERSION}"
    register_address=$(head ${GRID_HUB_LOGFILE} | grep -o 'http://[0-9a-z.:/]\+register/')
    count=0
    while (( ${count} < ${GRID_NODE_COUNT} )); do
        grid_node_port=${GRID_NODE_PORT_OPTIONS[${count}]}
        count=$((count+1))
        grid_node_logfile=$(printf ${GRID_NODE_LOGFILE_FORMAT} ${count})
        java -jar ${SELENIUM_GRID_JAR_LOCATION}/selenium-server-standalone-${SELENIUM_SERVER_VERSION}.jar -role node -hub ${register_address} -port ${grid_node_port} -timeout ${GRID_NODE_TIMEOUT} &> ${grid_node_logfile} &
        >&2 echo "Attached node ${count} to port ${grid_node_port} with logfile ${grid_node_logfile}"
    done
    hub_address=$(head ${GRID_HUB_LOGFILE} | grep -o 'http://[0-9a-z.:/]\+hub')
    echo ${hub_address} | tee ${HUB_ADDR_OUTFILE}
fi
