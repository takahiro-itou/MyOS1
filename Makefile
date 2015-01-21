
.PHONY  :  all  clean  install

all  :  Boot.img

bootsector :

Boot.img  :  Boot.asm               \
        assembly16/ReadFloppy.asm   \
        assembly16/WriteString.asm
	nasm  -o Boot.img  -l Boot.lst  $<

install  :  Boot.img
	dd if=Boot.img bs=512 count=1 of=/proc/sys/Device/ImDisk0

clean    :
	$(RM)  Boot.img  Boot.lst

