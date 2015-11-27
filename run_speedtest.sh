#!/usr/bin/env bash

#
# Execution parameters:
#
# ./run_speedtest.sh --dc_id=US-RDU-1 --tenant_id=1f010a6961b644979e03285671f2f9a0 --project_id=CIS-DCOS-DCOS-RDU-DEMO-01 --host_name=mesos-slave-02 --log_file_location="./CIS-DCOS-DCOS-RDU-DEMO-01.log" --sleep_duration=10s
#
#


sleepDuration=30s
logFileLocation="speedtest.log"

for i in "$@"
do
case $i in
    --dc_id=*)
    dcID="${i#*=}"
    shift # past argument=value
    ;;
    --tenant_id=*)
    tenantID="${i#*=}"
    shift # past argument=value
    ;;
    --project_id=*)
    projectID="${i#*=}"
    shift
    ;;
    --host_name=*)
    hostName="${i#*=}"
    shift
    ;;

    --log_file_location=*)
    logFileLocation="${i#*=}"
    shift
    ;;

    --sleep_duration=*)
    sleepDuration="${i#*=}"
    shift
    ;;

    --default)
    DEFAULT=YES
    shift
    ;;
    *)
            # unknown option
    ;;
esac
done
echo "DCID         = ${dcID}"
echo "TENANT_ID    = ${tenantID}"
echo "PROJECT_ID   = ${projectID}"
echo "HOST_NAME    = ${hostName}"

if [ ! -e $logFileLocation ]
then
    echo "DCID, TENANT_ID, PROJECT_ID, HOST_NAME, DATE,TIME,PING ms,DL mb/s,UL mb/s" > $logFileLocation
fi



echo "[run_speedtest.sh]: Starting infinite run loop, sleep for $sleepDuration between tests"
echo "[run_speedtest.sh]: Press Ctrl-C to stop"
echo "[run_speedtest.sh]: Writing log to $logFileLocation"

while [ 1 ]; do
    echo "[run_speedtest.sh]: Running single test..."
    echo -n "$dcID,$tenantID,$projectID,$hostName," >> $logFileLocation
    ./speedtest.sh --log $logFileLocation --verbose --simple > /dev/null
    echo "[run_speedtest.sh]: DONE single test"
    echo "[run_speedtest.sh]: Sleeping for  $sleepDuration..."
    sleep $sleepDuration
done
