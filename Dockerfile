FROM ubuntu:22.04

RUN apt-get update -y
RUN apt-get install -y git python3
RUN apt-get install -y python-pip
RUN apt-get install -y python3-dev
RUN apt-get install -y python3-pip
RUN apt-get install -y python-is-python3
RUN apt-get install -y g++
RUN apt-get install -y ccache gawk make wget cmake

RUN mkdir /home/pilot

WORKDIR /home/pilot

RUN git clone --recursive --depth 1 https://github.com/ArduPilot/ardupilot.git
RUN wget https://github.com/aler9/mavp2p/releases/download/v0.6.5/mavp2p_v0.6.5_linux_amd64.tar.gz
RUN tar -xvzf mavp2p_v0.6.5_linux_amd64.tar.gz

WORKDIR ardupilot

RUN apt-get install -y iproute2
RUN apt-get install -y nano
RUN apt-get install -y dos2unix
RUN pip install future lxml pymavlink MAVProxy pexpect
RUN pip3 install empy==3.3.4
RUN pip3 install future pexpect

RUN ./waf configure --board sitl

RUN ./waf copter

RUN ./waf plane

WORKDIR /home/pilot

RUN mkdir app

COPY app app

WORKDIR app

RUN dos2unix launch.sh
RUN dos2unix starts.txt
RUN dos2unix clear_ips.sh
RUN dos2unix gateway.sh

CMD ./launch.sh
