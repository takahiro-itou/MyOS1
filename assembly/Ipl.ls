
OUTPUT_FORMAT(binary)
OUTPUT_ARCH(i386)

IPL_BASE  =  0x1000;
IPL_DATA  =  0x0F00;

SECTIONS {
    .  =  IPL_DATA;
    .data       : { *(.data) }
    .  =  IPL_BASE;
    .text       : { *(.text) }
}

