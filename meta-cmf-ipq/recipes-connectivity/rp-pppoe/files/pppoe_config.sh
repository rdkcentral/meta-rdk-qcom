#!/bin/sh

PPP_CONFIG_FILE=/etc/ppp/pppoe.conf
CF_BASE=$(basename "$PPP_CONFIG_FILE")
DNS1=${DNS1:-}

umask 077

cp "$PPP_CONFIG_FILE" "$PPP_CONFIG_FILE-bak"

echo > "$PPP_CONFIG_FILE"
echo "DEFAULTROUTE=yes" >> "$PPP_CONFIG_FILE"
echo "CONNECT_TIMEOUT=0" >> "$PPP_CONFIG_FILE"
echo "CONNECT_POLL=2" >> "$PPP_CONFIG_FILE"
echo "ACNAME=" >> "$PPP_CONFIG_FILE"
echo "SERVICENAME=" >> "$PPP_CONFIG_FILE"
echo "PING=." >> "$PPP_CONFIG_FILE"
echo "CF_BASE=$CF_BASE" >> "$PPP_CONFIG_FILE"
echo "SYNCHRONOUS=no" >> "$PPP_CONFIG_FILE"
echo "CLAMPMSS=1412" >> "$PPP_CONFIG_FILE"
echo "LCP_INTERVAL=1000" >> "$PPP_CONFIG_FILE"
echo "LCP_FAILURE=10" >> "$PPP_CONFIG_FILE"
echo "PPPOE_TIMEOUT=80" >> "$PPP_CONFIG_FILE"
echo "PPPOE_EXTRA=" >> "$PPP_CONFIG_FILE"
echo "PPPD_EXTRA=" >> "$PPP_CONFIG_FILE"
echo "USER=$1" >> "$PPP_CONFIG_FILE"
echo "ETH=$3" >> "$PPP_CONFIG_FILE"
echo "DEMAND=no" >> "$PPP_CONFIG_FILE"
echo "DNSTYPE=NOCHANGE" >> "$PPP_CONFIG_FILE"
echo "PEERDNS=no" >> "$PPP_CONFIG_FILE"
echo "DNS1=" >> "$PPP_CONFIG_FILE"
echo "DNS2=" >> "$PPP_CONFIG_FILE"
echo 'PIDFILE="/etc/ppp/$CF_BASE-pppoe.pid"' >> "$PPP_CONFIG_FILE"
echo "FIREWALL=NONE" >> "$PPP_CONFIG_FILE"
echo "LINUX_PLUGIN=rp-pppoe.so" >> "$PPP_CONFIG_FILE"

if [ -n "$DNS1" ]; then
    /bin/echo "nameserver $DNS1" > /etc/resolv.conf
fi
/bin/echo "\"$1\"   *       \"$2\"" > /etc/ppp/chap-secrets
/bin/echo "Congratulations, PPPoE client is ready!"
exit 0
