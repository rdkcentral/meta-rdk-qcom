FILESEXTRAPATHS:prepend := "${TOPDIR}/../rdkb/components/generic/:${THISDIR}/file/:"
SRC_URI += "file://json-rpc \
	    file://001-bug-fix-for-events.patch \
           "
do_mypatch() {
            if [ ! -f ${TOPDIR}/../rdkb/components/generic/json-rpc/.001-bug-fix-for-events.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/generic/json-rpc
                  patch -p1 < ${WORKDIR}/001-bug-fix-for-events.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/generic/json-rpc/.001-bug-fix-for-events.patched
            fi
            if [ ! -f ${WORKDIR}/json-rpc/.001-bug-fix-for-events.patched ]; then
                  cd ${WORKDIR}/json-rpc/
                  patch -p1 < ${WORKDIR}/001-bug-fix-for-events.patch
                  cd -
                  touch ${WORKDIR}/json-rpc/.001-bug-fix-for-events.patched
            fi
}

addtask mypatch before do_compile after do_unpack

do_install_append(){
        install -d ${D}${includedir}
        rm -rf ${WORKDIR}/json-rpc/oe-logs
        rm -rf ${WORKDIR}/json-rpc/oe-workdir
        cp -rf ${WORKDIR}/json-rpc/* ${D}${includedir}/
}
