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

echo "===========set the mode, map and vehicle up=============="

#set mode,map and vehicle.
bash /apollo/modules/autoset/auto_set.sh

#lanuch Dreamview.
echo "=============set up the Dreamview============"
bash /apollo/scripts/bootstrap.sh
sleep 5

#Turn the modules on
bash /apollo/modules/autoset/auto_stop_modules.sh
bash /apollo/modules/autoset/auto_modules.sh
echo "===============Turn all of the modules on===================="
