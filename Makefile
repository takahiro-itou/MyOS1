
.PHONY  :  all  clean  install

all  :  Boot.img

bootsector :

Boot.img  :  \
        assembly16/BootSector.asm   \
        assembly16/ReadFloppy.asm   \
        assembly16/WriteString.asm
	nasm  -o BootSector.img  -l assembly16/BootSector.lst  $<

install  :  BootSector.img
	dd if=BootSector.img bs=512 count=1 of=/proc/sys/Device/ImDisk0

clean    :
	$(RM)  BootSector.img  assembly16/Boot.lst

