menu "Network configuration"

menuconfig BR2_USER_NETWORK_LO_ENABLE
	bool "enable loopback device"
	default y
	help
	   Enables the loopback interface at startup

if BR2_USER_NETWORK_LO_ENABLE
config BR2_USER_NETWORK_LO_AUTO
	bool "enable loopback interface at startup"
	default y
	help 
	   Should the loopback inteface be brought up automatically at startup
	   
endif

menuconfig BR2_USER_NETWORK_1_ENABLE
	bool "enable first network interface"
	default y
	help
	   Enable the first network interface

if BR2_USER_NETWORK_1_ENABLE
config BR2_USER_NETWORK_1_AUTO
	bool "enable first network interface at startup"
	default y
	help 
	   Should the first network inteface be brought up automatically at startup

config BR2_USER_NETWORK_1_NAME
	string "name of the first physical network interface"
	default "eth0"
	help
	   The name used to recognise the first network interface as reported by the kernel
	
choice 
	prompt "Configuration type"
	default BR2_USER_NETWORK_1_DHCP
	help
	   The type of configuration to use for the first physical interface

config BR2_USER_NETWORK_1_IPV4_DHCP
	bool "IPv4 with DHCP"
	help
	   Use DHCP to configure this interface
	   using the IPv4 protocol

config BR2_USER_NETWORK_1_IPV4_MANUAL
	bool "IPv4 with parameters manually specified"
	help
	   Configure IPv4 by specifying each parameter separately
endchoice

if BR2_USER_NETWORK_1_IPV4_MANUAL
config BR2_USER_NETWORK_1_IPV4_ADDRESS
	string "IP Address of the first network interface"

config BR2_USER_NETWORK_1_IPV4_NETMASK
	string "Netmask of the first network interface"

config BR2_USER_NETWORK_1_IPV4_BROADCAST
	string "Broadcast Address of the first network interface"

config BR2_USER_NETWORK_1_IPV4_GATEWAY
	string "Address of the gateway for the first network interface"
endif

endif

endmenu
