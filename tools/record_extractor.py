#!/usr/bin/env python

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

import sys
from datetime import datetime
from cyber_py.record import RecordReader
from modules.localization.proto import localization_pb2
from modules.control.proto import control_cmd_pb2
from modules.canbus.proto import chassis_pb2
from modules.perception.proto import traffic_light_detection_pb2
if __name__ == '__main__':
    sync = False
    if len(sys.argv) < 2:
        print "usage: python record_extractor.py record_file1 record_file2 ... and you also can use parameter '-s' to sync the initial timestamp. "
        sys.exit()
    else:
        if len(sys.argv[1]) < 3:
            if sys.argv[1] == '-s':
                sync = True
                frecords = sys.argv[2:]
            else:
                print "parameter usage: " + "\n" + "-s: sync the initial timestamp."
                sys.exit()
        else:
            frecords = sys.argv[1:]

    now = datetime.now().strftime("%Y-%m-%d_%H.%M.%S")

    time_sync_end = 0
    traffic_light_timestamp = 0
    control_timestamp = 0
    localization_timestamp = 0
    chassis_timestamp = 0

#get the initial time
    if sync == True:
        for frecord in frecords:
            print "get initial timestamp"
            reader = RecordReader(frecord)
            for msg in reader.read_messages():
                if msg.topic == "/apollo/perception/traffic_light":
                    if traffic_light_timestamp == 0:
                        traffic_light_detection = traffic_light_detection_pb2.TrafficLightDetection()
                        traffic_light_detection.ParseFromString(msg.message)
                        traffic_light_timestamp = traffic_light_detection.header.timestamp_sec
                        print "traffic_light_timestamp: " + str(traffic_light_timestamp)

                if msg.topic == "/apollo/control":
                    if control_timestamp == 0:
                        control = control_cmd_pb2.ControlCommand()
                        control.ParseFromString(msg.message)
                        control_timestamp = control.header.timestamp_sec
                        print "control_timestamp: " + str(control_timestamp)

                if msg.topic == "/apollo/localization/pose":
                    if localization_timestamp == 0:
                        localization = localization_pb2.LocalizationEstimate()
                        localization.ParseFromString(msg.message)
                        localization_timestamp = localization.header.timestamp_sec
                        print "localization_timestamp: " + str(localization_timestamp)

                if msg.topic == "/apollo/canbus/chassis":
                    if chassis_timestamp == 0:
                        chassis = chassis_pb2.Chassis()
                        chassis.ParseFromString(msg.message)
                        chassis_timestamp = chassis.header.timestamp_sec
                        print "chassis_timestamp: " + str(chassis_timestamp)
                if (traffic_light_timestamp > 0) and (control_timestamp > 0) and (localization_timestamp > 0) and (chassis_timestamp > 0):
                    break

#sync the initial timestamp
    if (traffic_light_timestamp > 0) and (control_timestamp > 0) and (localization_timestamp > 0) and (chassis_timestamp > 0):
            time_sync = max([traffic_light_timestamp, control_timestamp, localization_timestamp, chassis_timestamp])
            print "time_sync: " + str(time_sync)

#get TrafficLightDetection from traffic light topic
    with open("traffic_light.csv", 'w') as f:
        for frecord in frecords:
            print "processing traffic_light" + frecord
            reader = RecordReader(frecord)
            f.write("timestamp_sec,color,id,confidence" + "\n")
            for msg in reader.read_messages():
                if msg.topic == "/apollo/perception/traffic_light":
                    traffic_light_detection = traffic_light_detection_pb2.TrafficLightDetection()
                    traffic_light_detection.ParseFromString(msg.message)
                    timestamp = traffic_light_detection.header.timestamp_sec
                    color = traffic_light_detection.traffic_light[0].color
                    light_id = traffic_light_detection.traffic_light[0].id
                    confidence = traffic_light_detection.traffic_light[0].confidence
                    if sync == False:
                        f.write(str(timestamp) + "," + str(color) + "," + str(light_id)+ "," + str(confidence) + "\n")
                    if (sync == True) and (timestamp >= time_sync):
                        f.write(str(timestamp) + "," + str(color) + "," + str(light_id)+ "," + str(confidence) + "\n")

# get brake and throttle from control topic
    with open("control_brake&throttle.csv", 'w') as f:
        for frecord in frecords:
            print "processing control" + frecord
            reader = RecordReader(frecord)
            f.write("timestamp_sec,throttle,brake" + "\n")
            for msg in reader.read_messages():
                if msg.topic == "/apollo/control":
                    control = control_cmd_pb2.ControlCommand()
                    control.ParseFromString(msg.message)
                    timestamp = control.header.timestamp_sec
                    throttle = control.throttle
                    brake = control.brake
                    if sync == False:
                        f.write(str(timestamp) + "," + str(throttle) + "," + str(brake) + "\n")
                    if (sync == True) and (timestamp >= time_sync):
                        f.write(str(timestamp) + "," + str(throttle) + "," + str(brake) + "\n")


#get position and acceleration from localization topic
    with open("localization_pos&accel.csv", 'w') as f:
        for frecord in frecords:
            print "processing localization " + frecord
            reader = RecordReader(frecord)
            f.write("timestamp_sec,pos.x,pos.y,accel.x,accel.y" + "\n")
            for msg in reader.read_messages():
                if msg.topic == "/apollo/localization/pose":
                    localization = localization_pb2.LocalizationEstimate()
                    localization.ParseFromString(msg.message)
                    timestamp = localization.header.timestamp_sec
                    pos_x = localization.pose.position.x
                    pos_y = localization.pose.position.y
                    accel_x = localization.pose.linear_acceleration_vrf.x
                    accel_y = localization.pose.linear_acceleration_vrf.y
                    if sync == False:
                        f.write(str(timestamp) + "," + str(pos_x) + "," + str(pos_y) + "," + str(accel_x) + "," + str(accel_y) + "\n")
                    if (sync == True) and (timestamp >= time_sync):
                        f.write(str(timestamp) + "," + str(pos_x) + "," + str(pos_y) + "," + str(accel_x) + "," + str(accel_y) + "\n")

#get speed and steering angle from chassis topic
    with open("chassis_speed&steering.csv", 'w') as f:
        for frecord in frecords:
            print "processing chassis" + frecord
            reader = RecordReader(frecord)
            f.write("timestamp_sec,speed_mps,steering percentage,steering angle" + "\n")
            for msg in reader.read_messages():
                if msg.topic == "/apollo/canbus/chassis":
                    chassis = chassis_pb2.Chassis()
                    chassis.ParseFromString(msg.message)
                    timestamp = chassis.header.timestamp_sec
                    speed_mps = chassis.speed_mps
                    steering_percentage = chassis.steering_percentage
                    steering_angle = steering_percentage * 500 * 0.01
                    if sync == False:
                        f.write(str(timestamp) + "," + str(speed_mps) + "," + str(steering_percentage) + "," + str(steering_angle) + "\n")
                    if (sync == True) and (timestamp >= time_sync):
                        f.write(str(timestamp) + "," + str(speed_mps) + "," + str(steering_percentage) + "," + str(steering_angle) + "\n")












