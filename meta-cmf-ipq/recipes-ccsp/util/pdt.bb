DESCRIPTION = "scripts to include pdt service into image"
SECTION = "pdt"
LICENSE = "ISC"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/${LICENSE};md5=f3b90e78ea0cffb20bf5cca7947a896d"
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}/files:"

PR = "r0"

inherit systemd

SRC_URI = "file://pdt"

S = "${WORKDIR}/pdt"

do_install_append() {
        install -d ${D}${bindir}
        install -m 0755 ${WORKDIR}/pdt/usr/bin/pdt.sh ${D}${bindir}

        install -d ${D}${systemd_unitdir}/system
        install -m 0644 ${WORKDIR}/pdt/pdt.service  ${D}${systemd_unitdir}/system
}

FILES_${PN} += "${libdir}/* ${baselib}/* ${sysconfdir}/* ${bindir}/*"

BBCLASSEXTEND += "native"
SYSTEMD_SERVICE_${PN} += "pdt.service"
