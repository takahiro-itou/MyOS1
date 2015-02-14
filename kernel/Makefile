
##
##    List of Files.
##

KERNEL_0_IMG   =  Kernel0.img
KERNEL_0_OBJS  =  \
        KernelEntry.o  \
        KernelMain.o

##
##    Environments.
##

SYSDEV_FLOPPY    =  /proc/sys/Device/ImDisk0
CPDEST_FLOPPY    =  /cygdrive/a
AS_CMN_DIR       = ../assembly/common

##
##    Commands.
##

AS      =  /usr/bin/i686-pc-linux-gnu-as
CC      =  /usr/bin/i686-pc-linux-gnu-gcc
LD      =  /usr/bin/i686-pc-linux-gnu-ld
CP      =  cp
DD      =  dd

##
##    Targets.
##

.PHONY     :  all  clean  cleanall  cleanobj  install
.SUFFIXES  :  .o  .s

all        :  $(KERNEL_0_IMG)

clean      :  cleanobj
	$(RM)  $(KERNEL_0_IMG)

cleanall   :  clean
	$(RM)  $(KERNEL_0_IMG:%.img=%.map)
	$(RM)  $(KERNEL_0_OBJS:%.o=%.lst)

cleanobj   :
	$(RM)  $(KERNEL_0_OBJS)

install    :  $(KERNEL_0_IMG)
	$(CP)  -pv  $^  $(CPDEST_FLOPPY)/

##
##    Build.
##

$(KERNEL_0_IMG)  :  $(KERNEL_0_OBJS)
	$(LD)  -Map $(KERNEL_0_IMG:%.img=%.map)  \
        -T Kernel0.ls  -nostdlib             \
        -o $@  $(KERNEL_0_OBJS)

##
##    Suffix Rules.
##

.s.o  :
	$(AS)  -o $@  -I $(AS_CMN_DIR)  -a=$(@:%.o=%.lst)  $<

##
##
##

$(KERNEL_0_IMG:%.img=%.o)  :  \
        Kernel0.ls

