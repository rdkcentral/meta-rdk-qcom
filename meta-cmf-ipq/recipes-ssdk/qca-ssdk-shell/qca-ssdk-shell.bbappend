
SRC_URI += "file://sw_config.sh"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

do_install_append() {
	install -d ${D}/lib/ipq-boot
	install -m 0755 ${WORKDIR}/sw_config.sh ${D}/lib/ipq-boot/sw_config.sh
}

FILES_${PN} += "/lib/*"
