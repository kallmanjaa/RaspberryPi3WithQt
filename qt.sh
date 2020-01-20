#!/bin/bash
set -eux -o pipefail

. utils.sh
. env.sh

qt::get_source_and_validate(){
	utils::log "Download and validate qt source..."
	pushd "${BUILD_DIR}"

	wget "${QT_DOWNLOAD_SRC}"
	readonly checksum=$(md5sum "${BUILD_DIR:?}/${QT_SRC_FILE}"  | cut -d " " -f 1  2>&1) #no sha256 checksum
	if [[ "$checksum" == "${QT_CHECKSUM}" ]]; then
   		echo "Checksum_verified"
	else
   		echo "Checksum_failed for qt_download ...quitting"
   		exit 1
	fi	
	tar -C "${BUILD_DIR}" -xvvf "${QT_SRC_FILE}"
	
	popd

}

qt::compile(){
 	utils::log "Qt start compile"
 	pushd "${QT_SRC_DIR}"
		./configure -opensource -confirm-license -prefix /opt -release -force-debug-info -opengl es2 -device linux-rasp-pi3-g++ -sysroot "${ROOTFS_TARGET_DIR:?}" \
		-device-option CROSS_COMPILE="${CROSS_COMPILE:?}" \
		-no-xcb \
		-no-sql-db2 \
		-no-mtdev \
		-nomake tests \
		-nomake examples \
		-no-sql-mysql \
		-eglfs \
		-qpa eglfs \
		-make tools \
		-qt-pcre \
		-iconv \
		-no-xkb \
		-no-xkbcommon \
		-no-fontconfig \
		-no-kms \
		-system-libpng \
		-no-tslib \
		-no-icu \
		-no-directfb \
		-no-sql-oci \
		-no-sql-sqlite2 \
		-accessibility \
		-widgets \
		-linuxfb \
		-no-libudev \
		-no-sql-psql \
		-make libs \
		-no-openvg \
		-no-sql-tds \
		-dbus \
		-system-zlib \
		-no-pulseaudio \
		-no-sm \
		-no-sql-ibase \
		-no-sql-odbc \
		-release -v
	popd
}

qt::make(){
	pushd "${QT_SRC_DIR}"
		make -j"${CPU_CORES}"
	popd
}

qt::make_install(){
	pushd "${QT_SRC_DIR}"
		make install
	popd

	rsync -r --progress "${ROOTFS_TARGET_DIR:?}/usr/share/fonts" "${ROOTFS_TARGET_DIR:?}/opt/lib/" ##copy fonts directory to /opt : can be done in chroot: not tested
}

qt::cleanup(){
	rm -rf "${BUILD_DIR:?}"/"${QT_SRC_FILE}" || true # clean the downloaded file
	rm -rf "${QT_SRC_DIR}" || true
}

qt::build(){
	utils::log "===============qt install log================"
	qt::get_source_and_validate
	qt::compile
	qt::make
	qt::make_install
	qt::cleanup
}
