
do_install_prepend () {
	install -d ${D}${sysconfdir}
	touch ${D}${sysconfdir}/pear.conf
}

do_install_append () {
	install -d ${D}${sysconfdir}
	rm ${D}${sysconfdir}/pear.conf
}

