#!/bin/bash
interfaces=$(find /etc/wireguard -type f -iname "*.conf")
interface=`echo $interfaces | head -n 1 | sed 's|.*/||; s|\.conf$||' `
wg show $interface transfer
