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

#use "start" to turn "start Auto" on, or use "stop" to turn it off.

if [ "$#" == "1" ]; then
	#Start Auto
	./bazel-bin/modules/autoset/tools/auto_pad_terminal $1
	sleep 1
	echo "auto pilot $1 done!"
else
	echo "the number of parameter is wrong in auto_pilot.sh"
fi
