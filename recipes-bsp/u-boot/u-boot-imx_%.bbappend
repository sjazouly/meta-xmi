FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "\
    file://ddr4_timing.c \
    file://imx8mp_ddr4_evk_defconfig \
    file://imx8mp_evk.c \
    file://imx8mp_evk.h \
    file://imx8mp-evk.dts \
    file://spl.c \
    file://imx8mp-evk-u-boot.dtsi \
    file://xmi-imx8mp.dts \
    file://Makefile \
    file://xmi-imx8mp-u-boot.dtsi \
"

do_override_sources () {
    install -Dm 0644 ${WORKDIR}/ddr4_timing.c ${S}/board/freescale/imx8mp_evk/ddr4_timing.c
    install -Dm 0644 ${WORKDIR}/imx8mp_ddr4_evk_defconfig ${S}/configs/imx8mp_ddr4_evk_defconfig
    install -Dm 0644 ${WORKDIR}/imx8mp_evk.c ${S}/board/freescale/imx8mp_evk/imx8mp_evk.c
    install -Dm 0644 ${WORKDIR}/imx8mp_evk.h ${S}/include/configs/imx8mp_evk.h
    install -Dm 0644 ${WORKDIR}/imx8mp-evk.dts ${S}/arch/arm/dts/imx8mp-evk.dts
    install -Dm 0644 ${WORKDIR}/xmi-imx8mp.dts ${S}/arch/arm/dts/xmi-imx8mp.dts
    install -Dm 0644 ${WORKDIR}/Makefile ${S}/arch/arm/dts/Makefile
    install -Dm 0644 ${WORKDIR}/imx8mp-evk-u-boot.dtsi ${S}/arch/arm/dts/imx8mp-evk-u-boot.dtsi
    install -Dm 0644 ${WORKDIR}/xmi-imx8mp-u-boot.dtsi ${S}/arch/arm/dts/xmi-imx8mp-u-boot.dtsi
    install -Dm 0644 ${WORKDIR}/spl.c ${S}/board/freescale/imx8mp_evk/spl.c
}
addtask override_sources after do_patch before do_configure
