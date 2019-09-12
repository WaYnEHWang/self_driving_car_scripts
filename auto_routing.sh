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

if [ "$#" == "0" ]; then
    echo "The parameter is wrong in auto_routing.sh"
else
	#route editing
	./bazel-bin/modules/autoset/tools/auto_routing $1
	echo "route editing done"

#	pkill -f "/apollo/modules/planning/dag/planning.dag"
#	sleep 1

#	nohup mainboard -d /apollo/modules/planning/dag/planning.dag &
#	sleep 1
fi
