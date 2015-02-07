
##
##    List of Files.
##

BOOT_SECTOR_IMG  =  BootSector.img

##
##    Environments.
##

SYSDEV_FLOPPY    =  /proc/sys/Device/ImDisk0

##
##    Commands.
##

AS      =  /usr/bin/i686-pc-linux-gnu-as
LD      =  /usr/bin/i686-pc-linux-gnu-ld
CP      =  cp
DD      =  dd

##
##    Targets.
##

.PHONY     :  all  clean  cleanall  cleanobj  install
.SUFFIXES  :  .o  .s

all        :  $(BOOT_SECTOR_IMG)

clean      :  cleanobj
	$(RM)  $(BOOT_SECTOR_IMG)

cleanall   :  clean
	$(RM)  $(BOOT_SECTOR_IMG:%.img=%.lst)

cleanobj   :
	$(RM)  $(BOOT_SECTOR_IMG:%.img=%.o)

install    :
	$(DD)  if=$(BOOT_SECTOR_IMG)  bs=512  count=1  of=$(SYSDEV_FLOPPY)


##
##    Build.
##

$(BOOT_SECTOR_IMG)  :  $(BOOT_SECTOR_IMG:%.img=%.o)
	$(LD)  -T Binary.ls  -o $@  $^

##
##    Suffix Rules.
##
.s.o  :
	$(AS)  -o $@  -a=$(@:%.o=%.lst)  $<

