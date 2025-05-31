#!/bin/bash

set -e


# Do we have an existing config?
interfaces=$(find /etc/wireguard -type f -iname "*.conf")
if [[ -z $interfaces ]]; then
    echo "$(date): Config file not found in /etc/wireguard" >&2

    # Should we create it?
    if [[ -n $WG_INT_NAME ]]; then
        interface="$WG_INT_NAME" # check Dockerfile for default value
        port_number="$WG_INT_PORT"

        # Generating keys
        private_key=$(wg genkey)
        public_key=$(echo "$private_key" | wg pubkey)
        echo "$public_key" > "/etc/wireguard/${interface}.pubkey"
        chmod 400 "/etc/wireguard/${interface}.pubkey"
        config_file="/etc/wireguard/${interface}.conf"

        # Create a basic WireGuard configuration
        cat <<EOL > "$config_file"
[Interface]
Address = 10.66.0.1/24
PrivateKey = $private_key
ListenPort = $port_number
PostUp = iptables -I INPUT -p udp --dport $port_number -j ACCEPT
PostDown = iptables -D INPUT -p udp --dport $port_number -j ACCEPT
EOL
        chmod 600 "/etc/wireguard/${interface}.conf"
        echo "$(date): Generated WireGuard config file at $config_file"
        echo "$(date): Private key: $private_key"
        echo "$(date): Public key: $public_key"
        echo "$(date): Check out the file yourself though"
        echo "$(date): Starting Wireguard"
    else
        echo "$(date): WG_INT_NAME environment variable is not set" >&2
        exit 1
    fi
else
    echo "$(date): Existing config files found in /etc/wireguard"
    echo "$(date): $interfaces"
    interface=`echo $interfaces | head -n 1`
fi

wg-quick up $interface

# Handle shutdown behavior
finish () {
    echo "$(date): Shutting down Wireguard"
    wg-quick down $interface
    exit 0
}

trap finish SIGTERM SIGINT SIGQUIT

sleep infinity &
wait $!
