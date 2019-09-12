#! /bin/bash

FILE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${FILE_DIR}/../../scripts/apollo_base.sh"

#Turn the modules on


#Recorder
nohup python /apollo/scripts/record_bag_acer.py &

#Localization
nohup mainboard -d /apollo/modules/localization/dag/dag_streaming_rtk_localization.dag &
sleep 1
echo "==turn Localization on=="

#GPS
nohup mainboard -d /apollo/modules/drivers/gnss/dag/gnss.dag &
sleep 1
echo "==turn GPS on=="

#Transform
nohup mainboard -d /apollo/modules/transform/dag/static_transform.dag &
sleep 1
echo "==turn Transform on=="

#Perception
nohup mainboard -d /apollo/modules/perception/production/dag/dag_streaming_perception_hdl-32e.dag &
sleep 1
echo "==turn Perception on=="

#Velodyne
nohup mainboard -d /apollo/modules/drivers/velodyne/dag/velodyne32.dag &
sleep 1
echo "==turn Velodyne on=="

#Prediction
nohup mainboard -d /apollo/modules/prediction/dag/prediction.dag &
sleep 1
echo "==turn Prediction on=="

#Routing
nohup mainboard -d /apollo/modules/routing/dag/routing.dag &
sleep 1
echo "==turn Routing on=="

#Planning
nohup mainboard -d /apollo/modules/planning/dag/planning.dag &
sleep 1
echo "==turn Planning on=="

#Log
nohup mainboard -d /apollo/modules/log/dag/log.dag &
sleep 1
echo "==turn Log on=="

#Control
nohup mainboard -d /apollo/modules/control/dag/control.dag &
sleep 1
echo "==turn Control on=="

#Canbus
nohup mainboard -d /apollo/modules/canbus/dag/canbus.dag &
sleep 1
echo "==turn Canbus on=="


