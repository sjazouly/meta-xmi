do_install:append() {
    # The 'kiosk' shell provides a full-screen app experience
    sed -i -e '/\[core\]/a #shell=kiosk-shell.so' ${D}${sysconfdir}/xdg/weston/weston.ini
    printf "\n[launcher]\nicon=/opt/gopoint-apps/icon/icon_demo_launcher.png\npath=/usr/bin/demoexperience\n\n[launcher]\nicon=/usr/share/weston/terminal.png\npath=/usr/bin/weston-terminal" >> ${D}${sysconfdir}/xdg/weston/weston.ini
    printf "\nHOME=/home/root/\nQT_QPA_PLATFORM=wayland" >> ${D}${sysconfdir}/default/weston
}
