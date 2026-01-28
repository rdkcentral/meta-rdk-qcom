require ccsp_common_ipq.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
EXTRA_OECONF += "PHP_RPATH=no"

SRC_URI_append = " \
            file://lighttpd.conf \
        "

do_install_append () {
    install -d ${D}${sysconfdir}
    install -m 755 ${S}/../Styles/xb3/config/php.ini ${D}${sysconfdir}

    install -m 0644 ${WORKDIR}/lighttpd.conf  ${D}/etc/lighttpd.conf

    # delete wan0 reference for R-Pi
    sed -i '/wan0/d' ${D}${sysconfdir}/webgui.sh

    #replace brlan0 with br-lan
    sed -i "s/\bbrlan0\b/br-lan/" ${D}${sysconfdir}/webgui.sh

    #delete server.pem reference for R-Pi
    sed -e '/server.pem/ s/^#*/echo "Removed server.pem references for R-pi"\n#/' -i ${D}${sysconfdir}/webgui.sh

    # add spawn-fcgi command required to run fcgi with lighttpd 1.5
    sed -i '/lighttpd -f/i \
\/usr\/bin\/spawn-fcgi -s \/tmp\/php-fastcgi.sock -f \"\/usr\/bin\/php-cgi -c \/etc\/php.ini\" -C 5 -P \/var\/run\/spawn-fcgi.pid' ${D}${sysconfdir}/webgui.sh
    sed -i -e "s/'TCP',\ 'UDP',\ 'TCP\/UDP'/'TCP',\ 'UDP',\ 'BOTH'/g" ${D}/usr/www/actionHandler/ajax_managed_services.php
}

FILES_${PN} += "${sysconfdir}/php.ini"