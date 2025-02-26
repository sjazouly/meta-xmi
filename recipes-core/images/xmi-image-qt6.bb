DESCRIPTION = "Sample image for XMI app"
LICENSE = "MIT"

require dynamic-layers/qt6-layer/recipes-fsl/images/imx-image-full.bb

IMAGE_INSTALL += "\
    qtmultimedia \
"
IMAGE_ROOTFS_EXTRA_SPACE = "640000"

IMAGE_INSTALL:append = "\
    boost \
    boost-dev \
    boost-staticdev \
    cmake \
    curl \
    e2fsprogs-resize2fs \
    g++ \
    gcc \
    git \
    htop \
    i2c-tools \
    make \
    opengl-es-cts \
    opensc \
    openssl \
    openssl-bin \
    packagegroup-core-buildessential \
    packagegroup-qt6-essentials \
    pkgconfig \
    psplash \
    python3-cffi \
    python3-click \
    python3-cryptography \
    python3-matplotlib \
    python3-misc \
    python3-pip \
    python3-pycparser \
    python3-pyserial \
    python3-pyzmq \
    qtmultimedia \
    rng-tools \
    sdc-tests \
    sox \
    subversion \
"
#    packagegroup-qt6-addons


PACKAGECONFIG:append:pn-iptables = " libnftnl"


# rsync is only used during development
IMAGE_INSTALL += "rsync"

IMAGE_INSTALL:remove = "linux-firmware-nxp89xx"
