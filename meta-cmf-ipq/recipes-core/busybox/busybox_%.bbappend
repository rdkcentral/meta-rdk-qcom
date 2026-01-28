
do_install_append() {
        rm ${D}${sysconfdir}/syslog.conf
}

FILES_${PN}-syslog_remove = "${sysconfdir}/syslog.conf"
