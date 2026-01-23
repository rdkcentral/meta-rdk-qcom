FILESEXTRAPATHS_prepend := "${THISDIR}:"
SRC_URI += "file://rdkb_log4crc"

do_configure_append_broadband () {
   install -m 644 ${WORKDIR}/rdkb_log4crc ${S}/log4crc
}

do_configure_append () {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'extender', 'true', 'false', d)}; then
        echo "LOG.RDK.CCSPEXTENDER = FATAL ERROR WARNING NOTICE INFO" >> ${S}/debug.ini
    fi
}
