SUMMARY = "common inc for IPQ Platform"

# It is assumed that all recipes including this inc file have
# included meta-rdk/recipes-ccsp/ccsp/ccsp_common.inc

#require meta-rdk/recipes-ccsp/ccsp/ccsp_common.inc

CFLAGS_append += "-U_COSA_SIM_ -fno-exceptions -ffunction-sections -fdata-sections -fomit-frame-pointer -fno-strict-aliasing \
           -D_ANSC_LINUX -D_ANSC_USER -D_ANSC_LITTLE_ENDIAN_ -D_CCSP_CWMP_TCP_CONNREQ_HANDLER \
           -D_DSLH_STUN_ -D_NO_PKI_KB5_SUPPORT -D_BBHM_SSE_FILE_IO -D_ANSC_USE_OPENSSL_ -DENABLE_SA_KEY \
           -D_ANSC_AES_USED_ -D_COSA_INTEL_USG_ARM_ -D_COSA_FOR_COMCAST_ -D_NO_EXECINFO_H_ -D_PLATFORM_IPQ_ -DFEATURE_SUPPORT_SYSLOG \
           -DBUILD_WEB -D_NO_ANSC_ZLIB_ -D_DEBUG -U_ANSC_IPV6_COMPATIBLE_ -DUSE_NOTIFY_COMPONENT \
           -DENABLE_SD_NOTIFY -DCOSA_DML_WIFI_FEATURE_LoadPsmDefaults -UPARODUS_ENABLE \
           -DCONFIG_VENDOR_CUSTOMER_COMCAST -DENABLE_ETH_WAN -DETH_STATS_ENABLED -D_WIFI_AX_SUPPORT_ -DINTEL_GRE_HOTSPOT -D_COSA_QCA_ARM_"

CFLAGS_append += "${@bb.utils.contains('DISTRO_FEATURES', 'rdkb_wan_manager', ' -DFEATURE_RDKB_WAN_MANAGER ', '', d)}"	   
CFLAGS_append_aarch64 = " -D_64BIT_ARCH_SUPPORT_ "

EXTRA_OECONF_append  = " --with-ccsp-platform=qca --with-ccsp-arch=arm"

UNKNOWN_CONFIGURE_OPT_IGNORE:append:kirkstone = " --with-ccsp-arch --with-ccsp-platform "

DEPENDS += "breakpad-wrapper"
LDFLAGS += "-lbreakpadwrapper"
LDFLAGS_append_dunfell = " -lpthread -lcrypto -lsafec-3.5.1"
