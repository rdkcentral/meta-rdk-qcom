SRC_URI_remove = "${CMF_GIT_ROOT}/rdkb/components/opensource/ccsp/OneWifi;protocol=${CMF_GIT_PROTOCOL};branch=${CMF_GIT_BRANCH};name=libwebconfig"

SRC_URI = "git://github.com/akilesh-k26/OneWifi.git;protocol=https;branch=develop;name=libwebconfig"
SRCREV_libwebconfig = "${AUTOREV}"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

CFLAGS_append = " -DMAX_NUM_RADIOS=3 -DCONFIG_IEEE80211AX -DQCOM_ATH12K_PORT "

DEPENDS += " rdk-wifi-libhostap"

CFLAGS_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' -DONEWIFI_RBUS_SUPPORT=1 ', '', d)}"

DEPENDS += " ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' rdk-wifi-libhostap unified-wifi-mesh-header ', '', d)}"
EXTRA_OECONF_append = "${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' --enable-easymesh --enable-em-app ', '', d)}"
CFLAGS += " -Wno-enum-conversion "
CFLAGS += "${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' -Wno-error=maybe-uninitialized -Wno-error=unused-variable -Wno-error=unused-but-set-variable -Wno-error=incompatible-pointer-types -Wno-error=sign-compare -Wno-error -DEASY_MESH_NODE -DEM_APP  ', '', d)}"

do_compile_append() {
	oe_runmake -C source/platform
}

do_install_append() {
	oe_runmake -C source/platform DESTDIR=${D} install
	install -m 644 ${S}/include/webconfig_external_proto_easymesh.h  ${D}/usr/include/ccsp
}

