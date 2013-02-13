#!/bin/bash
SDIR=/opt/squid/sbin
function list_services {
        printf "%20s  %s\n" "Service Name" "Service Function"
        printf "%20s  %s\n" "------------" "----------------"
        for service in `ls $SDIR | grep -v not-working`; do
                desc=`grep DEF: $SDIR/$service | sed 's/.*DEF: //'`
                printf "%20s: %s\n" $service "$desc"
        done
        printf "\n"
}
if [ -z $1 ] || [ -z $2 ] || [ -z $3 ]; then
        list_services
        echo "Usage: $0 wifi_interface internet_interface service_name"
        echo
        exit
fi
if [ ! -f $SDIR/$3 ] ; then
        printf "\n!!! Invalid service name: %s\n\n" $3
        list_services
        exit
fi
echo "[+] Setting IP address on $1"
ifconfig $1 10.0.0.1/24

echo "[+] Starting DHCP server"
/etc/init.d/isc-dhcp-server stop >/dev/null
sleep 2
/etc/init.d/isc-dhcp-server start >/dev/null

echo "[+] Removing old temporary files"
rm -rf /var/www/tmp/* 2>/dev/null

echo "[+] Configuring Squid Proxy for $3"
rm /etc/squid3/url_rewrite_program
ln -s $SDIR/$3 /etc/squid3/url_rewrite_program
service squid3 restart

echo "[+] Setting firewall rules"
iptables --flush
iptables --table nat --flush
iptables --delete-chain
iptables --table nat --append POSTROUTING --out-interface $2 -j MASQUERADE
iptables --append FORWARD --in-interface $1 -j ACCEPT
iptables --table nat -A PREROUTING -i $1 -p tcp --destination-port 80 -j REDIRECT --to-port 3128

echo "[+] Setting up routing"
sysctl -w net.ipv4.ip_forward=1 >/dev/null

echo "[+] Starting wireless AP, press CTRL+C to end"
hostapd /etc/hostapd/hostapd.conf

