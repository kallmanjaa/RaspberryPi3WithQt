#!/bin/bash
set -eux -o pipefail

. utils.sh
. env.sh
. dependency_host.sh
. cross_toolchain.sh
. rootfs.sh
. rpi_opengl.sh
. kernel.sh
. qt.sh
. image_generate.sh




main(){
	cd "$(dirname "$0")"
	start=$(date +%s)

	bash env.sh

	if [ -d "${BUILD_DIR}" ]; then rm -Rf "${BUILD_DIR}"; fi # start always clean build	
	mkdir -p "${BUILD_DIR}"

	utils::log::setup

	dependency::build
	cross_toolchain::build
	rootfs::build
	rpi_opengl::build
	kernel::build
	qt::build
	image::build 

	end=$(date +%s)
	#sh ./cleanup
	echo "BUILD TIME in minutes: $((end/60-start/60))"
}

# shellcheck disable=SC2128
[[ "$0" == "$BASH_SOURCE" ]] && main "$@"
