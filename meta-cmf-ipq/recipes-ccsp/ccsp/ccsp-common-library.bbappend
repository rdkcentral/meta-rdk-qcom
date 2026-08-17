require ccsp_common_ipq.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

DEPENDS_append_ipq = " breakpad"
DEPENDS_append_dunfell = " ${@bb.utils.contains('DISTRO_FEATURES', 'safec', ' safec', ' ', d)}"
CXXFLAGS_append_ipq = " \
                                -I${STAGING_INCDIR}/breakpad \
                                -std=c++11 \
                              "
SOC="${@d.getVar('SOC_FAMILY', d, 1).split(':')[1]}"
export SOC_T = "${@d.getVar('SOC', d, 0).split('_')[0]}"
CFLAGS_remove += " -Werror"

SRC_URI_append = " \
    file://gwprovapp.conf \
    file://ccsp_vendor.h \
    file://wifiinitialized.service \
    file://wifiinitialized.path \
    file://onewifiinitialized.path \
    file://onewifi_post_start.sh \
    file://onewifi_pre_start.sh \
    file://onewifi_post_stop.sh \
    file://wifi-initialized.target \
    file://if_check.sh \
    file://003-wifiagent-service.patch \
    file://002-6G-CommonLib-change.patch \
    file://hostapd-wifi.service \
    file://hostapd-phy00.0.conf \
    file://hostapd-phy00.1.conf \
    file://hostapd-phy00.2.conf \
"

# we need to patch to code for ipq
SRC_URI_remove_dunfell = "file://0001-DBusLoop-SSL_state-TLS_ST_OK.patch"

SRC_URI_append_dunfell = " file://0001-DBusLoop-SSL_state-TLS_ST_OK.patch;apply=no"
SRC_URI_append_dunfell = " file://002-6G-CommonLib-change.patch"
SRC_URI_append_dunfell = " file://Changes_for_snmpSubagent.patch"

addtask ipq_patches_kirkstone after do_unpack before do_configure

do_configure_prepend_aarch64() {
	sed -e '/len/ s/^\/*/\/\//' -i ${S}/source/ccsp/components/common/DataModel/dml/components/DslhObjRecord/dslh_objro_access.c
}

