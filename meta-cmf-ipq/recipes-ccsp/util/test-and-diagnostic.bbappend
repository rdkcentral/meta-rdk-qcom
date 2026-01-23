require recipes-ccsp/ccsp/ccsp_common_ipq.inc

FILESEXTRAPATHS_prepend := "${THISDIR}:"
SRC_URI= " file://001-task_health.patch \
	   file://002-fix_martian_flooding.patch \
	 "

do_install_append() {
        install -m 756 ${S}/scripts/*.sh ${D}/usr/ccsp/tad/
        rm -f ${D}/usr/ccsp/tad/selfheal_bootup.sh
}

do_mypatch() {
    if [ ! -f ${S}/.001-task_health.patched ]; then
        cd ${S}
	cp ${WORKDIR}/001-task_health.patch ${S}/
        patch -p1 < ${S}/001-task_health.patch
        cd -
        touch ${S}/.001-task_health.patched
    fi

    if [ ! -f ${S}/.002-fix_martian_flooding.patched ]; then
        cd ${S}
        cp ${WORKDIR}/002-fix_martian_flooding.patch ${S}/
        patch -p1 < ${S}/002-fix_martian_flooding.patch
        cd -
        touch ${S}/.002-fix_martian_flooding.patched
    fi

}

addtask mypatch after do_unpack before do_compile
