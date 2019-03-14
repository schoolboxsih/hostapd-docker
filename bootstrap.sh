#!/bin/bash

echo "Starting bootsrraper ..."
iw dev $WLAN_INT interface add $HOTSPOT_INT type managed
ip link set dev $HOTSPOT_INT down
macchanger -e $HOTSPOT_INT
ip addr flush dev $HOTSPOT_INT
ip link set $HOTSPOT_INT up

sysctl net.ipv4.ip_forward=1
sysctl net.ipv4.ip_dynaddr=1

echo "Setting iptables for outgoing traffics on all interfaces..."

# Capture external docker signals
#trap 'true' SIGINT
#trap 'true' SIGTERM
#trap 'true' SIGHUP

echo "Starting HostAP daemon ..."

hostapd /etc/hostapd.conf
