FILESPATH =+ "${TOPDIR}/../meta-rdk-qcom/meta-cmf-ipq/recipes-ccsp/ccsp:"
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append += "file://001-logagent_header.patch"	

do_mypatch() {	
    if [ ! -f ${TOPDIR}/../rdkb/components/generic/CcspLogAgent/.001-logagent_header.patched ]; then	
        cd ${TOPDIR}/../rdkb/components/generic/CcspLogAgent/source/	
        patch -l -p2 < ${WORKDIR}/001-logagent_header.patch
        cd -	
        touch ${TOPDIR}/../rdkb/components/generic/CcspLogAgent/.001-logagent_header.patched
    fi	
}	

addtask mypatch after do_unpack before do_compile 
