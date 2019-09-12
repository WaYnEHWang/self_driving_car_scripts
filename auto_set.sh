#! /bin/bash
MODE="Acer S3 Rtk Debug"
MAP="ntpu_0709"
VEHICLE="S3"


FILE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$FILE_DIR/../.."
APOLLO_HOME="$( pwd )"



# change mode
echo "====MODE====="
CURRENT_MODE="$( ./bazel-bin/modules/common/kv_db/kv_db_tool --op get --key "/apollo/hmi/status:current_mode" )"
if [ "$CURRENT_MODE" != "$MODE" ]; then
	./bazel-bin/modules/common/kv_db/kv_db_tool --op put --key "/apollo/hmi/status:current_mode" --value "$MODE"
	echo "mode has been set to $MODE."
else
	echo "mode has already been set to $MODE."
fi


#change map
echo "=====MAP====="
RET="$( grep 'map_dir' $APOLLO_HOME/modules/common/data/global_flagfile.txt | awk -F "/" 'END{print $NF}' )"
if [ "$RET" != "$MAP" ]; then
	echo "--map_dir=/apollo/modules/map/data/$MAP" >> $APOLLO_HOME/modules/common/data/global_flagfile.txt
	echo "It've been changed to $MAP."
else
	echo "$MAP is already the newest map."
fi


#change vehicle
echo "===VEHICLE==="
ret="$( diff $APOLLO_HOME/modules/calibration/data/$VEHICLE/vehicle_param.pb.txt $APOLLO_HOME/modules/common/data/vehicle_param.pb.txt)"
if [ "$ret" == "" ]; then
	echo "$VEHICLE vehicle does not need to change."
else
	cp /apollo/modules/calibration/data/S3/vehicle_param.pb.txt /apollo/modules/common/data/vehicle_param.pb.txt
	cp /apollo/modules/calibration/data/S3/control_conf.pb.txt /apollo/modules/control/conf/control_conf.pb.txt
	cp /apollo/modules/calibration/data/S3/cancard_params/canbus_conf.pb.txt /apollo/modules/canbus/conf/canbus_conf.pb.txt
	cp /apollo/modules/calibration/data/S3/navigation_lincoln.pb.txt /apollo/modules/control/conf/navigation_lincoln.pb.txt
	cp /apollo/modules/calibration/data/S3/velodyne_params /apollo/modules/drivers/velodyne/params
	cp /apollo/modules/calibration/data/S3/velodyne_params /apollo/modules/localization/msf/params/velodyne_params
	cp /apollo/modules/calibration/data/S3/velodyne_params /apollo/modules/perception/data/params
	cp /apollo/modules/calibration/data/S3/camera_params /apollo/modules/perception/data/params
	cp /apollo/modules/calibration/data/S3/radar_params /apollo/modules/perception/data/params
	cp /apollo/modules/calibration/data/S3/gnss_params/ant_imu_leverarm.yaml /apollo/modules/localization/msf/params/gnss_params/ant_imu_leverarm.yaml
	cp /apollo/modules/calibration/data/S3/vehicle_params /apollo/modules/localization/msf/params/vehicle_params
	cp /apollo/modules/calibration/data/S3/vehicle_info.pb.txt /apollo/modules/tools/ota/vehicle_info.pb.txt
	echo "$VEHICLE's configure has been set."
fi

