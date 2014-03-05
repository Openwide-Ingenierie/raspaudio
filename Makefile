

#project name
PROJECT_NAME := raspaudio

#location of the buildroot sources
MAKEARGS := -C $(CURDIR)/buildroot 
#location to store build files
MAKEARGS += O=$(CURDIR)/output
# location to store extra config options and buildroot packages
MAKEARGS += BR2_EXTERNAL=$(CURDIR)
# location of default defconfig
DEFCONFIG := BR2_DEFCONFIG=$(CURDIR)/$(PROJECT_NAME)_defconfig
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


# update from current configuration, run the command, then save the result
$(config_change_targets):
	touch $(CURDIR)/$(PROJECT_NAME)_defconfig
	$(MAKE) $(MAKEARGS) $(DEFCONFIG) defconfig $@ savedefconfig

_all:
	$(MAKE) $(MAKEARGS) $(DEFCONFIG) $(all)

$(all): _all
	@:

%/: _all
	@:

Makefile:;

