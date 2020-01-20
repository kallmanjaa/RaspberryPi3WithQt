#!/bin/bash
set -eux -o pipefail

. utils.sh

host_install_debs::install(){
	declare -a arr=("bison"
			"gperf"
			"qemu-user-static"
			"debootstrap"
			"binfmt-support"
			"gcc-aarch64-linux-gnu"
			"g++-aarch64-linux-gnu"
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
			"lib32stdc++6")

				

	for package in "${arr[@]}" ; do

	    dpkg -s "$package" >/dev/null 2>&1 && {

	        echo "$package is installed."

	    } || {

	        sudo apt-get install -y "$package"

	    }

	done
}

host_install_debs::build(){
	utils::log "Installing dependencies for host ubuntu..."
	host_install_debs::install
}
