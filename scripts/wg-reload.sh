#!/bin/bash
interfaces=$(find /etc/wireguard -type f -iname "*.conf")
interface=`echo $interfaces | head -n 1 | sed 's|.*/||; s|\.conf$||' `
echo "$(date): reloading $interface"
wg syncconf $interface <(wg-quick strip $interface)
