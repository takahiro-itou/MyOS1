
OUTPUT_FORMAT(binary)
OUTPUT_ARCH(i386)

BOOT_SECTOR_BASE  =  0x7C00;

SECTIONS {
    .  =  BOOT_SECTOR_BASE;
    .text       : { *(.text) }
    .data       : { *(.data) }
    .  =  BOOT_SECTOR_BASE + 0x1FE;
    .sign       : { SHORT(0xAA55) }
}

