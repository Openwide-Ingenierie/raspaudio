#!/bin/sh

#extract  our parameters from the list of available devices
for PARAM in \
	BR2_USER_NETWORK_LO_ENABLE \
	BR2_USER_NETWORK_LO_AUTO \
	\
	BR2_USER_NETWORK_1_ENABLE \
	BR2_USER_NETWORK_1_AUTO \
	BR2_USER_NETWORK_1_IPV4_DHCP \
	BR2_USER_NETWORK_1_IPV4_MANUAL \
	; do 
TMP=$(sed -r -e "/^$PARAM=(.*)$/!d;" -e 's//\1/;' $BR2_CONFIG)
	export $PARAM=$TMP
	#echo $PARAM=$TMP
done

for PARAM in \
	BR2_USER_NETWORK_1_NAME \
	BR2_USER_NETWORK_1_IPV4_ADDRESS \
	BR2_USER_NETWORK_1_IPV4_NETMASK \
	BR2_USER_NETWORK_1_IPV4_BROADCAST \
	BR2_USER_NETWORK_1_IPV4_GATEWAY \
	; do 
TMP=$(sed -r -e "/^$PARAM=\"(.*)\"$/!d;" -e 's//\1/;' $BR2_CONFIG)
	export $PARAM=$TMP
	#echo $PARAM=\'$TMP\'
done



IFACE_FILE=$1/etc/network/interfaces
echo -n > $IFACE_FILE # empty the file

if [ $BR2_USER_NETWORK_LO_ENABLE ] ; then
	if [ $BR2_USER_NETWORK_LO_AUTO ] ; then
		echo "auto lo">> $IFACE_FILE
	fi
	echo "iface lo inet loopback">> $IFACE_FILE
	echo >>$IFACE_FILE
fi

if [ $BR2_USER_NETWORK_1_ENABLE ] ; then
	if [ -z $BR2_USER_NETWORK_1_NAME ] ; then
		echo ERROR no name specified for first network interface
		exit 1
	fi
	if [ $BR2_USER_NETWORK_1_AUTO ] ; then
		echo "auto  $BR2_USER_NETWORK_1_NAME">> $IFACE_FILE
	fi
	if [ $BR2_USER_NETWORK_1_IPV4_DHCP ] ; then
		echo "iface $BR2_USER_NETWORK_1_NAME inet dhcp">> $IFACE_FILE
	elif [ $BR2_USER_NETWORK_1_IPV4_MANUAL ] ; then
		for PARAM in \
			BR2_USER_NETWORK_1_IPV4_ADDRESS \
			BR2_USER_NETWORK_1_IPV4_NETMASK \
			BR2_USER_NETWORK_1_IPV4_BROADCAST \
			BR2_USER_NETWORK_1_IPV4_GATEWAY \
			; do
			eval VALUE=\$$PARAM
			if [ -z $VALUE ] ; then
				echo ERROR $PARAM not set
				exit 1
			fi
		done
		echo "iface $BR2_USER_NETWORK_1_NAME inet static">> $IFACE_FILE
		echo "	address $BR2_USER_NETWORK_1_IPV4_ADDRESS">> $IFACE_FILE
		echo "	netmask $BR2_USER_NETWORK_1_IPV4_NETMASK">> $IFACE_FILE
		echo "	broadcast $BR2_USER_NETWORK_1_IPV4_BROADCAST">> $IFACE_FILE
		echo "	gateway $BR2_USER_NETWORK_1_IPV4_GATEWAY">> $IFACE_FILE
	else
		echo Incorrect buildroot configuration
		exit 1
	fi
	echo >>$IFACE_FILE
fi
cat $IFACE_FILE
