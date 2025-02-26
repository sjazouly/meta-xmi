#!/bin/sh
#
# This script spawns UWB module's demo_ranging_controlee app, and publishes the
# reported distance information to MQTT.

# Ensure the driver is loaded
modprobe sr1xx

export LD_LIBRARY_PATH="/usr/local/uwbiot/uwb_api:/usr/local/lib"

# Publish distance from stdout's 5th column
stdbuf -oL /root/bin/demo_ranging_controlee 2>/dev/null |
    awk '
/distance/ {
    system("mosquitto_pub -t sensors/sr040-distance -m " $5);
}'
