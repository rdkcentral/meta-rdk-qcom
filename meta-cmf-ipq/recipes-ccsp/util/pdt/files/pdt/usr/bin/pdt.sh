#!/bin/sh

# Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
# Licensed under the ISC License

#----------------------------------------------------------------------
# This work is a script which will perform pdt related initializations
# and will be called by pdt.service during bootup.
#----------------------------------------------------------------------

SERVICE_NAME="pdt"

#----------------------------------------------------------------------
#pdt service start
#----------------------------------------------------------------------

pdt_start()
{
        syscfg set mgmt_wan_telnetaccess 1
        syscfg set mgmt_lan_telnetaccess 1
        syscfg commit
        firewall restart
        telnetd
        /usr/sbin/smbd -F &
        touch /tmp/pdt_inited
}


#----------------------------------------------------------------------
#pdt service stop
#----------------------------------------------------------------------

pdt_stop()
{
        kill `pidof telnetd`
        kill `pidof smbd`
        rm /tmp/pdt_inited
}


#----------------------------------------------------------------------
# main entry
#----------------------------------------------------------------------

case "$1" in
    start)
        pdt_start
        ;;
    stop)
        pdt_stop
        ;;
    *)
        echo "Usage: pdt.sh [ start | stop ]" > /dev/console
        exit 3
        ;;
esac

