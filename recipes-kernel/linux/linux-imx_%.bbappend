FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
    file://add-drivers-for-rpi-7in-display.patch \
    file://defconfig \
    file://0001-Add-NXP-UWM-drivers-for-the-SR1xx-UWB-radio-in-the-M.patch \
    file://xmi-imx8mp.dts \
    file://xmi-imx8mp-imx219.dts \
    file://xmi-imx8mp-ar0144.dts \
    file://Makefile \
    file://0001-remove-message-warning-about-hblank-data.patch \
    file://0001-tty-serial-add-Exar-XRM1280-support.patch \
"

# Override meta-imx's KBUILD_DEFCONFIG,
# thus ensuring "file://defconfig" is used
unset KBUILD_DEFCONFIG

do_override_files () {
    # custom defconfig
    install -Dm 0644 ${WORKDIR}/defconfig ${S}/arch/arm64/configs/imx_v8_defconfig

    # device-tree customizations
    install -Dm 0644 ${WORKDIR}/xmi-imx8mp.dts ${S}/arch/arm64/boot/dts/freescale/xmi-imx8mp.dts
    install -Dm 0644 ${WORKDIR}/xmi-imx8mp-imx219.dts ${S}/arch/arm64/boot/dts/freescale/xmi-imx8mp-imx219.dts
    install -Dm 0644 ${WORKDIR}/xmi-imx8mp-ar0144.dts ${S}/arch/arm64/boot/dts/freescale/xmi-imx8mp-ar0144.dts
    install -Dm 0644 ${WORKDIR}/Makefile ${S}/arch/arm64/boot/dts/freescale/Makefile
}
addtask override_files after do_kernel_configme before do_configure

deltask kernel_localversion
deltask merge_delta_config
