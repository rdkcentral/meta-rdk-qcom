
do_install_append() {
	rm -f ${D}/etc/lighttpd.conf
        install -m 0644 ${TOPDIR}/../meta-cmf-ipq/recipes-ccsp/ccsp/ccsp-webui/lighttpd.conf  ${D}/etc/lighttpd/lighttpd.conf
}

