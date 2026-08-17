#!/bin/sh
#Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
#All rights reserved.
#Licensed under the Apache License, Version 2.0

echo "onewifi pre" > /tmp/onewifi_soc.log

#buffer overrun causes I/O starvation and journald buffer backpressure
echo 0x10 > /sys/module/ath12k/parameters/debug_mask
# -----------------------------------------------------------------------
# Argument handling
#
#   Mode is stored in syscfg (persists across reboots in /nvram/syscfg.db):
#     syscfg key : wifi_mode
#     values     : "hostapd"  -> run hostapd instead of onewifi
#                  "onewifi"  -> run onewifi (default / unset)
#
#   A single onewifi.service handles both modes:
#     ExecStartPre -> onewifi_pre_start.sh  (this script, no arg)
#     ExecStart    -> wifi_mode_start.sh    (runs hostapd OR onewifi binary)
#
#   To switch modes call this script directly with an argument.
#   systemctl restart onewifi is called automatically to apply the change.
#
#   Direct usage:
#     sh /usr/ccsp/wifi/onewifi_pre_start.sh hostapd  # switch to hostapd
#     sh /usr/ccsp/wifi/onewifi_pre_start.sh onewifi  # switch to onewifi
#
#   $1 = "hostapd"  -> set syscfg wifi_mode=hostapd, restart onewifi service
#   $1 = "onewifi"  -> set syscfg wifi_mode=onewifi,  restart onewifi service
#   (no arg)        -> ExecStartPre logic (called by systemd)
# -----------------------------------------------------------------------
case "$1" in

    hostapd)
        # ---------------------------------------------------------------
        # Switch to hostapd mode
        # Invoke directly: sh onewifi_pre_start.sh hostapd
        # ---------------------------------------------------------------
        echo "arg=hostapd: setting wifi_mode=hostapd and restarting service" >> /tmp/onewifi_soc.log
        syscfg set wifi_mode hostapd
        syscfg commit
        # Restart the single onewifi service; ExecStartPre + ExecStart will
        # pick up the new mode automatically.
        systemctl restart onewifi &
        exit 0
        ;;

    onewifi)
        # ---------------------------------------------------------------
        # Switch back to onewifi mode
        # Invoke directly: sh onewifi_pre_start.sh onewifi
        # ---------------------------------------------------------------
        echo "arg=onewifi: setting wifi_mode=onewifi and restarting service" >> /tmp/onewifi_soc.log
        syscfg set wifi_mode onewifi
        syscfg commit
        # Restart the single onewifi service; systemd will SIGTERM the
        # currently running process (hostapd or onewifi) before restarting.
        systemctl restart onewifi &
        exit 0
        ;;

    "")
        # No argument — fall through to ExecStartPre logic below
        ;;

    *)
        echo "Usage: $0 [hostapd|onewifi]" >&2
        echo "  hostapd  - switch to hostapd mode (restarts onewifi.service)" >&2
        echo "  onewifi  - switch to onewifi mode (restarts onewifi.service)" >&2
        echo "  (no arg) - ExecStartPre sequence called by systemd" >&2
        exit 1
        ;;
esac

# -----------------------------------------------------------------------
# ExecStartPre logic (called by systemd with no argument)
# Performs mode-appropriate setup before ExecStart runs.
# -----------------------------------------------------------------------
WIFI_MODE=$(syscfg get wifi_mode 2>/dev/null)

if [ "$WIFI_MODE" = "hostapd" ]; then
    # -------------------------------------------------------------------
    # hostapd pre-start: wait for driver, add AP interface, create socket dir
    # -------------------------------------------------------------------
    echo "wifi_mode=hostapd: hostapd pre-start" >> /tmp/onewifi_soc.log

    while [ ! -e /sys/class/net/wlan0 ]; do sleep 1; done

    # Clean up any stale hostapd runtime directory from a previous run
    rm -rf /var/run/hostapd

    iw phy phy00 interface add phy00-mld3 type __ap
    mkdir -p /var/run/hostapd

    echo "hostapd pre-start done" >> /tmp/onewifi_soc.log
    exit 0
