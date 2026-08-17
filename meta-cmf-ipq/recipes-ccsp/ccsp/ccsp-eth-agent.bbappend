require ccsp_common_ipq.inc
CFLAGS_aarch64_append = " -Werror=format-truncation=1 "
CFLAGS_append = " -D_RDK_REF_PLATFORM_ -DDSLITE_FEATURE_SUPPORT_ -DDDNS_BROADBANDFORUM_ -DDEVICE_GATEWAY_ASSOCIATION_FEATURE_ \
                  -DFEATURE_FWUPGRADE_MANAGER_ -DFEATURE_RDKB_GPON_MANAGER_ -DFEATURE_RDKB_XDSL_PPP_MANAGER_ -DFEATURE_SUPPORT_RDKLOG_ \
                  -D_2_5G_ETHERNET_SUPPORT_ \
                "
FILESEXTRAPATHS_prepend := "${THISDIR}:"
CFLAGS:remove = "-DFEATURE_SUPPORT_ONBOARD_LOGGING "

SOC="${@d.getVar('SOC_FAMILY', d, 1).split(':')[1]}"
export SOC_T = "${@d.getVar('SOC', d, 0).split('_')[0]}"
NUM_OF_RADIOS = "${@d.getVar('NUM_RADIOS', d, 1).split(':')[1]}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq807x', ' -D_PLATFORM_IPQ807x', ' ', d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq807x', ' -DMAX_NUM_RADIOS=2', ' ', d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq54xx', ' -DMAX_NUM_RADIOS=${NUM_OF_RADIOS}', ' ', d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq53xx', ' -DMAX_NUM_RADIOS=${NUM_OF_RADIOS}', ' ', d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq95xx', ' -DMAX_NUM_RADIOS=${NUM_OF_RADIOS}', ' ', d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq52xx', ' -DMAX_NUM_RADIOS=${NUM_OF_RADIOS}', ' ', d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq96xx', ' -DMAX_NUM_RADIOS=${NUM_OF_RADIOS}', ' ', d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq95xx', ' -DETH_5_PORTS', ' ', d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq54xx', ' -DETH_5_PORTS', ' ', d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq52xx', ' -DETH_5_PORTS', ' ', d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq96xx', ' -DETH_5_PORTS', ' ', d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq95xx', ' -D_PLATFORM_IPQ95xx', ' ', d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq54xx', ' -D_PLATFORM_IPQ54xx', ' ', d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq53xx', ' -D_PLATFORM_IPQ53xx', ' ', d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq52xx', ' -D_PLATFORM_IPQ52xx', ' ', d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq96xx', ' -D_PLATFORM_IPQ96xx', ' ', d)}"


SRC_URI += " file://001-CcspEthAgent.patch \
             file://003-Ethagent-eth-interface-name-change.patch \
            file://020-10G_wan_port_change_alder_cosa_ethernet.patch \
            file://021-Ethagent-switch-port-handling.patch \
            file://023-Ethagent-erouter0-support.patch \
            file://juhu-10G-port-support.patch \
            file://025_EthAgent_lnkspeed_redn.patch \    
            file://miami-HTT-support.patch \
            "
