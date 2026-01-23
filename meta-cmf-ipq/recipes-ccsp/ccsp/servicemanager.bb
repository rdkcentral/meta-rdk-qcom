SUMMARY = "CCSP servicemanager component"

INHERIT += "externalsrc"
EXTERNALSRC_pn-servicemanager = ''

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=175792518e4ac015ab6696d16c4f607e"

DEPENDS = "ccsp-common-library hal-cm hal-dhcpv4c hal-ethsw hal-moca hal-mso_mgmt hal-mta hal-platform hal-vlan hal-wifi utopia rdk-logger"
DEPENDS_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'systemd', '', d)}"


require ccsp_common_ipq.inc

SRC_URI += "git://code.rdkcentral.com/r/rdkb/components/generic/servicemanager;protocol=${RDK_GIT_PROTOCOL};branch=${CCSP_GIT_BRANCH};name=servicemanager"


SRCREV_servicemanager = "${AUTOREV}"
PV = "${RDK_RELEASE}+git${SRCPV}"

S = "${WORKDIR}/git"

inherit autotools

EXTRA_OECONF_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', '--enable-notify', '', d)}"
EXTRA_OECONF_remove  = " --with-ccsp-platform=bcm --with-ccsp-arch=arm"

CFLAGS += "-DFEATURE_SUPPORT_RDKLOG"
CFLAGS_append = " -D_COSA_HAL_"
CFLAGS_append = " \
    -I${STAGING_INCDIR}/dbus-1.0 \
    -I${STAGING_LIBDIR}/dbus-1.0/include \
    -I${STAGING_INCDIR}/ccsp \
    -I${STAGING_INCDIR}/service-agent-c \
    "
CFLAGS_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'bci', '-D_COSA_FOR_BCI_', '', d)}"

# Add flags to support mesh wifi if the feature is available.
CFLAGS_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'meshwifi', '-DFEATURE_SUPPORT_MESH', '', d)}"

CFLAGS_append = "${@bb.utils.contains('DISTRO_FEATURES', 'mdc', '-D_MDC_SUPPORTED_', '', d)}"

LDFLAGS_append = " \
    -ldbus-1 \
    -lsvc_agt \
    -lrdkloggers \
    "

FILES_${PN} += " \
     ${libdir}/*.so \
     ${prefix}/bin/CcspServiceManager \
     ${prefix}/ccsp/CcspServiceManager \
     ${prefix}/ccsp/ccsp-servicemanager-broadband \
     ${prefix}/ccsp/ccsp-servicemanager-broadband/TR181-ServiceManager.xml \
     ${prefix}/usr/ccsp/ccsp-servicemanager-broadband/svcagt_exclude_services.txt \
"

FILES_SOLIBSDEV = ""
INSANE_SKIP_${PN} += "dev-so"

do_install_append () {
    # Config files and scripts
    install -d ${D}/usr/ccsp
    install -d ${D}/usr/ccsp/ccsp-servicemanager-broadband
    install -m 644 ${S}/config/TR181-ServiceManager.xml ${D}/usr/ccsp/ccsp-servicemanager-broadband/TR181-ServiceManager.xml
    install -m 644 ${S}/services_exclude/Exclude_services_xB3.txt ${D}/usr/ccsp/ccsp-servicemanager-broadband/svcagt_exclude_services.txt
    ln -sf /usr/bin/CcspServiceManager ${D}/usr/ccsp/CcspServiceManager
}
