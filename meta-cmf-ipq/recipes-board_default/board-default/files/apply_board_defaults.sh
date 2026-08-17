#Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
#All rights reserved.
#Licensed under the Apache License, Version 2.0

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
   *ipq5424*|*ipq5332*|*ipq5210*)
      echo "board type detected is " $board > /dev/console
      has_qce2204=0
      lan_ifaces=""

      syscfg set wan_physical_ifname_ethname "eth0"
      syscfg set board_default_applied "1"
      syscfg set front_end "auto"
      syscfg set enable_rps "1"

	  # Check if qce2204 switch is present (mirrors QSDK ipq54xx_setup_interfaces)
      if grep -q "qce2204" /proc/device-tree/soc@0/*/switch0@*/compatible 2>/dev/null; then
         has_qce2204=1
         port_count=$(ls /proc/device-tree/soc@0/*/switch0@*/ports/port@*/name 2>/dev/null | wc -l)
         i=1
         while [ "$i" -lt "${port_count:-0}" ]; do
            if [ -n "$lan_ifaces" ]; then
               lan_ifaces="$lan_ifaces lan$i"
            else
               lan_ifaces="lan$i"
            fi
            i=$((i + 1))
         done
      fi

      if [ "$has_qce2204" = "1" ]; then
         syscfg set lan_ethernet_physical_ifnames "$lan_ifaces"
      fi

      syscfg commit
      ;;
   qcom,ipq5332-ap-mi01.2-qce2204)
      syscfg set lan_ethernet_physical_ifnames "eth2 eth3 eth4"
      syscfg set wan_physical_ifname_ethname "eth1"
      syscfg set board_default_applied "1"
      syscfg set front_end "auto"
      syscfg commit
      ;;
   qcom,ipq5424-rdp464-qce2204)
      syscfg set lan_ethernet_physical_ifnames "eth2 eth3 eth4 ath5 eth6"
      syscfg set board_default_applied "1"
      syscfg set front_end "auto"
      syscfg commit
      ;;
esac
