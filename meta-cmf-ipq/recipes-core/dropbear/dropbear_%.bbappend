SYSTEMD_AUTO_ENABLE_${PN} = "disable"

do_configure_prepend_broadband () {
    export LIBS="${LIBS} -ltelemetry_msgsender"
}
