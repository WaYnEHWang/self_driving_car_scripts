#! /bin/bash
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


BEGIN=1
TIMES=2
END=$1
if [ "$#" == "0" ]; then
    echo "The parameter is wrong in auto_round.sh"
else

	for((i=$BEGIN; i<=$END; i++))
	do
		echo "////////"
		echo "Round $i"
		echo "////////"

		for((j=1; j<=2; j++))
		do
			now=$(date)
			echo "[${now}]To No.${j} stop"
			#set the route 1 or 2.
			bash /apollo/modules/autoset/auto_routing.sh $j
			sleep 1
			#start Auto
			bash /apollo/modules/autoset/auto_pilot.sh start
			sleep 1
			#wait until receives the "mission_complete" from planning.
			bash /apollo/modules/autoset/auto_listener.sh

			#stop Auto
			bash /apollo/modules/autoset/auto_pilot.sh stop
			sleep 1
		done


	done

	echo "//////////"
	echo "//finish//"
	echo "//////////"
fi
