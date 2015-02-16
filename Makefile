
##
##    List of Sub Directory.
##

SUBDIRS  =  assembly  kernel

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

AS      =  /usr/bin/i686-pc-linux-gnu-as
LD      =  /usr/bin/i686-pc-linux-gnu-ld
CP      =  cp
DISASM  =  objdump  -mi386

##
##    Targets.
##


.PHONY  :  all  clean  cleanall  cleanobj  install

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

