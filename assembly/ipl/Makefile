
##
##    List of Files.
##

OBJECT_FILES     =  \
        EnableA20.o  \
        IplStart.o   \
        SetupGdt.o   \
        StartMain.o

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

all       :  $(OBJECT_FILES)

clean     :  cleanobj

cleanall  :  clean
	$(RM)  $(OBJECT_FILES:%.o=%.lst)

cleanobj  :
	$(RM)  $(OBJECT_FILES)

install   :  all

##
##    Make Sub Directories.
##

RECURSIVE   :
$(SUBDIRS)  :  RECURSIVE
	$(MAKE)  -C $@  $(MAKECMDGOALS)

##
##    Build.
##

InstallSystemFiles  :  $(IPL_BIN)
	$(CP)  -pv  $^  $(CPDEST_FLOPPY)/

##
##    Suffix Rules.
##

.s.o  :
	$(AS)  -o $@  -alm=$(@:%.o=%.lst)  $<

##
##
##

IplStart.o  :  Makefile  IplStart.s

