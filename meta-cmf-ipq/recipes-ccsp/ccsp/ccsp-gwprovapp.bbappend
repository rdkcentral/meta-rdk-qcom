require ccsp_common_ipq.inc

DEPENDS_remove = " ruli"
FILESPATH =+ "${TOPDIR}/../meta-cmf-ipq/recipes-ccsp/ccsp:"
export PLATFORM_IPQ_ENABLED="yes"
CFLAGS += " -Wno-unused-function "
SSTATE_ALLOW_OVERLAP_FILES += "${STAGING_DIR_TARGET}${includedir}/utctx/autoconf.h"

FILES_${PN} += " \
    ${STAGING_DIR_TARGET}${includedir}/utctx/autoconf.h \
    /usr/bin/gw_prov_utopia \
"


