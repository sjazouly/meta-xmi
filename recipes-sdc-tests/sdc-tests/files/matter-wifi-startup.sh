
service otbr_fwcfg start
sleep 5
otbr-agent -I wpan0 -B mlan0 'spinel+spi:///dev/spidev2.0?gpio-reset-device=/dev/gpiochip4&gpio-int-device=/dev/gpiochip2&gpio-int-line=7&gpio-reset-line=00&spi-mode=0&spi-speed=1000000&spi-reset-delay=0' &

sleep 5
iptables -A FORWARD -i mlan0 -o wpan0 -j ACCEPT
iptables -A FORWARD -i wpan0 -o mlan0 -j ACCEPT
otbr-web &

ot-ctl dataset init new
ot-ctl dataset activetimestamp 1
ot-ctl dataset channel 15
ot-ctl dataset channelmask 0x07fff800
ot-ctl dataset extpanid 1111111122222222
ot-ctl dataset meshlocalprefix fde2:498c:88c6:1b27::/64
ot-ctl dataset networkkey 00112233445566778899aabbccddeeff
ot-ctl dataset networkname OpenThreadDemo
ot-ctl dataset panid 0x1234
ot-ctl dataset pskc 445f2b5ca6f2a93a55ce570a70efeecb
ot-ctl dataset securitypolicy 672 onrc
ot-ctl dataset commit active
ot-ctl ifconfig up
ot-ctl thread start
ot-ctl dataset

