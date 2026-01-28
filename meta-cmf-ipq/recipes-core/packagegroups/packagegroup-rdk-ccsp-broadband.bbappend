RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = "ccsp-cm-agent-ccsp"
RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = "ccsp-cm-agent"
RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = "ccsp-moca"
RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = "ccsp-moca-ccsp"
RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = "sys-resource"
RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = "xupnp"
RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = "hal-fwupgrade"
RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = "rdk-fwupgrade-manager"
RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = "ccsp-hotspot-kmod"
RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = "neon"
RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = "ccsp-adv-security"
RDEPENDS_packagegroup-rdk-ccsp-broadband_remove = "rdktelcovoicemanager"

RDEPENDS_packagegroup-rdk-ccsp-broadband_append = "\
    rdk-logger \
    libseshat \
    notify-comp \
    start-parodus \
"

# Set the gwprov app for IPQ
GWPROVAPP = "${@bb.utils.contains('DISTRO_FEATURES','rdkb_wan_manager', 'ccsp-gwprovapp-ethwan', '', d)}"
