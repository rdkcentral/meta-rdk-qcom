require ccsp_common_ipq.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
FILESEXTRAPATHS_prepend := "${THISDIR}/sysint/device/systemd_units/:"
FILESEXTRAPATHS_prepend := "${THISDIR}/sysint/device/lib/rdk:"

EXTRA_OECONF += "PHP_RPATH=no"

SRC_URI += "${CMF_GIT_ROOT}/rdkb/devices/raspberrypi/sysint;protocol=${CMF_GIT_PROTOCOL};branch=${CMF_GIT_BRANCH};destsuffix=sysint/devicerpi;name=rdkbsysintrpi"
SRCREV_rdkbsysintrpi = "${AUTOREV}"

SRC_URI_append = " \
	 file://CcspWebUI.sh \
	 file://CcspWebUI.service \
"
CFLAGS_append = " -D_RDK_REF_PLATFORM_ -DDSLITE_FEATURE_SUPPORT_ -DDDNS_BROADBANDFORUM_ -DDEVICE_GATEWAY_ASSOCIATION_FEATURE_ \
                  -DFEATURE_FWUPGRADE_MANAGER_ -DFEATURE_RDKB_GPON_MANAGER_ -DFEATURE_RDKB_XDSL_PPP_MANAGER_ "

inherit systemd
do_install_append () {
		install -d ${D}${sysconfdir}
		install -d ${D}${base_libdir}/rdk/
		install -d ${D}${systemd_unitdir}/system/

		# delete wan0 reference for R-Pi
		sed -i "/wan0:80/a  echo \"This interface is not available in RPI\""  ${D}${sysconfdir}/webgui.sh
		sed -i "/wan0:443/a  echo \"This interface is not available in RPI\""  ${D}${sysconfdir}/webgui.sh
		sed -i "s/if \[ \"\$BOX_TYPE\" == \"HUB4\" \]/if \[ \"\$BOX_TYPE\" = \"HUB4\" \]/g" ${D}${sysconfdir}/webgui.sh
		sed -i '/wan0/d' ${D}${sysconfdir}/webgui.sh

		#delete server.pem reference for R-Pi
	        sed -e '/\$INTERFACE:10443/ s/^#*/echo "Removed server.pem references for R-pi"\n#/' -i ${D}${sysconfdir}/webgui.sh
                sed -e '/\$INTERFACE:18080/ s/^#*/echo "Removed server.pem references for R-pi"\n#/' -i ${D}${sysconfdir}/webgui.sh

		install -m 644 ${WORKDIR}/CcspWebUI.service ${D}${systemd_unitdir}/system/

                sed -i "s/'20MHz', '40MHz', '80MHz'/'20MHz', '40MHz', '80MHz', '160MHz'/g"  ${D}/usr/www2/actionHandler/ajaxSet_wireless_network_configuration_edit.jst
                sed -i "s/g,n/g,n,ax/g"  ${D}/usr/www2/actionHandler/ajaxSet_wireless_network_configuration_edit.jst
                sed -i "s/n,ac/n,ac,ax/g"  ${D}/usr/www2/actionHandler/ajaxSet_wireless_network_configuration_edit.jst
                sed -i "s/n,ac/n,ac,ax/g"  ${D}/usr/www2/wireless_network_configuration_edit.jst
                sed -i "s/g,n/g,n,ax/g"  ${D}/usr/www2/wireless_network_configuration_edit.jst
                sed -i "s/n\/ac/n\/ac\/ax/g"  ${D}/usr/www2/wireless_network_configuration_edit.jst
                sed -i "s/g\/n/g\/n\/ax/g"  ${D}/usr/www2/wireless_network_configuration_edit.jst
                sed -i "/\"80MHz\"==$channel_bandwidth/a <label for=\"channel_bandwidth3\" class=\"acs-hide\"></label> <input type=\"radio\"  name=\"channel_bandwidth1\" value=\"160MHz\"  id=\"channel_bandwidth3\" <?% if (\"160MHz\"==\$channel_bandwidth) echo( 'checked=\"checked\"');?> /><b>20/40/80/160</b>
" ${D}/usr/www2/wireless_network_configuration_edit.jst

		sed -i '/Security.X_COMCAST-COM_KeyPassphrase/a \
		\t\t\tsetStr("Device.DeviceInfo.X_RDKCENTRAL-COM_ConfigureWiFi", "false", true);' ${D}/usr/www2/actionHandler/ajaxSet_wireless_network_configuration_redirection.jst
		sed -i "s/\$clients_RSSI\[strtoupper(\$Host\[\$i\.toString\(\)\]\['PhysAddress'\])\]/\$Host\[\$i\.toString\(\)\]\['X_CISCO_COM_RSSI'\]/g" ${D}/usr/www2/connected_devices_computers.jst
		sed -i "s/\$wnStatus= (\$wan_enable==\"true\" \&\& \$wan_status==\"Down\") ? \"true\" : \"false\";/\$wnStatus= (\$wan_enable==\"true\" \&\& \$wan_status==\"Up\") ? \"true\" : \"false\";/g" ${D}/usr/www2/wan_network.jst
                sed -i "s/if((!strcmp(\$url, \$Wan_IPv4) || ((inet_pton(\$url)!=\"\") || (inet_pton(\$Wan_IPv6!==\"\"))) \&\&(inet_pton(\$url) == inet_pton(\$Wan_IPv6)))){/if((!strcmp(\$url, \$Wan_IPv4) || ((inet_pton(\$url)!=\"\") \&\& (inet_pton(\$Wan_IPv6!==\"\"))) \&\&(inet_pton(\$url) == inet_pton(\$Wan_IPv6)))){/g" ${D}/usr/www2/index.jst
                sed -i "s/\$Wan_IPv4 = getStr(\"Device.X_CISCO_COM_CableModem.IPAddress\");/\$Wan_IPv4 = getStr(\"Device.DeviceInfo.X_COMCAST-COM_CM_IP\");/g" ${D}/usr/www2/index.jst
                sed -i "s/\$Wan_IPv4 = getStr(\"Device.X_CISCO_COM_CableModem.IPAddress\");/\$Wan_IPv4 = getStr(\"Device.DeviceInfo.X_COMCAST-COM_CM_IP\");/g" ${D}/usr/www2/captiveportal.jst
                sed -i "s/if((!strcmp(\$url, \$Wan_IPv4) || ((inet_pton(\$url)!=\"\") || (inet_pton(\$Wan_IPv6!==\"\"))) \&\&(inet_pton(\$url) == inet_pton(\$Wan_IPv6)))){/if((!strcmp(\$url, \$Wan_IPv4) || ((inet_pton(\$url)!=\"\") \&\& (inet_pton(\$Wan_IPv6!==\"\"))) \&\&(inet_pton(\$url) == inet_pton(\$Wan_IPv6)))){/g" ${D}/usr/www2/captiveportal.jst
}

