
##
##    List of Programs.
##

BOOT_SECTOR_IMG  =  BootSector.img

##
##    List of Files.
##

LINKER_SCRIPT    =  LinkerScript

##
##    Environments.
##

SYSDEV_FLOPPY    =  /proc/sys/Device/ImDisk0

AS_CMN_DIR       =  ../common
CPP_INCLUDE_DIR  =  ../../include

##
##    Commands.
##

AS      =  /usr/bin/i686-pc-linux-gnu-as
CCAS    =  /usr/bin/i686-pc-linux-gnu-gcc
LD      =  /usr/bin/i686-pc-linux-gnu-ld

CP      =  cp
DD      =  dd

##
##    Compile and Link Flags.
##

AM_CCASFLAGS  =  -I $(AS_CMN_DIR)  -I $(CPP_INCLUDE_DIR)

##
##    List of Installs.
##

noinst_PROGRAMS  =  $(BOOT_SECTOR_IMG)

##
##    Build Programs.
##

BootSector_img_SOURCES  =  \
        BootSector.S                     \
        $(AS_CMN_DIR)/Fat12Bpb.inc       \
        $(LINKER_SCRIPT)
BootSector_img_LINK     =  $(LD)  -T $(LINKER_SCRIPT)  -o $@

##
##    Install Programs.
##

install  :  $(BOOT_SECTOR_IMG)
	$(DD)  if=$(BOOT_SECTOR_IMG)  bs=512  count=1  of=$(SYSDEV_FLOPPY)

