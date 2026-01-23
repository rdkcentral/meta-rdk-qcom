require recipes-ccsp/ccsp/ccsp_common_ipq.inc

SOC="${@d.getVar('SOC_FAMILY', d, 1).split(':')[1]}"

#DEPENDS_append = "utopia-headers"
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " \
    file://system_defaults \
    file://ipq53xx_64_system_defaults \
    file://ipq53xx_system_defaults \
    file://ipq54xx_64_system_defaults \
    file://ipq54xx_system_defaults \
    file://ipq807x_64_system_defaults \
    file://ipq807x_system_defaults \
    file://ipq95xx_64_system_defaults \
    file://ipq95xx_system_defaults \
    file://0004-service-wan.patch \
    file://005-lan-handler-dhcp-server-functions.patch \
    file://0006-sysevetd-main.patch \
    file://0007-firewall.patch \
    file://0008-geneiacs-server.patch \
    file://0009-lan-handler-psm-rpi-ipq.patch \
    file://0010-service-multinet.patch \
    file://0011-handle-gre.patch \
    file://0005-service-lan.patch \
    file://0012-service-gre-route-add.patch \
    file://0013-service-dhcp-for-four-bridge.patch \
    file://0014-service-dhcp-server-fix.patch \
    file://015_PPPoE_SNAT-in-Firewall.patch \
    file://016_power_save.patch \
    file://multiple_reboot.patch \
    file://019-ezmesh-firewall-sysevent.patch \
    file://020-Captive_Portal_dhcp_server_function.patch \
    file://021-dibbler_restart_for_dslite_tunnel_creation.patch \
    file://022-enable_bridge_multicast.patch \
    file://023-IPv6_GRETAP_Tunnel_Interface_fix.patch \
    file://0015-service-bridge_wan_fix.patch \
    file://025-dropbear-enablement-fix.patch \
    file://026-utopia-init-fix.patch \
    file://025-dhcp_mode_and_ppp_trafficflow_fix.patch  \
    file://026-potd_console_flood_fix.patch  \
    file://027-syscfg_init_fix.patch \
"

SSTATE_ALLOW_OVERLAP_FILES += "${STAGING_DIR_TARGET}${includedir}/utctx/autoconf.h"
SSTATE_ALLOW_OVERLAP_FILES += "${STAGING_DIR_TARGET}${includedir}/utctx/utctx.h"
SSTATE_ALLOW_OVERLAP_FILES += "${STAGING_DIR_TARGET}${includedir}/utctx/utctx_api.h"
SSTATE_ALLOW_OVERLAP_FILES += "${STAGING_DIR_TARGET}${includedir}/utctx/utctx_rwlock.h"

LDFLAGS_append = " \
    -lsecure_wrapper \
    -lbreakpadwrapper \
    -lhal_platform \
"

CFLAGS_append = " -Wno-format-extra-args -Wno-error "

