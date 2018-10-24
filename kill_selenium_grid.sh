#!/bin/bash
source config.env

case $(uname -a) in
    *"Linux"*)
        MATCHSET=$(ps a | grep ".*[s]elenium-server-standalone-${SELENIUM_SERVER_VERSION}.jar.*")
        ;;
    *"Cygwin"*)
        MATCHSET=$(ps -a | grep -o '[0-9].*/java$')
        ;;
    *"Darwin"*)
        MATCHSET=$(ps -e | grep -o "\d\+.*[s]elenium-server-standalone-${SELENIUM_SERVER_VERSION}.jar.*")
        ;;
esac

printf "Marked for death:\n$MATCHSET\n"
printf "$MATCHSET" | cut -d " " -f 1 | xargs kill
rm last_hub_addr.txt &> /dev/null
echo "Mischief managed."
