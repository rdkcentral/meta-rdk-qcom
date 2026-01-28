FILESEXTRAPATHS_prepend := "${THISDIR}/dibbler:"

SRC_URI += " file://prepare_dhcpv6_config.patch;patchdir=${WORKDIR}"

do_install_append_broadband() {
   sed -i "s/sysevent set wan_service-status started/#sysevent set wan_service-status started/g" ${D}${base_libdir}/rdk/client-notify.sh
}
