require ccsp_common_ipq.inc

FILESPATH =+ "${TOPDIR}/../meta-rdk-qcom/meta-cmf-ipq/recipes-ccsp/ccsp:"
SRC_URI += "file://002-lm-lite-max-station.patch"

DEPENDS_append = "utopia-headers"

do_mypatch() {
            if [ ! -f ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspLMLite/source/.002-lm-lite-max-station.patched ]; then
                  cd ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspLMLite/source/
                  patch -p2 < ${WORKDIR}/002-lm-lite-max-station.patch
                  cd -
                  touch ${TOPDIR}/../rdkb/components/opensource/ccsp/CcspLMLite/source/.002-lm-lite-max-station.patched
            fi
}

addtask mypatch after do_unpack before do_compile
