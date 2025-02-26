#!/bin/sh
#
# Load the BT driver and setup BT services

modprobe moal mod_para=nxp/wifi_mod_para.conf

systemctl start bluetooth.service

if ! hciconfig | grep -q hci0; then
	modprobe btnxpuart
	sleep 3
	hciconfig hci0 up
fi
