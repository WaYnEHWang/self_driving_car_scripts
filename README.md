# self_driving_car_scripts

##Introduction
The scripts in this file are used to execute the procedure automatically.

#History:
    time    author  version   notes
 2019/05/02 Wayne   0.1   just try how to write the shell script!
 2019/05/06	Wayne		0.2	 	set the apollo path.
 2019/05/07	Wayne		0.3		This script can run to lauch the dreamview.
 2019/05/07	Wayne		0.4		Add a function about turning the dreamview on or off.
 2019/05/08	Wayne		0.5		Add a function about compiling a C++ program.
 2019/05/13	Wayne		0.6		Test a function about bashing a file out of docker.
 2019/05/15	Wayne		0.7		Amend this code and add a function about checking files
 2019/05/17	Wayne		0.8		Add a function about setting mode and map.
 2019/05/21 Wayne		0.9		Amend this code and set directory automatically.
 2019/05/30	Wayne		1.0		Add a function for setting the waypoints.
 2019/05/31	Wayne		1.1		Add a function for "Start Auto" button.
 2019/06/10	Wayne		1.2		Amend setting modules
 2019/07/11	Wayne		2.0		Add a function about going around the school.
 2019/07/17	Wayne		2.1		Add a script for going around the school.
 2019/07/24	Wayne		2.2		Add a script for executing Apollo with App.
 2019/07/24	Wayne		2.3		Add a script for driving vehicle with App.
 2019/07/30	Wayne		3.0		Add two icons for version2.2&2.3
 2019/08/08	Wayne		3.1		Combine two apps into one script "auto_launch_round.sh"
 2019/08/08	Wayne		3.2		Add auto_stop_modules.sh to stop modules.
 2019/08/13	Wayne		3.3		Update recorder commands.
 2019/08/21	Wayne		3.4		only stopping modules after typing "c" in auto_launch_round.sh script.
 2019/08/22	Wayne		3.5		echo log with date and time while car starting and stopping.
 2019/08/22	Wayne		3.6		Add a function to check mission completed.
 2019/08/15	Wayne		4.0		Create a new Qt App for guests.
 2019/08/16	Wayne		4.1		Add a script for Qt App.
 2019/08/22	Wayne		4.2		Simplify Qt App.
###############################################################################

##Files:

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
