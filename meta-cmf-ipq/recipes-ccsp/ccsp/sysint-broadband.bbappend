FILESEXTRAPATHS_prepend := "${THISDIR}/sysint/device/systemd_units/:"
FILESEXTRAPATHS_prepend := "${THISDIR}/sysint/device/lib/rdk:"
FILESEXTRAPATHS_prepend := "${THISDIR}/sysint/etc:"
FILESEXTRAPATHS_prepend := "${THISDIR}/sysint:"

SRC_URI += "file://run_rm_key.sh \
            file://ntpd.service \
            file://webpabroadband.service \
            file://parodus.service \
            file://device.properties \
            file://utopia.service \
	        file://log_agent.service \
	        file://001-Captive_Portal_Webgui_arm.patch \
            file://002-logupload-script-fix.patch \
           "

do_install_append() {
        install -d ${D}${sysconfdir}
        install -d ${D}${systemd_unitdir}/system
        install -d ${D}${base_libdir}/rdk
       	install -d ${D}/rdklogger
        install -m 0644 ${WORKDIR}/device.properties ${D}${sysconfdir}
        install -m 0755 ${WORKDIR}/run_rm_key.sh ${D}${base_libdir}/rdk/
        install -m 0755 ${WORKDIR}/ntpd.service ${D}${systemd_unitdir}/system/
        install -m 0755 ${WORKDIR}/webpabroadband.service ${D}${systemd_unitdir}/system/
        install -m 0755 ${WORKDIR}/parodus.service ${D}${systemd_unitdir}/system/
	    install -m 0755 ${S}/device/systemd_units/dcm-log.service ${D}${systemd_unitdir}/system/
	    install -m 0755 ${WORKDIR}/log_agent.service ${D}${systemd_unitdir}/system/

        sed -i "/if \[ \! -f \/usr\/bin\/GetConfigFile \]\;then/,+4d" ${D}/rdklogger/logfiles.sh
        install -m 0755 ${S}/getaccountid.sh ${D}${base_libdir}/rdk
        install -m 0755 ${S}/utils.sh ${D}${base_libdir}/rdk
        install -m 0755 ${S}/getpartnerid.sh ${D}${base_libdir}/rdk
        install -m 0755 ${S}/device/lib/rdk/* ${D}${base_libdir}/rdk
        install -m 0755 ${S}/DCMscript.sh ${D}${base_libdir}/rdk

	    #Log Rotate Support
	    install -m 0644 ${S}/logFiles.properties ${D}${sysconfdir}/
	    install -m 0755 ${S}/getaccountid.sh   ${D}${base_libdir}/rdk
	    install -m 0644 ${S}/dcmlogservers.txt   ${D}/rdklogger/
        sed -i 's/rebootFunc/#rebootFunc/g' ${D}/rdklogger/backupLogs.sh

}

addtask mypatch after do_unpack before do_compile

SYSTEMD_SERVICE_${PN} += " ntpd.service "
SYSTEMD_SERVICE_${PN} += " webpabroadband.service "
SYSTEMD_SERVICE_${PN} += " parodus.service "
SYSTEMD_SERVICE_${PN} += " log_agent.service "
FILES_${PN} += "${sysconfdir}/*"
FILES_${PN} += "${base_libdir}/rdk/*"
FILES_${PN} += "${systemd_unitdir}/system/*"
