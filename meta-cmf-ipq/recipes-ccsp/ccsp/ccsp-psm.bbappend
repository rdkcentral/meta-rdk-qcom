require ccsp_common_ipq.inc
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SOC="${@d.getVar('SOC_FAMILY', d, 1).split(':')[1]}"
export SOC_T = "${@d.getVar('SOC', d, 0).split('_')[0]}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq95xx', ' -D_PLATFORM_IPQ95xx', ' ', d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq54xx', ' -D_PLATFORM_IPQ54xx', ' ', d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq53xx', ' -D_PLATFORM_IPQ53xx', ' ', d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq52xx', ' -D_PLATFORM_IPQ52xx', ' ', d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq96xx', ' -D_PLATFORM_IPQ96xx', ' ', d)}"
SRC_URI += "file://bbhm_def_cfg_ipq.xml"

ETH_MEMBERS = "${@bb.utils.contains('SOC_T', 'ipq95xx', 'eth0 eth1 eth2 eth3 eth4', \
                    bb.utils.contains('SOC_T', 'ipq54xx', 'eth1 eth2', \
                        bb.utils.contains('SOC_T', 'ipq53xx', 'eth1', \
                            bb.utils.contains('SOC_T', 'ipq52xx', 'eth1 eth2 eth3 eth4 eth5', \
                                bb.utils.contains('SOC_T', 'ipq96xx', 'eth0 eth1 eth2 eth3 eth4', \
                                '', d), d), d), d), d)}"

ETHIFCOUNT = "${@bb.utils.contains('SOC_T', 'ipq53xx', '5', '6', d)}"

WAN_BASE_IF = "${@bb.utils.contains_any('SOC_T', 'ipq95xx ipq96xx', \
                    'Device.Ethernet.X_RDK_Interface.6', \
                    'Device.Ethernet.X_RDK_Interface.1', d)}"

WAN_IF_NAME = "${@bb.utils.contains_any('SOC_T', 'ipq95xx ipq96xx', \
                    'eth5', 'eth0', d)}"

do_install_append() {
    # Config files and scripts
    install -d ${D}/usr/ccsp/config
    install -m 644 ${WORKDIR}/bbhm_def_cfg_ipq.xml ${D}/usr/ccsp/config/bbhm_def_cfg.xml
    install -m 755 ${S}/scripts/bbhm_patch.sh ${D}/usr/ccsp/psm/bbhm_patch.sh

    sed -i "s#<Record name=\"dmsb.l2net.1.Members.Eth\" type=\"astr\">.*</Record>#<Record name=\"dmsb.l2net.1.Members.Eth\" type=\"astr\">${ETH_MEMBERS}</Record>#" \
        ${D}/usr/ccsp/config/bbhm_def_cfg.xml

    sed -i "/<Record name=\"dmsb.l2net.1.Members.Eth\" type=\"astr\">/a <Record name=\"dmsb.ethagent.ethifcount\" type=\"astr\">${ETHIFCOUNT}</Record>" \
        ${D}/usr/ccsp/config/bbhm_def_cfg.xml

    sed -i "s#<Record name=\"dmsb.wanmanager.if.1.BaseInterface\" type=\"astr\">[^<]*</Record>#<Record name=\"dmsb.wanmanager.if.1.BaseInterface\" type=\"astr\">${WAN_BASE_IF}</Record>#" \
        ${D}/usr/ccsp/config/bbhm_def_cfg.xml

    sed -i "s#<Record name=\"dmsb.wanmanager.if.1.Name\" type=\"astr\">[^<]*</Record>#<Record name=\"dmsb.wanmanager.if.1.Name\" type=\"astr\">${WAN_IF_NAME}</Record>#" \
        ${D}/usr/ccsp/config/bbhm_def_cfg.xml

}
