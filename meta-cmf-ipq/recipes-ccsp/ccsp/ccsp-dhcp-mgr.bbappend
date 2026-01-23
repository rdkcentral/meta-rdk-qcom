FILESEXTRAPATHS_prepend := "${THISDIR}:"
DEPENDS_append = " core-net-lib breakpad-wrapper"
CFLAGS_append = " \
    -I${STAGING_INCDIR}/core-net-lib \
"
LDFLAGS_append = " \
    -lbreakpadwrapper \
"
LDFLAGS_append_aarch64 = " -lnanomsg "
CFLAGS_append = " -D_COSA_BCM_ARM_  "
