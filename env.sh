#!/bin/bash
set -eux -o pipefail

export CURRENT_DIR=${PWD}
export BUILD_DIR=${CURRENT_DIR}/build
export SOURCES=${CURRENT_DIR}/sources

##cross toolchain
export CROSS_TOOLCHAIN_SRC=https://github.com/raspberrypi/tools.git

## rpi firmware src
export RPI_FIRMWARE_SRC=https://github.com/raspberrypi/firmware.git

##cross_compile
export CROSS_COMPILE="${BUILD_DIR}/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin/arm-linux-gnueabihf-"
export ARCH="arm"
CPU_CORES="$(nproc)" || true
export CPU_CORES

##bootfs dir
export BOOTFS_DIR=${BUILD_DIR}/bootfs

## rootfs
export ROOTFS_TARGET_DIR=${CURRENT_DIR}/build/rootfs
export UBUNTU_BASE_SRC=ubuntu-base-18.04-base-armhf.tar.gz
export UBUNTU_SRC_WEBSITE=http://cdimage.ubuntu.com/ubuntu-base/releases/18.04.3/release/${UBUNTU_BASE_SRC}
export UBUNTU_SRC_CHECKSUM="dd52bbd8ecd1398ee61042db9dabad585b39c90988343767be4877db8945d44a"

## for qemu and resolvconf
export QEMU_AARCH64_STATIC=/usr/bin/qemu-arm-static
export RESOLV_CONF=/etc/resolv.conf

##kernel
export KERNEL_CONFIG=bcm2709_defconfig # for rpi3 , change with your version of rpi
export DTB_FILE=bcm2710-rpi-3-b.dtb # for rpi3 , change with your version of rpi
export BOOT_START_ELF=https://github.com/raspberrypi/firmware/raw/master/boot/start.elf
export BOOT_BOOTCODE_BIN=https://github.com/raspberrypi/firmware/raw/master/boot/bootcode.bin
export BOOT_FIXUP=https://github.com/raspberrypi/firmware/raw/master/boot/fixup.dat
export KERNEL_DIR=${BUILD_DIR}/kernel_build
export KERNEL_SRC=https://github.com/raspberrypi/linux.git
export KERNEL_BRANCH=rpi-5.5.y

##image genration
export IMAGEFILE=rpi3.img
export IMAGE_SIZE=+15G

##qt
export QT_VERSION=qt-everywhere-src-5.13.2
export QT_SRC_FILE=qt-everywhere-src-5.13.2.tar.xz
export QT_DOWNLOAD_SRC=https://download.qt.io/archive/qt/5.13/5.13.2/single/${QT_SRC_FILE}
export QT_SRC_DIR=${BUILD_DIR}/${QT_VERSION}
export QT_CHECKSUM="7c04c678d4ecd9e9c06747e7c17e0bb9" 
