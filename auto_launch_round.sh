#!/bin/bash
####################################################################
# Copyright 2019 The Acer Authors (Wayne.W.Wang@acer.com). All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
###############################################################################

FILE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$FILE_DIR/../.."
APOLLO_HOME="$( pwd )"

BOLD='\033[1m'
RED='\033[0;31m'
GREEN='\033[32m'
WHITE='\033[34m'
YELLOW='\033[33m'
NO_COLOR='\033[0m'


echo "------------------------------"
echo "-- WELCOME Dreamview Script --"
echo "------------------------------"


#Check network first.
function check_network() {
network_status="$( curl -I -s https://tw.yahoo.com/ | grep "200 OK" )"
if [ "$network_status" == "" ]; then
	echo -e "${RED}You don't hava network service.${NO_COLOR}"
	sleep 5
	exit 0
fi
}


#Check whether the files are exist or not.
function check_files() {

	if [ -f "$APOLLO_HOME/docker/scripts/dev_start.sh" -a -f "$APOLLO_HOME/scripts/bootstrap.sh" ]; then
		if [ -f "$APOLLO_HOME/modules/autoset/auto_modules.sh" -a -f "$APOLLO_HOME/modules/autoset/auto_set.sh" ]; then
			echo ""
		else
			echo "someone is not exist"
			exit 0
		fi
	else
		echo "someone is not exist."
		exit 0
	fi
}


#set mode,map and vehicle.
function setting() {
echo -e "${GREEN}---- Setting the mode, map and vehicle -----${NO_COLOR}"
docker exec -u $USER -it apollo_dev_$USER /bin/bash /apollo/modules/autoset/auto_set.sh
}


#lanuch Dreamview.
function launch_dreamview() {
#lanuch Dreamview.
echo -e "${GREEN}=============set up the Dreamview============${NO_COLOR}"
docker exec -u $USER -it apollo_dev_$USER /bin/bash /apollo/scripts/bootstrap.sh stop
sleep 3
docker exec -u $USER -it apollo_dev_$USER /bin/bash /apollo/scripts/bootstrap.sh
sleep 5
}


#Turn the modules on
function set_modules() {
docker exec -u $USER -it apollo_dev_$USER /bin/bash /apollo/modules/autoset/auto_modules.sh
echo "===============Turn all of the modules on===================="
}

#Turn the modules off
function set_modules_off() {
docker exec -u $USER -it apollo_dev_$USER /bin/bash /apollo/modules/autoset/auto_stop_modules.sh
}


# get into docker.
function into() {
docker exec -u $USER -it apollo_dev_$USER /bin/bash
}

function start() {
echo "---- Starting the Docker -----"
#bash $APOLLO_HOME/docker/scripts/dev_start.sh -l -t apollo0413
bash $APOLLO_HOME/docker/scripts/dev_start.sh
echo -e "${GREEN}=============docker has been set up.==================${NO_COLOR}"
}


#Check if the docker is exist.
function check_dokcer() {
ret="$( docker container ls | grep "apollo" )"
echo "$ret"
}



#-------------main------------------


docker_exist=$(check_dokcer)
if [ "$docker_exist" == "" ]; then
	check_files
	check_network
	start
fi

#xhost +local:root 1>/dev/null 2>&1	
setting
launch_dreamview
nohup firefox http://localhost:8888/ &
set_modules_off
set_modules
#xhost -local:root 1>/dev/null 2>&1

while :
do
	#check the unmbers of the round times.
	echo -e "${RED}press C to exit...${NO_COLOR}"
	read -p "How many times do you want to run?" ans
	if [ "${ans}" == "c" -o "${ans}" == "C" ]; then
		set_modules_off
#		bash $APOLLO_HOME/docker/scripts/dev_start.sh stop
		exit
	else
		var=$(echo ${ans} | bc)
		if [ "${var}" != "0" ]; then
			echo "${ans} times  OK."
			docker exec -u $USER -it apollo_dev_$USER /bin/bash /apollo/modules/autoset/auto_round.sh ${ans}
		else
			echo -e "${RED}Please type numbers${NO_COLOR}"
		fi
	fi
done
