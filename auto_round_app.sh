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


echo "------------------------------"
echo "--- WELCOME to Running Man ---"
echo "------------------------------"


#check the unmbers of the round times.
read -p "How many times do you want to run?" ans

echo "${ans} times  OK."


xhost +local:root 1>/dev/null 2>&1
	docker exec -u $USER -it apollo_dev_$USER /bin/bash /apollo/modules/autoset/auto_round.sh ${ans}
xhost -local:root 1>/dev/null 2>&1

