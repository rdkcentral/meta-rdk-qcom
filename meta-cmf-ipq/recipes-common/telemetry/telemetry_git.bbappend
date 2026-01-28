do_install_append_broadband() {
        use_sysv="${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'false', 'true', d)}"
        $use_sysv || install -d ${D}${systemd_unitdir}/system
        $use_sysv || install -m 0644 ${S}/telemetry2_0.service ${D}${systemd_unitdir}/system/
        $use_sysv || install -m 0644 ${S}/telemetry2_0.path ${D}${systemd_unitdir}/system/
        install -d ${D}${sysconfdir}
}

SYSTEMD_SERVICE_${PN}_append_broadband = " telemetry2_0.service \
                                           telemetry2_0.path \
"