do_install_append_class-target () {
    # Config files and scripts
    install -m 777 ${S}/scripts/cli_start_arm.sh ${D}/usr/ccsp/cli_start.sh
    install -m 777 ${S}/scripts/cosa_start_arm.sh ${D}/usr/ccsp/cosa_start.sh

    # we need unix socket path
    echo "unix:path=/var/run/dbus/system_bus_socket" > ${S}/config/ccsp_msg.cfg
    install -m 644 ${S}/config/ccsp_msg.cfg ${D}/usr/ccsp/ccsp_msg.cfg
    install -m 644 ${S}/config/ccsp_msg.cfg ${D}/usr/ccsp/cm/ccsp_msg.cfg
    install -m 644 ${S}/config/ccsp_msg.cfg ${D}/usr/ccsp/mta/ccsp_msg.cfg
    install -m 644 ${S}/config/ccsp_msg.cfg ${D}/usr/ccsp/pam/ccsp_msg.cfg
    install -m 644 ${S}/config/ccsp_msg.cfg ${D}/usr/ccsp/tr069pa/ccsp_msg.cfg

    install -m 777 ${S}/systemd_units/scripts/ccspSysConfigEarly.sh ${D}/usr/ccsp/ccspSysConfigEarly.sh
    install -m 777 ${S}/systemd_units/scripts/ccspSysConfigLate.sh ${D}/usr/ccsp/ccspSysConfigLate.sh
    install -m 777 ${S}/systemd_units/scripts/utopiaInitCheck.sh ${D}/usr/ccsp/utopiaInitCheck.sh
    install -m 777 ${S}/systemd_units/scripts/ccspPAMCPCheck.sh ${D}/usr/ccsp/ccspPAMCPCheck.sh

    install -m 777 ${S}/systemd_units/scripts/ProcessResetCheck.sh ${D}/usr/ccsp/ProcessResetCheck.sh
    sed -i -e "s/source \/rdklogger\/logfiles.sh;syncLogs_nvram2/#source \/rdklogger\/logfiles.sh;syncLogs_nvram2/g" ${D}/usr/ccsp/ProcessResetCheck.sh
    # install systemd services
    install -d ${D}${systemd_unitdir}/system
    install -D -m 0644 ${S}/systemd_units/CcspCrSsp.service ${D}${systemd_unitdir}/system/CcspCrSsp.service
    install -D -m 0644 ${S}/systemd_units/CcspPandMSsp.service ${D}${systemd_unitdir}/system/CcspPandMSsp.service
    install -D -m 0644 ${S}/systemd_units/PsmSsp.service ${D}${systemd_unitdir}/system/PsmSsp.service
    install -D -m 0644 ${S}/systemd_units/rdkbLogMonitor.service ${D}${systemd_unitdir}/system/rdkbLogMonitor.service
    install -D -m 0644 ${S}/systemd_units/CcspTandDSsp.service ${D}${systemd_unitdir}/system/CcspTandDSsp.service
    install -D -m 0644 ${S}/systemd_units/CcspLMLite.service ${D}${systemd_unitdir}/system/CcspLMLite.service
    install -D -m 0644 ${S}/systemd_units/CcspTr069PaSsp.service ${D}${systemd_unitdir}/system/CcspTr069PaSsp.service
    install -D -m 0644 ${S}/systemd_units/snmpSubAgent.service ${D}${systemd_unitdir}/system/snmpSubAgent.service
    install -D -m 0644 ${S}/systemd_units/CcspEthAgent.service ${D}${systemd_unitdir}/system/CcspEthAgent.service
    install -D -m 0644 ${S}/systemd_units/notifyComp.service ${D}${systemd_unitdir}/system/notifyComp.service
    install -D -m 0644 ${S}/systemd_units/CcspTelemetry.service ${D}${systemd_unitdir}/system/CcspTelemetry.service
    install -D -m 0644 ${S}/systemd_units/gwprovapp.service ${D}${systemd_unitdir}/system/gwprovapp.service

    sed -i 's|/usr/ccsp/notify-comp|/tmp|' ${D}/${systemd_unitdir}/system/notifyComp.service
    #rfc service file
    install -D -m 0644 ${S}/systemd_units/rfc.service ${D}${systemd_unitdir}/system/rfc.service

    install -D -m 0644 ${WORKDIR}/wifiinitialized.service ${D}${systemd_unitdir}/system/wifiinitialized.service

    install -D -m 0644 ${WORKDIR}/wifiinitialized.path ${D}${systemd_unitdir}/system/wifiinitialized.path

    install -D -m 0644 ${WORKDIR}/wifi-initialized.target ${D}${systemd_unitdir}/system/wifi-initialized.target

install -D -m 0644 ${WORKDIR}/onewifiinitialized.path ${D}${systemd_unitdir}/system/onewifiinitialized.path

    install -D -m 0644 ${WORKDIR}/gwprovapp.conf ${D}${systemd_unitdir}/system/gwprovapp.service.d/gwprovapp.conf
    install -D -m 0644 ${S}/systemd_units/ProcessResetDetect.service ${D}${systemd_unitdir}/system/ProcessResetDetect.service
    install -D -m 0644 ${S}/systemd_units/ProcessResetDetect.path ${D}${systemd_unitdir}/system/ProcessResetDetect.path
    install -D -m 0644 ${S}/systemd_units/RdkPppManager.service ${D}${systemd_unitdir}/system/RdkPppManager.service
    install -D -m 0644 ${S}/systemd_units/RdkGponManager.service ${D}${systemd_unitdir}/system/RdkGponManager.service

     sed -i -e '/ConditionPathExists/d' ${D}${systemd_unitdir}/system/gwprovapp.service
    sed -i  '/Description=/a ConditionPathExists=/tmp/fontanaenabled' ${D}${systemd_unitdir}/system/RdkGponManager.service
    sed -i '/ExecStop=/a ExecStopPost= /bin/sh -c "/etc/init.d/omci_done stop"' ${D}${systemd_unitdir}/system/RdkGponManager.service


    # Install wrapper for breakpad (disabled to support External Source build)
    #install -d ${D}${includedir}/ccsp
    #install -m 644 ${S}/source/breakpad_wrapper/include/breakpad_wrapper.h ${D}${includedir}/ccsp

    # Install "vendor information"
    install -m 0644 ${WORKDIR}/ccsp_vendor.h ${D}${includedir}/ccsp

    sed -i -- 's/NotifyAccess=.*/#NotifyAccess=main/g' ${D}${systemd_unitdir}/system/CcspCrSsp.service
    sed -i -- 's/notify.*/forking/g' ${D}${systemd_unitdir}/system/CcspCrSsp.service

    #copy rfc.properties into nvram
    sed -i '/ExecStartPre/ a\ExecStartPre=-/bin/cp /etc/rfc.properties /nvram/' ${D}${systemd_unitdir}/system/rfc.service
    sed -i 's#${PARODUS_START_LOG_FILE}#/rdklogs/logs/dcmrfc.log#g' ${D}${systemd_unitdir}/system/rfc.service
    sed -i 's/rfc.service /RFCbase.sh /g' ${D}${systemd_unitdir}/system/rfc.service
    #reduce sleep time to 12 sconds
    sed -i 's/300/12/g' ${D}${systemd_unitdir}/system/rfc.service

    #Remove pre execution script validation from Psm service
    sed -i "/utopiaInitCheck.sh/d" ${D}${systemd_unitdir}/system/PsmSsp.service
    sed -i "/log_psm.db.sh/d" ${D}${systemd_unitdir}/system/PsmSsp.service

    sed -i "/device.properties/a ExecStartPre=/bin/sh -c '(/usr/ccsp/utopiaInitCheck.sh)'"  ${D}${systemd_unitdir}/system/CcspPandMSsp.service
DISTRO_OneWiFi_ENABLED="${@bb.utils.contains('DISTRO_FEATURES','OneWifi','true','false',d)}"
if [ $DISTRO_OneWiFi_ENABLED = 'false' ]; then
    sed -i "/CcspPandMSsp.service/a After=qcawifi.service" ${D}${systemd_unitdir}/system/ccspwifiagent.service
    sed -i "/device.properties/a ExecStartPre=/bin/touch /nvram/wifienable" ${D}${systemd_unitdir}/system/ccspwifiagent.service
    sed -i "/PROCESS_RESTART_LOG/a ExecStartPost=/bin/sh  -c '(/usr/ccsp/wifi/bridge_mode.sh)'" ${D}${systemd_unitdir}/system/ccspwifiagent.service
fi

    sed -i "/Description=CcspCrSsp service/a After=disable_systemd_restart_param.service" ${D}${systemd_unitdir}/system/CcspCrSsp.service

    #snmp module support
    #sed -i "/tcp\:192.168.254.253\:705/a  ExecStart=\/usr\/bin\/snmp_subagent \&" ${D}${systemd_unitdir}/system/snmpSubAgent.service

    #Telemetry support
    sed -i "/Type=oneshot/a EnvironmentFile=\/etc/\device.properties" ${D}${systemd_unitdir}/system/CcspTelemetry.service
    sed -i "/EnvironmentFile=\/etc\/device.properties/a EnvironmentFile=\/etc\/dcm.properties" ${D}${systemd_unitdir}/system/CcspTelemetry.service
    sed -i "/EnvironmentFile=\/etc\/dcm.properties/a ExecStartPre=\/bin\/sh -c '\/bin\/touch \/rdklogs\/logs\/dcmscript.log'" ${D}${systemd_unitdir}/system/CcspTelemetry.service
    sed -i "s/ExecStart=\/bin\/sh -c '\/lib\/rdk\/dcm.service \&'/ExecStart=\/bin\/sh -c '\/lib\/rdk\/StartDCM.sh \>\> \/rdklogs\/logs\/telemetry.log \&'/g" ${D}${systemd_unitdir}/system/CcspTelemetry.service
    sed -i 's~ExecStop=/usr/bin/killall telemetry2_0~ExecStop=/bin/sh -c '\''pidof telemetry2_0 \&\& killall telemetry2_0 || echo "Process not running"'\''~' ${D}${systemd_unitdir}/system/CcspTelemetry.service
    sed -i "s/wan-initialized.target/multi-user.target/g" ${D}${systemd_unitdir}/system/CcspTelemetry.service
    install -D -m 0644 ${S}/systemd_units/CcspXdnsSsp.service ${D}${systemd_unitdir}/system/CcspXdnsSsp.service
    install -d ${D}${base_libdir}/rdk
    install -m 755 ${WORKDIR}/if_check.sh ${D}${base_libdir}/rdk/

    #WanManager - RdkWanManager.service
    DISTRO_WAN_ENABLED="${@bb.utils.contains('DISTRO_FEATURES','rdkb_wan_manager','true','false',d)}"
    if [ $DISTRO_WAN_ENABLED = 'true' ]; then
        install -D -m 0644 ${S}/systemd_units/RdkWanManager.service ${D}${systemd_unitdir}/system/RdkWanManager.service
        sed -i "/WorkingDirectory/a ExecStartPre=/bin/sh /lib/rdk/run_rm_key.sh" ${D}${systemd_unitdir}/system/RdkWanManager.service
        sed -i "s/After=CcspCrSsp.service/After=CcspCrSsp.service utopia.service /g" ${D}${systemd_unitdir}/system/RdkWanManager.service
        sed -i "/Restart=always/a TimeoutStopSec=5" ${D}${systemd_unitdir}/system/RdkWanManager.service
        sed -i "s/CcspPandMSsp.service/CcspCrSsp.service CcspPandMSsp.service/g" ${D}${systemd_unitdir}/system/CcspEthAgent.service
        install -D -m 0644 ${S}/systemd_units/RdkTelcoVoiceManager.service ${D}${systemd_unitdir}/system/RdkTelcoVoiceManager.service
        install -D -m 0644 ${S}/systemd_units/RdkVlanManager.service ${D}${systemd_unitdir}/system/RdkVlanManager.service
	sed -i "s/After=CcspCrSsp.service/After=CcspCrSsp.service PsmSsp.service/g" ${D}${systemd_unitdir}/system/RdkVlanManager.service
        install -D -m 0644 ${S}/systemd_units/CcspAdvSecuritySsp.service ${D}${systemd_unitdir}/system/CcspAdvSecuritySsp.service
        sed -i "s/wan-initialized.target/multi-user.target/g" ${D}${systemd_unitdir}/system/CcspAdvSecuritySsp.service
    fi

    DISTRO_FW_ENABLED="${@bb.utils.contains('DISTRO_FEATURES','fwupgrade_manager','true','false',d)}"
    if [ $DISTRO_FW_ENABLED = 'true' ]; then
        install -D -m 0644 ${S}/systemd_units/RdkFwUpgradeManager.service ${D}${systemd_unitdir}/system/RdkFwUpgradeManager.service
    fi

    ##### erouter0 ip issue
    sed -i '/Factory/a \
IsErouterRunningStatus=\`ifconfig erouter0 | grep RUNNING | grep -v grep | wc -l\` \
if [ \"\$IsErouterRunningStatus\" == 0 ]; then \
ethtool -s erouter0 speed 1000 \
fi' ${D}/usr/ccsp/ccspPAMCPCheck.sh

DISTRO_OneWiFi_ENABLED="${@bb.utils.contains('DISTRO_FEATURES','OneWifi','true','false',d)}"
     if [ $DISTRO_OneWiFi_ENABLED = 'true' ]; then
         install -D -m 0644 ${S}/systemd_units/onewifi.service ${D}${systemd_unitdir}/system/onewifi.service

         # Disable OneWifi entirely when the kernel is booted with ftm_mode
         sed -i '/^After=/a ConditionKernelCommandLine=!wifi_ftm_mode' ${D}${systemd_unitdir}/system/onewifi.service

         sed -i "/OSW_DRV_TARGET_DISABLED=1/a ExecStartPre=\/bin\/sh \/usr\/ccsp\/wifi\/onewifi_pre_start.sh"  ${D}${systemd_unitdir}/system/onewifi.service
         sed -i "/\$Subsys/a ExecStartPost=\/bin\/sh \/usr\/ccsp\/wifi\/onewifi_post_start.sh"  ${D}${systemd_unitdir}/system/onewifi.service
        install -D -m 0644 ${WORKDIR}/onewifi_pre_start.sh ${D}/usr/ccsp/wifi/onewifi_pre_start.sh
        install -D -m 0644 ${WORKDIR}/onewifi_post_start.sh ${D}/usr/ccsp/wifi/onewifi_post_start.sh
        install -D -m 0644 ${WORKDIR}/onewifi_post_stop.sh ${D}/usr/ccsp/wifi/onewifi_post_stop.sh
        sed -i '/Restart=always/a [Install]' ${D}${systemd_unitdir}/system/onewifi.service
        sed -i '/\[Install\]/a WantedBy=multi-user.target' ${D}${systemd_unitdir}/system/onewifi.service
        sed -i "/onewifi_post_start.sh/a ExecStopPost=\/bin\/sh \/usr\/ccsp\/wifi\/onewifi_post_stop.sh" ${D}${systemd_unitdir}/system/onewifi.service

        # Install hostapd-wifi.service (installed but NOT enabled; kept as reference)
        install -D -m 0644 ${WORKDIR}/hostapd-wifi.service ${D}${systemd_unitdir}/system/hostapd-wifi.service

        # ---------------------------------------------------------------
        # Create wifi_mode_start.sh — the ExecStart wrapper for onewifi.service.
        # It reads syscfg wifi_mode at runtime and exec's either hostapd or
        # the original onewifi binary, so the service is always "active/running"
        # regardless of mode.  No ExecCondition / masking needed.
        # ---------------------------------------------------------------
        # Extract the original ExecStart command from the installed service file
        ORIG_EXEC=$(grep '^ExecStart=' ${D}${systemd_unitdir}/system/onewifi.service | sed 's/^ExecStart=//')

        # Write the wrapper script
        {
            printf '#!/bin/sh\n'
            printf '# wifi_mode_start.sh\n'
            printf '# ExecStart wrapper for onewifi.service.\n'
            printf '# Runs hostapd or the onewifi binary based on syscfg wifi_mode.\n'
            printf 'WIFI_MODE=$(syscfg get wifi_mode 2>/dev/null)\n'
            printf 'if [ "$WIFI_MODE" = "hostapd" ]; then\n'
            printf '    exec /usr/sbin/hostapd -dddtK -g /var/run/hostapd/global \\\n'
            printf '        /nvram/hostapd-phy00.0.conf \\\n'
            printf '        /nvram/hostapd-phy00.1.conf \\\n'
            printf '        /nvram/hostapd-phy00.2.conf\n'
            printf 'fi\n'
            printf '# Default: start onewifi\n'
            printf 'exec %s\n' "$ORIG_EXEC"
        } > ${D}/usr/ccsp/wifi/wifi_mode_start.sh
        chmod 755 ${D}/usr/ccsp/wifi/wifi_mode_start.sh

        # Replace ExecStart in onewifi.service with the wrapper script
        sed -i 's|^ExecStart=.*|ExecStart=/bin/sh /usr/ccsp/wifi/wifi_mode_start.sh|' \
            ${D}${systemd_unitdir}/system/onewifi.service

        # Install hostapd conf files to /nvram so they persist across reboots
        install -d ${D}/nvram
        install -D -m 0644 ${WORKDIR}/hostapd-phy00.0.conf ${D}/nvram/hostapd-phy00.0.conf
        install -D -m 0644 ${WORKDIR}/hostapd-phy00.1.conf ${D}/nvram/hostapd-phy00.1.conf
        install -D -m 0644 ${WORKDIR}/hostapd-phy00.2.conf ${D}/nvram/hostapd-phy00.2.conf
     fi

    #Disable console logging in service files
    sed -i "s/StandardOutput=syslog+console/StandardOutput=syslog/g"  ${D}${systemd_unitdir}/system/snmpSubAgent.service
    sed -i "s/StandardOutput=syslog+console/StandardOutput=syslog/g"  ${D}${systemd_unitdir}/system/CcspPandMSsp.service
    sed -i "s/StandardOutput=syslog+console/StandardOutput=syslog/g"  ${D}${systemd_unitdir}/system/CcspCrSsp.service
    sed -i "s/StandardOutput=syslog+console/StandardOutput=syslog/g"  ${D}${systemd_unitdir}/system/PsmSsp.service
    sed -i "s/StandardOutput=syslog+console/StandardOutput=syslog/g"  ${D}${systemd_unitdir}/system/CcspTandDSsp.service
    sed -i "s/StandardOutput=syslog+console/StandardOutput=syslog/g"  ${D}${systemd_unitdir}/system/CcspLMLite.service
    sed -i "s/StandardOutput=syslog+console/StandardOutput=syslog/g"  ${D}${systemd_unitdir}/system/CcspTr069PaSsp.service
    sed -i "s/StandardOutput=syslog+console/StandardOutput=syslog/g"  ${D}${systemd_unitdir}/system/CcspEthAgent.service
    sed -i "s/StandardOutput=syslog+console/StandardOutput=syslog/g"  ${D}${systemd_unitdir}/system/ProcessResetDetect.service
    sed -i "s/StandardOutput=syslog+console/StandardOutput=syslog/g"  ${D}${systemd_unitdir}/system/rfc.service
    sed -i "s/StandardOutput=syslog+console/StandardOutput=syslog/g"  ${D}${systemd_unitdir}/system/CcspTelemetry.service
    sed -i "s/StandardOutput=syslog+console/StandardOutput=syslog/g"  ${D}${systemd_unitdir}/system/notifyComp.service
    sed -i "s/StandardOutput=syslog+console/StandardOutput=syslog/g"  ${D}${systemd_unitdir}/system/CcspXdnsSsp.service
    if [ $DISTRO_WAN_ENABLED = 'true' ]; then
        sed -i "s/StandardOutput=syslog+console/StandardOutput=syslog/g"  ${D}${systemd_unitdir}/system/RdkWanManager.service
    fi
    if [ $DISTRO_FW_ENABLED = 'true' ]; then
        sed -i "s/StandardOutput=syslog+console/StandardOutput=syslog/g"  ${D}${systemd_unitdir}/system/RdkFwUpgradeManager.service
    fi
    sed -i "s/StandardOutput=syslog+console/StandardOutput=syslog/g"  ${D}${systemd_unitdir}/system/CcspAdvSecuritySsp.service
    sed -i "s/StandardOutput=syslog+console/StandardOutput=syslog/g"  ${D}${systemd_unitdir}/system/RdkTelcoVoiceManager.service
    #sed -i "s/StandardOutput=syslog+console/StandardOutput=syslog/g"  ${D}${systemd_unitdir}/system/ccspwifiagent.service
    sed -i "s/StandardOutput=syslog+console/StandardOutput=syslog/g"  ${D}${systemd_unitdir}/system/RdkVlanManager.service
    sed -i "s/StandardOutput=syslog+console/StandardOutput=syslog/g"  ${D}${systemd_unitdir}/system/rdkbLogMonitor.service
}

