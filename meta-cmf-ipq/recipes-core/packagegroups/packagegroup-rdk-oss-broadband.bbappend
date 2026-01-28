RDEPENDS_packagegroup-rdk-oss-broadband_append = " \
    tcpdump \
    ethtool \
    ebtables \
    ${@bb.utils.contains('MACHINEOVERRIDES', 'morty', 'wireless-tools', 'open-iw', d)} \
"

RDEPENDS_packagegroup-rdk-oss-broadband_remove = " \
    alljoyn \
    linux-firmware \
    neon \
    iw \
"
