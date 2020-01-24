#!/bin/bash
set -eux -o pipefail

. utils.sh
. env.sh 

image::create_device(){
	mknod -m 0660 "${LOOP_DEVICE:?}" b 7 99
}

image::create_virtual_disk_image(){
	truncate -s "${IMAGE_SIZE:?}" "${BUILD_DIR:?}"/"${IMAGEFILE:?}" #faster way
}

#partition
image::create_partition(){
	parted -s "${BUILD_DIR:?}/${IMAGEFILE:?}" mklabel msdos
	parted -s "${BUILD_DIR:?}/${IMAGEFILE:?}" unit s mkpart primary fat32 16384 147455 
	parted -s "${BUILD_DIR:?}/${IMAGEFILE:?}" unit s mkpart primary ext4 147456s 99% -a opt
	parted "${BUILD_DIR:?}/${IMAGEFILE:?}" print
} 


#mount
image::create_image(){
	losetup -P "${LOOP_DEVICE:?}" "${BUILD_DIR:?}/${IMAGEFILE:?}"

	mkfs -t vfat "${LOOP_DEVICE:?}p1"
	mkfs.ext4 "${LOOP_DEVICE:?}p2"

	mkdir -p "${BUILD_DIR:?}/boot_part"
	mkdir -p "${BUILD_DIR:?}/rootfs_part"

	mount "${LOOP_DEVICE:?}p1" "${BUILD_DIR:?}/boot_part"
	mount "${LOOP_DEVICE:?}p2" "${BUILD_DIR:?}/rootfs_part"

	rsync -av --progress "${BUILD_DIR:?}"/bootfs/* "${BUILD_DIR:?}/boot_part"
	rsync -av --progress "${BUILD_DIR:?}"/rootfs/* "${BUILD_DIR:?}/rootfs_part"
 
}


image::clean_up(){
	umount "${BUILD_DIR:?}/boot_part" || true
	umount "${BUILD_DIR:?}/rootfs_part" || true
	losetup -d "${LOOP_DEVICE:?}"
	rm -r "${LOOP_DEVICE:?}"
	rm -r "${BUILD_DIR:?}/boot_part" || true
	rm -r "${BUILD_DIR:?}/rootfs_part" || true
}

#sequence
image::build(){
	utils::log "===============image generation started================"
	image::create_device
	image::create_virtual_disk_image
	image::create_partition
	image::create_image
	image::clean_up
	utils::log "=============== Image generation completed ================"
}
