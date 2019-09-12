#! /bin/bash
echo "----turn off modules----"

FILE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${FILE_DIR}/../../scripts/apollo_base.sh"

#Turn the modules off first
/apollo/scripts/kill_recorder_process.sh
sleep 0.1
pkill -f "/apollo/modules/canbus/dag/canbus.dag"
sleep 0.1
pkill -f "/apollo/modules/control/dag/control.dag"
sleep 0.1
pkill -f "/apollo/modules/drivers/gnss/dag/gnss.dag"
sleep 0.1
pkill -f "/apollo/modules/localization/dag/dag_streaming_rtk_localization.dag"
sleep 0.1
pkill -f "/apollo/modules/log/dag/log.dag"
sleep 0.1
pkill -f "/apollo/modules/perception/production/dag/dag_streaming_perception_hdl-32e.dag"
sleep 0.1
pkill -f "/apollo/modules/planning/dag/planning.dag"
sleep 0.1
pkill -f "/apollo/modules/prediction/dag/prediction.dag"
sleep 0.1
pkill -f "/apollo/modules/routing/dag/routing.dag"
sleep 0.1
pkill -f "/apollo/modules/transform/dag/static_transform.dag"
sleep 0.1
pkill -f "/apollo/modules/drivers/velodyne/dag/velodyne32.dag"
sleep 0.1
