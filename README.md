# self_driving_car_scripts

#Introduction:
The scripts in this file are used to execute the procedure automatically.


#Files:

#auto_build.sh:
This script is used to build apollo automatically.

#auto_launch_completely.sh:
This script is used to launch apollo automatically out of docker, and the procedure is from "dev_start" to turning all modules on.

#auto_launch_indocker.sh:
This script is used to launch apollo automatically in the docker, and the procedure is from setting configures to turning all modules on.

#auto_modules.sh:
This script is used to turn on the modules that all you need.

#auto_pilot.sh:
This script is used to press "start Auto" or "stop Auto" automatically, and note that you need put a parameter in the command line.
e.x. bash auto_pilot.sh start

#auto_round.sh:
This script is used to set how many round you wnat to go, and please set a parameter in the command line.
e.x. bash auto_round.sh 10  ----> run 10 times.

#auto_routing.sh:
This script is used to set start point and end point, and note that you need put a parameter in the command line.
e.x. bash auto_routing.sh 1

#auto_set.sh:
This script is used to set configures automatically.

#auto_listener.sh:
This script is used to listen the messages from planning. It waits until it receives the "mission_complete" message.

#auto_launch_app.sh:
This script is used to launch apollo automatically out of docker, and the procedure is from "dev_start" to turning all modules on.

#auto_round_app.sh
This script is used to drive vehicle after setting round times.
