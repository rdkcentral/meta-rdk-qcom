FILESPATH =+ "${TOPDIR}/../rdkb/devices/ipq/hal:"
SRC_URI += "file://hal-vlan \
           "
do_configure_prepend() {
    rm ${S}/Makefile.am
    rm ${S}/vlan_hal.c
    ln -sf ${WORKDIR}/hal-vlan/source/hal-vlan/Makefile.am ${S}/Makefile.am
    ln -sf ${WORKDIR}/hal-vlan/source/hal-vlan/vlan_hal.c ${S}/vlan_hal.c
    ln -sf ${WORKDIR}/hal-vlan/source/hal-vlan/vlan_api.c ${S}/vlan_api.c
}
