FILESPATH =+ "${TOPDIR}/../rdkb/devices/ipq/hal:"
SRC_URI += "file://hal-ethsw \
           "

do_configure_prepend() {
    ln -sf ${WORKDIR}/hal-ethsw/source/hal-ethsw/ccsp_hal_ethsw.c ${S}/ccsp_hal_ethsw.c
    ln -sf ${WORKDIR}/hal-ethsw/source/hal-ethsw/Makefile.am ${S}/Makefile.am
}
