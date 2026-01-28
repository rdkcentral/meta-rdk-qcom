require ccsp_common_ipq.inc

CFLAGS_remove = " -Wall -Werror -Wextra "
CFLAGS += " -Wall "

EXTRA_OECONF_remove = " ${@bb.utils.contains('DISTRO_FEATURES', 'rdkb_wan_manager', '--enable-wanmgr', '', d)}"

FILESEXTRAPATHS_prepend := "${THISDIR}:"

do_mypatch() {
}

do_install_append() {
    # Config files and scripts
    install -m 644 ${S}/config-arm/CcspCMDM.cfg ${D}${prefix}/ccsp/cm/CcspCMDM.cfg
    install -m 644 ${S}/config-arm/CcspCM.cfg ${D}${prefix}/ccsp/cm/CcspCM.cfg
    install -m 644 ${S}/config-arm/TR181-CM.XML ${D}${prefix}/ccsp/cm/TR181-CM.XML

    # delete files that are installed by some other package
    rm -f ${D}/usr/include/ccsp/cosa_apis.h
    rm -f ${D}/usr/include/ccsp/cosa_apis_busutil.h
    rm -f ${D}/usr/include/ccsp/cosa_dml_api_common.h
}

FILES_${PN} += "/usr/ccsp/cm/TR181-CM.XML"

addtask mypatch after do_unpack before do_compile
