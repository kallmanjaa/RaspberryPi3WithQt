#!/bin/bash
set -eux -o pipefail

. utils.sh
. env.sh

rpi_opengl::download_rpi_firmware(){
	pushd "${BUILD_DIR:?}"
		git clone --progress "${RPI_FIRMWARE_SRC:?}"
	popd
}

rpi_opengl::build(){
	utils::log "===============rpi_opengl SUPPORT LIBS install log================"
	rpi_opengl::download_rpi_firmware
}
