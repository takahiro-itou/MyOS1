
##
##    List of Files.
##

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

all       :  \
        IplStart.o

clean     :  cleanobj

cleanall  :  clean
	$(RM)  *.lst

cleanobj  :
	$(RM)	*.o

install   :

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
	$(AS)  -o $@  -a=$(@:%.o=%.lst)  $<

##
##
##

IplStart.o  :  Makefile  IplStart.s

