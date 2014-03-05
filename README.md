raspaudio
============

Small project to use buildroot and Raspberry pi to send audio from a pulseaudio source to a HiFi system

please refer to [The main website](http://openwide-ingenierie.github.io/raspaudio/) for information


TODO List
---------

* Since the whole image is readonly, use a single partition and an initrd
* Alternatively use buildroot's genimage infrastructure if/when it's integrated
* Proper handling of linux-menuconfig and the other kconfig based tools
* look into WiFi support
* change network configuration via config options
* streamline/generalize the creation of new projects
