# Ardupilot SITL Docker

Docker image/container for multi-agent Ardupilot Software-in-the-Loop simulation. This one targets multi-vehicle simulation by exploiting the new (Oct 2020) capability in [Ardupilot](https://github.com/ArduPilot/ardupilot) to set the System ID via the command line.  

## Build and run local (tested on Windows)

Rather than pull from a docker hub, this simulation has been configured to run locally. After cloning the repo. First run the following command to build the Docker image:

 ```docker build -t ardupilot-sitl-docker .```
 
Then run a multi-agent simulation using:

```docker compose -f docker-compose.gateway.yml up --scale copter=5 --scale plane=5 --scale quadp=5```

The ```copter=5``` type arguments indicates the number of agents of various types. The system will reliably work up to ~18 agents (total across all frame types). If you only want a particular type, the others must be scaled to zero i.e. for no planes ```--scale plane=0```

There are two similar Docker compose scripts. 
* ```docker-compose.gateway.yml``` sets a 2Hz update rate from all agents. Best for larger swarms/groups (5+ agents)
* ```docker-compose.gateway_fast.yml``` sets a 10Hz update rate. Best for smaller 'cooperative' groups (2-4 agents)

There is a small delay between the compose command and the vehicles being 'ready-to-fly'. There are delays with the docker startup and also the ardupilot EFK/position estimates. Approximatly 1 minute is usually enough time before a 'takeoff' command can be sent.

All of the individual MAVLink streams are combined into a single IP based stream using mavp2p. There are streams available on the host system via the local host (0.0.0.0 in Linux, 127.0.0.1 Windows)
* tcps:0.0.0.0:14554
* tcps:0.0.0.0:14555
* udps:0.0.0.0:14556

This allows a GCS application (such as MissionPlanner) to connect in parallel to an experimental control script (such as pymavlink, MAVSDK, etc). 

Here is ax example of Mission Planner connected to 18 agents using ```tcpc:127.0.0.1:14555```.

![Mission planner startup screenshot](mission_planner_start2.png)

Don't forget to first ARM the vehicle, then issue a TAKEOFF command before the automatic disarm timeout (~10 seconds). You can fly the drones around by hand, using Guided mode. Use the drop-down box at the top right to choose which drone you're talking to. 

There is currently a bug with the container shutdown process which leaves orphaned processes which then cause subsequent Docker up commands to fail. If this happens the Docker environment can be cleared up with:

```docker compose down```

```docker container prune```

## Updates

* All uses of MAVProxy have been removed and replaced with [mavp2p](https://github.com/aler9/mavp2p).
* The multi-layer MAVLink message routing has been simplified to use a single gateway router connected directly to the container SITL instances. This significantly reduced CPU load and reduced unnessesary message routing.
* The SITL is no longer staretd as a background service to prevent orphaned SITL instances.
* Automatic starting locations now at Fenswood Farm in Bristol.
* (work in progress) The ```copter.parm``` file has been embedded in the Docker image to allow for custom vehicle setups.
* Three vehicle types can now be run in parallel - quadcopter, plane, quadplane.
* Significantly reduced the startup time. No need for a 40s dealy now.

## Original branch

This work was branched from (https://github.com/arthurrichards77/ardupilot_sitl_docker) and the original instructions are below. This branch has been optimised specifically for multi-agent simulation, hence some of the original features might now be broken. It is recomended that the ```docker-compose.gateway.udp.yml``` always be used to start the containers.



## Environment Variable Reference

The default command of the container runs a [launch script] which employs environment variables to enable customization.  The full list of these is below, including their default settings. Of course, everything can be customized by overriding the command via Docker.

* SYSID : the target system ID, i.e. ```--sysid``` of the drone in the range 1-255 : default is the last number of the IP address
* STARTPOSE : the ```--home``` location for the drone in format lat,lon,alt,yaw 
* SITL_EXE : the executable filename from Ardupilot's ```/build/sitl/bin``` folder : default is ```arducopter```
* SITL_OPTS : options for SITL besides ```--home``` and ```-sysid```: default is ```--model=quad --defaults=/home/pilot/ardupilot/Tools/autotest/default_params/copter.parm```

NOTE: The copter.parm, plane.parm, and quadplane.parm vehicle configuration settings are local copies of the default ones. This means you can make edits to the parameters to suit your own setup and they are not lost each time you compile the docker image. For example setting cruise airspeeds or maximum roll/pich angles.

## Similar Work

(https://hub.docker.com/r/edrdo/ardupilot-sitl-docker) was the inspiration for this work. See also (https://hub.docker.com/r/radarku/ardupilot-sitl) and many more found by searching on Docker hub.
