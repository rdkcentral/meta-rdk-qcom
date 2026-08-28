FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# QCA-specific patches and files for HOSTAPD 2.12
# These are vendor-specific customizations for Qualcomm platforms
SRC_URI:append = " \
    file://2.12/qca-vendor.h \
    file://2.12/0013-new-qcvendor.patch;patchdir=source/hostap-${HOSTAPD_PV} \
    file://2.12/0014-use-link-addr-for-auth-reply.patch;patchdir=source/hostap-${HOSTAPD_PV} \
    file://2.12/0015-expose-hostapd_setup_bss.patch;patchdir=source/hostap-${HOSTAPD_PV} \
    file://2.12/0016-comment-uhr-operation.patch;patchdir=source/hostap-${HOSTAPD_PV} \
"

# Copy QCA vendor header to source tree
do_configure:append() {
    if ${@bb.utils.contains('DISTRO_FEATURES', 'HOSTAPD_2_12', 'true', 'false', d)}; then
        install -m 0644 ${WORKDIR}/2.12/qca-vendor.h ${S}/source/hostap-${HOSTAPD_PV}/src/common/qca-vendor.h
        bbnote "Installed QCA vendor header for Qualcomm platform"
    fi
}
