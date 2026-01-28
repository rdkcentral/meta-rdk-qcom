DESCRIPTION = "Board based default syscfg configuration file"
LICENSE = "ISC"
PR = "r0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/${LICENSE};md5=f3b90e78ea0cffb20bf5cca7947a896d"

FILESEXTRAPATHS_prepend := "${THISDIR}/:"
SRC_URI = " \
	  file://files \
	  "

do_install() {
	install -d ${D}${bindir}
	install -m 0755 ${WORKDIR}/files/apply_board_defaults.sh ${D}${bindir}/apply_board_defaults.sh
}

FILES_${PN} = " \
		${bindir}/apply_board_defaults.sh \
	"
