
FILESPATH =+ "${TOPDIR}/../rdkb/devices/ipq/hal:"
SRC_URI += "file://hal-platform \
	   "
DEPENDS += "utopia-headers"
CFLAGS_append = " \
    -I=${includedir}/utctx \
"
CFLAGS_append_aarch64 = " -D_64BIT_ARCH_SUPPORT_"

do_configure_prepend(){
    rm ${S}/platform_hal.c
    ln -sf ${WORKDIR}/hal-platform/source/hal-platform/platform_hal.c ${S}/platform_hal.c
}

