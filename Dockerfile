#Get a base Ubuntu distro. 
#Not the most up to date distribution, but it works.
FROM ubuntu:22.04

#Install tools needed to compile Ardupilot
RUN apt-get update -y
RUN apt-get install -y git python3
RUN apt-get install -y python-pip
RUN apt-get install -y python3-dev
RUN apt-get install -y python3-pip
RUN apt-get install -y python-is-python3
RUN apt-get install -y g++
RUN apt-get install -y ccache gawk make wget cmake

#Make and move to a working directory
RUN mkdir /home/pilot
WORKDIR /home/pilot

#Get and unzip the Ardupilot repo. Move into the directory.
RUN git clone --recursive --depth 1 https://github.com/ArduPilot/ardupilot.git
RUN wget https://github.com/aler9/mavp2p/releases/download/v0.6.5/mavp2p_v0.6.5_linux_amd64.tar.gz
RUN tar -xvzf mavp2p_v0.6.5_linux_amd64.tar.gz
WORKDIR ardupilot

#Install further dependencies for Ardupilot
RUN pip3 install empy==3.3.4
RUN pip3 install future lxml pymavlink MAVProxy pexpect

#Build arducopter (rotary), arduplane (fixed-wing/quadplane)
#ardurover (wheeled, walker, surface-boat), ardusub (submarine/ROV),
#and ardu'heli' (single-rotary)
RUN ./waf configure --board sitl
RUN ./waf copter
RUN ./waf plane
RUN ./waf rover
RUN ./waf sub
RUN ./waf heli

#Install tools required for MAVLink routing
RUN apt-get install -y iproute2
RUN apt-get install -y nano
RUN apt-get install -y dos2unix
RUN apt-get install -y systemctl 

#Move back to the parent directory.
#Make a new folder and copy various startup/run scripts into it
WORKDIR /home/pilot
RUN mkdir app
COPY app app
WORKDIR app

#Ensure the scripts have the correct line endings (useful if editing from Windows) 
RUN dos2unix launch.sh
RUN dos2unix starts_farm.txt
RUN dos2unix starts_llanbedr.txt
RUN dos2unix clear_ips.sh
RUN dos2unix gateway.sh

#Set the default launch command
#(this is not run when compiling)
CMD ["./launch.sh"]

#end of file