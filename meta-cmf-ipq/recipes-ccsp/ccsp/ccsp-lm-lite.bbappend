require ccsp_common_ipq.inc

FILESPATH =+ "${TOPDIR}/../meta-cmf-ipq/recipes-ccsp/ccsp:"
#SRC_URI += "file://001-ipq-ccsp-lm-lite.patch"
SRC_URI += "file://002-lm-lite-max-station.patch"

DEPENDS_append = "utopia-headers"
DEPENDS += " safec safec-common-wrapper "

TARGET_CFLAGS += " -I${PKG_CONFIG_SYSROOT_DIR}$(includedir)/safeclib/"
TARGET_LDFLAGS += " -lsafec"

EXTRA_OECONF_append = " --enable-wan_traffic_count_support=${@bb.utils.contains('DISTRO_FEATURES', 'wan-traffic-count', 'yes', 'no', d)} "

LDFLAGS_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'wan-traffic-count', ' -lrbus -lrbuscore -lrtMessage ', '', d)}"
CFLAGS_append  = " ${@bb.utils.contains('DISTRO_FEATURES', 'wan-traffic-count', ' -I${STAGING_INCDIR}/rbus -I${STAGING_INCDIR}/rtmessage ', '', d)}"
CFLAGS_append  = " ${@bb.utils.contains('DISTRO_FEATURES', 'wan-traffic-count', ' -DWAN_TRAFFIC_COUNT_SUPPORT', '', d)}"
