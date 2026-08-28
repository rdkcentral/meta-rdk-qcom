#FILESEXTRAPATHS_append := "${THISDIR}/files:"
FILESPATH =+ "${TOPDIR}/../meta-cmf-ipq/recipes-common/crashupload/files:"

SRC_URI += " \
            file://01-changes-for-crashupload.patch \
            "

do_install_append() {
	# Remove the multiple Install sections in the service file and overwrite with the below snippet
	sed -i '/^\[Install\]/,$d' "${D}${systemd_system_unitdir}/coredump-upload.service"
	cat >> "${D}${systemd_system_unitdir}/coredump-upload.service" << 'EOF'
[Install]
WantedBy=multi-user.target
EOF

	# Remove network dependency in the path for avoid ordering cycle loops in systemd
	sed -i '/^After=network-online\.target$/d;/^Requires=network-online\.target$/d' "${D}${systemd_system_unitdir}/coredump-upload.path"
	# Use multi-user.target as wan-initialized.target is invalid
	sed -i 's/^WantedBy=wan-initialized\.target$/WantedBy=multi-user.target/' "${D}${systemd_system_unitdir}/coredump-upload.path"
}
