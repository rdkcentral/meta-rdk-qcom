require ccsp_common_ipq.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_remove = "git://github.com/rdkcentral/rdk-wifi-hal.git;protocol=https;branch=main;name=rdk-wifi-hal"

SRC_URI += "git://github.com/akilesh-k26/rdk-wifi-hal.git;protocol=https;branch=develop;name=rdk-wifi-hal"
SRCREV_rdk-wifi-hal = "${AUTOREV}"

SRC_URI += "file://factory_nvram.data \
           "

EXTRA_OECONF_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', 'QCOM_ATH12K_PORT=true', '', d)}"

CFLAGS_append = " -DHOSTAPD_2_12 -DPLATFORM_IPQ -DQCOM_ATH12K_PORT "
# hostapd_if_plugin.h (in qcn_extns/) includes hostapd_if_common.h which lives in
# src/hostapd_if/ — add that subdirectory explicitly so the compiler can find it.
CFLAGS_append = " -I${PKG_CONFIG_SYSROOT_DIR}/usr/include/rdk-wifi-libhostap/src/hostapd_if"

# Use the mac80211/uapi nl80211.h (from backports-6.1, same as the running kernel)
# instead of the older linux-libc-headers nl80211.h.  The linux-libc-headers version
# has only 311 nl80211_attrs entries and 236 nl80211_ext_feature_index entries, while
# the backports-6.1 kernel has 380 and 308 respectively.  This mismatch causes
# NL80211_EXT_FEATURE_FILS_DISCOVERY to resolve to bit 235 in userspace but bit 307
# in the kernel, so FILS Discovery capability is never detected.  Placing the
# mac80211/uapi path first ensures the correct (kernel-matching) nl80211.h is used.
CFLAGS_prepend = "-I${PKG_CONFIG_SYSROOT_DIR}/usr/include/mac80211/uapi "

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

DEPENDS += " hal-wifi-generic rdk-wifi-libhostap open-mac80211"

LDFLAGS_append = " -lhal_wifi"

#ONEWIFI_CONFIG_FLAGS_append = "-DVNTXER5_PORT"
CFLAGS_append += " -DEAPOL_OVER_NL -fcommon -DCONFIG_HW_CAPABILITIES -DCONFIG_IEEE80211W -DCONFIG_WMM "

# Workaround because flags propagation via pkg does not work for hostapd 2.10 and below.
CFLAGS_append = " \
    ${@bb.utils.contains('DISTRO_FEATURES', 'CONFIG_IEEE80211BE', '-DCONFIG_IEEE80211BE -DCONFIG_MLO', '', d)} \
"
ONEWIFI_CONFIG_FLAGS = " -DWIFI_HAL_VERSION_3 \
                         -DLINUX_PORT \
                         -DRDK_ONEWIFI \
                         -DRDK_PORT -DFEATURE_SINGLE_PHY \
                         -DKERNEL_6_6 -DCONFIG_GENERIC_MLO"

# Propagate build-time CONFIG_* flags from rdk-wifi-libhostap (Makefile.libhostap)
# into rdk-wifi-hal via the libhostap.pc pkg-config file installed by
# meta-cmf-ipq/recipes-ccsp/rdk-wifi-libhostap/rdk-wifi-libhostap.bbappend.
# This replaces the ONEWIFI_CONFIG_FLAGS legacy block in rdk-wifi-hal.bb for
# the IPQ/UD-driver platform.
do_configure_prepend() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', 'true', 'false', d)}; then
        LIBHOSTAP_CFLAGS=$(pkg-config --cflags libhostap 2>/dev/null || true)
        if [ -n "${LIBHOSTAP_CFLAGS}" ]; then
            bbnote "rdk-wifi-hal (IPQ): applying libhostap pkg-config cflags: $LIBHOSTAP_CFLAGS"
            export CFLAGS="${CFLAGS} ${LIBHOSTAP_CFLAGS} ${ONEWIFI_CONFIG_FLAGS}"
        else
            bbnote "rdk-wifi-hal (IPQ): libhostap.pc not found, using ONEWIFI_CONFIG_FLAGS fallback"
            export CFLAGS="${CFLAGS} ${ONEWIFI_CONFIG_FLAGS}"
        fi
    fi
}

FILES_${PN} += "/tmp/factory_nvram.data"
INSANE_SKIP_${PN} += "empty-dirs"

do_install_append() {
    # Remove aes_siv.h, don't install header files which is already provided by libwpa2
    rm -f ${D}${includedir}/aes_siv.h

    # Install factory_nvram.data to /etc on the target
    install -d ${D}/etc
    install -m 0444 ${WORKDIR}/factory_nvram.data ${D}/etc/factory_nvram.data
}
