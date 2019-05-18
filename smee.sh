#!/bin/bash
SMEE_CHANNELS="ySa2J3CLJ4b1qSN"
function start_smee() {
  for channel in ${SMEE_CHANNELS}; do
    pidfile=${channel}.pid
    if [ ! -f /var/run/smee/${pidfile} ]; then
      smee -u https://smee.io/${channel} -t http://localhost/webhooks/ &
      pid=$!
      echo ${pid} > /var/run/smee/${pidfile}
  fi
  done
}
function stop_smee() {
  for pidfile in `ls /var/run/smee/`; do
    while kill -3 `cat /var/run/smee/${pidfile}` >/dev/null 2>&1; do 
      sleep 1
    done
    rm /var/run/smee/${pidfile}
  done
}
cmd=$1
case $cmd in

    start)
        start_smee
        ;;

    stop)
        stop_smee
        ;;

    *)
        echo "usage: $0 [start|stop]"; exit 1
        ;;
esac
