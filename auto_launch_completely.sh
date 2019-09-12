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

echo "------------------------------"
echo "-- WELCOME Dreamview Script --"
echo "------------------------------"


#Check whether the files are exist or not.

function check_files() {
if [ -f "$APOLLO_HOME/docker/scripts/dev_start.sh" -a -f "$APOLLO_HOME/apollo.sh" -a -f "$APOLLO_HOME/scripts/bootstrap.sh" ]; then

	if [ -f "$APOLLO_HOME/modules/autoset/auto_modules.sh" -a
		-f "$APOLLO_HOME/modules/autoset/auto_set.sh" ]; then
		echo "finish checking."
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
echo "===========set the mode, map and vehicle up=============="
docker exec -u $USER -it apollo_dev_$USER /bin/bash /apollo/modules/autoset/auto_set.sh
}


#lanuch Dreamview.
function launch_dreamview() {
echo "=============set up the Dreamview============"
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
#bash $APOLLO_HOME/docker/scripts/dev_start.sh -l -t apollo0413
bash $APOLLO_HOME/docker/scripts/dev_start.sh
echo "=============docker has been set up.=================="
}

function stop() {
bash $APOLLO_HOME/docker/scripts/dev_start.sh stop
}


function build() {
#docker exec -u $USER apollo_dev_$USER /apollo/apollo.sh build_opt_gpu
docker exec -u $USER apollo_dev_$USER /apollo/apollo.sh build
}



#Check if you want to start or off the docker.
read -p "Do you want to turn it ON or OFF?(N/F)" ans
if [ "${ans}" == "F" ] || [ "${ans}" == "f" ]; then
	stop
else
	#Execute the dev_start.sh
	start

	#Check if you've built this project or not.
	read -p "Have you built this project? (Y/N): " yn
	if [ "${yn}" == "N" ] || [ "${yn}" == "n" ]; then

		#Build Apollo
		xhost +local:root 1>/dev/null 2>&1
		build
		xhost -local:root 1>/dev/null 2>&1
		echo "=============apollo has been built.=================="
	fi

	xhost +local:root 1>/dev/null 2>&1
	setting
	launch_dreamview
	set_modules_off
	set_modules
	into
	xhost -local:root 1>/dev/null 2>&1

fi

