#!/bin/bash 
o="/home/pilot/ips/sitl_ip.txt"
echo "Clearing old IP lists..."
rm -f $o
> $o
echo "    ... done"