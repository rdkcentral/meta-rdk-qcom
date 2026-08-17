require recipes-ccsp/ccsp/ccsp_common_ipq.inc

FILESEXTRAPATHS_prepend := "${THISDIR}:"
SRC_URI += " file://001-task_health.patch \
             file://002-fix_martian_flooding.patch \
           "
