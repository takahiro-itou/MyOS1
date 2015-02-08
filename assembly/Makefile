
##
##    List of Sub Directory.
##

SUBDIRS  =  ipl

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

AS   =  /usr/bin/i686-pc-linux-gnu-as
LD   =  /usr/bin/i686-pc-linux-gnu-ld
CP   =  cp

##
##    Targets.
##

.PHONY  :  all  clean  cleanall  cleanobj  install

all       :  $(SUBDIRS)  $(IPL_BIN)

clean     :  $(SUBDIRS)  cleanobj
	$(RM)  $(IPL_BIN)

cleanall  :  $(SUBDIRS)  clean

cleanobj  :  $(SUBDIRS)

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
	$(LD)  -T ipl/Ipl.ls  -o $@  $(IPL_BIN_OBJS)

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

