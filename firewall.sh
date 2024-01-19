#!/bin/bash

# Remove firewall rules
firewall-cmd --zone=public --remove-service=ssh --permanent
firewall-cmd --zone=public --remove-service=cockpit --permanent
firewall-cmd --zone=public --remove-service=dhcpv6-client --permanent
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=22/tcp --permanent
firewall-cmd --reload

