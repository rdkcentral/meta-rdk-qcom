
FILESPATH =+ "${TOPDIR}/../rdkb/devices/ipq/hal:"
SRC_URI += "file://hal-platform \
	   "
DEPENDS += "utopia-headers"

DEPENDS += "libnl qca-nss-dscpstats"

TARGET_CPPFLAGS +="-I${STAGING_DIR_TARGET}/usr/include"
TARGET_CPPFLAGS +="-I${STAGING_DIR}/usr/include"
TARGET_CPPFLAGS += "-I${STAGING_INCDIR}/libnl3"


CFLAGS_append = " \
    -I=${includedir}/utctx \
    -I=${includedir}/qca-nss-dscpstats \
"
CFLAGS_append = " -I${STAGING_INCDIR}/libnl3 "
CFLAGS_append_aarch64 = " -D_64BIT_ARCH_SUPPORT_"

LDFLAGS_append = " -L${STAGING_LIBDIR} -lnl-genl-3 -lnl-3"

do_configure_prepend(){
    rm ${S}/platform_hal.c
    ln -sf ${WORKDIR}/hal-platform/source/hal-platform/platform_hal.c ${S}/platform_hal.c
}

