#!/bin/bash

usage="usage: $(basename "$0") blackiface rediface

where:
    blackiface  interface connected to the internet access (e.g. eth0)
    rediface    interface to your computer (e.g. wlan0)"

render(){
    eval "echo \"$(cat $1.template)\"" >$1
}


if [ $# -ne 2 ]
then
    echo "$usage" >&2
    exit 1
fi

BLACKIF=$1
REDIF=$2

if echo "$BLACKIF" | grep -q "wlan"
then
    BLKW=""
else
    BLKW="#"
fi

if echo "$REDIF" | grep -q "wlan"
then
    REDW=""
else
    REDW="#"
fi

#eval "echo \"$(cat interfaces.template)\"" >interfaces
render interfaces
render hostapd.conf
render isc-dhcp-server
render change_router_pw.sh
render change_router_ssid.sh
render change_sponion_ssidpw.sh
sed "s/REDIF/$REDIF/g" index.php.template > tmp
sed "s/BLACKIF/$BLACKIF/g" tmp > index.php
rm tmp
render iptables_hostapd.sh
render iptables_tor.sh

