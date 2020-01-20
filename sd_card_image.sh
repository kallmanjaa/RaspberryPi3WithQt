#!/bin/bash
set -eux -o pipefail

. utils.sh
. env.sh 

image::create_virtual_disk_image(){
	utils::log "create virtual disk..."
	truncate -s "${IMAGE_SIZE}" "${BUILD_DIR}"/"${IMAGEFILE}" #faster way
}

#partition
image::create_partition(){
	utils::log "make partition ..."
	parted -s "${BUILD_DIR}"/"${IMAGEFILE}" mklabel msdos
	parted -s "${BUILD_DIR}"/"${IMAGEFILE}" unit s mkpart primary fat32 16384 147455 
	parted -s "${BUILD_DIR}"/"${IMAGEFILE}" unit s mkpart primary ext4 147456s 99% -a opt
	parted "${BUILD_DIR}"/"${IMAGEFILE}" print
} 


#mount
image::create_image(){
	utils::log "create final image..."
	losetup -fP "${BUILD_DIR}"/"${IMAGEFILE}"

	device=$(losetup -j "${BUILD_DIR}"/"${IMAGEFILE}" | grep -o "/dev/loop[0-9]*")

	mkfs -t vfat "${device}p1"
	mkfs.ext4 "${device}p2"

	mkdir -p "${BUILD_DIR}"/boot_part
	mkdir -p "${BUILD_DIR}"/rootfs_part

	mount "${device}p1" "${BUILD_DIR}"/boot_part
	mount "${device}p2" "${BUILD_DIR}"/rootfs_part

	rsync -av --progress "${BUILD_DIR}"/bootfs/* "${BUILD_DIR}"/boot_part
	rsync -av --progress "${BUILD_DIR}"/rootfs/* "${BUILD_DIR}"/rootfs_part
 
}


image::clean_up(){
	utils::log "release and cleanup all mounted devices..."

	umount "${BUILD_DIR}"/boot_part || true
	umount "${BUILD_DIR}"/rootfs_part || true
	losetup -d "$device"
	rm -r "${BUILD_DIR:?}"/boot_part || true
	rm -r "${BUILD_DIR:?}"/rootfs_part || true
}

#sequence
image::build(){
	utils::log "===============image generate log================"
	image::create_virtual_disk_image
	image::create_partition
	image::create_image
	image::clean_up
}
