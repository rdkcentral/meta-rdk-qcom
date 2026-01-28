require ccsp_common_ipq.inc
LDFLAGS += "-Wl,--no-as-needed -lulog"
CFLAGS_append = " -D_RDK_REF_PLATFORM_ -DDSLITE_FEATURE_SUPPORT_ -DDDNS_BROADBANDFORUM_ -DDEVICE_GATEWAY_ASSOCIATION_FEATURE_ \
                  -DFEATURE_FWUPGRADE_MANAGER_ -DFEATURE_RDKB_GPON_MANAGER_ -DFEATURE_RDKB_XDSL_PPP_MANAGER_ "

FILESEXTRAPATHS_prepend := "${THISDIR}:"
SRC_URI += " file://0001-ccsp-management-server-genieacs.patch "
SRC_URI += " file://0002-6g-support-genieacs.patch "
SRC_URI += " file://0003-adv-support-genieacs.patch "
SRC_URI += " file://0004-ccsp_tr069_rdkgponmanager.patch "

do_install_append () {
    # Config files and scripts
    install -m 644 ${S}/config/ccsp_tr069_pa_certificate_cfg_arm.xml ${D}/usr/ccsp/tr069pa/ccsp_tr069_pa_certificate_cfg.xml
    install -m 644 ${S}/config/ccsp_tr069_pa_cfg_arm.xml ${D}/usr/ccsp/tr069pa/ccsp_tr069_pa_cfg.xml
    install -m 644 ${S}/config/ccsp_tr069_pa_mapper_arm.xml ${D}/usr/ccsp/tr069pa/ccsp_tr069_pa_mapper.xml
    install -m 644 ${S}/config/sdm_arm.xml ${D}/usr/ccsp/tr069pa/sdm.xml

    install -d ${D}/fss/gw/
    install -d ${D}/fss/gw/usr/ccsp/
    install -d ${D}/etc
    install -m 777 ${D}/usr/bin/CcspTr069PaSsp -t ${D}/usr/ccsp/tr069pa

    ln -sf /version.txt ${D}/fss/gw/version.txt
    ln -sf /usr/ccsp/tr069pa/ ${D}/fss/gw/usr/ccsp/tr069pa
    ln -sf /usr/ccsp/tr069pa/sdm.xml ${D}/usr/bin/sdm.xml
    ln -sf /usr/ccsp/tr069pa/url ${D}${sysconfdir}/url
    echo "5555" > ${D}/usr/ccsp/tr069pa/sharedkey
}

do_mypatch() {
    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspTr069Pa/source-embedded/.0001-ccsp-management-server-genieacs-patched ]; then
        cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspTr069Pa/source-embedded/
        patch -p2 < ${WORKDIR}/0001-ccsp-management-server-genieacs.patch
        touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspTr069Pa/source-embedded/.0001-ccsp-management-server-genieacs-patched
        cd -
    fi

    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspTr069Pa/.0002-6g-support-genieacs-patched ]; then
        cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspTr069Pa/
        patch -p1 -l < ${WORKDIR}/0002-6g-support-genieacs.patch
        touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspTr069Pa/.0002-6g-support-genieacs-patched
        cd -
    fi
    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspTr069Pa/.0003-adv-support-genieacs-patched ]; then
        cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspTr069Pa/
        patch -p1 -l < ${WORKDIR}/0003-adv-support-genieacs.patch
        touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspTr069Pa/.0003-adv-support-genieacs-patched
        cd -
    fi
    if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspTr069Pa/.0004-ccsp_tr069_rdkgponmanager.patched ]; then
        cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspTr069Pa/
        patch -p1 -l < ${WORKDIR}/0004-ccsp_tr069_rdkgponmanager.patch
        touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspTr069Pa/.0004-ccsp_tr069_rdkgponmanager.patched
        cd -
    fi
}

addtask mypatch after do_unpack before do_compile

FILES_${PN}-ccsp += " \
    ${prefix}/ccsp/tr069pa/CcspTr069PaSsp \
    ${prefix}/ccsp/tr069pa/url \
"

FILES_${PN} += " \
    /fss/gw/usr/ccsp/ \
    /fss/gw/version.txt \
    /etc/url \
"
