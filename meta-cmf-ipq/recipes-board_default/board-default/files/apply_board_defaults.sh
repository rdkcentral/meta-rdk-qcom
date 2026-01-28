#!/bin/sh
#
# Copyright (c) 2018, 2022-2023 Qualcomm Innovation Center, Inc. All rights reserved.
# Licensed under the ISC License
#
# This file sets board specific default parameters.

. /lib/ipq.sh

# Control flag to run this script only once.
# board_default_applied values :
#       0 : board default parameters not applied.
#       1 : board default parameters applied.
IS_APPLIED=`syscfg get "board_default_applied"`

[ "$IS_APPLIED" = "1" ] && echo "Not applying Board defaults" > /dev/console && exit

board=$(ipq_board_name)
echo $board

case "$board" in
   ap-dk04.1-c1 | ap-dk07.1-c1)
      echo "board type detected is " $board > /dev/console
      syscfg set lan_ethernet_physical_ifnames "eth1"
      syscfg set wan_physical_ifname_ethname "eth0"
      syscfg set board_default_applied "1"
      syscfg set front_end "sfe"
      syscfg commit
      ;;
   qcom,ipq9574-ap-al01-c1 | qcom,ipq9574-ap-al02-c1 | qcom,ipq9574-ap-al02-c2 | qcom,ipq9574-ap-al02-c3 | qcom,ipq9574-ap-al02-c4 | qcom,ipq9574-ap-al02-c5 | qcom,ipq9574-ap-al02-c10)
      echo "board type detected is " $board > /dev/console
      syscfg set board_default_applied "1"
      syscfg set front_end "auto"
      syscfg set enable_rps "1"
      syscfg commit
      ;;
   ap-hk01-c2)
      syscfg set lan_ethernet_physical_ifnames "eth0 eth1 eth2 eth3 eth4"
      syscfg set wan_physical_ifname_ethname "eth5"
      syscfg set board_default_applied "1"
      syscfg set front_end "nss"
      syscfg set enable_rps "1"
      syscfg commit
      ;;
   ap-hk02)
      syscfg set lan_ethernet_physical_ifnames "eth1 eth2"
      syscfg set wan_physical_ifname_ethname "eth0"
      syscfg set board_default_applied "1"
      syscfg set front_end "nss"
      syscfg set enable_rps "1"
      syscfg commit
      ;;
   *ap-hk14*)
      syscfg set lan_ethernet_physical_ifnames "eth0 eth1 eth2 eth3"
      syscfg set wan_physical_ifname_ethname "eth4"
      syscfg set board_default_applied "1"
      syscfg set front_end "nss"
      syscfg set enable_rps "1"
      syscfg commit
      ;;
   *ap-hk09*)
      syscfg set lan_ethernet_physical_ifnames "eth0 eth1 eth2 eth3 eth5"
      syscfg set wan_physical_ifname_ethname "eth4"
      syscfg set board_default_applied "1"
      syscfg set front_end "nss"
      syscfg set enable_rps "1"
      syscfg commit
      ;;
esac
