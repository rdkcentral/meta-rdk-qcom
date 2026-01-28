require ccsp_common_ipq.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

DEPENDS_append = " cjson"
CFLAGS_append = " -DRDKLOGGER_SUPPORT_WIFI_ -D_ENABLE_BAND_STEERING_ -D_RDK_REF_PLATFORM_ -DDSLITE_FEATURE_SUPPORT_ -DDDNS_BROADBANDFORUM_ -DDEVICE_GATEWAY_ASSOCIATION_FEATURE_ \
                  -DFEATURE_FWUPGRADE_MANAGER_ -DFEATURE_RDKB_GPON_MANAGER_ -DFEATURE_RDKB_XDSL_PPP_MANAGER_ -DCONFIG_DFS -DWIFI_HAL_VERSION_3 -Wno-error "

LDFLAGS += " \
	-lutopiautil \
	-lcjson \
	   "
SOC="${@d.getVar('SOC_FAMILY', d, 1).split(':')[1]}"
export SOC_T = "${@d.getVar('SOC', d, 0).split('_')[0]}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', "ipq807x", " -D_PLATFORM_IPQ807x", " ", d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', "ipq807x", " -DMAX_NUM_RADIOS=2", " ", d)}"
CFLAGS_append = "${@bb.utils.contains('SOC_T', "ipq53xx", " -D_PLATFORM_IPQ53xx", " ", d)}"

SRC_URI_append = " \
    file://wifiTelemetrySetup.sh \
    file://checkwifi.sh \
    file://radio_param_def.cfg \
    file://bridge_mode.sh \
    file://01-add-ipq-support.patch \
    file://hostapd0.conf \
    file://hostapd1.conf \
    file://hostapd2.conf \
    file://hostapd3.conf \
    file://hostapd4.conf \
    file://hostapd5.conf \
    file://hostapd6.conf \
    file://hostapd7.conf \
    file://hostapd12.conf \
    file://hostapd13.conf \
    file://hostapd14.conf \
    file://hostapd15.conf \
    file://hostapd16.conf \
    file://hostapd17.conf \
    file://hostapd22.conf \
    file://hostapd23.conf \
    file://02-memleak-fix-v1.patch \
    file://03-Cosa-Wifi-apis-MaxNumber.patch \
    file://04-q3-transmitpower-issue-fix.patch \
    file://05-Dynamic-VAP-support-CosaWiFiAgent-changes.patch \    
    file://06-Bridge-VLAN-adding-ath-interface-on-reboot.patch \
    file://07-ppe-support-CosaWifiAgent-changes.patch \
    file://08-Wifi-Datamodel-Support.patch \
    file://09-DFS-Enable-Fix.patch \
    file://010-ccspwifiagent-sae-wpa3.patch \
    file://09-wifi-11be-support.patch \
    file://011-ccspwifiagent-bssid-fix.patch \
    file://011-WiFi-QCA-Adv-Features.patch \
    file://012-regulatory-missing-countries-fix.patch \
    file://012-dpp-ccsp-wifi-agent.patch  \
    file://dpp-hostapd-update.sh  \
    file://013-WDS-WiFi-QCA-Adv-Features.patch \
    file://012-ccspwifiagent-mfpc-fix.patch \
    file://014-Fix_for_TransmitPowerSupported.patch \
    file://015-cosa_enable_radio.patch \
    file://acs_Refresh_dml.patch \
    file://015-MAC-Filter-Fix.patch \
    file://radiohealth.sh  \
    file://016-Regulatory_Domain_fix.patch \
    file://017-Wifi-telemetry-crash-fix.patch  \
    file://018-feature_mfp_config.patch \
    file://019-RekeyingInterval.patch \
    file://018-Guard_Interval_DM_added.patch \
    file://020-ACS-channel-update.patch \
    file://021-auto-bandwidth-enable.patch \
    file://022-transmit-power-fix.patch \
    file://022-Type-DM-added.patch \
    file://023-Beacon-interval-changes.patch \
    file://024-RTS-Threshold-fix.patch \
    file://026-Beacon_interval_fix.patch \
    file://028-wifiagent-restart-issue.patch \
    file://029-mlo-ssid-fix.patch \
    file://029-spatial-streams-fix.patch \
    file://030-2024q3-mig-DFS-issue.patch \
    file://031-rfc-wpa3-fix.patch \
    file://032-Handle-wifi-reload-for-global-country-mode.patch \
    file://033-Unified-CountrycodeSet.patch \
    file://034-Reset-values-after-FR-fix.patch \
    file://035-transmit-power-issue-fix.patch \
    file://036-Ap-IsolationEnable-fix.patch \
    file://037-MLDUnit-dm-implementation.patch \
    file://sae_password_file \
    file://038-Unsupported-11BE-mode.patch \
    file://039-MFP-RFC-Issue.patch \
    file://040-Airties-Controller-notification.patch \
    "
