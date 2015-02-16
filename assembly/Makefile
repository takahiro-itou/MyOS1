
##
##    List of Sub Directory.
##

SUBDIRS  =  bootsector  ipl

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

AS      =  /usr/bin/i686-pc-linux-gnu-as
CC      =  /usr/bin/i686-pc-linux-gnu-gcc
LD      =  /usr/bin/i686-pc-linux-gnu-ld
CP      =  cp
DISASM  =  objdump

##
##    Targets.
##

.PHONY  :  all  clean  cleanall  cleanobj  disasm  install

all       :  $(SUBDIRS)
clean     :  $(SUBDIRS)
cleanall  :  $(SUBDIRS)
cleanobj  :  $(SUBDIRS)
disasm    :  $(SUBDIRS)
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

.s.o  :
	$(AS)  -o $@  -a=$(@:%.o=%.lst)  $<

##
##
##

