#!/bin/sh
##########################################################################
# If not stated otherwise in this file or this component's LICENSE file the
# following copyright and licenses apply:
#
# Copyright 2018 RDK Management
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
# Copyright (c) 2022 Qualcomm Innovation Center, Inc. All rights reserved.
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

#### To generate the server.pem by using openssl
#### For support HTTPS port in Remote Management

if [ ! -f /etc/server.pem ]; then
openssl req -newkey rsa:2048 -new -nodes -x509 -days 3650 -subj /C=IN/ST=TN/L=Bangalore/O=Example_Org/CN=*.example.org -keyout /etc/key.pem -out /etc/cert.pem
cat /etc/key.pem > /etc/server.pem
cat /etc/cert.pem >> /etc/server.pem
rm /etc/key.pem /etc/cert.pem
fi

##### set the value of eth_wan_mac #####
WAN_INTERFACE=`ifconfig erouter0 | grep erouter0 | wc -l`
if [ $WAN_INTERFACE -eq 1 ]; then
MACADDRESS=`ifconfig erouter0 | grep HWaddr | cut -d ' ' -f7`
sysevent set eth_wan_mac $MACADDRESS
fi
