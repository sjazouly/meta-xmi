FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://mosquitto.mamabear.conf"

PACKAGECONFIG:remove = "ssl dlt websockets"
PACKAGECONFIG:append = " systemd"

do_install:append() {
    install -Dm 0644 ${WORKDIR}/mosquitto.mamabear.conf ${D}${sysconfdir}/mosquitto/mosquitto.conf
}
