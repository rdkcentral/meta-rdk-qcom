require ccsp_common_ipq.inc

DEPENDS_append = " utopia curl "

CFLAGS_append = " \
    -I=${includedir}/utctx \
    -I=${includedir}/utapi \
"
CFLAGS_append = "${@bb.utils.contains('SOC_T', "ipq807x", " -D_PLATFORM_IPQ807x", " ", d)}"
CFLAGS_append = " -D_RDK_REF_PLATFORM_ -DDSLITE_FEATURE_SUPPORT_ -DDDNS_BROADBANDFORUM_ -DDEVICE_GATEWAY_ASSOCIATION_FEATURE_ \
                  -DFEATURE_FWUPGRADE_MANAGER_  -DINTEL_GRE_HOTSPOT " 

LDFLAGS_remove = " \
    -lmoca_mgnt \
"

CFLAGS_remove = "-Werror"
#Disabling the ppp manager conditional flag until the pppmanager functionality support in RPI
CFLAGS_remove = " ${@bb.utils.contains('DISTRO_FEATURES', 'rdkb_xdsl_ppp_manager', '-DFEATURE_RDKB_XDSL_PPP_MANAGER', '', d)}"

FILESEXTRAPATHS_prepend := "${THISDIR}:"
SRC_URI += " file://001-CcsPandM-middle-layer-src.patch \
             file://002-CcsPandM-cosa_dhcpv6_apis.patch \
             file://003-reset-pwd.patch \
             file://004-CcsPandM-cosa_ip_dml.patch \
             file://005-gui-pwd.patch \
             file://006-CcspPandM-router-bridge.patch \
	     file://007-CcspPandM-Bridging-VLAN.patch \
	     file://008_CcspPandM_McProxy.patch \
	     file://009-DHCP-configuration.patch \
             file://PAM-cmvariant.patch \
	     file://010-ACS-reboot-fix.patch \
	     file://011-remove-ppp-manager.patch \
	     file://012_CcspPandM_IPQ_WiFiReload_dml.patch \
	     file://013_TR181-USGv2_WifiReload.patch \
	     file://014-VLANTermination.patch \
	     file://015-t2_pam_enable.patch \
             file://015-GRE-Files-for-23q1.patch \
	     file://016-Remote-http-pandm.patch \
             file://016-Bridge-Mode-Support.patch \
             file://017-Captive_Portal_network_response.patch \
	     file://019_PandM_UPnP_remove.patch \
		"

do_compile_prepend () {
	#for GRETAP support
        sed -i '2i <?define INTEL_GRE_HOTSPOT=True?>' ${S}/config-arm/TR181-USGv2.XML
	#for IPQ support in PAM xml file
	sed -i '2i <?define _PLATFORM_IPQ_=True?>' ${S}/config-arm/TR181-USGv2.XML
}
do_configure_prepend () {
   #for WanManager support
   #Below lines of code needs to be removed , once (Device.DHCPv4.Client.{i} and Device.DhCPv6,CLient.{i}) the mentioned parameters are permanently removed from TR181-USGv2.XML
    DISTRO_WAN_ENABLED="${@bb.utils.contains('DISTRO_FEATURES','rdkb_wan_manager','true','false',d)}"
if [ $DISTRO_WAN_ENABLED = 'true' ]; then
if [ ! -f ${WORKDIR}/WanManager_XML_UPDATED ]; then
   GREP_WORD=`cat -n ${S}/config-arm/TR181-USGv2.XML  | grep 9536 | cut -d '<' -f2 | cut -d  '>' -f2`
   if [ "$GREP_WORD" = "ClientNumberOfEntries" ]; then
        #for DHCPv4.Client.{i}.
        sed -i '9534s/<parameter>/<!-- <parameter>/g' ${S}/config-arm/TR181-USGv2.XML
        sed -i '9542s/<\/parameter>/<\/parameter>-->/g' ${S}/config-arm/TR181-USGv2.XML
        sed -i '9642s/<object>/<!-- <object>/g' ${S}/config-arm/TR181-USGv2.XML
        sed -i '10058s/<\/object>/<\/object>-->/g' ${S}/config-arm/TR181-USGv2.XML
        #for DHCPv6.Client.{i}.
        sed -i '10832s/<parameter>/<!-- <parameter>/g' ${S}/config-arm/TR181-USGv2.XML
        sed -i '10836s/<\/parameter>/<\/parameter>-->/g' ${S}/config-arm/TR181-USGv2.XML
        sed -i '10839s/<object>/<!-- <object>/g' ${S}/config-arm/TR181-USGv2.XML
        sed -i '11138s/<\/object>/<\/object>-->/g' ${S}/config-arm/TR181-USGv2.XML
   fi
   if ${@bb.utils.contains('DISTRO_FEATURES', 'rdkb_xdsl_ppp_manager', 'true', 'false', d)}; then
  	 sed -i "s/<?ifndef FEATURE_RDKB_XDSL_PPP_MANAGER?>/<?ifdef FEATURE_RDKB_XDSL_PPP_MANAGER?>/g" ${S}/config-arm/TR181-USGv2.XML
   fi
   touch ${WORKDIR}/WanManager_XML_UPDATED
fi
fi
}

