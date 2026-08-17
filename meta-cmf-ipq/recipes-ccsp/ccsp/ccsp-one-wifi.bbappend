FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_remove = "${CMF_GIT_ROOT}/rdkb/components/opensource/ccsp/OneWifi;protocol=${CMF_GIT_PROTOCOL};branch=${CMF_GIT_BRANCH};name=OneWifi"
SRC_URI = "git://github.com/rdkcentral/OneWifi.git;protocol=https;branch=main;name=OneWifi"
SRCREV_OneWifi = "${AUTOREV}"

SRC_URI += " ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', 'file://EasymeshCfg.json', '', d)}"

SOC="${@d.getVar('SOC_FAMILY', d, 1).split(':')[1]}"
export SOC_T = "${@d.getVar('SOC', d, 0).split('_')[0]}"
NUM_OF_RADIOS = "${@d.getVar('NUM_RADIOS', d, 1).split(':')[1]}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq807x', ' -D_PLATFORM_IPQ807x', ' ', d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq807x', ' -DMAX_NUM_RADIOS=2', ' ', d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq54xx', ' -DMAX_NUM_RADIOS=${NUM_OF_RADIOS}', ' ', d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq53xx', ' -DMAX_NUM_RADIOS=${NUM_OF_RADIOS}', ' ', d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq95xx', ' -DMAX_NUM_RADIOS=${NUM_OF_RADIOS}', ' ', d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq52xx', ' -DMAX_NUM_RADIOS=${NUM_OF_RADIOS}', ' ', d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq96xx', ' -DMAX_NUM_RADIOS=${NUM_OF_RADIOS}', ' ', d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq53xx', ' -D_PLATFORM_IPQ53xx', ' ', d)}"

CFLAGS_append = " -DWIFI_HAL_VERSION_3 -DCONFIG_DFS -DFEATURE_SUPPORT_WPS -DQCOM_ATH12K_PORT "
CFLAGS_append_aarch64 = " -D_64BIT_ARCH_SUPPORT_ "

EXTRA_OECONF_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' --enable-em-app ', '', d)}"
CFLAGS_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' -DEASY_MESH_NODE ', '', d)}"
CFLAGS_append = " -DFEATURE_SINGLE_PHY"

CFLAGS_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' -Wno-unused-function -Wno-error ', '', d)}"
EXTRA_OECONF_append = "  ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' --enable-easymesh=yes --enable-em-app ', '', d)}"

DEPENDS_append = " rdk-wifi-hal hal-wifi-generic rdk-wifi-libhostap"
LDFLAGS_append = " -lbreakpadwrapper -lhal_wifi"

LDFLAGS_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' -ldl ', '', d)}"

EXTRA_OECONF_remove = " ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' ONEWIFI_CAC_APP_SUPPORT=true ', '', d)}"
CFLAGS_remove = " ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' -DONEWIFI_CAC_APP_SUPPORT ', '', d)}"

FILES_${PN}_append += "${bindir}/wifi_events_consumer"
FILES_${PN}_append += "${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' /nvram/EasymeshCfg.json', '', d)}"

FILES_${PN}_append +=  "\
                        ${libdir}/libwifi_math_utils.so.* \
                        ${libdir}/libwifi_quality_manager.so.* \
                        "

DEPENDS_remove = " hal-mta "


do_install_append() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', 'true', 'false', d)}; then
        install -d ${D}/nvram
        install -m 644 ${WORKDIR}/EasymeshCfg.json ${D}/nvram/EasymeshCfg.json
    fi
}
