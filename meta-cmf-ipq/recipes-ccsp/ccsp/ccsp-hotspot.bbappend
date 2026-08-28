require ccsp_common_ipq.inc

CFLAGS_remove = "-Werror"
FILESPATH =+ "${TOPDIR}/../meta-cmf-ipq/recipes-ccsp/ccsp:"
DEPENDS += "rbus"
LDFLAGS += "-lrbus"
CFLAGS_append = " -I${STAGING_INCDIR}/rbus"
