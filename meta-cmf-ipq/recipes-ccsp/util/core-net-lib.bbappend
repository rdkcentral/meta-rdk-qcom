do_populate_sysroot() {
	sysroot_stage_dir ${D}/usr/include ${SYSROOT_DESTDIR}/usr/include/core-net-lib/
	sysroot_stage_dir ${D}/usr/lib ${SYSROOT_DESTDIR}/usr/lib/
}
