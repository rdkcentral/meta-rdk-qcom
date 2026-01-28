FILESEXTRAPATHS_prepend := "${THISDIR}:"

SRC_URI_append += "file://rootpermission_fwupgrade.patch"

EXTRA_OECONF_remove_kirkstone = " --with-ccsp-platform=bcm --with-ccsp-arch=arm "
CFLAGS_append_kirkstone = " ${@bb.utils.contains('DISTRO_FEATURES', 'safec', ' -fPIC -I${STAGING_INCDIR}/safeclib', '-fPIC', d)}"

do_mypatch() {
    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/RdkPlatformManager/.rootpermission_fwupgrade.patched ]; then
        cd ${TOPDIR}/../rdkb/components/opensource/ccsp/RdkPlatformManager/source/
        patch -l -p2 < ${WORKDIR}/rootpermission_fwupgrade.patch
        cd -
        touch ${TOPDIR}/../rdkb/components/opensource/ccsp/RdkPlatformManager/.rootpermission_fwupgrade.patched
    fi
}

addtask mypatch after do_unpack before do_compile
