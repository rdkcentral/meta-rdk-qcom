require ccsp_common_ipq.inc

FILESPATH =+ "${TOPDIR}/../meta-cmf-ipq/recipes-ccsp/ccsp/rdk-easymesh-controller:"
SRC_URI += "file://0001-Airties-controller-changes.patch \
	    "
do_patch[noexec] = "1"

do_install_append () {
    # Config files and scripts
	install -d ${D}${systemd_unitdir}/system
	install -D -m 0644 ${S}/scripts/RdkEasyMeshController.service ${D}${systemd_unitdir}/system/RdkEasyMeshController.service
	install -d ${D}/etc/systemd/system/multi-user.target.wants/
}

do_mypatch() {

            if [ ! -f ${S}/.0001-Airties-controller-changes.patched ]; then
                 cd ${S}/
                 patch -p1 < ${WORKDIR}/0001-Airties-controller-changes.patch
                 touch .0001-Airties-controller-changes.patched
            fi

}

SYSTEMD_SERVICE_${PN} += " RdkEasyMeshController.service"
FILES_${PN}_append += " ${systemd_unitdir}/system/RdkEasyMeshController.service"
SYSTEMD_AUTO_ENABLE_${PN} = "disable"

addtask mypatch after do_unpack before do_compile
