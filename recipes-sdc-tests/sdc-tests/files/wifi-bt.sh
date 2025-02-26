#!/bin/sh

# set -x

# pulseaudio &
systemctl start bluetooth.service

if ! lsmod | grep -q moal; then                                                                                                                                                                     
        modprobe moal mod_para=nxp/wifi_mod_para.conf                                                                                                                                                                                 
fi 

wpa_supplicant -d -B -i mlan0 -c /etc/wpa_supplicant.conf 

sleep 10

udhcpc -i mlan0 -t 10 -n -A 3

if ! hciconfig | grep -q hci0; then  
	modprobe btnxpuart
	sleep 3
	hciconfig hci0 up
fi

#fix symbolic link to DNS server settings
rm /etc/resolv.conf
ln /etc/resolv-conf.systemd /etc/resolv.conf


