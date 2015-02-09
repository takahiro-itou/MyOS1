
##
##    List of Sub Directory.
##

SUBDIRS  =  bootsector  assembly  kernel

##
##    List of Files.
##

##
##    Environments.
##

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

all       :  $(SUBDIRS)
clean     :  $(SUBDIRS)
cleanall  :  $(SUBDIRS)
cleanobj  :  $(SUBDIRS)
install   :  $(SUBDIRS)

##
##    Make Sub Directories.
##

RECURSIVE   :
$(SUBDIRS)  :  RECURSIVE
	$(MAKE)  -C $@  $(MAKECMDGOALS)


##
##    Build.
##

##
##    Suffix Rules.
##

InstallSystemFile  :  $(IPL_BIN)
	$(CP)  -pv  $^  $(CPDEST_FLOPPY)/

