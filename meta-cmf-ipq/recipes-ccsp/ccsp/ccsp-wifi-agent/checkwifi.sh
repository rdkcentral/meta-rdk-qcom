#!/bin/sh
##########################################################################
# If not stated otherwise in this file or this component's LICENSE file the
# following copyright and licenses apply:
#
# Copyright 2015 RDK Management
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
##########################################################################

# Changes from Qualcomm Innovation Center, Inc. are provided under the following license:
# Copyright (c) 2017 Qualcomm Innovation Center, Inc. All rights reserved.
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
##########################################################################

wlan0=$(iwconfig ath0|grep IEEE\ 802.11)
wifi_driver_init=${#wlan0}
check_dual_band=1
if [ $wifi_driver_init != 0 ]; then
	echo "Wifi (single band) driver is initialized"
        while [ $check_dual_band -le 5 ]
        do
           echo "checking for dual band support:$check_dual_band"
           wlan1=$(iwconfig ath1|grep IEEE\ 802.11)
           wifi_dual_band=${#wlan1}
           if [ $wifi_dual_band != 0 ]; then
               break
           fi
           check_dual_band=`expr $check_dual_band + 1`
           sleep 1;
        done
	sleep 1;
	touch /tmp/wifi_driver_initialized
else
	echo "Wifi driver is not initialized"
fi
