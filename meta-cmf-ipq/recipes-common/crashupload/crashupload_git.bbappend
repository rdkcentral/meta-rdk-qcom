#FILESEXTRAPATHS_append := "${THISDIR}/files:"
FILESPATH =+ "${TOPDIR}/../meta-rdk-qcom/meta-cmf-ipq/recipes-common/crashupload/files:"

SRC_URI += " \
            file://01-changes-for-crashupload.patch \
            file://02-changes-for-crashupload.patch \
            file://03-changes-for-crashupload.patch \
            "


do_mypatch() {
    flock ${TOPDIR}/../rdk/components/generic/crashupload/patch_apply.lock -c '
    if [ ! -f ${TOPDIR}/../rdk/components/generic/crashupload/01-changes-for-crashupload.patched ]; then
           cd ${TOPDIR}/../rdk/components/generic/crashupload
           if patch -p1 --dry-run -f < ${WORKDIR}/01-changes-for-crashupload.patch; then
               patch  -p1  < ${WORKDIR}/01-changes-for-crashupload.patch
           else
               echo "01-changes-for-crashupload.patch Patch already applied or cannot be applied."
           fi
           touch ${TOPDIR}/../rdk/components/generic/crashupload/01-changes-for-crashupload.patched
    fi
    if [ ! -f ${TOPDIR}/../rdk/components/generic/crashupload/02-changes-for-crashupload.patched ]; then
           cd ${TOPDIR}/../rdk/components/generic/crashupload
           if patch -p1 -l --dry-run -f < ${WORKDIR}/02-changes-for-crashupload.patch; then
               patch  -p1  -l < ${WORKDIR}/02-changes-for-crashupload.patch
           else
               echo "02-changes-for-crashupload.patch Patch already applied or cannot be applied."
           fi
           touch ${TOPDIR}/../rdk/components/generic/crashupload/02-changes-for-crashupload.patched
    fi
    if [ ! -f ${TOPDIR}/../rdk/components/generic/crashupload/03-changes-for-crashupload.patched ]; then
           cd ${TOPDIR}/../rdk/components/generic/crashupload
           if patch -p1 -l --dry-run -f < ${WORKDIR}/03-changes-for-crashupload.patch; then
               patch  -p1  -l < ${WORKDIR}/03-changes-for-crashupload.patch
           else
               echo "03-changes-for-crashupload.patch Patch already applied or cannot be applied."
           fi
           touch ${TOPDIR}/../rdk/components/generic/crashupload/03-changes-for-crashupload.patched
    fi
    '
}

addtask mypatch after do_unpack before do_compile
