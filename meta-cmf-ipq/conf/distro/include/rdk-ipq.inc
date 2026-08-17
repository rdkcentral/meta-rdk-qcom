DISTRO_FEATURES_append = " rdkb_wan_manager"
DISTRO_FEATURES_append = " easymesh-controller"
DISTRO_FEATURES_append = " rdkb_xdsl_ppp_manager"
DISTRO_FEATURES_append = " fwupgrade_manager"
DISTRO_FEATURES_append = " rdkb_gpon_manager"
DISTRO_FEATURES_append = " WanManagerUnificationEnable"
DISTRO_FEATURES_append = " wan-traffic-count "
DISTRO_FEATURES_append = " HOSTAPD_2_12"
DISTRO_FEATURES_append = " CONFIG_IEEE80211BE"
#OneWifi feature
DISTRO_FEATURES_append = " OneWifi"
DISTRO_FEATURES_append = " disable_nl80211_acl "

PREFERRED_VERSION_samba_dunfell = "${@bb.utils.contains('DISTRO_FEATURES', '', '4.10.18', '3.6.25', d)}"
PREFERRED_VERSION_gnutls_dunfell = "${@bb.utils.contains('DISTRO_FEATURES', '', '3.6.14', '3.3.30', d)}"
PREFERRED_VERSION_nettle_dunfell = "${@bb.utils.contains('DISTRO_FEATURES', '', '3.5.1', '2.7.1', d)}"
PREFERRED_VERSION_gmp_dunfell = "${@bb.utils.contains('DISTRO_FEATURES', '', '6.2.0', '4.2.1', d)}"
PREFERRED_VERSION_wireless-tools_dunfell = "${@bb.utils.contains('DISTRO_FEATURES', '', '29', '30.pre9', d)}"
PREFERRED_VERSION_nghttp2_dunfell = "${@bb.utils.contains('DISTRO_FEATURES', '', '1.40.0', '1.31.1', d)}"
PREFERRED_VERSION_iw_dunfell = "${@bb.utils.contains('DISTRO_FEATURES', '', '5.16', '4.7', d)}"

DISTRO_FEATURES_remove = " bluetooth bluez5 "
DISTRO_FEATURES_append = " webconfig_bin "

#Easymesh feature
DISTRO_FEATURES_append = " EasyMesh"

DISTRO_FEATURES_append_broadband = " RbusBuildFlagEnable"
DISTRO_FEATURES_append_broadband = " WanManagerUnificationEnable "

# RDKB-44824: CoreNetLib move bb file location
DISTRO_FEATURES_append_broadband = " core-net-lib"

# RDKBDEV-73 : Dynamic DNS : Standardization based on broadband-forum.
DISTRO_FEATURES_append_broadband = " ddns_broadband"

# RDKBDEV-50: Adding DSLite Functionality and related TR-181 DataModel Parameters
DISTRO_FEATURES_append_broadband = " dslite"

# REFPLTB-1546 : WiFi HAL 3.0 support
DISTRO_FEATURES_append_broadband = " halVersion3"

DISTRO_FEATURES_append_broadband = " ipv6"

# RDKB-50999: WebConfig blob handler
DISTRO_FEATURES_append_broadband = " lld_support"

#No Moca Support
DISTRO_FEATURES_append = " no_moca_support"

DISTRO_FEATURES_append_broadband = " referencepltfm"

# RDKBDEV-298 : Add USP Agent support using OBUSPA
DISTRO_FEATURES_append_broadband = " usppa"

# RDKBDEV-694: Adding Partner Default Ext
DISTRO_FEATURES_append_broadband = " partner_default_ext "

#BB MASKS
BBMASK += "libkwk-rdk"

BBMASK += "meta-ipq/recipes-networking/openvswitch/openvswitch_%.bbappend"
MACHINEOVERRIDES_append =. "${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ':onewifi', '' ,d)}"


