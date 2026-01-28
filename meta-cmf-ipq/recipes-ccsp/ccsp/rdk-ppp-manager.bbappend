FILESEXTRAPATHS_prepend := "${THISDIR}:"
SRC_URI += " file://001-pppmanager-vlan-change-name.patch \
	     file://015_PPPoE_SNAT-in-PPpMang.patch \
	     file://002-pppmanager-signal_6coredump-fix.patch \
           "

do_mypatch() {
            if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/RdkPppManager/source/.001-pppmanager-vlan-change-name-patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/RdkPppManager/source/
                  patch -p2 < ${WORKDIR}/001-pppmanager-vlan-change-name.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/RdkPppManager/source/.001-pppmanager-vlan-change-name-patched
            fi

	    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/RdkPppManager/source/.015_PPPoE_SNAT-in-PPpMang.patched ]; then
		  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/RdkPppManager/source/
		  patch -p2 < ${WORKDIR}/015_PPPoE_SNAT-in-PPpMang.patch
		  cd -
		  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/RdkPppManager/source/.015_PPPoE_SNAT-in-PPpMang.patched
	    fi

            if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/RdkPppManager/source/.002-pppmanager-signal_6coredump-fix.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/RdkPppManager/source/
                  patch -p2 < ${WORKDIR}/002-pppmanager-signal_6coredump-fix.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/RdkPppManager/source/.002-pppmanager-signal_6coredump-fix.patched
            fi

}

addtask mypatch before do_compile after do_unpack