do_install_append() {

    # Don't install header files which are provided by utopia-headers
    rm -f ${D}${includedir}/utctx/autoconf.h
    rm -f ${D}${includedir}/utctx/utctx.h
    rm -f ${D}${includedir}/utctx/utctx_api.h
    rm -f ${D}${includedir}/utctx/utctx_rwlock.h

    # Config files and scripts
    install -d ${D}/rdklogs
    install -d ${D}/fss/gw/bin
    install -d ${D}/fss/gw/usr/bin
    install -d ${D}/fss/gw/usr/sbin
    install -d ${D}/fss/gw/etc/utopia/service.d
    install -d ${D}/var/spool/cron/crontabs

    install -d ${D}${sbindir}/
    install -d ${D}${sysconfdir}/utopia/service.d
    install -d ${D}${sysconfdir}/utopia/registration.d
    install -d ${D}${sysconfdir}/utopia/post.d
    install -d ${D}${sysconfdir}/IGD
    install -d ${D}${sysconfdir}/utopia/service.d/service_bridge
    install -d ${D}${sysconfdir}/utopia/service.d/service_ddns
    install -d ${D}${sysconfdir}/utopia/service.d/service_dhcp_server
    install -d ${D}${sysconfdir}/utopia/service.d/service_lan
    install -d ${D}${sysconfdir}/utopia/service.d/service_multinet
    install -d ${D}${sysconfdir}/utopia/service.d/service_syslog
    install -d ${D}${sysconfdir}/utopia/service.d/service_wan

    install -m 755 ${S}/source/scripts/init/system/utopia_init.sh ${D}${sysconfdir}/utopia/
    install -m 755 ${S}/source/scripts/init/service.d/*.sh ${D}${sysconfdir}/utopia/service.d/
    install -m 755 ${S}/source/scripts/init/service.d/service_bridge/*.sh ${D}${sysconfdir}/utopia/service.d/service_bridge
    install -m 755 ${S}/source/scripts/init/service.d/service_ddns/*.sh ${D}${sysconfdir}/utopia/service.d/service_ddns
    install -m 755 ${S}/source/scripts/init/service.d/service_dhcp_server/* ${D}${sysconfdir}/utopia/service.d/service_dhcp_server
    install -m 755 ${S}/source/scripts/init/service.d/service_lan/*.sh ${D}${sysconfdir}/utopia/service.d/service_lan
    install -m 755 ${S}/source/scripts/init/service.d/service_multinet/*.sh ${D}${sysconfdir}/utopia/service.d/service_multinet
    install -m 755 ${S}/source/scripts/init/service.d/service_syslog/*.sh ${D}${sysconfdir}/utopia/service.d/service_syslog
    install -m 755 ${S}/source/scripts/init/service.d/service_wan/*.sh ${D}${sysconfdir}/utopia/service.d/service_wan
    install -m 755 ${S}/source/scripts/init/service.d/service_firewall/firewall_log_handle.sh ${D}${sysconfdir}/utopia/service.d/
    install -m 644 ${S}/source/igd/src/inc/*.xml ${D}${sysconfdir}/IGD
    install -D -m 644 ${S}/source/scripts/init/syslog_conf/syslog.conf_default ${D}/fss/gw/${sysconfdir}/syslog.conf.${BPN}
    install -m 755 ${S}/source/scripts/init/syslog_conf/log_start.sh ${D}${sbindir}/
    install -m 755 ${S}/source/scripts/init/syslog_conf/log_handle.sh ${D}${sbindir}/
    install -m 755 ${S}/source/scripts/init/syslog_conf/syslog_conf_tool.sh ${D}${sbindir}/
    install -m 644 ${S}/source/scripts/init/service.d/event_flags ${D}${sysconfdir}/utopia/service.d/
    install -m 644 ${S}/source/scripts/init/service.d/rt_tables ${D}${sysconfdir}/utopia/service.d/rt_tables
    install -m 755 ${S}/source/scripts/init/service.d/service_cosa_arm.sh ${D}${sysconfdir}/utopia/service.d/service_cosa.sh
    install -m 755 ${S}/source/scripts/init/service.d/service_dhcpv6_client_arm.sh ${D}${sysconfdir}/utopia/service.d/service_dhcpv6_client.sh
    install -m 755 ${S}/source/scripts/init/system/need_wifi_default.sh ${D}${sysconfdir}/utopia/
    touch ${D}${sysconfdir}/dhcp_static_hosts
    install -m 755 ${S}/source/scripts/init/service.d/service_bridge_rpi.sh ${D}${sysconfdir}/utopia/service.d/service_bridge.sh
    install -m 755 ${S}/source/scripts/init/service.d/service_dynamic_dns.sh ${D}${sysconfdir}/utopia/service.d/service_dynamic_dns.sh

    # Creating symbolic links to install files in specific directory as in legacy builds
    ln -sf /usr/bin/10_firewall ${D}${sysconfdir}/utopia/post.d/10_firewall
    ln -sf /usr/bin/service_multinet_exec ${D}${sysconfdir}/utopia/service.d/service_multinet_exec
    ln -sf /usr/bin/10_mcastproxy ${D}${sysconfdir}/utopia/post.d/10_mcastproxy
    ln -sf /usr/bin/10_mldproxy ${D}${sysconfdir}/utopia/post.d/10_mldproxy
    ln -sf /usr/bin/15_igd ${D}${sysconfdir}/utopia/post.d/15_igd
    ln -sf /usr/bin/15_misc ${D}${sysconfdir}/utopia/post.d/15_misc
    ln -sf /usr/bin/02_bridge ${D}${sysconfdir}/utopia/registration.d/02_bridge
    ln -sf /usr/bin/02_forwarding ${D}${sysconfdir}/utopia/registration.d/02_forwarding
    ln -sf /usr/bin/02_ipv4 ${D}${sysconfdir}/utopia/registration.d/02_ipv4
    ln -sf /usr/bin/02_lanHandler ${D}${sysconfdir}/utopia/registration.d/02_lanHandler
    ln -sf /usr/bin/02_multinet ${D}${sysconfdir}/utopia/registration.d/02_multinet
    ln -sf /usr/bin/02_wan ${D}${sysconfdir}/utopia/registration.d/02_wan
    ln -sf /usr/bin/02_wlan ${D}${sysconfdir}/utopia/registration.d/02_wlan
    ln -sf /usr/bin/15_ccsphs ${D}${sysconfdir}/utopia/registration.d/15_ccsphs
    ln -sf /usr/bin/15_ddnsclient ${D}${sysconfdir}/utopia/registration.d/15_ddnsclient
    ln -sf /usr/bin/15_dhcp_server ${D}${sysconfdir}/utopia/registration.d/15_dhcp_server
    ln -sf /usr/bin/15_hotspot ${D}${sysconfdir}/utopia/registration.d/15_hotspot
    ln -sf /usr/bin/15_ssh_server ${D}${sysconfdir}/utopia/registration.d/15_ssh_server
    ln -sf /usr/bin/15_wecb ${D}${sysconfdir}/utopia/registration.d/15_wecb
    ln -sf /usr/bin/20_routing ${D}${sysconfdir}/utopia/registration.d/20_routing
    ln -sf /usr/bin/25_crond ${D}${sysconfdir}/utopia/registration.d/25_crond
    ln -sf /usr/bin/26_potd ${D}${sysconfdir}/utopia/registration.d/26_potd
    ln -sf /usr/bin/33_cosa ${D}${sysconfdir}/utopia/registration.d/33_cosa
    ln -sf /usr/bin/syscfg ${D}${bindir}/syscfg_create
    ln -sf /usr/bin/syscfg ${D}${bindir}/syscfg_destroy
    ln -sf /usr/bin/firewall ${D}/fss/gw/usr/bin/firewall
    ln -sf /usr/bin/GenFWLog ${D}/fss/gw/usr/bin/GenFWLog
    ln -sf /etc/utopia/service.d/log_capture_path.sh ${D}/fss/gw/etc/utopia/service.d/log_capture_path.sh
    ln -sf /etc/utopia/service.d/log_env_var.sh ${D}/fss/gw/etc/utopia/service.d/log_env_var.sh
    ln -sf /usr/bin/syseventd_fork_helper ${D}/fss/gw/usr/bin/syseventd_fork_helper
    ln -sf /usr/sbin/log_start.sh ${D}/fss/gw/usr/sbin/log_start.sh
    ln -sf /usr/sbin/log_handle.sh ${D}/fss/gw/usr/sbin/log_handle.sh
    ln -sf /etc/syslog.conf.utopia ${D}/fss/gw/etc/syslog.conf.utopia
    ln -sf /etc/utopia/service.d/misc_handler.sh ${D}/fss/gw/etc/utopia/service.d/misc_handler.sh

    install -m 755 ${WORKDIR}/system_defaults ${D}${sysconfdir}/utopia/system_defaults

    echo "touch -f /tmp/utopia_inited" >> ${D}${sysconfdir}/utopia/utopia_init.sh
    echo "iptables -I INPUT -p tcp --dport 22 -j ACCEPT" >> ${D}${sysconfdir}/utopia/utopia_init.sh
    echo "IF_NAMES=\`syscfg get lan_ethernet_physical_ifnames\`" >> ${D}${sysconfdir}/utopia/utopia_init.sh
    echo "for var in \$IF_NAMES; do" >> ${D}${sysconfdir}/utopia/utopia_init.sh
    echo "        ifconfig \$var up" >> ${D}${sysconfdir}/utopia/utopia_init.sh
    echo "done" >> ${D}${sysconfdir}/utopia/utopia_init.sh

    if [ "${@bb.utils.contains('DISTRO_FEATURES','extender','true','false',d)}" = 'true' ]; then
        sed -i "/^iptables/d; /^ip6tables/d" ${D}${sysconfdir}/utopia/utopia_init.sh
        sed -i "/^execute_dir \$INIT_DIR&/d" ${D}${sysconfdir}/utopia/utopia_init.sh
    fi
}

do_install_append() {
     cp ${WORKDIR}/${SOC}_system_defaults ${D}${sysconfdir}/utopia/system_defaults
}

do_utopia_patches_append() {
    cd ${S}
    if [ ! -e .0004-service-wan-patched ]; then
        patch -p1 < ${WORKDIR}/0004-service-wan.patch
        touch .0004-service-wan-patched
    fi

    if [ ! -e .005-lan-handler-dhcp-server-functions-patched ]; then
        patch -l -p1 < ${WORKDIR}/005-lan-handler-dhcp-server-functions.patch
        touch .005-lan-handler-dhcp-server-functions-patched
    fi

    if [ ! -e .0006-sysevetd-main.patched ]; then
        patch -p1 < ${WORKDIR}/0006-sysevetd-main.patch
        touch .0006-sysevetd-main.patched
    fi

    if [ ! -e .0007-firewall.patched ]; then
        patch -l -p1 < ${WORKDIR}/0007-firewall.patch
        touch .0007-firewall.patched
    fi

    if [ ! -e .0008-geneiacs-server.patched ]; then
        patch -p1 < ${WORKDIR}/0008-geneiacs-server.patch
        touch .0008-geneiacs-server.patched
    fi

    if [ ! -e .0009-lan-handler-psm-rpi-ipq.patched ]; then
        patch -p1 < ${WORKDIR}/0009-lan-handler-psm-rpi-ipq.patch
        touch .0009-lan-handler-psm-rpi-ipq.patched
    fi

    if [ ! -e .0010-service-multinet.patched ]; then
        patch -p1 < ${WORKDIR}/0010-service-multinet.patch
        touch .0010-service-multinet.patched
    fi

    if [ ! -e .0011-handle-gre.patched ]; then
        patch -p1 < ${WORKDIR}/0011-handle-gre.patch
        touch .0011-handle-gre.patched
    fi

    if [ ! -e .0005-service-lan.patched ]; then
        patch -p1 < ${WORKDIR}/0005-service-lan.patch
        touch .0005-service-lan.patched
    fi

    if [ ! -e .0012-service-gre-route-add.patched ]; then
        patch -p1 < ${WORKDIR}/0012-service-gre-route-add.patch
        touch .0012-service-gre-route-add.patched
    fi

    if [ ! -e .0013-service-dhcp-for-four-bridge.patched ]; then
        patch -p1 -l < ${WORKDIR}/0013-service-dhcp-for-four-bridge.patch
        touch .0013-service-dhcp-for-four-bridge.patched
    fi

    if [ ! -e .0014-service-dhcp-server-fix.patched ]; then
	patch -p1 < ${WORKDIR}/0014-service-dhcp-server-fix.patch
	touch .0014-service-dhcp-server-fix.patched
    fi

    if [ ! -e .015_PPPoE_SNAT-in-Firewall.patched ]; then
	patch -p1 < ${WORKDIR}/015_PPPoE_SNAT-in-Firewall.patch
	touch .015_PPPoE_SNAT-in-Firewall.patched
    fi

     if [ ! -e .016_power_save.patched ]; then
         patch -p1 < ${WORKDIR}/016_power_save.patch
         touch .016_power_save.patched
     fi

     if [ ! -e .multiple_reboot.patched ]; then
        patch -p1 < ${WORKDIR}/multiple_reboot.patch
        touch .multiple_reboot.patched
    fi

     if [ ! -e .019-ezmesh-firewall-sysevent.patched ]; then
         patch -p1 < ${WORKDIR}/019-ezmesh-firewall-sysevent.patch
         touch .019-ezmesh-firewall-sysevent.patched
     fi

     if [ ! -e .020-Captive_Portal_dhcp_server_function.patched ]; then
         patch -p1 < ${WORKDIR}/020-Captive_Portal_dhcp_server_function.patch
         touch .020-Captive_Portal_dhcp_server_function.patched
     fi

     if [ ! -e .021-dibbler_restart_for_dslite_tunnel_creation.patched ]; then
         patch -p1 < ${WORKDIR}/021-dibbler_restart_for_dslite_tunnel_creation.patch
         touch .021-dibbler_restart_for_dslite_tunnel_creation.patched
     fi

     if [ ! -e .022-enable_bridge_multicast.patched ]; then
         patch -p1 < ${WORKDIR}/022-enable_bridge_multicast.patch
	 touch .022-enable_bridge_multicast.patched
     fi

     if [ ! -e .023-IPv6_GRETAP_Tunnel_Interface_fix.patched ]; then
         patch -p1 < ${WORKDIR}/023-IPv6_GRETAP_Tunnel_Interface_fix.patch
         touch .023-IPv6_GRETAP_Tunnel_Interface_fix.patched
     fi

     if [ ! -e .0015-service-bridge_wan_fix.patched ]; then
         patch -p1 < ${WORKDIR}/0015-service-bridge_wan_fix.patch
         touch .0015-service-bridge_wan_fix.patched
     fi

     if [ ! -e .025-dropbear-enablement-fix.patched ]; then
         patch -p1 < ${WORKDIR}/025-dropbear-enablement-fix.patch
         touch .025-dropbear-enablement-fix.patched
     fi

     if [ ! -e .026-utopia-init-fix.patched ]; then
         patch -p1 < ${WORKDIR}/026-utopia-init-fix.patch
         touch .026-utopia-init-fix.patched
     fi

     if [ ! -e .025-dhcp_mode_and_ppp_trafficflow_fix.patched ]; then
         patch -p1 < ${WORKDIR}/025-dhcp_mode_and_ppp_trafficflow_fix.patch
         touch .025-dhcp_mode_and_ppp_trafficflow_fix.patched
     fi

     if [ ! -e .026-potd_console_flood_fix.patched ]; then
         patch -p1 < ${WORKDIR}/026-potd_console_flood_fix.patch
         touch .026-potd_console_flood_fix.patched
      fi

     if [ ! -e .027-syscfg_init_fix.patched ]; then
         patch -p1 < ${WORKDIR}/027-syscfg_init_fix.patch
         touch .027-syscfg_init_fix.patched
     fi
    cd -
}

FILES_${PN} += " \
    /rdklogs/ \
    /fss/gw/bin/ \
    /fss/gw/usr/bin/ \
    /fss/gw/usr/sbin/ \
    /var/spool/cron/crontabs \
    /fss/gw/etc/utopia/* \
    /etc/utopia/system_defaults \
"
