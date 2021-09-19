#!/bin/bash 
#Wait to allow the ip file erase to occur
sleep 10
o="../ips/sitl_ip.txt"
#ip a
if [ -z "$SYSID" ]
then
  echo "LAUNCH.SH: taking SYSID from IP address"
  SYSID=$(ip a | grep -o -m 1 172.[0123456789]*.0.[0123456789]* | grep -o -m 1 [0123456789]*$)
  #Need to ensure the IPs are all written to file without conflict, hence use a lock to ensure sequential write
  sleep $SYSID
  echo "=+=+=+=+=+=Writing IP $SYSID to file..."
  flock $o echo $(ip a | grep -o -m 1 172.[0123456789]*.0.[0123456789]*) >> $o
  echo "=+=+=+=+=+=    ... done"
fi
echo "LAUNCH.SH: System ID will be $SYSID"

if [ -z "$STARTPOSE" ]
then
  echo "LAUNCH.SH: taking STARTPOSE from starts.txt file"
  STARTPOSE=$(tail -n +$SYSID /home/pilot/app/starts.txt | head -n 1)
fi
echo "LAUNCH.SH: Start location will be $STARTPOSE"

if [ -z "$SITL_EXE" ]
then
  SITL_EXE='arducopter'
fi

if [ -z "$SITL_OPTS" ]
then
  SITL_OPTS='--model=quad --defaults=/home/pilot/app/copter.parm'
fi

echo "LAUNCH.SH: /home/pilot/ardupilot/build/sitl/bin/$SITL_EXE --sysid=$SYSID --home=$STARTPOSE $SITL_OPTS"
/home/pilot/ardupilot/build/sitl/bin/$SITL_EXE --sysid=$SYSID --home=$STARTPOSE $SITL_OPTS
