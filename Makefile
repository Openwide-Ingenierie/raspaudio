

#project name
PROJECT_NAME := raspaudio

#location of the buildroot sources
MAKEARGS := -C $(CURDIR)/buildroot 
#location to store build files
MAKEARGS += O=$(CURDIR)/$(PROJECT_NAME)_output
# location to store extra config options and buildroot packages
MAKEARGS += BR2_EXTERNAL=$(CURDIR)
#transmit project name to be able to use it in kconfig
MAKEARGS += PROJECT_NAME=$(PROJECT_NAME)
# location of default defconfig
DEFCONFIG_FILE=$(CURDIR)/$(PROJECT_NAME)_defconfig
DEFCONFIG := BR2_DEFCONFIG=$(DEFCONFIG_FILE)
ALT_DEFCONFIG := BR2_DEFCONFIG=$(CURDIR)/defconfig

MAKEFLAGS += --no-print-directory

#these targets change the config file
config_change_targets:=menuconfig nconfig xconfig gconfig oldconfig \
       	silentoldconfig randconfig allyesconfig allnoconfig randpackageconfig \
       	allyespackageconfig allnopackageconfig

special_target:=$(config_change_targets) Makefile defconfig savedefconfig %_defconfig

all	:= $(filter-out $(special_target),$(MAKECMDGOALS))

default:  
	$(MAKE) $(MAKEARGS) $(DEFCONFIG) defconfig
	$(MAKE) $(MAKEARGS) $(DEFCONFIG)


.PHONY: $(special_target) $(all) 

# update from current config and save it as defconfig
defconfig:
	$(MAKE) $(MAKEARGS) $(ALT_DEFCONFIG) $@
	$(MAKE) $(MAKEARGS) $(DEFCONFIG) savedefconfig

# update from defconfig and save it as current configuration
savedefconfig:
	$(MAKE) $(MAKEARGS) $(DEFCONFIG) defconfig
	$(MAKE) $(MAKEARGS) $(ALT_DEFCONFIG) savedefconfig

# generate from a defconfig then save as current configuration
%_defconfig:
	$(MAKE) $(MAKEARGS) $(DEFCONFIG) $@ savedefconfig
	$(call UPDATE_DEFCONFIG)


# update from current configuration, run the command, then save the result
$(config_change_targets): $(DEFCONFIG_FILE)
	$(MAKE) $(MAKEARGS) $(DEFCONFIG) defconfig $@ savedefconfig

_all:
	$(MAKE) $(MAKEARGS) $(DEFCONFIG) $(all)

$(all): _all
	@:

%/: _all
	@:

Makefile:;

$(DEFCONFIG_FILE):
	$(call UPDATE_DEFCONFIG)

define UPDATE_DEFCONFIG
	echo 'BR2_DL_DIR="$$(BR2_EXTERNAL)/dl"' >> $(DEFCONFIG_FILE)
	echo 'BR2_ROOTFS_OVERLAY="$$(BR2_EXTERNAL)/$$(PROJECT_NAME)_overlay"' >> $(DEFCONFIG_FILE)
	echo 'BR2_PACKAGE_OVERRIDE_FILE="$$(BR2_EXTERNAL)/$$(PROJECT_NAME)_local.mk"' >> $(DEFCONFIG_FILE)
	echo 'BR2_GLOBAL_PATCH_DIR="$$(BR2_EXTERNAL)/$$(PRJECT_NAME)_patch"' >> $(DEFCONFIG_FILE)
	$(MAKE) $(MAKEARGS) $(DEFCONFIG) defconfig savedefconfig
endef


