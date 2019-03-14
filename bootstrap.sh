#!/bin/bash

echo "Starting bootsrraper ..."
iw dev $WLAN_INT interface add $HOTSPOT_INT type managed
ip link set dev $HOTSPOT_INT down
macchanger -e $HOTSPOT_INT
ip addr flush dev $HOTSPOT_INT
ip link set $HOTSPOT_INT up

sysctl net.ipv4.ip_forward=1
sysctl net.ipv4.ip_dynaddr=1

sed -i -s "s/^interface=.*/interface=$HOTSPOT_INT/" /etc/hostapd.conf
sed -i -s "s/^channel=.*/channel=$CHANNEL/" /etc/hostapd.conf
sed -i -s "s/^ssid=.*/ssid=$SSID/" /etc/hostapd.conf

# Capture external docker signals
trap 'true' SIGINT
trap 'true' SIGTERM
trap 'true' SIGHUP

echo "Starting HostAP daemon ..."
exec hostapd /etc/hostapd.conf
