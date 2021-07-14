FROM ubuntu:18.04

RUN apt-get update -y

RUN apt-get install -y git python
RUN apt-get install -y g++
RUN apt-get install -y ccache gawk make wget cmake
RUN apt-get install -y python-pip
RUN apt-get install -y iproute2

RUN pip install future lxml pymavlink MAVProxy pexpect

RUN useradd --create-home pilot

USER pilot

WORKDIR /home/pilot

RUN git clone --recursive --depth 1 https://github.com/ArduPilot/ardupilot.git
RUN wget https://github.com/aler9/mavp2p/releases/download/v0.6.5/mavp2p_v0.6.5_linux_amd64.tar.gz
RUN tar -xvzf mavp2p_v0.6.5_linux_amd64.tar.gz

WORKDIR ardupilot

RUN ./waf configure

RUN ./waf copter

RUN ./waf plane

WORKDIR /home/pilot

RUN mkdir app

COPY app app

WORKDIR app

CMD ./launch.sh
