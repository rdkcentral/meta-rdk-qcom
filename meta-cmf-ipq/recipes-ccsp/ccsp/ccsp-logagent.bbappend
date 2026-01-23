FILESEXTRAPATHS_prepend := "${THISDIR}:"
SRC_URI_append += " \
        file://001-logagent_header.patch \
        file://002-logagent-fix.patch \
        "

EXTRA_OECONF_remove_kirkstone = " --with-ccsp-platform=bcm --with-ccsp-arch=arm "

do_mypatch() {
    if [ ! -f ${TOPDIR}/../rdkb/components/generic/CcspLogAgent/.001-logagent_header.patched ]; then
        cd ${TOPDIR}/../rdkb/components/generic/CcspLogAgent/source/
        patch -p2 < ${WORKDIR}/001-logagent_header.patch
        cd -
        touch ${TOPDIR}/../rdkb/components/generic/CcspLogAgent/.001-logagent_header.patched
    fi

    if [ ! -f ${TOPDIR}/../rdkb/components/generic/CcspLogAgent/.002-logagent-fix.patched ]; then
        cd ${TOPDIR}/../rdkb/components/generic/CcspLogAgent/source/
        patch -p2 < ${WORKDIR}/002-logagent-fix.patch
        cd -
        touch ${TOPDIR}/../rdkb/components/generic/CcspLogAgent/.002-logagent-fix.patched
    fi
}
addtask mypatch after do_unpack before do_compile
