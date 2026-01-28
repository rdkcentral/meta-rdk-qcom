FILESEXTRAPATHS_prepend :="${THISDIR}/files:"

SRC_URI += " file://pppoe_config.sh \
             file://pppoe_config.patch;patchdir=${WORKDIR}"

RDEPENDS_${PN} += "bash"

do_install_append() {
        install -d ${D}/usr/sbin/
        install -m 0755 ${WORKDIR}/pppoe_config.sh ${D}/usr/sbin/pppoe_config.sh
}

FILES_${PN} += "/usr/sbin/pppoe_config.sh"
