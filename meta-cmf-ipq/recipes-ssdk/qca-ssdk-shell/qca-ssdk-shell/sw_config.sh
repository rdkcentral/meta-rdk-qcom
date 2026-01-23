#!/bin/sh
#
# Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
# Licensed under the ISC License

. /lib/ipq.sh

ipq_config_switch()
{

	local lanports=$(syscfg get $(ipq_board_name)-lanports)
	local wanports=$(syscfg get $(ipq_board_name)-wanports)
	local cpu_port=0

	echo "--- $(ipq_board_name)-lanports:$lanports ---" >/dev/console
	echo "--- $(ipq_board_name)-wanports:$wanports ---" >/dev/console
	ssdk_sh vlan entry create 1 > /dev/null
	ssdk_sh vlan entry create 2 > /dev/null

	lanports="${lanports:2}"
	for port_id in ${lanports}
	do
		ssdk_sh vlan member add 1 $port_id untagged > /dev/null
		ssdk_sh portvlan defaultcvid set $port_id 1 > /dev/null
		ssdk_sh portvlan ingress set $port_id secure > /dev/null
                ssdk_sh qos ptmode set $port_id dscp enable > /dev/null
	done

	wanports="${wanports:2}"
	for port_id in ${wanports}
	do
		ssdk_sh vlan member add 2 $port_id untagged > /dev/null
		ssdk_sh portvlan defaultcvid set $port_id 2 > /dev/null
		ssdk_sh portvlan ingress set $port_id secure > /dev/null
                ssdk_sh qos ptmode set $port_id dscp enable > /dev/null
	done

	#setup cpu port
	ssdk_sh portvlan ingress set $cpu_port secure > /dev/null
        ssdk_sh vlan member add 1 $cpu_port tagged > /dev/null
	ssdk_sh vlan member add 2 $cpu_port tagged > /dev/null

}

ipq_config_switch
return 0
