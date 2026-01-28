require ccsp_common_ipq.inc
CFLAGS_aarch64_append = " -Werror=format-truncation=1 "
CFLAGS_append = " -D_RDK_REF_PLATFORM_ -DDSLITE_FEATURE_SUPPORT_ -DDDNS_BROADBANDFORUM_ -DDEVICE_GATEWAY_ASSOCIATION_FEATURE_ \
                  -DFEATURE_FWUPGRADE_MANAGER_ -DFEATURE_RDKB_GPON_MANAGER_ -DFEATURE_RDKB_XDSL_PPP_MANAGER_ -DFEATURE_SUPPORT_RDKLOG_"

FILESEXTRAPATHS_prepend := "${THISDIR}:"

SOC="${@d.getVar('SOC_FAMILY', d, 1).split(':')[1]}"
export SOC_T = "${@d.getVar('SOC', d, 0).split('_')[0]}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', "ipq807x", " -D_PLATFORM_IPQ807x", " ", d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', "ipq807x", " -DMAX_NUM_RADIOS=2", " ", d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', "ipq95xx", " -D_PLATFORM_IPQ95xx", " ", d)}"


SRC_URI += " file://001-CcspEthAgent.patch \
	     file://003-Ethagent-eth-interface-name-change.patch \
       file://020-10G_wan_port_change_alder_cosa_ethernet.patch "

do_mypatch() {
            if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspEthAgent/source/.001-CcspEthAgent-patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspEthAgent/source/
                  patch -p2 < ${WORKDIR}/001-CcspEthAgent.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspEthAgent/source/.001-CcspEthAgent-patched
            fi

      	   if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspEthAgent/source/.003-Ethagent-eth-interface-name-change.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspEthAgent/source/
                  patch -p2 < ${WORKDIR}/003-Ethagent-eth-interface-name-change.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspEthAgent/source/.003-Ethagent-eth-interface-name-change.patched
            fi

           if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspEthAgent/source/.020-10G_wan_port_change_alder_cosa_ethernet.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspEthAgent/source/
                  patch -p2 < ${WORKDIR}/020-10G_wan_port_change_alder_cosa_ethernet.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspEthAgent/source/.020-10G_wan_port_change_alder_cosa_ethernet.patched
            fi
 

}

addtask mypatch after do_unpack before do_compile
