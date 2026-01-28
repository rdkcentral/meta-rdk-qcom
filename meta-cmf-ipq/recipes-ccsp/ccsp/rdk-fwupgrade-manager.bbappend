FILESEXTRAPATHS_prepend := "${THISDIR}:"

SRC_URI_append += "file://rootpermission_fwupgrade.patch"

do_mypatch() {
    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/RdkPlatformManager/.rootpermission_fwupgrade.patched ]; then
        cd ${TOPDIR}/../rdkb/components/opensource/ccsp/RdkPlatformManager/source/
        patch -l -p2 < ${WORKDIR}/rootpermission_fwupgrade.patch
        cd -
        touch ${TOPDIR}/../rdkb/components/opensource/ccsp/RdkPlatformManager/.rootpermission_fwupgrade.patched
    fi
}

addtask mypatch after do_unpack before do_compile
