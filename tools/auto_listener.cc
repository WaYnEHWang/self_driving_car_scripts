/******************************************************************************
 * Copyright 2019 The Acer Authors (Wayne.W.Wang@acer.com). All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *****************************************************************************/
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <memory>

#include "cyber/cyber.h"
#include "modules/planning/proto/decision.pb.h"
#include "modules/planning/proto/planning.pb.h"
#include "modules/common/adapters/adapter_gflags.h"

namespace apollo {
namespace auto_listener {

using apollo::planning::ADCTrajectory;
using apollo::cyber::Reader;

bool car_run = false;
bool car_has_stopped = false;
std::unique_ptr<std::thread> terminal_thread_;

std::shared_ptr<Reader<apollo::planning::ADCTrajectory>>
    listener = nullptr;

void OnMissionComplete(
    const std::shared_ptr<apollo::planning::ADCTrajectory>& msg) {


      bool mission_complete = msg->decision().main_decision().has_mission_complete();
      bool stop = msg->decision().main_decision().has_stop();
      double path_length = msg->total_path_length();
      AINFO << "mission_complete: " << mission_complete << " stop: " << stop << " total_path_length: " << path_length;
      if (stop && !car_run && (path_length > 0.0)) {
        AINFO << "-----car start running.-----";
        car_run = true;
        mission_complete = false;
      }

      if (car_run) {
        AINFO << "car is running.";
        if (mission_complete && (path_length == 0.0)) {
          AINFO << "-----car has arrived.-----";
          car_has_stopped = true;
        }
      }
      if (car_has_stopped) {
          AINFO << "---shutdown---";
          apollo::cyber::AsyncShutdown();
      }

}

void init(char *argv[]) {

  // init cyber framework
  apollo::cyber::Init(argv[0]);
  // create listener node
  auto listener_node = apollo::cyber::CreateNode("listener");
  // create listener
  apollo::auto_listener::listener =
      listener_node->CreateReader<ADCTrajectory>(
          FLAGS_planning_trajectory_topic, apollo::auto_listener::OnMissionComplete);
}


}//auto_listener
}//apollo




int main(int argc, char* argv[]) {
  //init cyber, map...
  apollo::auto_listener::init(argv);
  apollo::cyber::WaitForShutdown();
  return 0;
}
