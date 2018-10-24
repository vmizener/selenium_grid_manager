#!/bin/bash
source config.env

SELENIUM_GRID_JAR_DOWNLOAD_ROOT_URL=http://selenium-release.storage.googleapis.com

if [[ ! $(echo $1 | grep -E '^\d+\.\d+\.\d+$') ]]; then
    >&2 echo "You must supply a version of selenium grid to get in the required format"
    >&2 echo "The format is '<Major version>.<Minor version>.<Release>'"
    >&2 echo "(e.g. '3.13.0')"
    exit 1
fi

RELEASE=$1
VERSION=$(echo ${RELEASE} | cut -d. -f 1,2)
DOWNLOAD_URL=${SELENIUM_GRID_JAR_DOWNLOAD_ROOT_URL}/${VERSION}/selenium-server-standalone-${RELEASE}.jar

if [[ ! $(curl -Is ${DOWNLOAD_URL} | head -n 1 | grep "200 OK") ]]; then
    >&2 echo "Failed to retrieve indicated release @ ${DOWNLOAD_URL}"
    >&2 echo "Did you supply a real version?"
    >&2 echo "Check for versions @ ${SELENIUM_GRID_JAR_DOWNLOAD_ROOT_URL}"
    exit 1
fi

if [[ ! -d ${SELENIUM_GRID_JAR_LOCATION} ]]; then
    mkdir -p ${SELENIUM_GRID_JAR_LOCATION}
fi

DOWNLOAD_LOCATION=${SELENIUM_GRID_JAR_LOCATION}/selenium-server-standalone-${RELEASE}.jar
curl ${DOWNLOAD_URL} > ${DOWNLOAD_LOCATION}
echo "Success!"
echo "Downloaded to: ${DOWNLOAD_LOCATION}"
