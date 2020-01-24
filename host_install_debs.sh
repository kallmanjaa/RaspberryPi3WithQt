#!/bin/bash
set -eux -o pipefail

. utils.sh

host_install_debs::install(){
	declare -a arr=("bison"
			"gperf"
			"qemu-user-static"
			"debootstrap"
			"binfmt-support"
			"gcc-multilib"
			"g++-multilib"
			"g++-arm-linux-gnueabihf"
			"gcc-arm-linux-gnueabihf"
			"linux-libc-dev:i386"
			"libncurses5-dev"
			"libncursesw5-dev"
			"device-tree-compiler"
			"zlib1g-dev"
			"python-minimal"
			"libnss3"
			"libnss3-dev"
			"bison"
			"flex"
			"libdbus-1-dev"
			"pkg-config"
			"git"
			"bc"
			"build-essential"
			"libpng-dev"
			"make"
			"git"
			"cmake"
			"libssl-dev"
			"lib32z1" 
			"lib32ncurses5"
			"lib32stdc++6"
			"rsync"
			"parted"
			"udev"
			"kmod"
			"subversion"
			"dosfstools")

				

	for package in "${arr[@]}" ; do

	    dpkg -s "$package" >/dev/null 2>&1 && {

	        echo "$package is installed."

	    } || {

	        apt-get install -y "$package"

	    }

	done
}

host_install_debs::build(){
	host_install_debs::install
}
