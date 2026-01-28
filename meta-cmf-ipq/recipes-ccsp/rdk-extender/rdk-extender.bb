SUMMARY = "RDK Mesh Extender"

LICENSE = "ISC"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/${LICENSE};md5=f3b90e78ea0cffb20bf5cca7947a896d"

DEPENDS = " \
           ccsp-common-library dbus rdk-logger rbus libnl utopia \
           ${@bb.utils.contains('DISTRO_FEATURES', 'safec', ' safec', " ", d)} \
          "

require recipes-ccsp/ccsp/ccsp_common.inc

FILESPATH =+ "${TOPDIR}/../rdkb/devices/ipq:"

SRC_URI = " \
            file://rdk-extender \
          "

S = "${WORKDIR}/rdk-extender"

inherit autotools pkgconfig ${@bb.utils.contains("DISTRO_FEATURES", "kirkstone", "python3native", "pythonnative", d)} systemd

CFLAGS_append = " \
           -Wall -Werror -Wextra -Wno-pointer-sign -Wno-sign-compare \
           ${@bb.utils.contains('DISTRO_FEATURES', 'safec',  ' `pkg-config --cflags libsafec`', '-fPIC', d)} \
           ${@bb.utils.contains('DISTRO_FEATURES', 'safec', '', ' -DSAFEC_DUMMY_API', d)} \
           -I${STAGING_INCDIR}/dbus-1.0 \
           -I${STAGING_LIBDIR}/dbus-1.0/include \
           -I${STAGING_INCDIR}/ccsp \
         "
CFLAGS_append_kirkstone = " -Wno-array-bounds -Wno-stringop-overflow "

LDFLAGS_append = " \
            ${@bb.utils.contains('DISTRO_FEATURES', 'safec', ' `pkg-config --libs libsafec`', '', d)} \
            -ldbus-1 -lrdkloggers \
          "
LDFLAGS_remove = "${@bb.utils.contains('DISTRO_FEATURES', 'safec', '-lsafec-3.5', '', d)}"
LDFLAGS_append_dunfell = "${@bb.utils.contains('DISTRO_FEATURES', 'safec', ' -lsafec-3.5.1 ', '', d)}"
LDFLAGS_append_kirkstone = " ${@bb.utils.contains('DISTRO_FEATURES', 'safec', ' -lsafec ', '', d)}"

do_compile_prepend(){
    (${PYTHON} ${STAGING_BINDIR_NATIVE}/dm_pack_code_gen.py ${S}/source/ccsp/config/rdk_extender.xml ${S}/source/ccsp/src/dm_pack_datamodel.c)
}

do_install_append (){
    install -d ${D}/usr/ccsp/ccsp-extender
    install -m 755 ${S}/source/ext_svc/configs/defaults.json ${D}/usr/ccsp/ccsp-extender/defaults.json
    install -m 755 ${S}/source/ext_svc/configs/hostapd0.conf ${D}/usr/ccsp/ccsp-extender/hostapd0.conf
    install -m 755 ${S}/source/ext_svc/configs/hostapd1.conf ${D}/usr/ccsp/ccsp-extender/hostapd1.conf
    install -m 755 ${S}/source/ext_svc/configs/hostapd16.conf ${D}/usr/ccsp/ccsp-extender/hostapd16.conf
    install -m 755 ${S}/source/ext_svc/configs/wpa_supplicant-def5G.conf ${D}/usr/ccsp/ccsp-extender/wpa_supplicant-def5G.conf

    install -m 755 ${S}/source/ext_svc/configs/hostapd-mld0_0.conf ${D}/usr/ccsp/ccsp-extender/hostapd-mld0_0.conf
    install -m 755 ${S}/source/ext_svc/configs/hostapd-mld1_1.conf ${D}/usr/ccsp/ccsp-extender/hostapd-mld1_1.conf
    install -m 755 ${S}/source/ext_svc/configs/hostapd-mld2_16.conf ${D}/usr/ccsp/ccsp-extender/hostapd-mld2_16.conf

    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${S}/scripts/ccsp-extender.service  ${D}${systemd_unitdir}/system

    install -m 755 ${S}/scripts/dpp-supplicant-action.sh ${D}/usr/ccsp/ccsp-extender/dpp-supplicant-action.sh

    install -d ${D}/etc
    touch ${D}/etc/rdk_extender
}

FILES_${PN} = " \
    ${bindir}/CcspExtender \
    ${bindir}/bhaul-mon-dev \
    ${bindir}/ext_svc_ping \
    ${libdir}/libext-svc-utils.so* \
    ${libdir}/libmesh-ext-svc.so* \
    ${prefix}/ccsp/ccsp-extender/defaults.json \
    ${prefix}/ccsp/ccsp-extender/hostapd0.conf \
    ${prefix}/ccsp/ccsp-extender/hostapd1.conf \
    ${prefix}/ccsp/ccsp-extender/hostapd16.conf \
    ${prefix}/ccsp/ccsp-extender/wpa_supplicant-def5G.conf \
    ${prefix}/ccsp/ccsp-extender/hostapd-mld0_0.conf \
    ${prefix}/ccsp/ccsp-extender/hostapd-mld1_1.conf \
    ${prefix}/ccsp/ccsp-extender/hostapd-mld2_16.conf \
    ${systemd_unitdir}/system/ccsp-extender.service \
    ${prefix}/ccsp/ccsp-extender/dpp-supplicant-action.sh \
    /etc/rdk_extender \
    "

SYSTEMD_SERVICE_${PN} = "ccsp-extender.service"
