FILESEXTRAPATHS_prepend := "${THISDIR}/sysint/device/systemd_units/:"
FILESEXTRAPATHS_prepend := "${THISDIR}/sysint/device/lib/rdk:"
FILESEXTRAPATHS_prepend := "${THISDIR}/sysint/etc:"
FILESEXTRAPATHS_prepend := "${THISDIR}/sysint:"

SRC_URI += "file://run_rm_key.sh \
            file://ntpd.service \
            file://webpabroadband.service \
            file://parodus.service \
            file://utopia.service \
            file://device.properties \
            file://rdkbLogMonitor.sh \
            file://logfiles.sh \
	    file://dcm.properties \
	    file://include.properties \
	    file://dcm-log.service \
	    file://log_agent.service \
	    file://001-Captive_Portal_Webgui_arm.patch \
           "

do_install_append() {
        install -d ${D}${sysconfdir}
        install -d ${D}${systemd_unitdir}/system
        install -d ${D}${base_libdir}/rdk
       	install -d ${D}/rdklogger
        install -m 0644 ${WORKDIR}/device.properties ${D}${sysconfdir}
        install -m 0755 ${WORKDIR}/run_rm_key.sh ${D}${base_libdir}/rdk/
	ln -sf /rdklogger/DCMscript.sh ${D}${base_libdir}/rdk/
        install -m 0755 ${WORKDIR}/ntpd.service ${D}${systemd_unitdir}/system/
        install -m 0755 ${WORKDIR}/webpabroadband.service ${D}${systemd_unitdir}/system/
        install -m 0755 ${WORKDIR}/utopia.service ${D}${systemd_unitdir}/system/
        install -m 0755 ${WORKDIR}/parodus.service ${D}${systemd_unitdir}/system/
	install -m 0755 ${WORKDIR}/dcm-log.service ${D}${systemd_unitdir}/system/
	install -m 0755 ${WORKDIR}/log_agent.service ${D}${systemd_unitdir}/system/
        install -m 0755 ${WORKDIR}/rdkbLogMonitor.sh ${D}/rdklogger/
        install -m 0755 ${WORKDIR}/logfiles.sh ${D}/rdklogger/
	install -m 0644 ${WORKDIR}/dcm.properties ${D}${sysconfdir}
	install -m 0644 ${WORKDIR}/include.properties ${D}${sysconfdir}

        sed -i "/if \[ \! -f \/usr\/bin\/GetConfigFile \]\;then/,+4d" ${D}/rdklogger/logfiles.sh
        install -m 0755 ${TOPDIR}/../rdkb/components/opensource/ccsp/sysint/getaccountid.sh ${D}${base_libdir}/rdk
        install -m 0755 ${TOPDIR}/../rdkb/components/opensource/ccsp/sysint/utils.sh ${D}${base_libdir}/rdk
        install -m 0755 ${TOPDIR}/../rdkb/components/opensource/ccsp/sysint/getpartnerid.sh ${D}${base_libdir}/rdk
        install -m 0755 ${TOPDIR}/../meta-rdk-qcom/meta-cmf-ipq/recipes-ccsp/ccsp/sysint/device/lib/rdk/* ${D}${base_libdir}/rdk

	#Log Rotate Support
	install -m 0644 ${S}/logFiles.properties ${D}${sysconfdir}/
	install -m 0755 ${S}/getaccountid.sh   ${D}${base_libdir}/rdk
	install -m 0644 ${S}/dcmlogservers.txt   ${D}/rdklogger/
        sed -i 's/rebootFunc/#rebootFunc/g' ${D}/rdklogger/backupLogs.sh

}

do_mypatch() {
	    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/sysint/.001-Captive_Portal_Webgui_arm.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/sysint/
                  patch -p1 < ${WORKDIR}/001-Captive_Portal_Webgui_arm.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/sysint/.001-Captive_Portal_Webgui_arm.patched
            fi

}

addtask mypatch after do_unpack before do_compile

SYSTEMD_SERVICE_${PN} += " ntpd.service "
SYSTEMD_SERVICE_${PN} += " webpabroadband.service "
SYSTEMD_SERVICE_${PN} += " utopia.service "
SYSTEMD_SERVICE_${PN} += " parodus.service "
SYSTEMD_SERVICE_${PN} += " dcm-log.service "
SYSTEMD_SERVICE_${PN} += " log_agent.service "
FILES_${PN} += "${sysconfdir}/*"
FILES_${PN} += "${base_libdir}/rdk/*"
FILES_${PN} += "${systemd_unitdir}/system/*"
