#!/bin/bash

# SIGTERM-handler this funciton will be executed when the container receives the SIGTERM signal (when stopping)
term_handler(){
	echo "Stopping..."
	killall hostapd
	ifdown $INTERFACE
	ip link set $INTERFACE down
	ip addr flush dev $INTERFACE
	exit 0
}

echo "Starting..."

CONFIG_PATH=/data/options.json

SSID=$(jq --raw-output ".ssid" $CONFIG_PATH)
WPA_PASSPHRASE=$(jq --raw-output ".wpa_passphrase" $CONFIG_PATH)
CHANNEL=$(jq --raw-output ".channel" $CONFIG_PATH)
ADDRESS=$(jq --raw-output ".address" $CONFIG_PATH)
NETMASK=$(jq --raw-output ".netmask" $CONFIG_PATH)
BROADCAST=$(jq --raw-output ".broadcast" $CONFIG_PATH)
INTERFACE=$(jq --raw-output ".interface" $CONFIG_PATH)
HIDE_SSID=$(jq --raw-output ".hide_ssid" $CONFIG_PATH)
ALLOW_MAC_ADDRESSES=$(jq --raw-output '.allow_mac_addresses | join(" ")' $CONFIG_PATH)
DENY_MAC_ADDRESSES=$(jq --raw-output '.deny_mac_addresses | join(" ")' $CONFIG_PATH)
COUNTRY=$(jq --raw-output ".country" $CONFIG_PATH)

# Set interface as wlan0 if not specified in config
if [ ${#INTERFACE} -eq 0 ]; then
    INTERFACE="wlan0"
fi

echo "iface $INTERFACE inet static"$'\n' > /etc/network/interfaces

echo "Set nmcli managed no"
nmcli dev set $INTERFACE managed no

# Setup signal handlers
trap 'term_handler' SIGTERM


### MAC address filtering
## Allow is more restrictive, so we prioritise that and set
## macaddr_acl to 1, and add allowed MAC addresses to hostapd.allow
cat /hostapd.conf.base > /hostapd.conf
echo "" > /hostapd.allow
echo "" > /hostapd.deny
if [ ${#ALLOW_MAC_ADDRESSES} -ge 1 ]; then
    echo "macaddr_acl=1"$'\n' >> /hostapd.conf
    ALLOWED=($ALLOW_MAC_ADDRESSES)
    for mac in "${ALLOWED[@]}"; do
        echo "$mac"$'\n' >> /hostapd.allow
    done
    echo "accept_mac_file=/hostapd.allow"$'\n' >> /hostapd.conf
## else set macaddr_acl to 0, and add denied MAC addresses to hostapd.deny
    else
        if [ ${#DENY_MAC_ADDRESSES} -ge 1 ]; then
            echo "macaddr_acl=0"$'\n' >> /hostapd.conf
            DENIED=($DENY_MAC_ADDRESSES)
            for mac in "${DENIED[@]}"; do
                echo "$mac"$'\n' >> /hostapd.deny
            done
            echo "deny_mac_file=/hostapd.deny"$'\n' >> /hostapd.conf
## else set macaddr_acl to 0, with blank allow and deny files
            else
                echo "macaddr_acl=0"$'\n' >> /hostapd.conf
        fi

fi
# Set wireless country if specified in config
if [ ${#COUNTRY} -ne 0 ]; then
    echo "country_code=${COUNTRY}"$'\n' >> /hostapd.conf
fi



# Add interface to hostapd.conf
echo "interface=$INTERFACE" >> /hostapd.conf

# Enforces required env variables
required_vars=(SSID WPA_PASSPHRASE CHANNEL ADDRESS NETMASK BROADCAST)
for required_var in "${required_vars[@]}"; do
    if [[ -z ${!required_var} ]]; then
        error=1
        echo >&2 "Error: $required_var env variable not set."
    fi
done

# Sanitise config value for hide_ssid
if [ $HIDE_SSID -ne 1 ]; then
        HIDE_SSID=0
fi

if [[ -n $error ]]; then
    exit 1
fi

# Setup hostapd.conf
echo "Setup hostapd ..."
echo "ssid=$SSID"$'\n' >> /hostapd.conf
echo "wpa_passphrase=$WPA_PASSPHRASE"$'\n' >> /hostapd.conf
echo "channel=$CHANNEL"$'\n' >> /hostapd.conf
echo "ignore_broadcast_ssid=$HIDE_SSID"$'\n' >> /hostapd.conf

# Setup interface
echo "Setup interface ..."

#ip link set wlan0 down
#ip addr flush dev wlan0
#ip addr add ${IP_ADDRESS}/24 dev wlan0
#ip link set wlan0 up

#ip link set $INTERFACE down

ifdown $INTERFACE
ip addr flush dev $INTERFACE

echo "  address $ADDRESS" >> /etc/network/interfaces
echo "  netmask $NETMASK" >> /etc/network/interfaces
echo "  broadcast $BROADCAST" >> /etc/network/interfaces

ifup $INTERFACE
#ip link set $INTERFACE up


echo "Starting HostAP daemon ..."
killall hostapd; hostapd -d /hostapd.conf & wait ${!}
