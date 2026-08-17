FILESPATH =+ "${TOPDIR}/../rdkb/devices/ipq/hal:"
SRC_URI += "file://hal-qcawifi"

DEPENDS += "libnl open-mac80211 glib-2.0 qc-config"

TARGET_CPPFLAGS +="-I${STAGING_DIR_TARGET}/usr/include"
TARGET_CPPFLAGS +="-I${STAGING_DIR}/usr/include"
TARGET_CPPFLAGS += "-I${STAGING_INCDIR}/libnl3"
TARGET_CPPFLAGS += "-I${TOPDIR}/../src/ipq/qca-wifi/component_dev/tools/linux/telemetry/inc"
TARGET_CPPFLAGS += "-I${TOPDIR}/../src/ipq/common-tools/qca_nl80211_lib"

RDEPENDS_${PN} += " kernel-module-cfg80211 "
#RDEPENDS_${PN} += " qca-cfg80211tool"
RDEPENDS_${PN} += " open-mac80211"
RDEPENDS_${PN} += " qc-config"

CFLAGS_append = " -I=${includedir}/libnl3 ${TARGET_CPPFLAGS} -I${STAGING_INCDIR} -I${STAGING_LIBDIR} -DQCANL_LIB_ADD_API_SUPPORT_SINGLE_WIPHY_MLO"
LDFLAGS_append = " -L${STAGING_LIBDIR} -lnl-nf-3 -lnl-route-3 -lnl-3 -lnl-xfrm-3 -lnl-genl-3 -lglib-2.0 -lm -lqcconfig_utils"

SOC="${@d.getVar('SOC_FAMILY', d, 1).split(':')[1]}"
export SOC_T = "${@d.getVar('SOC', d, 0).split('_')[0]}"
NUM_OF_RADIOS = "${@d.getVar('NUM_RADIOS', d, 1).split(':')[1]}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq807x', ' -D_PLATFORM_IPQ807x', ' ', d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq807x', ' -DMAX_NUM_RADIOS=2', ' ', d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq54xx', ' -DMAX_NUM_RADIOS=${NUM_OF_RADIOS}', ' ', d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq53xx', ' -DMAX_NUM_RADIOS=${NUM_OF_RADIOS}', ' ', d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq95xx', ' -DMAX_NUM_RADIOS=${NUM_OF_RADIOS}', ' ', d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq52xx', ' -DMAX_NUM_RADIOS=${NUM_OF_RADIOS}', ' ', d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq96xx', ' -DMAX_NUM_RADIOS=${NUM_OF_RADIOS}', ' ', d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq53xx', ' -D_PLATFORM_IPQ53xx', ' ', d)}"

do_configure_prepend(){
    rm ${S}/Makefile.am
    ln -sf ${WORKDIR}/hal-qcawifi/source/hal-qcawifi/wifi_hal.c ${S}/wifi_hal.c
    ln -sf ${WORKDIR}/hal-qcawifi/source/hal-qcawifi/wifi_api.c ${S}/wifi_api.c
    ln -sf ${WORKDIR}/hal-qcawifi/source/hal-qcawifi/qca_wifi_hal.h ${S}/qca_wifi_hal.h
    ln -sf ${WORKDIR}/hal-qcawifi/source/hal-qcawifi/Makefile.am ${S}/Makefile.am
}
