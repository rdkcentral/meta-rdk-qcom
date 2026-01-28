EXTRA_OECONF_append = " --enable-ert --enable-platform"

FILESPATH =+ "${TOPDIR}/../rdkb/devices/ipq/tdkb:"
FILESEXTRAPATHS_prepend := "${THISDIR}:"

SRC_URI += "file://agent "
SRC_URI += " file://001-tdk-lib.patch "
SRC_URI += " file://002-ssp-pam-bridge-c.patch "
SRC_URI += " file://003-tdk-bootdelay.patch "
SRC_URI += " file://004-tdk-crash.patch "
SRC_URI += " file://005-makefile-macro.patch "
SRC_URI += " file://006-hal-3-apply.patch "

tdkdir = "/usr/ccsp/tdk/"

do_install_append () {
    install -d ${D}${tdkdir}
    install -d ${D}/etc
    install -p -m 755 ${WORKDIR}/agent/scripts/*.sh ${D}/${tdkdir}
    install -p -m 755 ${WORKDIR}/agent/scripts/tdk_platform.properties ${D}/etc/
}

do_mypatch(){
            if [ ! -f ${TOPDIR}/../rdkb/tools/tdkb/.001-tdk-lib-patched ]; then
                  cd ${TOPDIR}/../rdkb/tools/tdkb/
                  patch -p1 < ${WORKDIR}/001-tdk-lib.patch
                  patch -p1 < ${WORKDIR}/002-ssp-pam-bridge-c.patch
                  patch -p1 < ${WORKDIR}/003-tdk-bootdelay.patch
		  patch -p1 < ${WORKDIR}/004-tdk-crash.patch
		  patch -p1 < ${WORKDIR}/005-makefile-macro.patch
		  patch -p1 < ${WORKDIR}/006-hal-3-apply.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/tools/tdkb/.001-tdk-lib-patched
            fi

}

addtask mypatch before do_compile

FILES_${PN} += "/etc/*"
FILES_${PN} += "${tdkdir}/*"
