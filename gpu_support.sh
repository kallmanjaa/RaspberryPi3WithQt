#!/bin/bash
set -eux -o pipefail

. utils.sh
. env.sh

gpu::download_rpi_firmware(){
	pushd "${BUILD_DIR:?}"
		git clone --progress "${RPI_FIRMWARE_SRC:?}"
	popd
}

gpu::copy_sources_to_rootfs(){
	utils::log "copy gpu libs to rootfs..."
	rsync -av --recursive --progress "${BUILD_DIR:?}/firmware/opt/vc" "${ROOTFS_TARGET_DIR:?}/opt"
}

gpu::build(){
	utils::log "===============gpu SUPPORT LIBS install log================"
	gpu::download_rpi_firmware
	gpu::copy_sources_to_rootfs
}
