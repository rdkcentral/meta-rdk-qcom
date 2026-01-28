FILESPATH =+ "${TOPDIR}/../rdkb/devices/ipq/hal:"
SRC_URI += "file://hal-qcawifi"

DEPENDS += "libnl qca-wifi qca-cfg80211 qca-cfg80211tool glib-2.0 libwpa2"

TARGET_CPPFLAGS +="-I${STAGING_DIR_TARGET}/usr/include"
TARGET_CPPFLAGS +="-I${STAGING_DIR}/usr/include"
TARGET_CPPFLAGS += "-I${STAGING_INCDIR}/libnl3"

RDEPENDS_${PN} += " qca-cfg80211 "
RDEPENDS_${PN} += " qca-cfg80211tool"
RDEPENDS_${PN} += " qca-wifi"
RDEPENDS_${PN} += " libwpa2"

CFLAGS_append = " -I=${includedir}/libnl3 ${TARGET_CPPFLAGS} -I${STAGING_INCDIR} -I${STAGING_LIBDIR} "
LDFLAGS_append = " -L${STAGING_LIBDIR} -lnl-nf-3 -lnl-route-3 -lnl-3 -lnl-xfrm-3 -lnl-genl-3 -lglib-2.0 -lwpa2 -lm"

SOC="${@d.getVar('SOC_FAMILY', d, 1).split(':')[1]}"
export SOC_T = "${@d.getVar('SOC', d, 0).split('_')[0]}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', "ipq807x", " -D_PLATFORM_IPQ807x", " ", d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', "ipq807x", " -DMAX_NUM_RADIOS=2", " ", d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', "ipq53xx", " -D_PLATFORM_IPQ53xx", " ", d)}"

do_configure_prepend(){
    rm ${S}/Makefile.am
    ln -sf ${WORKDIR}/hal-qcawifi/source/hal-qcawifi/wifi_hal.c ${S}/wifi_hal.c
    ln -sf ${WORKDIR}/hal-qcawifi/source/hal-qcawifi/wifi_api.c ${S}/wifi_api.c
    ln -sf ${WORKDIR}/hal-qcawifi/source/hal-qcawifi/Makefile.am ${S}/Makefile.am
}
