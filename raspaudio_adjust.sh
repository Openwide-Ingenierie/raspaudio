#!/bin/sh
# We can't simply source ${BUILDROOT_CONFIG} as it may contains constructs
# such as:
#    BR2_DEFCONFIG="$(CONFIG_DIR)/defconfig"
# which when sourced from a shell script will eventually try to execute
# a command name 'CONFIG_DIR', which is plain wrong for virtually every
# systems out there.
# So, we have to scan that file instead. Sigh... :-(
BR2_RASPAUDIO_PAACCESS="$( sed -r -e '/^BR2_RASPAUDIO_PAACCESS="(.*)"$/!d;'    \
                         -e 's//\1/;'                                           \
                         "${BR2_CONFIG}"                                  \
                )"
#remove previously added section
sed -i '/^\#\#\# Added/,$d' $TARGET_DIR/etc/pulse/system.pa

#re-add our customisationd
cat >> $TARGET_DIR/etc/pulse/system.pa <<END_PA
### Added for local use
load-module module-zeroconf-publish
END_PA

if [ -z $BR2_RASPAUDIO_PAACCESS ] ; then
	echo "load-module module-native-protocol-tcp auth-anonymous=1" >> $TARGET_DIR/etc/pulse/system.pa
else
	echo "load-module module-native-protocol-tcp auth-ip-acl=$BR2_RASPAUDIO_PAACCESS" >> $TARGET_DIR/etc/pulse/system.pa
fi

