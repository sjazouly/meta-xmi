##!/bin/bash

PASS=0

function evaluatetest {
	local RESULT
	read -p "$1 (y/n) " RESULT
	if [ "${RESULT,,}" == "y" ]
	then
		((PASS++))
		echo "######################################"
		printf "# Number of tests passed so far %-2d   #\n" $PASS
		echo "######################################"
	fi
}


echo "#######################################"
echo "# Testing Analog to Digical Converter #"
echo "#######################################"
ADCDIR=$(find /sys/devices/platform -name iio:device*)
# usually /sys/devices/platform/soc@0/30800000.bus/30800000.spba-bus/30820000.spi/spi_master/spi1/spi1.1/iio:device0
# but sometimes slightly different
cat $ADCDIR/in_voltage*_raw
evaluatetest "Were the numbers printed correct?"



echo "######################################"
echo "# Testing Microphone - Say Something #"
echo "#      Press Enter To Continue       #"
echo "######################################"
read

# this shouldn't be bodged in test, but properly fixed
# mv /etc/asound.conf /etc/asound.conf.bak

# should sometimes be hw:1,0
# I'm not sure how to fix that
arecord -D hw:2,0 -f S32_LE -d 5 out.wav

echo "###################################"
echo "# Playing Back the Recorded Audio #"
echo "###################################"
aplay out.wav
evaluatetest "Did you hear the recorded audio playing back?"



echo "##########################################"
echo "# Testing Speaker - Playing Sample Audio #"
echo "#        Press Enter To Continue         #"
echo "##########################################"
read
aplay -d 4 /etc/sdc/Moldova.wav
evaluatetest "Did the Speaker test pass?"



# read -p "Please enter the WiFi SSID: " SSID
read -p "please enter the WiFi Password for FE-IoT: " PASSWORD

SSID="wifi_24cd8d911496_46452d494f54_managed_psk"

echo "########################################"
echo "# Testing WiFi - Connecting to Network #"
echo "# SSID=$SSID Password=$PASSWORD    #"
echo "#       Press Enter To Continue        #"
echo "########################################"
read

modprobe moal mod_para=nxp/wifi_mod_para.conf

expect -c '
	spawn connmanctl
	expect "connmanctl> "
	send "agent on\r"
	expect "connmanctl> "
	send "enable wifi\r"
	expect "connmanctl> "
	send "services\r"
	expect "connmanctl> "
	send "connect '$SSID'\r"
	expect "Passphrase? "
	send "'$PASSWORD'\r"
	send "quit\r"
'
echo $PASSWORD | connmanctl connect $SSID

evaluatetest "Did the WiFi test pass?"



echo "#####################"
echo "# Testing Bluetooth #"
echo "#####################"

systemctl start bluetooth.service
modprobe btnxpuart
hciconfig hci0 up
expect -c '
	spawn bluetoothctl
	expect "\[bluetooth\]# "
	send "agent on\r"
	expect "\[bluetooth\]# "
	send "scan on\r"
	expect "\[bluetooth\]# "
	send "quit"
'
echo
evaluatetest "Did the Bluetooth test pass?"



echo "################"
echo "# Testing LEDs #"
echo "################"

echo 255 > /sys/class/leds/pca963x\:red/brightness
echo 255 > /sys/class/leds/pca963x\:green/brightness
echo 255 > /sys/class/leds/pca963x\:blue/brightness
sleep 1
echo 0 > /sys/class/leds/pca963x\:red/brightness
sleep 1
echo 255 > /sys/class/leds/pca963x\:red/brightness
echo 0 > /sys/class/leds/pca963x\:green/brightness
sleep 1
echo 0 > /sys/class/leds/pca963x\:red/brightness
sleep 1
echo 255 > /sys/class/leds/pca963x\:red/brightness
echo 255 > /sys/class/leds/pca963x\:green/brightness
echo 0 > /sys/class/leds/pca963x\:blue/brightness
sleep 1
echo 0 > /sys/class/leds/pca963x\:red/brightness
sleep 1
echo 255 > /sys/class/leds/pca963x\:red/brightness
echo 0 > /sys/class/leds/pca963x\:green/brightness
sleep 1
echo 0 > /sys/class/leds/pca963x\:red/brightness
sleep 1

evaluatetest "Did the LED test pass?"

