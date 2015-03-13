
##
##    List of Programs.
##

ROOT_BIN_FILES   =  IplF12.bin

##
##    List of Files.
##

LINKER_SCRIPT    =  $(srcdir)/LinkerScript

##
##    Environments.
##

SYSDEV_FLOPPY    =  /proc/sys/Device/ImDisk0
CPDEST_FLOPPY    =  /cygdrive/a/

AS_CMN_DIR       =  $(srcdir)/../common
CPP_INCLUDE_DIR  =  $(top_srcdir)/include

##
##    Commands.
##

CP      =  cp
DD      =  dd

##
##    Compile and Link Flags.
##

AM_CCASFLAGS  =  -I $(AS_CMN_DIR)  -I $(CPP_INCLUDE_DIR)
AM_LDFLAGS    =  -nostdlib

##
##    List of Installs.
##

noinst_PROGRAMS  =  $(ROOT_BIN_FILES)

##
##    Build Programs.
##

IplF12_bin_SOURCES  =  \
        EntryPoint.S                     \
        ProtectMode.S                    \
        StartKernel.S                    \
        $(AS_CMN_DIR)/Fat12Bpb.inc       \
        $(LINKER_SCRIPT)
IplF12_bin_LINK     =  $(LD)  -T $(LINKER_SCRIPT)  -o $@

##
##    Install Programs.
##

install  :  $(ROOT_BIN_FILES)
	$(CP)  -pv  $^  $(CPDEST_FLOPPY)

