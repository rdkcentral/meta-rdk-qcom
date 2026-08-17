GIT_TAG = "v1.6.0"
SRC_URI := "git://github.com/rdkcentral/ppp-manager.git;branch=releases/1.6.0-main;protocol=https;name=PppManager;tag=${GIT_TAG}"
PV = "${GIT_TAG}+git${SRCPV}"

FILESEXTRAPATHS_prepend := "${THISDIR}:"
SRC_URI += " file://001-pppmanager-vlan-change-name.patch \
	     file://015_PPPoE_SNAT-in-PPpMang.patch \
           "
CFLAGS_append_kirkstone = " ${@bb.utils.contains('DISTRO_FEATURES', 'safec', ' -fPIC -I${STAGING_INCDIR}/safeclib', '-fPIC', d)}"
