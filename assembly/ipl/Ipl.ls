
OUTPUT_FORMAT(binary)
OUTPUT_ARCH(i386)

IPL_BASE  =  0x1000;
IPL_DATA  =  0x0F00;
LOAD_ADDR_FAT      = 0x7E00;
LOAD_ADDR_ROOTDIR  = 0xA200;

SECTIONS {
    .  =  IPL_BASE;
    .text       : { *(.text) }
    .  =  ALIGN(0x0200);
    .data       : {
        *(.data)
        .  =  ALIGN(16);
        *(.gdt)
    }
    .  =  IPL_DATA;
    .bss        : { *(.bss)  }
}

