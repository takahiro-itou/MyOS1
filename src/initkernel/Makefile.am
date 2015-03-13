
##
##    List of Programs.
##

ROOT_BIN_FILES   =  Kernel0.img

##
##    List of Files.
##

LINKER_SCRIPT    =  $(srcdir)/LinkerScript

##
##    Environments.
##

SYSDEV_FLOPPY    =  /proc/sys/Device/ImDisk0
CPDEST_FLOPPY    =  /cygdrive/a/

CPP_INCLUDE_DIR  =  $(top_srcdir)/include

##
##    Commands.
##

CP      =  cp
DD      =  dd

##
##    Compile and Link Flags.
##

AM_CFLAGS     =  -I $(CPP_INCLUDE_DIR)
AM_CCASFLAGS  =  -I $(CPP_INCLUDE_DIR)
AM_LDFLAGS    =  -nostdlib

##
##    List of Installs.
##

noinst_PROGRAMS  =  $(ROOT_BIN_FILES)

##
##    Build Programs.
##

Kernel0_img_SOURCES  =  \
        KernelEntry.S        \
        KernelMain.c         \
        InterruptEntries.S   \
        InterruptHandlers.c  \
        SetupInterrupt.c     \
        SetupSegment.S       \
        $(LINKER_SCRIPT)
Kernel0_img_LINK     =  \
    $(LD)  -Map Kernel0.map  -T $(LINKER_SCRIPT)  -nostdlib  -o $@

##
##    Install Programs.
##

install  :  $(ROOT_BIN_FILES)
	$(CP)  -pv  $^  $(CPDEST_FLOPPY)

