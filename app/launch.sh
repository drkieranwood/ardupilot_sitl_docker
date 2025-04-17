#!/bin/bash 
#Wait to allow the ip file erase to occur
sleep 10
o="../ips/sitl_ip.txt"
#ip a
if [ -z "$SYSID" ]
then
  echo "LAUNCH.SH: taking SYSID from IP address"
  SYSID=$(ip a | grep -E -o -m 1 "172.[0-9]{1,3}.0.[0-9]{1,3}" | grep -o -m 1 [0123456789]*$)
  #Need to ensure the IPs are all written to file without conflict, hence use a lock to ensure sequential write
  #sleep $SYSID
  echo "=+=+=+=+=+=+=+=+=+=+=+="
  echo "Writing IP $SYSID to file..."
  SYS_IP=$(ip a | grep -E -o -m 1 "172.[0-9]{1,3}.0.[0-9]{1,3}")
  echo $SYS_IP
  flock $o echo $(ip a | grep -E -o -m 1 "172.[0-9]{1,3}.0.[0-9]{1,3}" ) >> $o
  echo "=+=+=+=+=+=+=+=+=+=+=+="
fi
#SYSID=4
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
  #SITL_EXE=sim_vehicle.py
  #SITL_EXE='arduplane'
fi

if [ -z "$SITL_OPTS" ]
then
  SITL_OPTS='--model=quad --defaults=/home/pilot/app/copter.parm '
  #SITL_OPTS='-v ArduPlane -j4 -f quadplane --console --map '
  #SITL_OPTS='-v ArduPlane -w '
  #SITL_OPTS='--model quadplane --defaults=/home/pilot/app/quadplane.parm '
fi

#echo "LAUNCH.SH: /home/pilot/ardupilot/build/sitl/bin/$SITL_EXE --sysid=$SYSID --home=$STARTPOSE $SITL_OPTS"
/home/pilot/ardupilot/build/sitl/bin/$SITL_EXE --sysid=$SYSID --home=$STARTPOSE $SITL_OPTS

#ls /home/pilot/ardupilot/Tools/autotest
#echo python3 /home/pilot/ardupilot/Tools/autotest/$SITL_EXE $SITL_OPTS
#python3 /home/pilot/ardupilot/Tools/autotest/$SITL_EXE $SITL_OPTS