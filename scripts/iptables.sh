#!/bin/bash

# This is an example script to set up iptables rules for the wiki-js docker host. 
LAN_NETWORK="192.168.70.0/23"

iptables -F
iptables -X

iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

iptables -A INPUT -p tcp --dport 22 -s $LAN_NETWORK -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -s $LAN_NETWORK -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -s $LAN_NETWORK -j ACCEPT

iptables -A INPUT -p icmp -j ACCEPT