fi

# -----------------------------------------------------------------------
# Normal OneWiFi pre-start logic
# -----------------------------------------------------------------------
echo "wifi_mode=onewifi: normal pre-start" >> /tmp/onewifi_soc.log

# Wait for wlan0 (wifi driver) to be ready before proceeding
while [ ! -e /sys/class/net/wlan0 ]; do sleep 1; done
touch /tmp/wifi_driver_initialized

iw dev wlan0 del

# Fetch persisted MAC addresses
mld_parent_mac=$(qc-config get wireless.mld0.macaddr 2>/dev/null | grep -oE '([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2}')
mld0_link_mac=$(qc-config get wireless.mld0.linkmacaddr 2>/dev/null | grep -oE '([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2}')
mld1_link_mac=$(qc-config get wireless.mld1.linkmacaddr 2>/dev/null | grep -oE '([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2}')
mld6_link_mac=$(qc-config get wireless.mld6.linkmacaddr 2>/dev/null | grep -oE '([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2}')
mld2_link_mac=$(qc-config get wireless.mld2.linkmacaddr 2>/dev/null | grep -oE '([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2}')
mld3_link_mac=$(qc-config get wireless.mld3.linkmacaddr 2>/dev/null | grep -oE '([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2}')
mld7_link_mac=$(qc-config get wireless.mld7.linkmacaddr 2>/dev/null | grep -oE '([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2}')
mld_bh_parent_mac=$(qc-config get wireless.mld1.macaddr 2>/dev/null | grep -oE '([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2}')

# mld0
if [ -n "$mld0_link_mac" ]; then
    iw phy phy00 interface add mld0 type __ap addr "$mld0_link_mac"
else
    iw phy phy00 interface add mld0 type __ap
fi

# mld1
if [ -n "$mld1_link_mac" ]; then
    iw phy phy00 interface add mld1 type __ap addr "$mld1_link_mac"
else
    iw phy phy00 interface add mld1 type __ap
fi

# mld6
if [ -n "$mld6_link_mac" ]; then
    iw phy phy00 interface add mld6 type __ap addr "$mld6_link_mac"
else
    iw phy phy00 interface add mld6 type __ap
fi

# phy00-mld0
if [ -n "$mld_parent_mac" ]; then
    iw phy phy00 interface add phy00-mld0 type __ap addr "$mld_parent_mac"
else
    iw phy phy00 interface add phy00-mld0 type __ap
fi

if [ -n "$mld_bh_parent_mac" ]; then
    iw phy phy00 interface add phy00-mld1 type __ap addr "$mld_bh_parent_mac"
fi

if [ -n "$mld2_link_mac" ]; then
    iw phy phy00 interface add mld2 type __ap addr "$mld2_link_mac"
fi
if [ -n "$mld3_link_mac" ]; then
    iw phy phy00 interface add mld3 type __ap addr "$mld3_link_mac"
fi
if [ -n "$mld7_link_mac" ]; then
    iw phy phy00 interface add mld7 type __ap addr "$mld7_link_mac"
fi

if [ -f /nvram/EasymeshCfg.json ]; then
    while true; do
        AL_MAC=$(cat /sys/class/net/eth0/address 2>/dev/null)

        if [ -z "$AL_MAC" ] || [ "$AL_MAC" = "00:00:00:00:00:00" ]; then
            AL_MAC=$(cat /sys/class/net/brlan0/address 2>/dev/null)
        fi

        if [ -z "$AL_MAC" ] || [ "$AL_MAC" = "00:00:00:00:00:00" ]; then
            AL_MAC=$(cat /sys/class/net/wlan0/address 2>/dev/null)
        fi

        if [ -n "$AL_MAC" ] && [ "$AL_MAC" != "00:00:00:00:00:00" ]; then
            break
        fi
        sleep 1
    done
    sed -i "s/\"AL_MAC_ADDR\".*/\"AL_MAC_ADDR\": \"$AL_MAC\",/" /nvram/EasymeshCfg.json
fi