SYSTEMD_SERVICE_${PN} += "CcspWebUI.service"
FILES_${PN} += "${systemd_unitdir}/system/CcspWebUI.service ${base_libdir}/rdk/*"

do_mypatch(){
            if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/webui/source/.001-webui-patched ]; then
                  patch ${TOPDIR}/../rdkb/components/opensource/ccsp/webui/source/Styles/xb3/config/webgui.sh < ${WORKDIR}/001-webui.patch
                  patch ${TOPDIR}/../meta-cmf-broadband/recipes-ccsp/ccsp/files/webgui_config.sh < ${WORKDIR}/002-webui.patch
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/webui/source/.001-webui-patched
            fi

	    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/webui/source/.001-Captive_Portal_webui.patched ]; then
                  patch ${TOPDIR}/../rdkb/components/opensource/ccsp/webui/source/Styles/xb3/config/webgui.sh < ${WORKDIR}/001-Captive_Portal_webui.patch

                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/webui/source/.001-Captive_Portal_webui.patched
            fi

}

do_install_append_aarch64 () {
     sed -i "s/count(\$IDs)-1/count(\$IDs)-2/g"  ${D}/usr/www2/actionHandler/ajax_managed_devices.jst
     sed -i "s/count(\$IDs)-1/count(\$IDs)-2/g"  ${D}/usr/www2/actionHandler/ajax_managed_services.jst
     sed -i "s/count(\$IDs)-1/count(\$IDs)-2/g"  ${D}/usr/www2/actionHandler/ajax_port_forwarding.jst
     sed -i "/p2j-foreach/a if(isset(\$hostsInstanceArr[\$key.toString()])==0){ break; }" ${D}/usr/www2/managed_devices_add_computer_blocked.jst
     sed -i "/getInstanceIDs(\"Device.Hosts.Host.\")/a \$hostIDs=\$hostIDs[count(\$hostIDs)-2];" ${D}/usr/www2/managed_devices_add_computer_allowed.jst
     sed -i "/getInstanceIDs(\"Device.Hosts.Host.\")/a \$hostIDs=\$hostIDs[count(\$hostIDs)-2];" ${D}/usr/www2/managed_devices_add_computer_blocked.jst
}

addtask mypatch after do_unpack before do_compile

FILESEXTRAPATHS_prepend := "${THISDIR}:"
SRC_URI += " file://001-webui.patch \
	     file://002-webui.patch \
	     file://001-Captive_Portal_webui.patch \
   	   "