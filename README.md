raspaudio
============

Small project to use buildroot and Raspberry pi to send audio from a pulseaudio source to a HiFi system


Compiling
---------

	$ git clone <repository>
	$ cd raspaudio
	$ git submodule init
	$ git submodule update
	$ make

At this point, you should have images ready to install on your raspberrypi in the output/images/ subdirectory

details on how to install on the raspberry-pi are available in the file buildroot/board/raspberrypi/readme


Enabling streaming on the PC
----------------------------

Once your raspberrypi is pluged on the back of your HiFi you need to have your PC stream to it.

Use the paprefs program from pulseaudio to enable detection of network sound devices

Use pavucontrol to use the newly detected devices.

Sound should be streamed from your PC to your raspberrypi

Note that there might be some time delay between the two. We have observed that these delays tend to disapear over time.


Adapting raspaudio to your need
-------------------------------

Raspaudio is based on the the [buildroot](http://buildroot.org) project. You can simply type

	make menuconfig

In the repository to adapt raspaudio to you own needs. There is only one raspaudio specific configuration option
in the *User-Defined* section. It allows you to set a whitelist of IP adresses that are allowed to stream to the
device. If that option is not set anybody can stream to the device

Technical details
-----------------

The aim of this project is both to have an easy way to stream audio from the PC to the living-room and 
to have a clean buildroot project. This section will provide more details on this configuration


Package details
---------------

raspaudio is based on buildroot's raspberrypi_defconfig with the following differences

* enable ALSA : needed for audio
* enable Pulseaudio : receive pulseaudio streams
* enable Avahi : advertise service on the network
* enable ntpdate : update clock on startup
* enable openssh : to have a ssh server on the target
* modify busybox : enable dhcp retry if server doesn't respond
* overlay network configuration : enable eth0, use dhcp for configuration
* post build script : add the public key of the build machine to the authorized keys of root for convienience
* post build script : generate the whitelist in pulseaudio's configuration files


Buildroot configuration
-----------------------

The buildroot installation has been customized to allow all configuration files to be moved out of the buildroot subdirectory 

* changed dl dir to dl/ (out of the buildroot subdirectory)
* changed busybox default config file to busybox-config
* added a makefile in the project's root directory to be able to build from there
* set buildroot's output directory to output/ (out of the buildroot subdirectory)
* set buildroot's BR2_EXTERNAL to the root of the project (out of the buildroot subdirectory)
* added a raspaudio specific configuration option in Config.mk
* The makefile will backup any change to the .config file to raspaudio_defconfig immediately

TODO List
---------

* Since the whole image is readonly, use a single partition and an initrd
* Alternatively use buildroot's genimage infrastructure if/when it's integrated
* Proper handling of linux-menuconfig and the other kconfig based tools

