FILESPATH =+ "${TOPDIR}/../rdkb/devices/ipq/hal:"
SRC_URI += "file://hal-ethsw \
           "

do_configure_prepend() {
    ln -sf ${WORKDIR}/hal-ethsw/source/hal-ethsw/ccsp_hal_ethsw.c ${S}/ccsp_hal_ethsw.c
    ln -sf ${WORKDIR}/hal-ethsw/source/hal-ethsw/Makefile.am ${S}/Makefile.am
}

SOC="${@d.getVar('SOC_FAMILY', d, 1).split(':')[1]}"
export SOC_T = "${@d.getVar('SOC', d, 0).split('_')[0]}"
CFLAGS += "${@bb.utils.contains('SOC_T', 'ipq95xx', ' -DETH_5_PORTS', ' ', d)}"
CFLAGS += "${@bb.utils.contains('SOC_T', 'ipq54xx', ' -DETH_5_PORTS', ' ', d)}"
CFLAGS += "${@bb.utils.contains('SOC_T', 'ipq96xx', ' -DETH_5_PORTS', ' ', d)}"
CFLAGS += "${@bb.utils.contains('SOC_T', 'ipq52xx', ' -DETH_5_PORTS', ' ', d)}"
CFLAGS += "${@bb.utils.contains('SOC_T', 'ipq54xx', ' -D_PLATFORM_IPQ54xx', ' ', d)}"
CFLAGS += "${@bb.utils.contains('SOC_T', 'ipq53xx', ' -D_PLATFORM_IPQ53xx', ' ', d)}"
CFLAGS += "${@bb.utils.contains('SOC_T', 'ipq95xx', ' -D_PLATFORM_IPQ95xx', ' ', d)}"
CFLAGS += "${@bb.utils.contains('SOC_T', 'ipq52xx', ' -D_PLATFORM_IPQ52xx', ' ', d)}"
CFLAGS += "${@bb.utils.contains('SOC_T', 'ipq96xx', ' -D_PLATFORM_IPQ96xx', ' ', d)}"
