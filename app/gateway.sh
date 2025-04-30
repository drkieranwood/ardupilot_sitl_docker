#!/bin/bash
#This central gateway links all the SITLs to a single IP address. 

echo " "
echo "STEP3"
echo "Starting gateway..."
sleep 5

#Get all IPs of other containers. During the launch, each container 
#writes its IP to a central file. It is echoed to terminal here.
#The compose file sets up this directory as shared between all containers (drones)
o="../ips/sitl_ip.txt"
cat $o

#Make a command string with the IPs
#Each container IP is pre- and post-fixed with the mavp2p commands.
#The stream frequency (how often the 'drones' transmit telem.) is set
#via the first command line argument.
#The combined stream is externally accessible via tcp (14554, 14555) and udp (14556)
echo "STREAM RATE = $1"
cmd="../mavp2p --hb-systemid=126 --streamreq-frequency=$1 "
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

echo "                ... done!"
echo "                ... GO FLY!"

#end of file