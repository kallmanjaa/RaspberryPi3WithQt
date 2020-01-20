#!/bin/bash
set -eux -o pipefail

. utils.sh
. env.sh 

kernel::clone_source(){
	utils::log "cloning kernel source..."
	mkdir -p "${KERNEL_DIR:?}"
	pushd "${KERNEL_DIR:?}"
		git clone --progress "${KERNEL_SRC}" -b "${KERNEL_BRANCH}" 
	popd

}

kernel::kernel_build(){
	utils::log "kernel building..."
	make -j"${CPU_CORES}" -C "${KERNEL_DIR:?}/linux" clean
	make -j"${CPU_CORES}" -C "${KERNEL_DIR:?}/linux" "${KERNEL_CONFIG:?}"
	make -j"${CPU_CORES}" -C "${KERNEL_DIR:?}/linux" zImage modules dtbs
}


kernel::install_modules(){
	utils::log "install modules to rootfs..."
	make -j"${CPU_CORES}" -C "${KERNEL_DIR:?}/linux" modules_install INSTALL_MOD_PATH="${ROOTFS_TARGET_DIR:?}"
	make -j"${CPU_CORES}" -C "${KERNEL_DIR:?}/linux" headers_install INSTALL_HDR_PATH="${ROOTFS_TARGET_DIR:?}"
}

kernel::prepare_bootfs(){
	mkdir -p "${BOOTFS_DIR:?}"
	pushd "${BOOTFS_DIR:?}"
		rsync -av --progress "${KERNEL_DIR:?}/linux/arch/arm/boot/zImage" "${BOOTFS_DIR:?}/kernel.img"
		rsync -av --progress "${KERNEL_DIR:?}/linux/arch/arm/boot/dts/${DTB_FILE:?}" "${BOOTFS_DIR:?}"
		rsync -av --relative --progress "${KERNEL_DIR:?}"/linux/arch/arm/boot/dts/./overlays/*.dtb* "${BOOTFS_DIR:?}"
		rsync -av --relative --progress "${KERNEL_DIR:?}"/linux/arch/arm/boot/dts/./overlays/README "${BOOTFS_DIR:?}"
		wget "${BOOT_START_ELF:?}"
		wget "${BOOT_BOOTCODE_BIN:?}"
		wget "${BOOT_FIXUP:?}"
		cat >> cmdline.txt <<-EOL
			dwc_otg.lpm_enable=0 console=ttyAMA0,115200 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 elevator=deadline fsck.repair=yes rootwait rw
		EOL
		cat >> config.txt <<-EOL
			enable_uart=1
			##arm_64bit=1
			device_tree=bcm2710-rpi-3-b.dtb
			kernel=kernel.img
			dtparam=i2c_arm=on
			dtparam=spi=on
			dtparam=audio=on
			gpu_mem=128
		EOL
	popd
}

#sequence
kernel::build(){
	utils::log "===============kernel install log================"
	kernel::clone_source
	kernel::kernel_build
	kernel::install_modules
	kernel::prepare_bootfs
}
