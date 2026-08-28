FILESEXTRAPATHS:prepend := "${THISDIR}/file/:"
SRC_URI += "file://001-bug-fix-for-events.patch \
           "

do_install_append(){
    install -d ${D}${includedir}
    cp -rf ${WORKDIR}/git/* ${D}${includedir}/
}