do_install_append() {
    # Config files and scripts
    install -m 644 ${S}/config-arm/CcspDmLib.cfg ${D}/usr/ccsp/pam/CcspDmLib.cfg
    install -m 644 ${S}/config-arm/CcspPam.cfg -t ${D}/usr/ccsp/pam
    install -m 644 ${S}/config-arm/TR181-USGv2.XML -t ${D}/usr/ccsp/pam
    install -m 755 ${S}/scripts/email_notification_monitor.sh ${D}/usr/ccsp/pam/email_notification_monitor.sh
    install -m 755 ${S}/arch/intel_usg/boards/arm_shared/scripts/calc_random_time_to_reboot_dev.sh ${D}/usr/ccsp/pam/calc_random_time_to_reboot_dev.sh
    install -m 755 ${S}/arch/intel_usg/boards/arm_shared/scripts/network_response.sh ${D}/usr/ccsp/pam/network_response.sh
    install -m 755 ${S}/arch/intel_usg/boards/arm_shared/scripts/network_response.sh ${D}/etc/network_response.sh
    install -m 755 ${S}/arch/intel_usg/boards/arm_shared/scripts/redirect_url.sh ${D}/usr/ccsp/pam/redirect_url.sh
    install -m 755 ${S}/arch/intel_usg/boards/arm_shared/scripts/revert_redirect.sh ${D}/usr/ccsp/pam/revert_redirect.sh
    install -m 755 ${S}/arch/intel_usg/boards/arm_shared/scripts/redirect_url.sh ${D}/etc/redirect_url.sh
    install -m 755 ${S}/arch/intel_usg/boards/arm_shared/scripts/revert_redirect.sh ${D}/etc/revert_redirect.sh
    install -m 755 ${S}/arch/intel_usg/boards/arm_shared/scripts/restart_services.sh ${D}/etc/restart_services.sh
    install -m 755 ${S}/arch/intel_usg/boards/arm_shared/scripts/whitelist.sh ${D}/usr/ccsp/pam/whitelist.sh
    install -m 755 ${S}/arch/intel_usg/boards/arm_shared/scripts/moca_status.sh ${D}/usr/ccsp/pam/moca_status.sh

    install -m 777 ${D}/usr/bin/CcspPandMSsp -t ${D}/usr/ccsp/pam/

    install -d ${D}/fss/gw/usr/sbin
    ln -sf /sbin/ip.iproute2 ${D}/fss/gw/usr/sbin/ip

    #captiveportal redirection
    DISTRO_ENABLED="${@bb.utils.contains('DISTRO_FEATURES','webui_jst','true','false',d)}"
    if [ $DISTRO_ENABLED = 'false' ]; then
    sed -i "/captiveportaldhcp/a fi" ${D}/etc/revert_redirect.sh
    sed -i "/captiveportaldhcp/a lighttpd -f /var/lighttpd.conf" ${D}/etc/revert_redirect.sh
    sed -i "/captiveportaldhcp/a sleep 2" ${D}/etc/revert_redirect.sh
    sed -i "/captiveportaldhcp/a killall lighttpd" ${D}/etc/revert_redirect.sh
    sed -i "/captiveportaldhcp/a sed -i '\$d' /var/lighttpd.conf" ${D}/etc/revert_redirect.sh
    sed -i "/captiveportaldhcp/a sed -i '\$d' /var/lighttpd.conf" ${D}/etc/revert_redirect.sh
    sed -i "/captiveportaldhcp/a sed -e '/url.redirect/ s/^#*/#/' -i /var/lighttpd.conf" ${D}/etc/revert_redirect.sh
    sed -i "/captiveportaldhcp/a if [ \$CAPTIVEPORTAL == \"$\" ] ; then"  ${D}/etc/revert_redirect.sh
    sed -i "/captiveportaldhcp/a CAPTIVEPORTAL=\`cat /var/lighttpd.conf | grep captiveportal.php | cut -c1\`" ${D}/etc/revert_redirect.sh
    sed -i "/dibbler-server start/a fi" ${D}/etc/restart_services.sh
    sed -i "/dibbler-server start/a fi" ${D}/etc/restart_services.sh
    sed -i "/dibbler-server start/a lighttpd -f \$LIGHTTPD_CONF" ${D}/etc/restart_services.sh
    sed -i "/dibbler-server start/a sleep 2" ${D}/etc/restart_services.sh
    sed -i "/dibbler-server start/a killall lighttpd" ${D}/etc/restart_services.sh
    sed -i "/dibbler-server start/a sed -i '\$d' \$LIGHTTPD_CONF" ${D}/etc/restart_services.sh
    sed -i "/dibbler-server start/a sed -i '\$d' \$LIGHTTPD_CONF" ${D}/etc/restart_services.sh
    sed -i "/dibbler-server start/a sed -e '/url.redirect/ s/^#*/#/' -i \$LIGHTTPD_CONF" ${D}/etc/restart_services.sh
    sed -i "/dibbler-server start/a if [ \$CAPTIVEPORTAL == \"\$\" ] ; then" ${D}/etc/restart_services.sh
    sed -i "/dibbler-server start/a CAPTIVEPORTAL=\`cat /var/lighttpd.conf | grep captiveportal.php | cut -c1\`" ${D}/etc/restart_services.sh
    sed -i "/dibbler-server start/a if [ \"\$CaptivePortal_flag\" == 1 ] && [ \"\$1\" == \"false\" ] ; then" ${D}/etc/restart_services.sh
    sed -i "/dibbler-server start/a fi" ${D}/etc/restart_services.sh
    sed -i "/dibbler-server start/a lighttpd -f \$LIGHTTPD_CONF" ${D}/etc/restart_services.sh
    sed -i "/dibbler-server start/a sleep 2" ${D}/etc/restart_services.sh
    sed -i "/dibbler-server start/a killall lighttpd" ${D}/etc/restart_services.sh
    sed -i "/dibbler-server start/a fi" ${D}/etc/restart_services.sh
    sed -i "/dibbler-server start/a echo \"}\" >> \$LIGHTTPD_CONF" ${D}/etc/restart_services.sh
    sed -i "/dibbler-server start/a echo \"}\" >> \$LIGHTTPD_CONF" ${D}/etc/restart_services.sh
    sed -i "/dibbler-server start/a echo \"\\\\\$HTTP[\\\\\"host\\\\\"] !~ \\\\\":8080\\\\\" {  \\\\\$HTTP[\\\\\"url\\\\\"] !~ \\\\\"captiveportal.php\\\\\" {  \\\\\$HTTP[\\\\\"referer\\\\\"] == \\\\\"\\\\\" { url.redirect = ( \\\\\".*\\\\\" => \\\\\"http://10.0.0.1/captiveportal.php\\\\\" ) url.redirect-code = 303 }\" >> \$LIGHTTPD_CONF" ${D}/etc/restart_services.sh
    sed -i "/dibbler-server start/a else" ${D}/etc/restart_services.sh
    sed -i "/dibbler-server start/a fi" ${D}/etc/restart_services.sh
    sed -i "/dibbler-server start/a echo \"}\" >> \$LIGHTTPD_CONF" ${D}/etc/restart_services.sh
    sed -i "/dibbler-server start/a echo \"}\" >> \$LIGHTTPD_CONF" ${D}/etc/restart_services.sh
    sed -i "/dibbler-server start/a sed -i \"/captiveportal.php/ s/^#*//g\" \$LIGHTTPD_CONF" ${D}/etc/restart_services.sh
    sed -i "/dibbler-server start/a else" ${D}/etc/restart_services.sh
    sed -i "/dibbler-server start/a echo \"Already lighttpd was successfully running with captiveportal changes\"" ${D}/etc/restart_services.sh
    sed -i "/dibbler-server start/a if [ \"\$lighttpd\" == \"\$\" ] ; then" ${D}/etc/restart_services.sh
    sed -i "/dibbler-server start/a if [ \"\$lighttpd_flag\" == 1 ] ; then" ${D}/etc/restart_services.sh
    sed -i "/dibbler-server start/a lighttpd=\`cat /var/lighttpd.conf | grep captiveportal.php | cut -c1\`" ${D}/etc/restart_services.sh
    sed -i "/dibbler-server start/a lighttpd_flag=\`cat /var/lighttpd.conf | grep captiveportal.php | wc -l\`" ${D}/etc/restart_services.sh
    sed -i "/dibbler-server start/a if [ \"\$CaptivePortal_flag\" == 1 ] && [ \"\$1\" == \"true\" ] ; then" ${D}/etc/restart_services.sh
    sed -i "/dibbler-server start/a fi" ${D}/etc/restart_services.sh
    sed -i "/dibbler-server start/a CaptivePortal_flag=1" ${D}/etc/restart_services.sh
    sed -i "/dibbler-server start/a else" ${D}/etc/restart_services.sh
    sed -i "/dibbler-server start/a CaptivePortal_flag=0" ${D}/etc/restart_services.sh
    sed -i "/dibbler-server start/a if [ -f /nvram/reverted ] ; then" ${D}/etc/restart_services.sh
    sed -i "/dibbler-server start/a LIGHTTPD_CONF=/var/lighttpd.conf" ${D}/etc/restart_services.sh
    sed -i "/dibbler-server start/a #captiveportal redirection" ${D}/etc/restart_services.sh
    fi

########## ETHWAN Support
   sed -i "s/\"Device.DeviceInfo.X_RDKCENTRAL-COM_Syndication.RDKB_UIBranding.AllowEthernetWAN\"\ :\ \"false\"\ \,/\"Device.DeviceInfo.X_RDKCENTRAL-COM_Syndication.RDKB_UIBranding.AllowEthernetWAN\" : \"true\" ,/g" ${D}/etc/partners_defaults.json

##### REFPLTB-728
    sed -i "s/www.rdkcentral.com/www.google.com/g" ${D}/etc/partners_defaults.json	
    sed -i "/productname\" : \"RDKM\"/{N;s/\n.*//;}" ${D}/etc/partners_defaults.json
    sed -i "/productname\" : \"RDKM\"/a \ \t\"Device.DeviceInfo.X_RDKCENTRAL-COM_Syndication.RDKB_UIBranding.CloudUI.link\" : \"www.rdkcentral.com\"," ${D}/etc/partners_defaults.json
    sed -i "/UserGuideLink\" : \"https:\/\/wiki.rdkcentral.com\/display\/RDK\/Download+and+Build+Documentation\",/{N;s/\n.*//;}" ${D}/etc/partners_defaults.json
    sed -i "/UserGuideLink\" : \"https:\/\/wiki.rdkcentral.com\/display\/RDK\/Download+and+Build+Documentation\",/a \ \t\"Device.DeviceInfo.X_RDKCENTRAL-COM_Syndication.RDKB_UIBranding.Footer.CustomerCentralLink\" : \"https:\/\/www.rdkcentral.com\/\"," ${D}/etc/partners_defaults.json
    sed -i "s/www.comcast.net/www.google.com/g" ${D}/etc/partners_defaults.json
}

