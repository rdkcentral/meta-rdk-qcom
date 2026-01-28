FILESEXTRAPATHS_append := "${THISDIR}/file:"
SRC_URI_append += "file://dhcpfixup.patch;patchdir=${WORKDIR};striplevel=0"

