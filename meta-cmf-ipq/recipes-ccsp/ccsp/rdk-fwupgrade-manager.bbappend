FILESEXTRAPATHS_prepend := "${THISDIR}:"

SRC_URI_append += "file://rootpermission_fwupgrade.patch"

EXTRA_OECONF_remove_kirkstone = " --with-ccsp-platform=bcm --with-ccsp-arch=arm "
CFLAGS_append_kirkstone = " ${@bb.utils.contains('DISTRO_FEATURES', 'safec', ' -fPIC -I${STAGING_INCDIR}/safeclib', '-fPIC', d)}"

