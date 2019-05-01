#!/bin/bash
GLOBIGNORE="*"
SINKS=$(pacmd list-sinks | grep "^\s*\*\?\s*index:")
echo ${SINKS}
read -r line <<< ${SINKS}
FIRST_SINK=`echo ${line} | sed -n "s/^\s*\*\?\s*index: //p"`
while read -r line
do
    if [ ! -z ${REACHED_ACTIVE_SINK} ]; then
        NEW_DEFAULT_SINK=`echo ${line} | sed -n "s/^\s*\*\?\s*index: //p"`
        printf "Setting default sink to %s\n" ${NEW_DEFAULT_SINK}
        pacmd set-default-sink ${NEW_DEFAULT_SINK}
        REACHED_ACTIVE_SINK=""
    fi
    if [[ "$line" == *"* index"* ]]; then
        REACHED_ACTIVE_SINK=1
    fi
done <<< "${SINKS}"
if [ ! -z ${REACHED_ACTIVE_SINK} ]; then
    NEW_DEFAULT_SINK=${FIRST_SINK}
    printf "Setting default sink to %s\n" ${NEW_DEFAULT_SINK}
    pacmd set-default-sink ${NEW_DEFAULT_SINK}
fi
