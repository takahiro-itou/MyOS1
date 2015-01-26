
BOOTSEC_IMG  =  BootSector.img
IPL_BIN      =  IplF12.bin

SYSDEV_FLOPPY  =  /proc/sys/Device/ImDisk0
CPDEST_FLOPPY  =  /cygdrive/a

ASM  =  nasm
CP   =  cp
DD   =  dd


.PHONY  :  all  clean  install  \
           InstallBootSector  InstallSystemFile


all  :  $(BOOTSEC_IMG)  $(IPL_BIN)

$(BOOTSEC_IMG)  :  \
        assembly16/BootSector.asm   \
        assembly16/ReadFloppy.asm   \
        assembly16/WriteString.asm
	$(ASM)  -o $@  -l assembly16/BootSector.lst  $<

$(IPL_BIN)  :  \
        Ipl.asm  \
        assembly16/WriteString.asm
	$(ASM)  -o $@  -l $*.lst  $<

install  :  InstallBootSector  InstallSystemFile

InstallBootSector  :  $(BOOTSEC_IMG)
	$(DD)  if=$(BOOTSEC_IMG)  bs=512  count=1  of=$(SYSDEV_FLOPPY)

InstallSystemFile  :  $(IPL_BIN)
	$(CP)  -pv  $^  $(CPDEST_FLOPPY)/

clean    :
	$(RM)  $(BOOTSEC_IMG)  assembly16/Boot.lst
	$(RM)  $(IPL_BIN)