do_configure_prepend() {
    sed -ni '/History/{x;d;};1h;1!{x;p;};${x;p;}' ${S}/config-atom/TR181-WiFi-USGv2.XML
    sed -i '/History/, +4d' ${S}/config-atom/TR181-WiFi-USGv2.XML
}

do_configure_prepend_aarch64() {
    sed -i "s/upload_client_debug_stats();/\/\/upload_client_debug_stats();/g" ${S}/source/TR-181/sbapi/wifi_monitor.c
}

do_mypatch() {
            if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/source/.02-memleak-fix-v1.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/source/
                  patch -l -p2 < ${WORKDIR}/02-memleak-fix-v1.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/source/.02-memleak-fix-v1.patched
            fi
            if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/source/.03-Cosa-Wifi-apis-MaxNumber.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/source/
                  patch -p2 < ${WORKDIR}/03-Cosa-Wifi-apis-MaxNumber.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/source/.03-Cosa-Wifi-apis-MaxNumber.patched
            fi
            if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/source/.04-q3-transmitpower-issue-fix.patched ]; then
                   cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/source/
                   patch -p2 < ${WORKDIR}/04-q3-transmitpower-issue-fix.patch
                   cd -
                   touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/source/.04-q3-transmitpower-issue-fix.patched
            fi
	    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.05-Dynamic-VAP-support-CosaWiFiAgent-changes.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
                  patch -p1 < ${WORKDIR}/05-Dynamic-VAP-support-CosaWiFiAgent-changes.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.05-Dynamic-VAP-support-CosaWiFiAgent-changes.patched
            fi
            if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/source/.06-Bridge-VLAN-adding-ath-interface-on-reboot.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/source/
                  patch -p2 < ${WORKDIR}/06-Bridge-VLAN-adding-ath-interface-on-reboot.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/source/.06-Bridge-VLAN-adding-ath-interface-on-reboot.patched
            fi
            if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.07-ppe-support-CosaWifiAgent-changes.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
                  patch -p1 < ${WORKDIR}/07-ppe-support-CosaWifiAgent-changes.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.07-ppe-support-CosaWifiAgent-changes.patched
            fi

            if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.08-Wifi-Datamodel-Support.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
                  patch -p1 < ${WORKDIR}/08-Wifi-Datamodel-Support.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.08-Wifi-Datamodel-Support.patched
            fi

	    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.09-DFS-Enable-Fix.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
                  patch -p1 < ${WORKDIR}/09-DFS-Enable-Fix.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.09-DFS-Enable-Fix.patched
            fi

	    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.010-ccspwifiagent-sae-wpa3.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
                  patch -p1 < ${WORKDIR}/010-ccspwifiagent-sae-wpa3.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.010-ccspwifiagent-sae-wpa3.patched
            fi
      
            if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.09-wifi-11be-support.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
                  patch -p1 < ${WORKDIR}/09-wifi-11be-support.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.09-wifi-11be-support.patched
            fi
 
            if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.011-WiFi-QCA-Adv-Features.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
                  patch -p1 < ${WORKDIR}/011-WiFi-QCA-Adv-Features.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.011-WiFi-QCA-Adv-Features.patched
            fi

	    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.011-ccspwifiagent-bssid-fix.patched ]; then
		  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
		  patch -p1 < ${WORKDIR}/011-ccspwifiagent-bssid-fix.patch
		  cd -
		  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.011-ccspwifiagent-bssid-fix.patched
	    fi

	    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.012-regulatory-missing-countries-fix.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
                  patch -p1 < ${WORKDIR}/012-regulatory-missing-countries-fix.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.012-regulatory-missing-countries-fix.patched
            fi
            
            if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.012-dpp-ccsp-wifi-agent.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
                  patch -p1 < ${WORKDIR}/012-dpp-ccsp-wifi-agent.patch
                  cd -
		  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.012-dpp-ccsp-wifi-agent.patched
            fi

            if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.012-ccspwifiagent-mfpc-fix.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
                  patch -p1 < ${WORKDIR}/012-ccspwifiagent-mfpc-fix.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.012-ccspwifiagent-mfpc-fix.patched
            fi

            if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.013-WDS-WiFi-QCA-Adv-Features.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
                  patch -p1 < ${WORKDIR}/013-WDS-WiFi-QCA-Adv-Features.patch
                  cd -
		  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.013-WDS-WiFi-QCA-Adv-Features.patched
            fi

            if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.014-Fix_for_TransmitPowerSupported.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
                  patch -p1 < ${WORKDIR}/014-Fix_for_TransmitPowerSupported.patch
                  cd -
		  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.014-Fix_for_TransmitPowerSupported.patched
            fi

	    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.015-cosa_enable_radio.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
                  patch -p1 < ${WORKDIR}/015-cosa_enable_radio.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.015-cosa_enable_radio.patched
	    fi
	    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.015-MAC-Filter-Fix.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
                  patch -p1 < ${WORKDIR}/015-MAC-Filter-Fix.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.015-MAC-Filter-Fix.patched
            fi
	    
            if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.acs_Refresh_dml.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
                  patch -p1 < ${WORKDIR}/acs_Refresh_dml.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.acs_Refresh_dml.patched
            fi

	    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.016-Regulatory_Domain_fix.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
                  patch -p1 < ${WORKDIR}/016-Regulatory_Domain_fix.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.016-Regulatory_Domain_fix.patched
            fi

	    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.017-Wifi-telemetry-crash-fix.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
                  patch -p1 < ${WORKDIR}/017-Wifi-telemetry-crash-fix.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.017-Wifi-telemetry-crash-fix.patched
            fi
            
	    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.018-feature_mfp_config.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
                  patch -p1 < ${WORKDIR}/018-feature_mfp_config.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.018-feature_mfp_config.patched
            fi

	    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.019-RekeyingInterval.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
                  patch -p1 < ${WORKDIR}/019-RekeyingInterval.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.019-RekeyingInterval.patched
            fi

	    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.018-Guard_Interval_DM_added.patched ]; then
		  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
		  patch -p1 < ${WORKDIR}/018-Guard_Interval_DM_added.patch
		  cd -
		  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.018-Guard_Interval_DM_added.patched
	    fi

	    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.020-ACS-channel-update.patched ]; then
		  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
		  patch -p1 < ${WORKDIR}/020-ACS-channel-update.patch
		  cd -
		  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.020-ACS-channel-update.patched
	    fi

	    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.021-auto-bandwidth-enable.patched ]; then
		  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
		  patch -p1 < ${WORKDIR}/021-auto-bandwidth-enable.patch
		  cd -
		  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.021-auto-bandwidth-enable.patched
	    fi

	    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.022-transmit-power-fix.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
                  patch -p1 < ${WORKDIR}/022-transmit-power-fix.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.022-transmit-power-fix.patched
            fi

	    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.022-Type-DM-added.patched ]; then
		  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
		  patch -p1 < ${WORKDIR}/022-Type-DM-added.patch
		  cd -
		  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.022-Type-DM-added.patched
	    fi

	    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.023-Beacon-interval-changes.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
                  patch -p1 < ${WORKDIR}/023-Beacon-interval-changes.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.023-Beacon-interval-changes.patched
            fi

	    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.024-RTS-Threshold-fix.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
                  patch -p1 < ${WORKDIR}/024-RTS-Threshold-fix.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.024-RTS-Threshold-fix.patched
            fi

	    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.026-Beacon_interval_fix.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
                  patch -p1 < ${WORKDIR}/026-Beacon_interval_fix.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.026-Beacon_interval_fix.patched
            fi

            if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.028-wifiagent-restart-issue.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
                  patch -p1 < ${WORKDIR}/028-wifiagent-restart-issue.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.028-wifiagent-restart-issue.patched
            fi

	    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.029-mlo-ssid-fix.patched  ]; then
		  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
		  patch -p1 < ${WORKDIR}/029-mlo-ssid-fix.patch
		  cd -
		  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.029-mlo-ssid-fix.patched
	    fi
	    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.029-spatial-streams-fix.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
                  patch -p1 < ${WORKDIR}/029-spatial-streams-fix.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.029-spatial-streams-fix.patched
            fi

	     if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.030-2024q3-mig-DFS-issue.patched ]; then
	           cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
	           patch -p1 < ${WORKDIR}/030-2024q3-mig-DFS-issue.patch
	           cd -
	           touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.030-2024q3-mig-DFS-issue.patched
	     fi


             if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.031-rfc-wpa3-fix.patched ]; then
                   cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
                   patch -p1 < ${WORKDIR}/031-rfc-wpa3-fix.patch
                   cd -
                   touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.031-rfc-wpa3-fix.patched
             fi

            if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.032-Handle-wifi-reload-for-global-country-mode.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
                  patch -p1 < ${WORKDIR}/032-Handle-wifi-reload-for-global-country-mode.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.032-Handle-wifi-reload-for-global-country-mode.patched
            fi

            if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.033-Unified-CountrycodeSet.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
                  patch -p1 < ${WORKDIR}/033-Unified-CountrycodeSet.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.033-Unified-CountrycodeSet.patched
            fi

            if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.034-Reset-values-after-FR-fix.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
                  patch -p1 < ${WORKDIR}/034-Reset-values-after-FR-fix.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.034-Reset-values-after-FR-fix.patched
            fi

            if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.035-transmit-power-issue-fix.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
                  patch -p1 < ${WORKDIR}/035-transmit-power-issue-fix.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.035-transmit-power-issue-fix.patched
            fi

            if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.036-Ap-IsolationEnable-fix.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
                  patch -p1 < ${WORKDIR}/036-Ap-IsolationEnable-fix.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.036-Ap-IsolationEnable-fix.patched
            fi

            if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.037-MLDUnit-dm-implementation.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
                  patch -p1 < ${WORKDIR}/037-MLDUnit-dm-implementation.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.037-MLDUnit-dm-implementation.patched
            fi

            if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.038-Unsupported-11BE-mode.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
                  patch -p1 < ${WORKDIR}/038-Unsupported-11BE-mode.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.038-Unsupported-11BE-mode.patched
            fi 

            if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.039-MFP-RFC-Issue.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
                  patch -p1 < ${WORKDIR}/039-MFP-RFC-Issue.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.039-MFP-RFC-Issue.patched
            fi

            if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.040-Airties-Controller-notification.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/
                  patch -p1 < ${WORKDIR}/040-Airties-Controller-notification.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspWifiAgent/.040-Airties-Controller-notification.patched
            fi
}

