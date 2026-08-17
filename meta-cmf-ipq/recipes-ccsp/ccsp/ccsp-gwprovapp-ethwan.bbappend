require ccsp_common_ipq.inc

export PLATFORM_RASPBERRYPI_ENABLED="yes"
BB_HASH_IGNORE_MISMATCH = "1"
DEPENDS_remove_dunfell = "hal-gwprovappabs"
LDFLAGS_remove_dunfell = "-lgwprovappabs"
DEPENDS_remove_kirkstone = "hal-gwprovappabs"
LDFLAGS_remove_kirkstone = "-lgwprovappabs"

CFLAGS_remove = "-Werror"
CFLAGS_remove = " -D_PLATFORM_RASPBERRYPI_"
CFLAGS_append = "-D_PLATFORM_IPQ_"
CFLAGS_append = " -Wno-unused-variable -Wno-sizeof-pointer-memaccess -Wno-unused-parameter -Wno-unused-but-set-variable "

inherit systemd

SOC="${@d.getVar('SOC_FAMILY', d, 1).split(':')[1]}"
export SOC_T = "${@d.getVar('SOC', d, 0).split('_')[0]}"
NUM_OF_RADIOS = "${@d.getVar('NUM_RADIOS', d, 1).split(':')[1]}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq807x', ' -D_PLATFORM_IPQ807x', ' ', d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq807x', ' -DMAX_NUM_RADIOS=2', ' ', d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq54xx', ' -DMAX_NUM_RADIOS=${NUM_OF_RADIOS}', ' ', d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq53xx', ' -DMAX_NUM_RADIOS=${NUM_OF_RADIOS}', ' ', d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq95xx', ' -DMAX_NUM_RADIOS=${NUM_OF_RADIOS}', ' ', d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq95xx', ' -D_PLATFORM_IPQ95xx', ' ', d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq96xx', ' -DMAX_NUM_RADIOS=${NUM_OF_RADIOS}', ' ', d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', 'ipq96xx', ' -D_PLATFORM_IPQ96xx', ' ', d)}"

FILESEXTRAPATHS_prepend := "${THISDIR}:"
SRC_URI += " file://gw_prov_ethwan_sm-001.patch "
SRC_URI += " file://IPQ_MACRO_Gw_prov-002.patch "
SRC_URI += " file://020-10G_wan_port_change_alder_gw_prov.patch"

SYSTEMD_SERVICE_${PN} = "gwprovethwan.service"
FILES_${PN} += " \
     ${systemd_unitdir}/system/gwprovethwan.service "

do_install_append () {
	install -d ${D}${systemd_unitdir}/system
	install -m 0644 ${S}/service/gwprovethwan.service ${D}${systemd_unitdir}/system
        sed -i "s/After=rg_network.service/After=network.target/g"  ${D}${systemd_unitdir}/system/gwprovethwan.service
        sed -i "/After=network.target/a wants=network.target"  ${D}${systemd_unitdir}/system/gwprovethwan.service
        sed -e '/Type/ s/^#*/#/' -i  ${D}${systemd_unitdir}/system/gwprovethwan.service
        sed -e '/ExecStartPre/ s/^#*/#/' -i  ${D}${systemd_unitdir}/system/gwprovethwan.service
        sed -i "/utopia_init.sh/a ExecStartPre=-/bin/sh -c 'mkdir -p /rdklogs/logs/'"  ${D}${systemd_unitdir}/system/gwprovethwan.service
        sed -i "/utopia_init.sh/a ExecStartPre=/bin/sh /lib/rdk/run_rm_key.sh" ${D}${systemd_unitdir}/system/gwprovethwan.service
        sed -i "/utopia_init.sh/a ExecStartPre=/bin/sh /lib/rdk/if_check.sh" ${D}${systemd_unitdir}/system/gwprovethwan.service
        sed -e '/ExecStartPost/ s/^#*/#/' -i  ${D}${systemd_unitdir}/system/gwprovethwan.service
        sed -i "/bin\/rm/a Restart=always"  ${D}${systemd_unitdir}/system/gwprovethwan.service
	sed -i "/rdklogs/a ExecStartPre=/bin/sh -c 'mkdir -p /nvram/'" ${D}${systemd_unitdir}/system/gwprovethwan.service
	sed -i "/nvram/a ExecStartPre=/bin/touch /nvram/ETHWAN_ENABLE" ${D}${systemd_unitdir}/system/gwprovethwan.service
	sed -i "s/#ExecStartPre=\/bin\/sh \/usr\/ccsp\/utopia_init.sh/ExecStartPre=\/bin\/sh \/etc\/utopia\/utopia_init.sh/g" ${D}${systemd_unitdir}/system/gwprovethwan.service
#        sed -i "/gw_prov_ethwan/a ExecStartPost=/bin/sh -c 'cd /lib/systemd/system; sleep 10; systemctl restart ccspwifiagent.service'" ${D}${systemd_unitdir}/system/gwprovethwan.service
}
