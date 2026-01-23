inherit dos2unix

FILESPATH =+ "${TOPDIR}/../meta-cmf-ipq/recipes-ccsp/ccsp:"
FILESEXTRAPATHS_append := "${THISDIR}:"

SRC_URI += " file://003-6G-HalInterface-Generic.patch \
             file://005-Regulatory-missing-countries-HalInterface-Generic.patch \
	     file://acs_refreshperiod.patch \
	     file://018-auto-bandwidth-enable.patch \
           "

SOC="${@d.getVar('SOC_FAMILY', d, 1).split(':')[1]}"
export SOC_T = "${@d.getVar('SOC', d, 0).split('_')[0]}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', "ipq807x", " -D_PLATFORM_IPQ807x", " ", d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', "ipq807x", " -DMAX_NUM_RADIOS=2", " ", d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', "ipq53xx", " -D_PLATFORM_IPQ53xx", " ", d)}"

do_mypatch() {
           if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/halinterface/.003-6G-HalInterface-Generic.patched ]; then
                 cd ${TOPDIR}/../rdkb/components/opensource/ccsp/halinterface
                 patch -p1 < ${WORKDIR}/003-6G-HalInterface-Generic.patch
                 cd -
                 touch ${TOPDIR}/../rdkb/components/opensource/ccsp/halinterface/.003-6G-HalInterface-Generic.patched
            fi

	    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/halinterface/.005-Regulatory-missing-countries-HalInterface-Generic.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/halinterface
                  patch -p1 < ${WORKDIR}/005-Regulatory-missing-countries-HalInterface-Generic.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/halinterface/.005-Regulatory-missing-countries-HalInterface-Generic.patched
            fi
 
	    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/halinterface/.acs_refreshperiod.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/halinterface
                  patch -p1 < ${WORKDIR}/acs_refreshperiod.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/halinterface/.acs_refreshperiod.patched
            fi

	    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/halinterface/.018-auto-bandwidth-enable.patched ]; then
		  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/halinterface
		  patch -p1 < ${WORKDIR}/018-auto-bandwidth-enable.patch
		  cd -
		  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/halinterface/.018-auto-bandwidth-enable.patched
	    fi
}

addtask mypatch after do_unpack before do_compile
addtask convert_crlf_to_lf before do_mypatch 