SYSTEMD_SERVICE_${PN} += "CcspCrSsp.service"
SYSTEMD_SERVICE_${PN} += "CcspPandMSsp.service"
SYSTEMD_SERVICE_${PN} += "PsmSsp.service"
SYSTEMD_SERVICE_${PN} += "rdkbLogMonitor.service"
SYSTEMD_SERVICE_${PN} += "CcspTandDSsp.service"
SYSTEMD_SERVICE_${PN} += "CcspLMLite.service"
SYSTEMD_SERVICE_${PN} += "CcspTr069PaSsp.service"
SYSTEMD_SERVICE_${PN} += "snmpSubAgent.service"
SYSTEMD_SERVICE_${PN} += "CcspEthAgent.service"
SYSTEMD_SERVICE_${PN} += "wifiinitialized.service"
SYSTEMD_SERVICE_${PN} += "wifiinitialized.path"
SYSTEMD_SERVICE_${PN} += "onewifiinitialized.path"
SYSTEMD_SERVICE_${PN} += "wifi-initialized.target"
SYSTEMD_SERVICE_${PN} += "ProcessResetDetect.path"
SYSTEMD_SERVICE_${PN} += "ProcessResetDetect.service"
SYSTEMD_SERVICE_${PN} += "rfc.service"
SYSTEMD_SERVICE_${PN} += "CcspTelemetry.service"
SYSTEMD_SERVICE_${PN} += "notifyComp.service"
SYSTEMD_SERVICE_${PN} += "CcspXdnsSsp.service"
SYSTEMD_SERVICE_${PN} += "${@bb.utils.contains('DISTRO_FEATURES', 'rdkb_wan_manager', 'RdkWanManager.service CcspAdvSecuritySsp.service ', '', d)}"
SYSTEMD_SERVICE_${PN} += "${@bb.utils.contains('DISTRO_FEATURES', 'fwupgrade_manager', 'RdkFwUpgradeManager.service ', '', d)}"
SYSTEMD_SERVICE_${PN} += "RdkPppManager.service"
SYSTEMD_SERVICE_${PN} += "RdkGponManager.service"
SYSTEMD_SERVICE_${PN} += "RdkVlanManager.service"
SYSTEMD_SERVICE_${PN} += "gwprovapp.service"
SYSTEMD_SERVICE_${PN} += "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', 'onewifi.service ', 'ccspwifiagent.service', d)}"
# NOTE: hostapd-wifi.service is intentionally NOT in SYSTEMD_SERVICE.
# onewifi.service (via wifi_mode_start.sh) handles both onewifi and hostapd
# modes based on syscfg wifi_mode.  hostapd-wifi.service is installed only
# as a reference / fallback.


