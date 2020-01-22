#!/bin/bash
set -eux -o pipefail

. utils.sh
. env.sh

rpi_opengl::download_rpi_firmware(){
	pushd "${BUILD_DIR:?}"
		git clone --progress "${RPI_FIRMWARE_SRC:?}"
	popd
}

rpi_opengl::copy_sources_to_rootfs(){
	utils::log "copy gpu libs to rootfs..."
	rsync -av --recursive --progress "${BUILD_DIR:?}/firmware/hardfp/opt/vc" "${ROOTFS_TARGET_DIR:?}/opt"
}

rpi_opengl::build(){
	utils::log "===============rpi_opengl SUPPORT LIBS install log================"
	rpi_opengl::download_rpi_firmware
	rpi_opengl::copy_sources_to_rootfs
}
