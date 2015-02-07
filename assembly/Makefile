
##
##    List of Sub Directory.
##

SUBDIRS  =  ipl

##
##    List of Files.
##

IPL_BIN          =  IplF12.bin

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

clean     :  $(SUBDIRS)
	$(RM)  $(IPL_BIN)

cleanall  :  $(SUBDIRS)
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

$(IPL_BIN)  :  ipl/IplStart.o
	$(LD)  -T Ipl.ls  -o $@  $^

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


