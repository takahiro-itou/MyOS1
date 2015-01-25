
.PHONY  :  all  clean  install  \
           InstallBootSector  InstallSystemFile

all  :  BootSector.img  Ipl.bin

bootsector :

BootSector.img  :  \
        assembly16/BootSector.asm   \
        assembly16/ReadFloppy.asm   \
        assembly16/WriteString.asm
	nasm  -o $@  -l assembly16/BootSector.lst  $<

Ipl.bin  :  \
        Ipl.asm  \
        assembly16/WriteString.asm
	nasm  -o $@  -l $*.lst  $<

install  :  InstallBootSector  InstallSystemFile

InstallBootSector  :  BootSector.img
	dd  if=BootSector.img bs=512 count=1 of=/proc/sys/Device/ImDisk0

InstallSystemFile  :  Ipl.bin
	cp  -pv  $^  /cygdrive/a/

clean    :
	$(RM)  BootSector.img  assembly16/Boot.lst
	$(RM)  Ipl.bin

