# RaspberryPi3WithQt
Rpi3 with kernel_build and ubuntu 18.04 rootfs with qt_build for eglfs [no wayland or X11]

# Raspberry Pi3 with Qt 5.13
### Host
    ubuntu 18.04 [osboxes.org virtual machine]
### Usage: 
    sudo ./build.sh
### sdcard Image
    After the build rpi3.img is generated in build directory
### Flash sdcard
    use tools like rufus or other to flash the image rpi3.img to sdcard
    Note : make sure to use 16gb sdcard 

### versions used:
    kernel: 5.5.y
    qt: qt-5.13.2
    rootfs: ubuntu 18.04 [armhf]
