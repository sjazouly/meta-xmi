do_install:append() {
    # pass -E to bluetoothd (enables experimental features)
    sed -i -e 's!^\(ExecStart=.*/bluetoothd\)!\1 -E!' ${D}${systemd_system_unitdir}/bluetooth.service
}