do_install_append(){
    install -m 777 ${D}/usr/bin/CcspWifiSsp -t ${D}/usr/ccsp/wifi/
    install -m 755 ${S}/scripts/cosa_start_wifiagent.sh ${D}/usr/ccsp/wifi
    install -m 777 ${WORKDIR}/wifiTelemetrySetup.sh ${D}/usr/ccsp/wifi/
    install -m 777 ${WORKDIR}/checkwifi.sh ${D}/usr/ccsp/wifi/
    install -m 777 ${WORKDIR}/radio_param_def.cfg ${D}/usr/ccsp/wifi/
    install -m 777 ${WORKDIR}/bridge_mode.sh ${D}/usr/ccsp/wifi/
    install -m 777 ${WORKDIR}/hostapd* ${D}/usr/ccsp/wifi/
    install -m 777 ${WORKDIR}/dpp-hostapd-update.sh ${D}/usr/ccsp/wifi
    install -m 756 ${WORKDIR}/radiohealth.sh ${D}/usr/ccsp/wifi/
    install -m 756 ${WORKDIR}/sae_password_file ${D}/usr/ccsp/wifi/

}

do_install_append_ipq807x() {
     rm -f ${D}/usr/ccsp/wifi/hostapd16.conf
     rm -f ${D}/usr/ccsp/wifi/hostapd17.conf
     rm -f ${D}/usr/ccsp/wifi/hostapd22.conf
     rm -f ${D}/usr/ccsp/wifi/hostapd23.conf
     sed -i 's/ssid=rdkb_alder/ssid=rdkb_hawkeye/g' ${D}/usr/ccsp/wifi/hostapd*
}

