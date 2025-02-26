#!/bin/sh

# MAMABEAR_BLE_MAC is an env. variable

# The same, with _s instead of :
export MAMABEAR_BLE_MAC_US=$(echo $MAMABEAR_BLE_MAC | sed -e 's/:/_/g')

##   #!/usr/bin/expect -f
#
# Interact with bluetoothctl to connect to the BabyBear BLE device and enable
# notifications.
# This script is intended to be run in the background and output to stdout. The
# output is then parsed by the ble-publisher.sh script.

expect -c '
set timeout -1

set device $env(MAMABEAR_BLE_MAC)
set device_us $env(MAMABEAR_BLE_MAC_US)

spawn bluetoothctl
expect "Agent registered"

while { 1 } {
	send -- "disconnect $device\r"
	expect {
		"Successful disconnected" { }
		"not available" { }
	}

	send -- "scan on\r"
	expect $device
	
        send -- "scan off\r"
	expect "Discovering"

	send -- "connect $device\r"
	expect {
		"Connection successful" {

			send -- "menu gatt\r"
			expect "Print environment variables"

			send -- "select-attribute /org/bluez/hci0/dev_$device_us/service002f/char0030\r"
			expect "char0030"
			send -- "notify on\r"
			expect {
				"Notify started" {
					expect "Device $device Connected: no"
					send -- "back\r"
				}

				"No attribute selected" {
					send -- "select-attribute /org/bluez/hci0/dev_$device_us/service002f/char0030\r"
					expect "char0030"
					send -- "notify on\r"
					exp_continue
				}
			}
		}

		"not available" { }
		"Failed to connect" { }
	}
}
expect eof
'