# Recipe: ccsp-epon-agent.bb | SRC_URI name=CcspEPONAgent | uses SRCREV_CcspEPONAgent
SRCREV_CcspEPONAgent_pn-ccsp-epon-agent="4ef8f81911d8d0d30faa9d593ddb38b44fee1751"
# Recipe: ccsp-one-wifi.bb | SRC_URI name=OneWifi | uses SRCREV_OneWifi
#SRCREV_OneWifi_pn-ccsp-one-wifi="b32832f8062ae47535973379954d65193f4c3880"
# Recipe: ccsp-one-wifi-libwebconfig.bb | SRC_URI name=libwebconfig | uses SRCREV_libwebconfig
#SRCREV_libwebconfig_pn-ccsp-one-wifi-libwebconfig="b32832f8062ae47535973379954d65193f4c3880"
# Recipe: ccsp-webui-jst.bb | unnamed webui repo (no name= in SRC_URI) | uses plain SRCREV
SRCREV_pn-ccsp-webui-jst="a1c11145894615bf536e7ffcb08624b817e5949f"
# Recipe: ccsp-webui-jst.bb | SRC_URI name=xb3 | uses SRCREV_xb3
SRCREV_xb3_pn-ccsp-webui-jst="27027631af99c21219629296fccde4772d1f5f68"
# Recipe: dca_git.bb | no SRC_URI name | uses plain SRCREV
SRCREV_pn-dca="1cd070ecdc99648e39abd2b95fda0560301e2f52"
# Recipe: dcmjsonparser_git.bb | no SRC_URI name | uses plain SRCREV
SRCREV_pn-dcmjsonparser="065da5cb555bd8e9328934bfb98b68745ecc618f"
# Recipe: hal-fwupgrade_git.bb | SRC_URI name=fwupgradehal | uses SRCREV_fwupgradehal
SRCREV_fwupgradehal_pn-hal-fwupgrade="a23731fbb8b3b7327f8cb8c164424435eb492302"
# Recipe: libsyswrapper.bb | SRC_URI name=libsyswrapper | uses SRCREV_libsyswrapper
SRCREV_libsyswrapper_pn-libsyswrapper="fd48b88ec9d4e3b6d1f9bec445c11b8e0271d0cd"
# Recipe: libunpriv.bb | SRC_URI name=libunpriv | uses SRCREV_libunpriv
SRCREV_libunpriv_pn-libunpriv="21c1e54e5092f81e807f9aaa564f22be29305741"
# Recipe: opensync-headers_2.4.1.bb | SRC_URI name=opensync-headers | uses SRCREV_opensync-headers
SRCREV_opensync-headers_pn-opensync-headers="c27f6d0c5a5c1029af57cf7085b53dff490bebdb"
# Recipe: rdk-easymesh-controller.bb | SRC_URI name=RdkEasyMeshController | uses SRCREV_RdkEasyMeshController
SRCREV_RdkEasyMeshController_pn-rdk-easymesh-controller="e927a70c7727bf5c3148ddcf1abda3bfd9ff529a"
# Recipe: rdk-wanmanager.bb | SRC_URI name=WanManager but uses plain SRCREV
SRCREV_pn-rdk-wanmanager="ee28b2b4690ec2dfd53ea331dfe30eb6b23f006c"
# Recipe: rdk-wifi-util.bb | SRC_URI name=rdk-wifi-util | uses SRCREV_rdk-wifi-util
SRCREV_rdk-wifi-util_pn-rdk-wifi-util="f81d7cacb67be345c5f7e5df38a61e3b24e64611"
# Recipe: rdm.bb | SRC_URI name=rdmgeneric | uses SRCREV_rdmgeneric
SRCREV_rdmgeneric_pn-rdm="cb7628372bf339b105eef6eb91c3795de618a49f"
# Recipe: sysint-broadband.bb | SRC_URI name=sysintbroadband | uses SRCREV_sysintbroadband
SRCREV_sysintbroadband_pn-sysint-broadband="4a2d35936d1875039179472da887aeba6c3b3d03"
# Recipe: webconfig-framework.bb | no SRC_URI name | uses plain SRCREV
SRCREV_pn-webconfig-framework="cca15c06d8fa58153856b4a53a7859520573d7d5"
SRCREV_pn-webconfig-framework-native="cca15c06d8fa58153856b4a53a7859520573d7d5"
# Recipe: ccsp-webui-jst.bbappend (meta-cmf-ipq) | SRC_URI name=rdkbsysintrpi
SRCREV_rdkbsysintrpi_pn-ccsp-webui-jst="84571d9371fea4fb3169e456ce49b8b7dc0ea48a"
# Recipe: sysint-broadband.bb | SRC_URI name=sysintdevice | uses SRCREV_sysintdevice
SRCREV_sysintdevice_pn-sysint-broadband="0d13c277bfd48e4dde02bd750c672c194ec72977"
# Recipe: memstress_0.1.bb | no SRC_URI name | uses plain SRCREV (set via .bbappend)
SRCREV_pn-memstress = "fb4db2459e4b5b1dbbe4e8582575fc43d55abcc2"