do_install_append_ipq807x-64() {
     rm -f ${D}/usr/ccsp/wifi/hostapd16.conf
     rm -f ${D}/usr/ccsp/wifi/hostapd17.conf
     rm -f ${D}/usr/ccsp/wifi/hostapd22.conf
     rm -f ${D}/usr/ccsp/wifi/hostapd23.conf
     sed -i 's/ssid=rdkb_alder/ssid=rdkb_hawkeye/g' ${D}/usr/ccsp/wifi/hostapd*
}

FILES_${PN} += " \
    ${prefix}/ccsp/wifi/CcspWifiSsp \
    ${prefix}/ccsp/wifi/cosa_start_wifiagent.sh \
    ${prefix}/ccsp/wifi/wifiTelemetrySetup.sh \
    ${prefix}/ccsp/wifi/checkwifi.sh \
    ${prefix}/ccsp/wifi/radio_param_def.cfg \
    ${prefix}/ccsp/wifi/bridge_mode.sh \
    ${prefix}/ccsp/wifi/hostapd0.conf \
    ${prefix}/ccsp/wifi/hostapd1.conf \
    ${prefix}/ccsp/wifi/hostapd2.conf \
    ${prefix}/ccsp/wifi/hostapd3.conf \
    ${prefix}/ccsp/wifi/hostapd4.conf \
    ${prefix}/ccsp/wifi/hostapd5.conf \
    ${prefix}/ccsp/wifi/hostapd6.conf \
    ${prefix}/ccsp/wifi/hostapd7.conf \
    ${prefix}/ccsp/wifi/hostapd12.conf \
    ${prefix}/ccsp/wifi/hostapd13.conf \
    ${prefix}/ccsp/wifi/hostapd14.conf \
    ${prefix}/ccsp/wifi/hostapd15.conf \
    ${prefix}/ccsp/wifi/hostapd16.conf \
    ${prefix}/ccsp/wifi/hostapd17.conf \
    ${prefix}/ccsp/wifi/hostapd22.conf \
    ${prefix}/ccsp/wifi/hostapd23.conf \
    ${prefix}/ccsp/wifi/dpp-hostapd-update.sh \
    ${prefix}/ccsp/wifi/radiohealth.sh \	
    ${prefix}/bin/wifi_events_consumer \
    ${prefix}/ccsp/wifi/sae_password_file \
    "

addtask mypatch after do_unpack before do_compile
