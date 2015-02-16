
##
##    List of Sub Directory.
##

SUBDIRS  =  bootsector  ipl

##
##    List of Files.
##

IPL_BIN          =  IplF12.bin
IPL_BIN_OBJS     =  \
        ipl/IplStart.o   \
        ipl/EnableA20.o  \
        ipl/SetupGdt.o   \
        ipl/StartMain.o

##
##    Environments.
##

SYSDEV_FLOPPY    =  /proc/sys/Device/ImDisk0
CPDEST_FLOPPY    =  /cygdrive/a

##
##    Commands.
##

AS      =  /usr/bin/i686-pc-linux-gnu-as
CC      =  /usr/bin/i686-pc-linux-gnu-gcc
LD      =  /usr/bin/i686-pc-linux-gnu-ld
CP      =  cp
DISASM  =  objdump

##
##    Targets.
##

.PHONY  :  all  clean  cleanall  cleanobj  install

all       :  $(SUBDIRS)  $(IPL_BIN)

clean     :  $(SUBDIRS)  cleanobj
	$(RM)  $(IPL_BIN)

cleanall  :  $(SUBDIRS)  clean
	$(RM)  $(IPL_BIN:%.bin=%.map)

cleanobj  :  $(SUBDIRS)

disasm    :
	$(DISASM)  -D -d -b binary  -mi8086  --start-address=0x50  \
            $(IPL_BIN)  >  $(IPL_BIN:%.bin=%.dis.s)

install   :  $(SUBDIRS)  InstallSystemFiles

##
##    Make Sub Directories.
##

RECURSIVE   :
$(SUBDIRS)  :  RECURSIVE
	$(MAKE)  -C $@  $(MAKECMDGOALS)

##
##    Build.
##

$(IPL_BIN)  :  $(IPL_BIN_OBJS)  ipl/Ipl.ls
	$(LD)  -Map $(IPL_BIN:%.bin=%.map)  \
        -T ipl/Ipl.ls  -nostdlib        \
        -o $@  $(IPL_BIN_OBJS)

InstallSystemFiles  :  $(IPL_BIN)
	$(CP)  -pv  $^  $(CPDEST_FLOPPY)/

##
##    Suffix Rules.
##

.s.o  :
	$(AS)  -o $@  -a=$(@:%.o=%.lst)  $<

##
##
##

