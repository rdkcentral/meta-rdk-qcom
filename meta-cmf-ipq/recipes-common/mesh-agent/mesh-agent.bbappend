CFLAGS += " -DWAN_FAILOVER_SUPPORTED "
FILES_${PN}_append += "${systemd_unitdir}/system/meshAgent.service"