FILES_${PN}_append = " \
    /usr/ccsp/ccspSysConfigEarly.sh \
    /usr/ccsp/ccspSysConfigLate.sh \
    /usr/ccsp/utopiaInitCheck.sh \
    /usr/ccsp/ccspPAMCPCheck.sh \
    /usr/ccsp/ProcessResetCheck.sh \
    /usr/ccsp/wifi/onewifi_pre_start.sh \
    /usr/ccsp/wifi/onewifi_post_start.sh \
    /usr/ccsp/wifi/onewifi_post_stop.sh \
    ${base_libdir}/rdk/if_check.sh \
    ${systemd_unitdir}/system/CcspCrSsp.service \
    ${systemd_unitdir}/system/CcspPandMSsp.service \
    ${systemd_unitdir}/system/PsmSsp.service \
    ${systemd_unitdir}/system/rdkbLogMonitor.service \
    ${systemd_unitdir}/system/CcspTandDSsp.service \
    ${systemd_unitdir}/system/CcspLMLite.service \
    ${systemd_unitdir}/system/CcspTr069PaSsp.service \
    ${systemd_unitdir}/system/snmpSubAgent.service \
    ${systemd_unitdir}/system/CcspEthAgent.service \
    ${systemd_unitdir}/system/wifiinitialized.service \
    ${systemd_unitdir}/system/wifiinitialized.path \
    ${systemd_unitdir}/system/onewifiinitialized.path \
    ${systemd_unitdir}/system/wifi-initialized.target \
    ${systemd_unitdir}/system/ProcessResetDetect.path \
    ${systemd_unitdir}/system/ProcessResetDetect.service \
    ${systemd_unitdir}/system/rfc.service \
    ${systemd_unitdir}/system/CcspTelemetry.service \
    ${systemd_unitdir}/system/CcspXdnsSsp.service \
    ${systemd_unitdir}/system/notifyComp.service \
    ${systemd_unitdir}/system/RdkPppManager.service \
    ${systemd_unitdir}/system/RdkGponManager.service \
    ${systemd_unitdir}/system/RdkVlanManager.service \
    ${systemd_unitdir}/system/gwprovapp.service \
    ${systemd_unitdir}/system/gwprovapp.service.d/gwprovapp.conf \
"
FILES_${PN}_append = "${@bb.utils.contains('DISTRO_FEATURES', 'rdkb_wan_manager', ' ${systemd_unitdir}/system/RdkWanManager.service ${systemd_unitdir}/system/RdkVlanManager.service ${systemd_unitdir}/system/RdkTelcoVoiceManager.service ${systemd_unitdir}/system/CcspAdvSecuritySsp.service ', '', d)}"
FILES_${PN}_append = "${@bb.utils.contains('DISTRO_FEATURES', 'fwupgrade_manager', ' ${systemd_unitdir}/system/RdkFwUpgradeManager.service ', '', d)}"
FILES_${PN}_append = "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' ${systemd_unitdir}/system/onewifi.service ', '  ${systemd_unitdir}/system/ccspwifiagent.service ', d)}"
FILES_${PN}_append = "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' ${systemd_unitdir}/system/hostapd-wifi.service /nvram/hostapd-phy00.0.conf /nvram/hostapd-phy00.1.conf /nvram/hostapd-phy00.2.conf /usr/ccsp/wifi/wifi_mode_start.sh ', '', d)}"
FILES_${PN}_append_lxcbrc = " \
	/lib/rdk/psm_container.sh \
   	/lib/rdk/pandm_container.sh \
   	/lib/rdk/wifi_container.sh \
"
