include recipes-core/images/ipq-pkgs.inc

IMAGE_FEATURES_remove_ipq = "read-only-rootfs"

# IMAGE_INSTALL += " \
#	ipq-boot \
#	${SHORTCUT_FE} \
#	board-default \
#	qca-mcs-lkm \
#	pdt \
#	"

IMAGE_INSTALL += " \
	kernel-modules \
	${IPQ_BASE_PKGS} \
	${NETWORK_PKGS} \
	${UTILS} \
	board-default \
        qc-config \
	"

IMAGE_INSTALL_append_ipq40xx += "${SSDK_HNAT_PKGS} \
                                 ${RFS_PKGS} \
                                 ${QCA_ECM} \
                                 ${QCA_EDMA} \
                                 ${MCS_PKGS} \
                                 ${WIFI_PKGS} \
                                "

NSS_ipq95xx_64 = "${QCA_PHY_PKGS} \
                  ${SSDK_NOHNAT_PKGS} \
		  ${NSS_PKGS} \
		  ${IPQ95XX_NSS_PKGS} \
		 "

NSS_ipq95xx = "${QCA_PHY_PKGS} \
               ${SSDK_NOHNAT_PKGS} \
	       ${NSS_PKGS} \
	       ${IPQ95XX_NSS_PKGS} \
              "

NSS_ipq807x_64 = "${SSDK_NOHNAT_PKGS} \
		  ${NSS_PKGS} \
		  ${IPQ807X_NSS_PKGS} \
		 "

NSS_ipq807x = "${SSDK_NOHNAT_PKGS} \
	       ${NSS_PKGS} \
	       ${IPQ807X_NSS_PKGS} \
	      "

NSS_ipq53xx_64 = "${SSDK_NOHNAT_PKGS} \
		  ${NSS_PKGS} \
		 "

NSS_ipq53xx = "${SSDK_NOHNAT_PKGS} \
	       ${NSS_PKGS} \
		"

NSS_ipq54xx_64 = "${QCA_PHY_PKGS} \
                  ${SSDK_NOHNAT_PKGS} \
                  ${NSS_PKGS} \
                 "

NSS_ipq54xx = "${QCA_PHY_PKGS} \
               ${SSDK_NOHNAT_PKGS} \
               ${NSS_PKGS} \
              "
IMAGE_INSTALL += " \
		${NSS} \
		${MCS_PKGS} \
		"
WIFI_ipq95xx_64 = "${WIFI_PKGS}"

WIFI_ipq95xx = "${WIFI_PKGS}"

WIFI_ipq807x_64 = "${WIFI_PKGS}"

WIFI_ipq807x = "${WIFI_PKGS}"

WIFI_ipq53xx_64 = "${WIFI_PKGS}"

WIFI_ipq53xx = "${WIFI_PKGS}"

WIFI_ipq54xx_64 = "${WIFI_PKGS}"

WIFI_ipq54xx = "${WIFI_PKGS}"

FONTANA_ipq95xx_64 = "${FONTANA_PKG}"

FONTANA_ipq95xx = "${FONTANA_PKG}"

FONTANA_ipq53xx_64 = "${FONTANA_PKG}"

FONTANA_ipq53xx = "${FONTANA_PKG}"

FONTANA_ipq54xx_64 = "${FONTANA_PKG}"

FONTANA_ipq54xx = "${FONTANA_PKG}"

IMAGE_INSTALL += "${WIFI}"
#IMAGE_INSTALL += "${FONTANA}"
IMAGE_INSTALL += "crashupload"

IMAGE_INSTALL += "rdk-fwupgrade-manager"
IMAGE_INSTALL += "ccsp-logagent"
IMAGE_INSTALL += "telemetry"
IMAGE_INSTALL += "qca-hyfi-bridge"

EXTRA_IMAGEDEPENDS += " \
                       ${TEST_PKGS} \
                       memtester \
                       dosfstools \
                       "

#IMAGE_INSTALL_remove = " \
#			${EXTRA_IMAGEDEPENDS} \
#			"
