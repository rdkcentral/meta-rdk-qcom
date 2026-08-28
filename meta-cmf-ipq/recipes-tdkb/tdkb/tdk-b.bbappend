EXTRA_OECONF:append = " --enable-ert --enable-platform"

SRC_URI:append= " ${CMF_GITHUB_ROOT}/tdk-broadband-raspberrypi;protocol=${CMF_GIT_PROTOCOL};branch=${CMF_GITHUB_MAIN_BRANCH};name=tdkbraspberrypi;destsuffix=git/platform/raspberrypi "
SRCREV_tdkbraspberrypi = "${AUTOREV}"
do_fetch[vardeps] += "SRCREV_tdkbraspberrypi"
SRCREV_FORMAT = "tdk_tdkbraspberrypi"

FILESEXTRAPATHS:prepend := "${THISDIR}:"

SRC_URI += " file://004-tdk-crash.patch "
SRC_URI += " file://006-hal-3-apply.patch "
SRC_URI += " file://007-ipq-tdk-agent.patch "

do_install:append () {
    install -d ${D}${tdkdir}
    install -d ${D}/etc
    install -p -m 755 ${S}/platform/raspberrypi/agent/scripts/*.sh ${D}${tdkdir}
    install -p -m 755 ${S}/platform/raspberrypi/agent/scripts/tdk_platform.properties ${D}/etc/
}

FILES:${PN} += "${prefix}/ccsp/"
FILES:${PN} += "/etc/*"
FILES:${PN} += "${tdkdir}/*"

CXXFLAGS:append = " -DWIFI_HAL_VERSION_3 "
