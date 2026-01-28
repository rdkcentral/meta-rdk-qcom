FILESPATH =+ "${TOPDIR}/../meta-rdk-qcom/meta-cmf-ipq/recipes-ccsp/ccsp:"
SRC_URI += " \
            file://001-start-parodus.patch"

do_mypatch() {
	cd ${S}
	if [ ! -e .001-start-parodus.patch ]; then
		patch -p1 < ${WORKDIR}/001-start-parodus.patch
		touch .001-start-parodus.patch
	fi
}

addtask mypatch after do_unpack before do_compile
