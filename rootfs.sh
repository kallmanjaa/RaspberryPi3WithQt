#!/bin/bash
set -eux -o pipefail

. utils.sh
. env.sh

rootfs::extract_ubuntu_base(){
	utils::log "Download ubuntu base source for arm64..."
	mkdir -p -m 777 "${ROOTFS_TARGET_DIR}"
	wget -P "${BUILD_DIR}" "${UBUNTU_SRC_WEBSITE}"
}

rootfs::checksum_verify(){
	readonly checksum=$(sha256sum "${BUILD_DIR:?}/${UBUNTU_BASE_SRC}"  | cut -d " " -f 1  2>&1)
	if [[ "$checksum" == "${UBUNTU_SRC_CHECKSUM}" ]]; then
   		echo "Checksum_verified"
   		return 0
	else
   		echo "Checksum_failed...quitting"
   		return 1
	fi
}

rootfs::prepare_ubuntu_base(){
	utils::log "Extracting ubuntu source base arm64..."
	tar xpf "${BUILD_DIR:?}"/"${UBUNTU_BASE_SRC}" -C "${ROOTFS_TARGET_DIR}"
	cp "${QEMU_AARCH64_STATIC}" "${ROOTFS_TARGET_DIR:?}"/usr/bin/
	cp "${RESOLV_CONF}" "${ROOTFS_TARGET_DIR:?}"/etc
}

rootfs::chrootJail(){
cat << EOF | chroot "${ROOTFS_TARGET_DIR}" /bin/bash
export LANG=C

apt-get clean
(cd /var/lib/apt && mv lists lists.old && mkdir -p lists/partial && apt-get clean && apt-get update -y)

apt-get upgrade -y

apt-get install --no-install-recommends -y openssh-server ntpdate gdb network-manager
apt-get install --no-install-recommends -y libnss3-dev symlinks ninja-build zlib1g-dev libdbus-1-dev libfontconfig1-dev
apt-get install --no-install-recommends -y libdrm-dev libwayland-server0 libxext6 libxdamage-dev

echo 'root:passwd' | chpasswd

cat >> /etc/network/interfaces <<EOL
auto lo  
iface lo inet loopback  
auto eth0  
iface eth0 inet dhcp	
EOL

cat >> /etc/ssh/sshd_config <<EOL
PermitRootLogin yes
EOL

pushd /usr/lib
symlinks -rc .
popd

touch /etc/NetworkManager/conf.d/10-globally-managed-devices.conf
sed -i 's/^managed=false/managed=true/' /etc/NetworkManager/NetworkManager.conf

echo root > /etc/hostname
echo T0:2345:respawn:/sbin/getty -L ttyS0 115200 vt100 >> /etc/inittab

exit
EOF

utils::log "chroot jail exit..."
}

rootfs::cleanUp()
{
	utils::log "clean up for rootfs..."
	rm "${ROOTFS_TARGET_DIR:?}""${RESOLV_CONF}" || true
	rm "${ROOTFS_TARGET_DIR:?}""${QEMU_AARCH64_STATIC}" || true
}

#sequence

rootfs::build(){
	utils::log "===============rootfs install log================"
	rootfs::extract_ubuntu_base
	val=$(rootfs::checksum_verify)
	if [ "$val" == "Checksum_verified" ]
	then
		rootfs::prepare_ubuntu_base
		rootfs::chrootJail
		rootfs::cleanUp
	else
	   echo "Checksum_failed...quitting"
	   exit 1
	fi
}
