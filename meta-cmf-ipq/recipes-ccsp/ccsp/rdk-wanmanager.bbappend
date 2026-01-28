CFLAGS_append = " -D_PLATFORM_IPQ_ "
FILESEXTRAPATHS_prepend := "${THISDIR}:"

SRC_URI += " file://002-wanmgr-bcast.patch \
	     file://003-wanmgr-onboarding.patch \
	   "

do_configure_prepend() {
        if ${@bb.utils.contains('DISTRO_FEATURES', 'rdkb_wan_manager', 'false', 'true', d)}; then
        (python ${STAGING_BINDIR_NATIVE}/dm_pack_code_gen.py ${S}/config/RdkWanManager.xml ${S}/source/WanManager/dm_pack_datamodel.c)
        fi
}

do_mypatch() {
    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/RdkWanManager/.002-wanmgr-bcast-patched ]; then
        cd ${TOPDIR}/../rdkb/components/opensource/ccsp/RdkWanManager/source/
        patch -p2 < ${WORKDIR}/002-wanmgr-bcast.patch
        cd -
        touch ${TOPDIR}/../rdkb/components/opensource/ccsp/RdkWanManager/.002-wanmgr-bcast-patched
    fi
    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/RdkWanManager/.003-wanmgr-onboarding.patched ]; then
        cd ${TOPDIR}/../rdkb/components/opensource/ccsp/RdkWanManager/source/
        patch -p2 < ${WORKDIR}/003-wanmgr-onboarding.patch
        cd -
        touch ${TOPDIR}/../rdkb/components/opensource/ccsp/RdkWanManager/.003-wanmgr-onboarding.patched
    fi
}

addtask mypatch after do_unpack before do_compile
