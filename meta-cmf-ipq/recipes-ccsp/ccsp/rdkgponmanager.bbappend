FILESPATH =+ "${THISDIR}/${PN}:"
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"


SRC_URI_append = " \
    file://001-RdkGponManager.patch \
"

EXTRA_OECONF_remove_kirkstone = " --with-ccsp-platform=bcm --with-ccsp-arch=arm "


DEPENDS_append = " libsyswrapper"
LDFLAGS_append = " -lsecure_wrapper"

CFLAGS_append  += " ${@bb.utils.contains('DISTRO_FEATURES', 'WanManagerUnificationEnable', '-DWAN_MANAGER_UNIFICATION_ENABLED', '', d)}"
CFLAGS_append = " -Wno-incompatible-pointer-types -Wno-implicit-function-declaration "

CFLAGS_append = " \
    -I${S}/source/GponManager \
    -I${S}/source/TR-181/middle_layer_src \
    -I${S}/source/TR-181/include \
"

do_install_append(){
    install -m 644 ${S}/config/gpon_manager_wan_unify_conf.json ${D}${sysconfdir}/rdk/conf
    install -m 644 ${S}/hal_schema/gpon_wan_unify_hal_schema.json ${D}${sysconfdir}/rdk/schemas
}

do_mypatch() {
	    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/RdkGponManager/config/.001-RdkGponManager.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/RdkGponManager/
                  patch -p1 < ${WORKDIR}/001-RdkGponManager.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/RdkGponManager/config/.001-RdkGponManager.patched
            fi
}

addtask mypatch before do_compile after do_unpack

FILES_${PN} += "${systemd_unitdir}/system/*"
