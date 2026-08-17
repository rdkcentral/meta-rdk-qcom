require ccsp_common_ipq.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " \
    file://cr-deviceprofile_ipq.xml \
"

do_install_append() {
    # Config files and scripts
    install -m 644 ${WORKDIR}/cr-deviceprofile_ipq.xml ${D}/usr/ccsp/cr-deviceprofile.xml
    install -m 644 ${WORKDIR}/cr-deviceprofile_ipq.xml ${D}/usr/ccsp/cr-ethwan-deviceprofile.xml
}
