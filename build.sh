#!/bin/bash
set -eux -o pipefail

cd "$(dirname "$0")"
. utils.sh
. env.sh
. host_install_debs.sh
. rootfs.sh
. kernel.sh
. qt.sh
. sd_card_image.sh




main(){
	cd "$(dirname "$0")"
	start=$(date +%s)

	bash env.sh

	if [ -d "${BUILD_DIR}" ]; then rm -Rf "${BUILD_DIR}"; fi # start always clean build	
	mkdir -p "${BUILD_DIR}"

	mkdir -p "${BOOTFS_DIR:?}"
	utils::log::setup

	host_install_debs::build
	rootfs::build
	kernel::build
	#qt::build
	image::build 

	end=$(date +%s)
	#sh ./cleanup
	echo "BUILD TIME in minutes: $((end/60-start/60))"
}

# shellcheck disable=SC2128
[[ "$0" == "$BASH_SOURCE" ]] && main "$@"
