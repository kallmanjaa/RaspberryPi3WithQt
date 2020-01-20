#!/bin/bash
set -eux -o pipefail

. utils.sh

cross_toolchain::download(){
	pushd "${BUILD_DIR:?}"
		git clone --progress "${CROSS_TOOLCHAIN_SRC:?}"
	popd
}

cross_toolchain::build(){
	utils::log "===============cross toolchain install log================"
	cross_toolchain::download
}
