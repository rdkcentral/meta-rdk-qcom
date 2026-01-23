
FILESPATH =+ "${TOPDIR}/../rdkb/devices/ipq/hal:"
SRC_URI += "file://hal-dhcpv4c \
	   "

do_configure_prepend(){
    rm ${S}/dhcpv4c_api.c
    ln -sf ${WORKDIR}/hal-dhcpv4c/source/hal-dhcpv4c/dhcpv4c_api.c ${S}/dhcpv4c_api.c
}