BBMASK += "meta-rdk/recipes-support/base64/base64_git\.bb"
BBMASK += "meta-rdk-broadband/recipes-ccsp/ccsp/batterymgr\.bb"
BBMASK += "meta-rdk/recipes-connectivity/bluetooth/bluetooth-core_git\.bb"
BBMASK += "meta-rdk/recipes-connectivity/bluetooth/bluetooth-mgr_git\.bb"
BBMASK += "meta-rdk-broadband/recipes-ccsp/ccsp/ccsp-dslagent\.bb"
BBMASK += "meta-rdk-broadband/recipes-ccsp/ccsp/ccsp-gwprovapp-epon\.bb"
BBMASK += "meta-rdk-broadband/recipes-ccsp/ccsp/ccsp-logagent\.bb"
BBMASK += "meta-rdk-broadband/recipes-ccsp/ccsp/ccsp-vlanagent\.bb"
BBMASK += "meta-rdk-broadband/recipes-ccsp/ccsp/ccsp-webui-bci-jst\.bb"
BBMASK += "meta-rdk-broadband/recipes-ccsp/ccsp/ccsp-webui-bci-php\.bb"
BBMASK += "meta-rdk-broadband/recipes-ccsp/ccsp/ccsp-webui-php\.bb"
BBMASK += "meta-rdk-broadband/recipes-ccsp/ccsp/ccsp-wifi-agent\.bb"
BBMASK += "meta-rdk-broadband/recipes-ccsp/ccsp/ccsp-xtmagent\.bb"
BBMASK += "meta-rdk/recipes-common/sys_mon_tools/cpuprocanalyzer_git\.bb"
BBMASK += "meta-rdk-broadband/recipes-ccsp/ccsp/gatewaymanager\.bb"
BBMASK += "meta-cmf/recipes-core/dbus/gdbus-client/gdbus-client_git\.bb"
BBMASK += "meta-rdk-ext/recipes-multimedia/gst-external-plugin/gst-external-plugin\.bb"
BBMASK += "meta-rdk-ext/recipes-ccsp/hal/hal-voice-asterisk_git\.bb"
BBMASK += "meta-cmf-broadband/recipes-ccsp/hal/hal-wifi-cfg80211_git\.bb"
BBMASK += "meta-rdk-broadband/recipes-extended/hwselftest/hwselftest_git\.bb"
BBMASK += "meta-rdk/recipes-extended/jquery/jquery_git\.bb"
BBMASK += "meta-cmf/recipes-support/libdacjwt/libdacjwt\.bb"
BBMASK += "meta-cmf/recipes-support/libmntfsimg/libmntfsimg\.bb"
BBMASK += "meta-cmf/recipes-containers/lxc-container-generator/lxc-container-generator-native\.bb"
BBMASK += "meta-rdk/recipes-containers/lxc-container-generator/lxc-container-generator-native\.bb"
BBMASK += "meta-rdk/recipes-containers/lxccpid/lxccpid_git\.bb"
BBMASK += "meta-rdk/recipes-common/mount-utils/mountutils\.bb"
BBMASK += "meta-rdk/recipes-common/nlmonitor/nlmonitor_git\.bb"
BBMASK += "meta-cmf/recipes-support/omi/omi\.bb"
BBMASK += "meta-rdk-broadband/recipes-ccsp/ccsp/platformmanager\.bb"
BBMASK += "meta-rdk/recipes-common/rdk-oss-ssa/rdk-oss-ssa_git\.bb"
BBMASK += "meta-rdk/recipes-common/rdkversion/rdkversion_.*\.bb"
BBMASK += "meta-rdk-broadband/recipes-ccsp/ccsp/rfc-agent\.bb"
BBMASK += "meta-cmf/recipes-extended/rpcserver/rpcserver\.bb"
BBMASK += "meta-cmf/recipes-common/rtremote/rtremote_git\.bbappend"
BBMASK += "meta-cmf-ipq/recipes-common/rtremote/rtremote_git\.bbappend"
BBMASK += "meta-cmf-ipq/recipes-ccsp/ccsp/servicemanager\.bb"
BBMASK += "meta-cmf/recipes-extended/smartmon/smartmon_git\.bb"
BBMASK += "meta-rdk-broadband/recipes-rdkb/sysint-broadband/sysint-broadband-min\.bb"
BBMASK += "meta-rdk/recipes-common/syslog-helper/syslog-helper_git\.bb"
BBMASK += "meta-rdk/recipes-common/sys_mon_tools/sys-resource_git\.bb"
BBMASK += "meta-cmf/recipes-support/libkwk-rdk/libkwk-rdk\.bb"
BBMASK += "meta-cmf/recipes-support/libkwk-rdk/libkwk-rdk-header\.bb"
