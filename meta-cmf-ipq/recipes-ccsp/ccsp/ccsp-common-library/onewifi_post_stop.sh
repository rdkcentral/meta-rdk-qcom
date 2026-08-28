#!/bin/sh
#Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
#All rights reserved.
#Licensed under the Apache License, Version 2.0

# Delete all VAPs including wlan0
for iface in $(iw dev | awk '/Interface/{print $2}'); do
    iw dev "$iface" del 2>/dev/null || true
done

# Recreate wlan0 so pre_start.sh wlan0 check passes on restart
iw phy phy00 interface add wlan0 type __ap

