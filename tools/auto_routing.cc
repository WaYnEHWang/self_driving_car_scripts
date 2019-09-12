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

#include "cyber/common/file.h"
#include "cyber/cyber.h"
#include "cyber/time/rate.h"
#include "cyber/time/time.h"

#include "modules/common/time/time.h"

#include "modules/common/adapters/adapter_gflags.h"
#include "modules/routing/proto/routing.pb.h"

DEFINE_bool(enable_remove_lane_id, true,
            "True to remove lane id in routing request");

DEFINE_string(routing_test_file_half1,
              "modules/autoset/tools/routing_half1.pb.txt",
              "Used for sending routing request to routing node.");

DEFINE_string(routing_test_file_half2,
              "modules/autoset/tools/routing_half2.pb.txt",
              "Used for sending routing request to routing node.");

using apollo::cyber::Rate;

int main(int argc, char *argv[]) {
  google::ParseCommandLineFlags(&argc, &argv, true);

  // init cyber framework
  apollo::cyber::Init(argv[0]);
  FLAGS_alsologtostderr = true;
  apollo::routing::RoutingRequest routing_request;

  if (std::string(argv[1]) == "1") {
    if (!apollo::cyber::common::GetProtoFromFile(FLAGS_routing_test_file_half1,
                                               &routing_request)) {
    AERROR << "failed to load file: " << FLAGS_routing_test_file_half1;
    return -1;
    }
  } else if (std::string(argv[1]) == "2") {
    if (!apollo::cyber::common::GetProtoFromFile(FLAGS_routing_test_file_half2,
                                               &routing_request)) {
    AERROR << "failed to load file: " << FLAGS_routing_test_file_half2;
    return -1;
    }
  } else {
    AERROR << "The parameter is wrong in auto_routing.cc";
  }

  
  

  if (FLAGS_enable_remove_lane_id) {
    for (int i = 0; i < routing_request.waypoint_size(); ++i) {
      routing_request.mutable_waypoint(i)->clear_id();
      routing_request.mutable_waypoint(i)->clear_s();
    }
  }

  /*auto timestamp = apollo::common::time::Clock::NowInSeconds();
  routing_request.mutable_header()->set_timestamp_sec(timestamp);
  routing_request.mutable_header()->set_module_name("routing");
  routing_request.mutable_header()->set_sequence_num(1);
  routing_request.mutable_waypoint(0)->set_id("lane_2");
  routing_request.mutable_waypoint(0)->set_s(44.04052347886276);
  routing_request.mutable_waypoint(0)->mutable_pose()->set_x(335439.00707641069);
  routing_request.mutable_waypoint(0)->mutable_pose()->set_y(2759521.3971898118);
  routing_request.mutable_waypoint(1)->set_id("lane_2");
  routing_request.mutable_waypoint(1)->set_s(15.103297136900354);
  routing_request.mutable_waypoint(1)->mutable_pose()->set_x(335450.94137292530);
  routing_request.mutable_waypoint(1)->mutable_pose()->set_y(2759541.9307797588);*/

  std::shared_ptr<apollo::cyber::Node> node(
      apollo::cyber::CreateNode("routing_tester"));
  auto writer = node->CreateWriter<apollo::routing::RoutingRequest>(
      FLAGS_routing_request_topic);

  Rate rate(1.0);
  int i = 0;
  while (apollo::cyber::OK()) {
    i += 1;
    writer->Write(routing_request);
    AINFO << "send out routing request: " << routing_request.waypoint(1).DebugString();
    rate.Sleep();
    if (i == 3) break;
  }
  return 0;
}
