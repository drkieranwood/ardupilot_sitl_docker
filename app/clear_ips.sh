#!/bin/bash 
#Clear the list of shared IP addresses
#The compose file sets up this directory as shared between all containers (drones)
echo " "
echo "STEP1"
echo "Clearing old IP lists..."

o="/home/pilot/ips/sitl_ip.txt"
rm -f $o
> $o

echo "                     ... done!"

#end of file