FILES_${PN}-ccsp += " \
    ${prefix}/ccsp/pam/CcspPandMSsp \
    /fss/gw/usr/sbin/ip \
"
do_mypatch() {
    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/.001-CcsPandM-middle-layer-src-patched ]; then
        cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/source/
        patch -p2 < ${WORKDIR}/001-CcsPandM-middle-layer-src.patch
        cd -
        cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/source-arm/
        patch -p2 < ${WORKDIR}/003-reset-pwd.patch
        cd -
        cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/
        patch -p1 < ${WORKDIR}/005-gui-pwd.patch
        cd -
        touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/.001-CcsPandM-middle-layer-src-patched
    fi
    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/.002-CcsPandM-cosa_dhcpv6_apis-patched ]; then
        cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/source-arm
        patch -p2 < ${WORKDIR}/002-CcsPandM-cosa_dhcpv6_apis.patch
        cd -
        touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/.002-CcsPandM-cosa_dhcpv6_apis-patched
    fi
    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/.004-CcsPandM-cosa_ip_dml-patched ]; then
        cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/source
        patch -p2 < ${WORKDIR}/004-CcsPandM-cosa_ip_dml.patch
        cd -
        touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/.004-CcsPandM-cosa_ip_dml-patched
    fi
    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/.006-CcspPandM-router-bridge-patched ]; then
        cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/source-arm
        patch -p2 < ${WORKDIR}/006-CcspPandM-router-bridge.patch
        cd -
        touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/.006-CcspPandM-router-bridge-patched
    fi
	
    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/.007-CcspPandM-Bridging-VLAN.patched ]; then
        cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/
        patch -p1 -l < ${WORKDIR}/007-CcspPandM-Bridging-VLAN.patch
        cd -
        touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/.007-CcspPandM-Bridging-VLAN.patched
    fi

    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/.008_CcspPandM_McProxy.patched ]; then
        cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/
        patch -p1 < ${WORKDIR}/008_CcspPandM_McProxy.patch
        cd -
        touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/.008_CcspPandM_McProxy.patched
    fi

    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/.009-DHCP-configuration.patched ]; then
        cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/
        patch -p1 < ${WORKDIR}/009-DHCP-configuration.patch
        cd -
        touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/.009-DHCP-configuration.patched
    fi

    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/.PAM-cmvariant.patched ]; then
	cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/
	patch -p1 < ${WORKDIR}/PAM-cmvariant.patch
	cd -
	touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/.PAM-cmvariant.patched
    fi

    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/.010-ACS-reboot-fix.patched ]; then
	cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/
	patch -p1 < ${WORKDIR}/010-ACS-reboot-fix.patch
	cd -
	touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/.010-ACS-reboot-fix.patched
    fi

    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/.011-remove-ppp-manager.patched ]; then
	cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/
	patch -p1 < ${WORKDIR}/011-remove-ppp-manager.patch
	cd -
	touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/.011-remove-ppp-manager.patched
    fi

    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/.012_CcspPandM_IPQ_WiFiReload_dml.patched ]; then
	cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/
	patch -p1 < ${WORKDIR}/012_CcspPandM_IPQ_WiFiReload_dml.patch
	cd -
	touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/.012_CcspPandM_IPQ_WiFiReload_dml.patched
    fi

    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/.013_TR181-USGv2_WifiReload.patched ]; then
	cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/
	patch -p1 < ${WORKDIR}/013_TR181-USGv2_WifiReload.patch
	cd -
	touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/.013_TR181-USGv2_WifiReload.patched
    fi

    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/.014-VLANTermination.patched ]; then
        cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/
        patch -p1 < ${WORKDIR}/014-VLANTermination.patch
        cd -
        touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/.014-VLANTermination.patched
    fi

    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/.015-t2_pam_enable.patched ]; then
        cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/
        patch -p1 < ${WORKDIR}/015-t2_pam_enable.patch
        cd -
        touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/.015-t2_pam_enable.patched
    fi

    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/.015-GRE-Files-for-23q1.patched ]; then
        cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/
        patch -p1 < ${WORKDIR}/015-GRE-Files-for-23q1.patch
        cd -
        touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/.015-GRE-Files-for-23q1.patched
    fi 
   
    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/.016-Remote-http-pandm.patched ]; then
        cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/
        patch -p1 < ${WORKDIR}/016-Remote-http-pandm.patch
        cd -
        touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/.016-Remote-http-pandm.patched
    fi

 
    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/.016-Bridge-Mode-Support.patched ]; then
        cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/
        patch -p1 < ${WORKDIR}/016-Bridge-Mode-Support.patch
        cd -
        touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/.016-Bridge-Mode-Support.patched
    fi


    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/.017-Captive_Portal_network_response.patched ]; then
        cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/
        patch -p1 < ${WORKDIR}/017-Captive_Portal_network_response.patch
        cd -
        touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/.017-Captive_Portal_network_response.patched
    fi

    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/.019_PandM_UPnP_remove.patched ]; then
        cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/
        patch -p1 < ${WORKDIR}/019_PandM_UPnP_remove.patch
        cd -
        touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspPandM/.019_PandM_UPnP_remove.patched
    fi

}
addtask mypatch after do_unpack before do_compile
