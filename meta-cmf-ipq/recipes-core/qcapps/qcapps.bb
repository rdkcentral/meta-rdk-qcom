DESCRIPTION = "Recipe file for QCA apps dependency"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${THISDIR}/../../../LICENSE;md5=35da34c67794562b2aff4c96502498b1"
inherit prebuilt

FILESPATH =+ "${TOPDIR}/../common/qcapps:"

inherit systemd breakpad-wrapper

DEPENDS = "glib-2.0 glibc jansson libnl libubox libpcap json-c rbus openssl breakpad breakpad-wrapper gtest cmake-native ccsp-one-wifi ccsp-one-wifi-libwebconfig rdk-wifi-halif unified-wifi-mesh-header mariadb gcc-sanitizers ca-certificates-native mosquitto "

S = "${WORKDIR}/qcapps"

FILES_SOLIBSDEV = ""
INSANE_SKIP_${PN} = "dev-so"
INSANE_SKIP_${PN} += "ldflags  installed-vs-shipped"

do_compile[noexec] = "1"

do_copy_data_model_headers() {
    install -d ${RECIPE_SYSROOT}${includedir}
    for h in ${TMPDIR}/work/${MULTIMACH_TARGET_SYS}/ccsp-one-wifi/*/git/source/platform/common/data_model/*.h; do
        if [ -f "$h" ]; then
            install -m 0644 "$h" ${RECIPE_SYSROOT}${includedir}/
        fi
    done
}
addtask do_copy_data_model_headers after do_prepare_recipe_sysroot before do_compile

do_install() {
    install -d ${D}${includedir}
    for h in ${TMPDIR}/work/${MULTIMACH_TARGET_SYS}/ccsp-one-wifi/*/git/source/platform/common/data_model/*.h; do
        if [ -f "$h" ]; then
            install -m 0644 "$h" ${D}${includedir}/
        fi
    done
}

FILES_${PN} += "${includedir}"
