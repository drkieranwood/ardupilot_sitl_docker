#!/bin/bash
echo "Waiting to start gateway (40s)"
sleep 10
echo "Waiting to start gateway (30s)"
sleep 10
echo "Waiting to start gateway (20s)"
sleep 10
echo "Waiting to start gateway (10s)"
sleep 10
echo "Starting gateway"

#Get all IPs of other containers
o="../ips/sitl_ip.txt"
cat $o

#Make a command string with the IPs
cmd="../mavp2p --hb-systemid=126 --streamreq-frequency=2 "
pre="tcpc:"
post=":5760 "
out="tcps:0.0.0.0:14554 tcps:0.0.0.0:14555 udps:0.0.0.0:14556"

while read -r p
do
  cmd=$cmd$pre"$p"$post
done < $o
cmd=$cmd$out

#Run the mavp2p service
echo $cmd
eval $cmd

