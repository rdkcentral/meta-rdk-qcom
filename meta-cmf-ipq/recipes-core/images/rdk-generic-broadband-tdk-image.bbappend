IMAGE_FEATURES_remove_ipq = "read-only-rootfs"

include recipes-core/images/ipq-pkgs.inc

# Include modules in rootfs

IMAGE_INSTALL += " \
        kernel-modules \
        ${IPQ_BASE_PKGS} \
        ${NETWORK_PKGS} \
        ${UTILS} \
	ipq-boot \
        board-default \
        "

IMAGE_INSTALL += " \
                  ${NSS} \
                  ${MCS_PKGS} \
                 "

NSS_ipq95xx_64 = "${SSDK_NOHNAT_PKGS} \
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
                  ${IPQ53XX_NSS_PKGS} \
                 "

NSS_ipq53xx = "${SSDK_NOHNAT_PKGS} \
               ${NSS_PKGS} \
               ${IPQ53XX_NSS_PKGS} \
                "

WIFI_ipq95xx_64 = "${WIFI_PKGS}"

WIFI_ipq95xx = "${WIFI_PKGS}"

WIFI_ipq807x_64 = "${WIFI_PKGS}"

WIFI_ipq807x = "${WIFI_PKGS}"

WIFI_ipq53xx_64 = "${WIFI_PKGS}"

WIFI_ipq53xx = "${WIFI_PKGS}"

IMAGE_INSTALL += "${WIFI}"

IMAGE_INSTALL += "crashupload"

EXTRA_IMAGEDEPENDS += " \
                       ${TEST_PKGS} \
                       memtester \
                       dosfstools \
                       "

IMAGE_INSTALL_remove = " \
			${EXTRA_IMAGEDEPENDS} \
			"
